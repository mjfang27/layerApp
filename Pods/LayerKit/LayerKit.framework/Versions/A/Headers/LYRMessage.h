//
//  LYRMessage.h
//  LayerKit
//
//  Created by Blake Watters on 5/8/14.
//  Copyright (c) 2014 Layer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYRConversation;

/**
 @abstract `LYRRecipientStatus` is an enumerated value that describes the status of a given Message for a specific participant in the Conversation to which the Message belongs.
 */
typedef NS_ENUM(NSInteger, LYRRecipientStatus) {
    /// @abstract Status for the recipient cannot be determined because the message is not in a state in which recipient status can be evaluated or the user is not a participant in the Conversation.
    LYRRecipientStatusInvalid   = -1,
    
    /// @abstract The message has been transported to Layer and is awaiting synchronization by the recipient's devices.
	LYRRecipientStatusSent      = 0,
	
    /// @abstract The message has been synchronized to at least one device for a recipient but has not been marked as read.
	LYRRecipientStatusDelivered = 1,
	
    /// @abstract The message has been marked as read by one of the recipient's devices.
	LYRRecipientStatusRead      = 2
};

/**
 @abstract The key used in the message metadata to specify the APNS alert message the server should include in the push delivered to the receiver of the message.
 The value associated to this key must be passed in before the message is sent and will not be seen by any of the receivers of the message.
 */
extern NSString *const LYRMessagePushNotificationAlertMessageKey;

/**
 @abstract The key used in the message metadata to specify the APNS sound name the server should include in the push delivered to the receiver of the message.
 The value associated to this key must be passed in before the message is sent and will not be seen by any of the receivers of the message.
 */
extern NSString *const LYRMessagePushNotificationSoundNameKey;

/**
 @abstract The `LYRMessage` class represents a message within a conversation (modeled by the `LYRConversation` class) between two or
 more participants within Layer.
 */
@interface LYRMessage : NSObject

/**
 @abstract Creates and returns a new message with the given conversation and set of message parts.
 @param conversation The conversation that the message is a part of. Cannot be `nil`.
 @param messageParts An array of `LYRMessagePart` objects specifying the content of the message. Cannot be `nil` or empty.
 @return A new message that is ready to be sent.
 @raises NSInvalidArgumentException Raised if `conversation` is `nil` or `messageParts` is empty.
 */
+ (instancetype)messageWithConversation:(LYRConversation *)conversation parts:(NSArray *)messageParts;

/**
 @abstract A unique identifier for the message.
 */
@property (nonatomic, readonly) NSURL *identifier;

/**
 @abstract Object index dictating message order in a conversation.
 
 @discussion Unsent messages have index value of `NSNotFound`.
 */
@property (nonatomic, readonly) NSUInteger index;

/**
 @abstract The conversation that the receiver is a part of.
 */
@property (nonatomic, readonly) LYRConversation *conversation;

/**
 @abstract An array of message parts (modeled by the `LYRMessagePart` class) that provide access to the content of the receiver.
 */
@property (nonatomic, readonly) NSArray *parts;

/**
 @abstract Returns a Boolean value that is true when the receiver has been sent by a client and posted to the Layer services.
 */
@property (nonatomic, readonly) BOOL isSent;

/**
 @abstract Returns a Boolean value that indicates if the receiver has been deleted.
 */
@property (nonatomic, readonly) BOOL isDeleted;

/**
 @abstract A dictionary of metadata about the message synchronized among all participants.
 
 @discussion The metadata is a free-form structure for embedding synchronized data about the conversation that is
 to be shared among the participants. For example, a message might be designated as important by embedding a Boolean value
 within the metadata dictionary.
 */
@property (nonatomic, readonly) NSDictionary *metadata;

/**
 @abstract A dictionary of private, user-specific information about the message.
 
 @discussion The user info is a free-form structure for embedding data about the conversation that is synchronized between all the devices
 of the authenticated user, but is not shared with any other participants. For example, an applicatication may wish to flag a message for
 future follow-up by the user by embedding a Boolean value into the user info dictionary.
 */
@property (nonatomic, readonly) NSDictionary *userInfo;

/**
 @abstract The date and time that the message was originally sent.
 */
@property (nonatomic, readonly) NSDate *sentAt;

/**
 @abstract The date and time that the message was received by the authenticated user or `nil` if the current user sent the message.
 */
@property (nonatomic, readonly) NSDate *receivedAt;

/**
 @abstract The user ID of the user who sent the message.
 */
@property (nonatomic, readonly) NSString *sentByUserID;

///------------------------------
/// @name Accessing Read Receipts
///------------------------------

/**
 @abstract Returns a dictionary keyed the user ID of all participants in the Conversation that the receiver belongs to and whose
 values are an `NSNumber` representation of the receipient status (`LYRRecipientStatus` value) for their corresponding key.
 */
@property (nonatomic, readonly) NSDictionary *recipientStatusByUserID;

/**
 @abstract Retrieves the message state for a given participant in the conversation.
 
 @param userID The user ID to retrieve the message status for.
 @return An `LYRRecipientStatus` value specifying the message status for the given participant or `LYRRecipientStatusInvalid` if the specified user is not a participant in the conversation.
 */
- (LYRRecipientStatus)recipientStatusForUserID:(NSString *)userID;

@end
