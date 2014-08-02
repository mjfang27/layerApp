//
//  LSHTTPResponseSerializer.h
//  LayerSample
//
//  Created by Blake Watters on 6/28/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const LSHTTPResponseErrorDomain;

typedef NS_ENUM(NSUInteger, LSHTTPResponseError) {
    LSHTTPResponseErrorInvalidContentType,
    LSHTTPResponseErrorUnexpectedStatusCode,
    LSHTTPResponseErrorClientError,
    LSHTTPResponseErrorServerError
};

@interface LSHTTPResponseSerializer : NSObject

+ (BOOL)responseObject:(id *)object withData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError **)error;

@end
