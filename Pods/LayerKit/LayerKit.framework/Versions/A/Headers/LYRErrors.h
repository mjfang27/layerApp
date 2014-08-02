//
//  LYRErrors.h
//  LayerKit
//
//  Created by Blake Watters on 4/29/14.
//  Copyright (c) 2014 Layer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const LYRErrorDomain;

typedef NS_ENUM(NSUInteger, LYRError) {
    LYRErrorUnknownError = 1000,
    
    /* Messaging Errors */
    LYRErrorUnauthenticated             = 1001,
    LYRErrorInvalidMessage              = 1002,
    LYRErrorTooManyParticipants         = 1003,
    LYRErrorDataLengthExceedsMaximum    = 1004,
};

typedef NS_ENUM(NSUInteger, LYRClientError) {
    // Client Errors
    LYRClientErrorAlreadyConnected        = 6000,
    
    // Crypto Configuration Errors
    LYRClientErrorKeyPairNotFound         = 7000,
    LYRClientErrorCertificateNotFound     = 7001,
    LYRClientErrorIdentityNotFound        = 7002,
    
    // Authentication
    LYRClientErrorFailedToPersistSession  = 7003,

    // Push Notification Errors
    LYRClientErrorDeviceTokenInvalid      = 8000,
};
