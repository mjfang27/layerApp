//
//  LSAPIManager.h
//  LayerSample
//
//  Created by Kevin Coleman on 6/12/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import "LSUser.h"
#import "LSPersistenceManager.h"

extern NSString *const LSUserDidAuthenticateNotification;
extern NSString *const LSUserDidDeauthenticateNotification;

/**
 @abstract The `LSAPIManager` class provides authentication with the backend and Layer and an interface for interacting with the JSON API.
 */
@interface LSAPIManager : NSObject

///-----------------------------
/// @name Initializing a Manager
///-----------------------------

+ (instancetype)managerWithBaseURL:(NSURL *)baseURL layerClient:(LYRClient *)layerClient;

/**
 @abstract The current authenticated session or `nil` if not yet authenticated.
 */
@property (nonatomic, readonly) LSSession *authenticatedSession;

///------------------------------------
/// @name Managing Authentication State
///------------------------------------

- (void)registerUser:(LSUser *)user completion:(void(^)(LSUser *user, NSError *error))completion;
- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password completion:(void(^)(LSUser *user, NSError *error))completion;
- (BOOL)resumeSession:(LSSession *)session error:(NSError **)error;
- (void)deauthenticateWithCompletion:(void(^)(BOOL success, NSError *error))completion;

///-------------------------
/// @name Accessing Contacts
///-------------------------

- (void)loadContactsWithCompletion:(void(^)(NSSet *contacts, NSError *error))completion;

///--------------------------
/// @name Delete All Contacts
///--------------------------

- (void)deleteAllContactsWithCompletion:(void(^)(BOOL completion, NSError *error))completion;

@end
