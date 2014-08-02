//
//  LSPersistenceManager.h
//  LayerSample
//
//  Created by Blake Watters on 6/28/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSession.h"
#import "LSUser.h"

/**
 @abstract The `LSPersistence` class manages persistence in the Layer Hackathon Sample App
 @discussion The application is configured to persist contacts loaded from the Layer Hackathon backend application. 
 All users you create will automatically be persited to disk for you and queryable via the public methods below.
 */


@interface LSPersistenceManager : NSObject

+ (instancetype)persistenceManagerWithInMemoryStore;
+ (instancetype)persistenceManagerWithStoreAtPath:(NSString *)path;

- (BOOL)persistUsers:(NSSet *)users error:(NSError **)error;
- (NSSet *)persistedUsersWithError:(NSError **)error;

- (BOOL)persistSession:(LSSession *)session error:(NSError **)error;
- (LSSession *)persistedSessionWithError:(NSError **)error;

- (BOOL)deleteAllObjects:(NSError **)error;

@end
