//
//  LYRMessagePart.h
//  LayerKit
//
//  Created by Blake Watters on 5/8/14.
//  Copyright (c) 2014 Layer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @abstract The `LYRMessagePart` class represents a piece of content embedded within a containing message. Each part has a specific MIME Type
 identifying the type of content it contains. Messages may contain an arbitrary number of parts with any MIME Type that the application
 wishes to support.
 */
@interface LYRMessagePart : NSObject

///-----------------------------
/// @name Creating Message Parts
///-----------------------------

/**
 @abstract Creates a message part with the given MIME Type and data.
 
 @param MIMEType A MIME Type identifying the type of data contained in the given data object.
 @param data The data to be embedded in the mesage part.
 @return A new message part with the given MIME Type and data.
 */
+ (instancetype)messagePartWithMIMEType:(NSString *)MIMEType data:(NSData *)data;

/**
 @abstract Creates a message part with the given MIME Type and stream of data.
 
 @param MIMEType A MIME Type identifying the type of data contained in the given data object.
 @param stream A stream from which to read the data for the message part.
 @return A new message part with the given MIME Type and stream of data.
 */
+ (instancetype)messagePartWithMIMEType:(NSString *)MIMEType stream:(NSInputStream *)stream;

/**
 @abstract Create a message part with a string of text.
 @discussion This is a convience accessor encapsulating the common operation of creating a message part
 with a plain text data attachment in UTF-8 encoding. It is functionally equivalent to the following example code:
 
 [LYRMessagePart messagePartWithMIMEType:@"text/plain" data:[text dataUsingEncoding:NSUTF8StringEncoding]];
 
 @param text The plain text body of the new message part.
 @return A new message part with the MIME Type text/plain and a UTF-8 encoded representation of the given input text.
 */
+ (instancetype)messagePartWithText:(NSString *)text;

///------------------------
/// @name Accessing Content
///------------------------

/**
 @abstract The MIME Type of the content represented by the receiver.
 */
@property (nonatomic, readonly) NSString *MIMEType;

/**
 @abstract The content of the receiver as a data object.
 */
@property (nonatomic, readonly) NSData *data;

/**
 @abstract Returns a new input stream object for reading the content of the receiver as a stream.
 @return A new, unopened input stream object configured for reading the content of the part represented by the receiver.
 */
- (NSInputStream *)inputStream;

@end
