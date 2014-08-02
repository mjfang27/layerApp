//
//  LSSession.h
//  LayerSample
//
//  Created by Blake Watters on 6/28/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSUser.h"

/**
 @abstract The `LSSession` class models a persistent User session.
 */
@interface LSSession : NSObject <NSCoding>

+ (instancetype)sessionWithAuthenticationToken:(NSString *)authenticationToken user:(LSUser *)user;

@property (nonatomic, readonly) NSString *authenticationToken;
@property (nonatomic, readonly) LSUser *user;

@end
