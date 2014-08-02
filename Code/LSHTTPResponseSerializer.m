//
//  LSHTTPResponseSerializer.m
//  LayerSample
//
//  Created by Blake Watters on 6/28/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSHTTPResponseSerializer.h"

NSString *const LSHTTPResponseErrorDomain = @"com.layer.LSSample.HTTPResponseError";

static NSString *LSHTTPErrorMessageFromErrorRepresentation(id representation)
{
    if ([representation isKindOfClass:[NSString class]]) {
        return representation;
    } else if ([representation isKindOfClass:[NSArray class]]) {
        return [representation componentsJoinedByString:@", "];
    } else if ([representation isKindOfClass:[NSDictionary class]]) {
     
        // Check for direct error message
        NSString *errorMessage = representation[@"error"];
        if (errorMessage) {
            return LSHTTPErrorMessageFromErrorRepresentation(errorMessage);
        }
        
        // Rails errors in nested dictionary
        id errors = representation[@"errors"];
        if (errors) {
            NSMutableArray *components = [NSMutableArray new];
            for (NSString *key in errors) {
                [components addObject:[NSMutableString stringWithFormat:@"%@ %@", key, LSHTTPErrorMessageFromErrorRepresentation(errors[key])]];
            }
            return [components componentsJoinedByString:@" "];
        }
    }
    return [NSString stringWithFormat:@"An unknown error representation was encountered. (%@)", representation];
}

@implementation LSHTTPResponseSerializer

+ (BOOL)responseObject:(id *)object withData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError **)error
{
    NSParameterAssert(object);
    NSParameterAssert(response);
    
    if (data.length && ![[response MIMEType] isEqualToString:@"application/json"]) {
        NSString *description = [NSString stringWithFormat:@"Expected content type of 'application/json', but encountered a response with '%@' instead.", [response MIMEType]];
        if (error) *error = [NSError errorWithDomain:LSHTTPResponseErrorDomain code:LSHTTPResponseErrorInvalidContentType userInfo:@{ NSLocalizedDescriptionKey: description }];
        return NO;
    }
    
    BOOL isClientErrorStatusCode = NSLocationInRange([response statusCode], NSMakeRange(400, 100));
    BOOL isErrorStatusCode = (isClientErrorStatusCode || NSLocationInRange([response statusCode], NSMakeRange(500, 100)));
    if (!(NSLocationInRange([response statusCode], NSMakeRange(200, 100)) || isErrorStatusCode)) {
        NSString *description = [NSString stringWithFormat:@"Expected status code of 2xx, 4xx, or 5xx but encountered a status code '%ld' instead.", (long)[response statusCode]];
        if (error) *error = [NSError errorWithDomain:LSHTTPResponseErrorDomain code:LSHTTPResponseErrorInvalidContentType userInfo:@{ NSLocalizedDescriptionKey: description }];
        return NO;
    }
    
    // No response body
    if (!data.length) {
        if (isErrorStatusCode) {
            if (error) *error = [NSError errorWithDomain:LSHTTPResponseErrorDomain code:(isClientErrorStatusCode ? LSHTTPResponseErrorClientError : LSHTTPResponseErrorServerError) userInfo:@{ NSLocalizedDescriptionKey: @"An error was encountered without a response body." }];
            return NO;
        } else {
            // Successful response with no data (typical of a 204 (No Content) response
            *object = nil;
            return YES;
        }
    }
    
    // We have response body and passed Content-Type checks, deserialize it
    NSError *serializationError = nil;
    id deserializedResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
    if (!deserializedResponse) {
        if (error) *error = serializationError;
        return NO;
    }
    
    if (isErrorStatusCode) {
        NSString *errorMessage = LSHTTPErrorMessageFromErrorRepresentation(deserializedResponse);
        if (error) *error = [NSError errorWithDomain:LSHTTPResponseErrorDomain code:(isClientErrorStatusCode ? LSHTTPResponseErrorClientError : LSHTTPResponseErrorServerError) userInfo:@{ NSLocalizedDescriptionKey: errorMessage }];
        return NO;
    }
    
    *object = deserializedResponse;
    return YES;
}

@end
