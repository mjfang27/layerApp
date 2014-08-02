//
//  LSAppController.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/30/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSApplicationController.h"
#import "LSUtilities.h"

@interface LSApplicationController () <LYRClientDelegate>

@property (nonatomic) NSURL *baseURL;

@end

@implementation LSApplicationController

+ (instancetype)controllerWithBaseURL:(NSURL *)baseURL layerClient:(LYRClient *)layerClient persistenceManager:(LSPersistenceManager *)persistenceManager
{
    NSParameterAssert(baseURL);
    NSParameterAssert(layerClient);
    return [[self alloc] initWithBaseURL:baseURL layerClient:layerClient persistenceManager:persistenceManager];
}

- (id)initWithBaseURL:(NSURL *)baseURL layerClient:(LYRClient *)layerClient persistenceManager:(LSPersistenceManager *)persistenceManager
{
    self = [super init];
    if (self) {
        _layerClient = layerClient;
        _layerClient.delegate = self;
        _persistenceManager = persistenceManager;
        _APIManager = [LSAPIManager managerWithBaseURL:baseURL layerClient:layerClient];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLayerClientWillBeginSynchronizationNotification:) name:LYRClientWillBeginSynchronizationNotification object:layerClient];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLayerClientDidFinishSynchronizationNotification:) name:LYRClientDidFinishSynchronizationNotification object:layerClient];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce
{
     NSLog(@"Layer Client did recieve authentication challenge");
    LSUser *user = self.APIManager.authenticatedSession.user;
    [self.APIManager authenticateWithEmail:user.email password:user.password completion:^(LSUser *user, NSError *error) {
        if (user && !error) {
            NSLog(@"silent auth successful");
        } else {
            [self.APIManager deauthenticateWithCompletion:^(BOOL success, NSError *error) {
                NSLog(@"Silent auth failed, deauthenticating");
            }];
        }
    }];
   
}

- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID
{
    NSLog(@"Layer Client did recieve authentication nonce");
}

- (void)layerClientDidDeauthenticate:(LYRClient *)client
{
    NSLog(@"Layer Client did deauthenticate");
}

- (void)layerClient:(LYRClient *)client didFinishSynchronizationWithChanges:(NSArray *)changes
{
    NSLog(@"Layer Client did finish sychronization");
}


- (void)layerClient:(LYRClient *)client didFailSynchronizationWithError:(NSError *)error
{
    LSAlertWithError(error);
    NSLog(@"Layer Client did fail synchronization ");
}

- (void)didReceiveLayerClientWillBeginSynchronizationNotification:(NSNotification *)notification
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveLayerClientDidFinishSynchronizationNotification:(NSNotification *)notification
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
