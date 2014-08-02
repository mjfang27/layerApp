//
//  LYRConversation.h
//  LayerKit
//
//  Created by Klemen Verdnik on 06/05/14.
//  Copyright (c) 2014 Layer Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYRMessage;

/**
 @abstract The `LYRConversation` class models a conversations between two or more participants within Layer. A conversation is an
 on-going stream of messages (modeled by the `LYRMessage` class) synchronized among all participants.
 */
@interface LYRConversation : NSObject

/**
 @abstract Creates a new Conversation with the given set of participants.
 @param participants An array of participants with which to initialize the new Conversation.
 @discussion This method will create a new `LYRConversation` instance, creating new message instances with a new `LYRConversation` object instance and sending them will also result in creation of a new conversation for other participants. If you wish to ensure that only one Conversation exists for a set of participants then query for an existing Conversation using LYRClient's `conversationForParticipants:` first.
 @return The newly created Conversation.
 */
+ (instancetype)conversationWithParticipants:(NSArray *)participants;

/**
 @abstract A unique identifier assigned to every conversation by Layer.
 */
@property (nonatomic, readonly) NSURL *identifier;

/**
 @abstract The set of user identifiers's specifying who is participating in the conversation modeled by the receiver.
 @discussion Layer conversations are addressed using the user identifiers of the host application. These user ID's are transmitted to
 Layer as part of the Identity Token during authentication. User ID's are commonly modeled as the primary key, email address, or username
 of a given user withinin the backend application acting as the identity provider for the Layer-enabled mobile application.
 */
@property (nonatomic, readonly) NSSet *participants;

/**
 @abstract A dictionary of metadata about the conversation synchronized among all participants.
 @discussion The metadata is a free-form structure for embedding synchronized data about the conversation that is
 to be shared among the participants. For example, a conversation may have a topic that is assigned by the participants represented
 as a string value within the metadata dictionary.
 */
@property (nonatomic, readonly) NSDictionary *metadata;

/**
 @abstract A dictionary of private, user-specific information about the conversation.
 @discussion The user info is a free-form structure for embedding data about the conversation that is synchronized between all the devices
 of the authenticated user, but is not shared with any other participants. For example, an applicatication may wish to designate certain
 conversations as being favorites of the current user or all the user to annotate the conversation with contextual notes for future reference.
 */
@property (nonatomic, readonly) NSDictionary *userInfo;

/**
 @abstract The date and time that the conversation was created.
 */
@property (nonatomic, readonly) NSDate *createdAt;

/**
 @abstract Returns the last Message recevied or sent in this Conversation.
 @discussion May be `nil`, if no messages exist in the conversation.
 */
@property (nonatomic, readonly) LYRMessage *lastMessage;

/**
 @abstract Returns a Boolean value that indicates if the receiver has been deleted.
 */
@property (nonatomic, readonly) BOOL isDeleted;

@end
