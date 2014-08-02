//
//  LSAPIManager.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/12/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSAPIManager.h"
#import "LSUser.h"
#import "LSHTTPResponseSerializer.h"

NSString *const LSUserDidAuthenticateNotification = @"LSUserDidAuthenticateNotification";
NSString *const LSUserDidDeauthenticateNotification = @"LSUserDidDeauthenticateNotification";

@interface LSAPIManager () <NSURLSessionDelegate>

@property (nonatomic, readonly) NSURLSessionConfiguration *authenticatedURLSessionConfiguration;
@property (nonatomic, readonly) LYRClient *layerClient;
@property (nonatomic) NSURL *baseURL;
@property (nonatomic) NSURLSession *URLSession;

@end

@implementation LSAPIManager

+ (instancetype)managerWithBaseURL:(NSURL *)baseURL layerClient:(LYRClient *)layerClient
{
    NSParameterAssert(baseURL);
    NSParameterAssert(layerClient);
    return [[self alloc] initWithBaseURL:baseURL layerClient:layerClient];
}

- (id)initWithBaseURL:(NSURL *)baseURL layerClient:(LYRClient *)layerClient
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
        _layerClient = layerClient;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{ @"Accept": @"application/json", @"Content-Type": @"application/json", @"X_LAYER_APP_ID": [self.layerClient.appID UUIDString] };
        _URLSession = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to call designated initializer." userInfo:nil];
}

- (void)registerUser:(LSUser *)user completion:(void (^)(LSUser *user, NSError *error))completion
{
    NSParameterAssert(completion);
    NSError *error = nil;
    if (! [user validate:&error]) {
        completion(nil, error);
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:@"users.json" relativeToURL:self.baseURL];
    NSDictionary *parameters = @{ @"user": @{ @"first_name": user.firstName, @"last_name": user.lastName, @"email": user.email, @"password": user.password, @"password_confirmation": user.passwordConfirmation}};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    [[self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Got response: %@, data: %@, error: %@", response, data, error);
        if (!response && error) {
            NSLog(@"Failed with error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }
        
        NSError *serializationError = nil;
        NSDictionary *userDetails = nil;
        BOOL success = [LSHTTPResponseSerializer responseObject:&userDetails withData:data response:(NSHTTPURLResponse *)response error:&serializationError];
        if (success) {
            NSLog(@"Loaded User Response: %@", userDetails);
            [self authenticateWithEmail:user.email password:user.password completion:completion];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, serializationError);
            });
        }
    }] resume];
}

- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password completion:(void(^)(LSUser *user, NSError *error))completion
{
    NSParameterAssert(completion);
    
    if (!email.length) {
        NSError *error = [NSError errorWithDomain:@"Login Error" code:101 userInfo:@{ NSLocalizedDescriptionKey : @"Please enter your Email address in order to Login"}];
        completion(nil, error);
        return;
    }
    
    if (!password.length) {
        NSError *error = [NSError errorWithDomain:@"Login Error" code:101 userInfo:@{ NSLocalizedDescriptionKey : @"Please enter your password in order to login"}];
        completion(nil, error);
        return;
    }

    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }
        
        NSURL *URL = [NSURL URLWithString:@"users/sign_in.json" relativeToURL:self.baseURL];
        NSDictionary *parameters = @{ @"user": @{ @"email": email, @"password": password }, @"nonce": nonce };
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        
        [[self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!response && error) {
                completion(nil, error);
                return;
            }
            
            NSError *serializationError = nil;
            NSDictionary *loginInfo = nil;
            BOOL success = [LSHTTPResponseSerializer responseObject:&loginInfo withData:data response:(NSHTTPURLResponse *)response error:&serializationError];
            if (!success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, serializationError);
                });
            } else {
                
                NSString *authToken = loginInfo[@"authentication_token"];
                LSUser *user = [LSUser userFromDictionaryRepresentation:loginInfo[@"user"]];
                user.password = password;
                LSSession *session = [LSSession sessionWithAuthenticationToken:authToken user:user];
                self.authenticatedSession = session;
                
                [self.layerClient authenticateWithIdentityToken:loginInfo[@"layer_identity_token"] completion:^(NSString *authenticatedUserID, NSError *error) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(nil, error);
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"Authenticated with layer userID:%@, error=%@", authenticatedUserID, error);
                            completion(user, error);
                        });
                    }
                }];
            }
        }] resume];
    }];
    completion([LSUser new], nil);
}

- (void)setAuthenticatedSession:(LSSession *)authenticatedSession
{
    if (authenticatedSession && !self.authenticatedSession) {
        _authenticatedSession = authenticatedSession;
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        sessionConfiguration.HTTPAdditionalHeaders = @{ @"Accept": @"application/json",
                                                        @"Content-Type": @"application/json",
                                                        @"X_AUTH_EMAIL" : authenticatedSession.user.email,
                                                        @"X_AUTH_TOKEN": authenticatedSession.authenticationToken,
                                                        @"X_LAYER_APP_ID": [self.layerClient.appID UUIDString]};
        _authenticatedURLSessionConfiguration = sessionConfiguration;
        
        [self.URLSession finishTasksAndInvalidate];
        self.URLSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:LSUserDidAuthenticateNotification object:authenticatedSession.user];
        });
    } else if (!authenticatedSession && self.authenticatedSession) {
        _authenticatedSession = authenticatedSession;
        _authenticatedURLSessionConfiguration = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:LSUserDidDeauthenticateNotification object:authenticatedSession.user];
        });
    }
}

- (BOOL)resumeSession:(LSSession *)session error:(NSError **)error
{
    if (self.layerClient.authenticatedUserID && session) {
        self.authenticatedSession = session;
        return YES;
    } else {
        if (error) *error = [NSError errorWithDomain:@"Authentication Error" code:500 userInfo:@{@"error" : @"No authenticated session"}];
        return NO;
    }
}

- (void)deauthenticateWithCompletion:(void(^)(BOOL success, NSError *error))completion
{
    //TODO: KC - Deauthenticate should STOP the sync manager but NOT cut off the SDK connection. Currently it is not stopping the sync manager.
    self.authenticatedSession = nil;
    if (completion) completion(YES, nil);
}

- (void)loadContactsWithCompletion:(void(^)(NSSet *contacts, NSError *error))completion
{
    NSURL *URL = [NSURL URLWithString:@"users.json" relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    [[self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!response && error) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, error);
                });
            }
            return;
        }
        
        NSArray *userRepresentations = nil;
        NSError *serializationError = nil;
        BOOL success = [LSHTTPResponseSerializer responseObject:&userRepresentations withData:data response:(NSHTTPURLResponse *)response error:&serializationError];
        if (!success) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, serializationError);
                });
            }
            return;
        }
        
        NSLog(@"Loaded user representations: %@", userRepresentations);
        NSMutableSet *contacts = [NSMutableSet new];
        for (NSDictionary *representation in userRepresentations) {
            LSUser *user = [LSUser userFromDictionaryRepresentation:representation];
            [contacts addObject:user];
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(contacts, nil);
            });
        }
    }] resume];
}

- (void)deleteAllContactsWithCompletion:(void(^)(BOOL completion, NSError *error))completion
{
    NSURL *URL = [NSURL URLWithString:@"users/all" relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"DELETE";
    [[self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!response && error) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, error);
                });
            }
            return;
        }
        
        NSError *serializationError = nil;
        BOOL success = [LSHTTPResponseSerializer responseObject:&response withData:data response:(NSHTTPURLResponse *)response error:&serializationError];
        if (!success) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, serializationError);
                });
            }
            return;
        }
        
        NSLog(@"Users succesfully deleted");
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(success, nil);
            });
        }
    }] resume];
}
@end
