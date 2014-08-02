//
//  LYRClient.h
//  LayerKit
//
//  Created by Klemen Verdnik on 7/23/13.
//  Copyright (c) 2013 Layer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LYRConversation.h"
#import "LYRMessage.h"
#import "LYRMessagePart.h"
#import "LYRObjectChangeConstants.h"

@class LYRClient;

extern NSString *const LYRClientDidAuthenticateNotification;
extern NSString *const LYRClientAuthenticatedUserIDUserInfoKey;
extern NSString *const LYRClientDidDeauthenticateNotification;

extern NSString *const LYRClientWillBeginSynchronizationNotification;
extern NSString *const LYRClientDidFinishSynchronizationNotification;

///---------------------------
/// @name Change Notifications
///---------------------------

/**
 @abstract Posted when the objects for a client have changed due to synchronization activities.
 @discussion The Layer client provides a flexible notification system for informing applications when changes have
 occured on domain objects in response to synchronization activities. The system is designed to be general
 purpose and models changes as the creation, update, or deletion of an object. Changes are modeled as simple
 dictionaries with a fixed key space that is defined below.
 @see LYRObjectChangeConstants.h
 */
extern NSString *const LYRClientObjectsDidChangeNotification;

/**
 @abstract The key into the `userInfo` of a `LYRClientObjectsDidChangeNotification` notification for an array of changes.
 @discussion Each element in array retrieved from the user info for the `LYRClientObjectChangesUserInfoKey` key is a dictionary whose value models a 
 single object change event for a Layer model object. The change dictionary contains information about the object that changed, what type of
 change occurred (create, update, or delete) and additional details for updates such as the property that changed and its value before and after mutation.
 Change notifications are emitted after synchronization has completed and represent the current state of the Layer client's database.
 @see LYRObjectChangeConstants.h
 */
extern NSString *const LYRClientObjectChangesUserInfoKey;

/**
 The `LYRClientDelegate` protocol provides a method for notifying the adopting delegate about information changes.
 */
@protocol LYRClientDelegate <NSObject>

@required

/**
 @abstract Tells the delegate that the server has issued an authentication challenge to the client and a new Identity Token must be submitted.
 @discussion At any time during the lifecycle of a Layer client session the server may issue an authentication challenge and require that
    the client confirm its identity. When such a challenge is encountered, the client will immediately become deauthenticated and will no
    longer be able to interact with communication services until reauthenticated. The nonce value issued with the challenge must be submitted
    to the remote identity provider in order to obtain a new Identity Token.
 @see LayerClient#authenticateWithIdentityToken:completion:
 @param client The client that received the authentication challenge.
 @param nonce The nonce value associated with the challenge.
 */
- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce;

@optional
/**
 @abstract Tells the delegate that a client has successfully authenticated with Layer.
 @param client The client that has authenticated successfully.
 @param userID The user identifier in Identity Provider from which the Identity Token was obtained. Typically the primary key, username, or email
    of the user that was authenticated.
 */
- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID;

/**
 @abstract Tells the delegate that a client has been deauthenticated.
 @discussion The client may become deauthenticated either by an explicit call to `deauthenticateWithCompletion:` or by encountering an authentication challenge.
 @param client The client that was deauthenticated.
 */
- (void)layerClientDidDeauthenticate:(LYRClient *)client;

/**
 @abstract Tells the delegate that a client has finished synchronization and applied a set of changes.
 @param client The client that received the changes.
 @param changes An array of `NSDictionary` objects, each one describing a change.
 */
- (void)layerClient:(LYRClient *)client didFinishSynchronizationWithChanges:(NSArray *)changes;

/**
 @abstract Tells the delegate the client encountered an error during synchronization.
 @param client The client that failed synchronization.
 @param error An error describing the nature of the sync failure.
 */
- (void)layerClient:(LYRClient *)client didFailSynchronizationWithError:(NSError *)error;

@end


@interface LYRClient : NSObject

/**
 @abstract Creates and returns a new Layer client instance.
 */
+ (instancetype)clientWithAppID:(NSUUID *)appID;

/**
 @abstract The object that acts as the delegate of the receiving client.
 */
@property (nonatomic, weak) id<LYRClientDelegate> delegate;

/**
 @abstract The app key.
 */
@property (nonatomic, copy, readonly) NSUUID *appID;

/**
 @abstract Signals the receiver to establish a network connection and initiate synchronization.
 @discussion If the client has previously established an authenticated identity then the session is resumed and synchronization is activated.
 @param completion An optional block to be executed once connection state is determined. The block has no return value and accepts two arguments: a Boolean value indicating if the connection was made successfully and an error object that, upon failure, indicates the reason that connection was unsuccessful.
*/
- (void)connectWithCompletion:(void (^)(BOOL success, NSError *error))completion;

/**
 @abstract Signals the receiver to end the established network connection.
 */
- (void)disconnect;

/**
 @abstract Returns a Boolean value that indicates if the client is connected to Layer.
 */
@property (nonatomic, readonly) BOOL isConnected;

///--------------------------
/// @name User Authentication
///--------------------------

/**
 @abstract Returns a string object specifying the user ID of the currently authenticated user or `nil` if the client is not authenticated.
 @discussion A client is considered authenticated if it has previously established identity via the submission of an identity token
 and the token has not yet expired. The Layer server may at any time issue an authentication challenge and deauthenticate the client.
*/
@property (nonatomic, readonly) NSString *authenticatedUserID;

/**
 @abstract Requests an authentication nonce from Layer.
 @discussion Authenticating a Layer client requires that an Identity Token be obtained from a remote backend application that has been designated to act as an
 Identity Provider on behalf of your application. When requesting an Identity Token from a provider, you are required to provide a nonce value that will be included
 in the cryptographically signed data that comprises the Identity Token. This method asynchronously requests such a nonce value from Layer.
 @warning Nonce values can be issued by Layer at any time in the form of an authentication challenge. You must be prepared to handle server issued nonces as well as those
 explicitly requested by a call to `requestAuthenticationNonceWithCompletion:`.
 @param completion A block to be called upon completion of the asynchronous request for a nonce. The block takes two parameters: the nonce value that was obtained (or `nil`
 in the case of failure) and an error object that upon failure describes the nature of the failure.
 @see LYRClientDelegate#layerClient:didReceiveAuthenticationChallengeWithNonce:
 */
- (void)requestAuthenticationNonceWithCompletion:(void (^)(NSString *nonce, NSError *error))completion;

/**
 @abstract Authenticates the client by submitting an Identity Token to Layer for evaluation.
 @discussion Authenticating a Layer client requires the submission of an Identity Token from a remote backend application that has been designated to act as an
    Identity Provider on behalf of your application. The Identity Token is a JSON Web Signature (JWS) string that encodes a cryptographically signed set of claims
    about the identity of a Layer client. An Identity Token must be obtained from your provider via an application defined mechanism (most commonly a JSON over HTTP
    request). Once an Identity Token has been obtained, it must be submitted to Layer via this method in ordr to authenticate the client and begin utilizing communication 
    services. Upon successful authentication, the client remains in an authenticated state until explicitly deauthenticated by a call to `deauthenticateWithCompletion:` or
    via a server-issued authentication challenge.
 @param identityToken A string object encoding a JSON Web Signature that asserts a set of claims about the identity of the client. Must be obtained from a remote identity
    provider and include a nonce value that was previously obtained by a call to `requestAuthenticationNonceWithCompletion:` or via a server initiated authentication challenge.
 @param completion A block to be called upon completion of the asynchronous request for authentication. The block takes two parameters: a string encoding the remote user ID that
    was authenticated (or `nil` if authentication was unsuccessful) and an error object that upon failure describes the nature of the failure.
 @see http://tools.ietf.org/html/draft-ietf-jose-json-web-signature-25
 */
- (void)authenticateWithIdentityToken:(NSString *)identityToken completion:(void (^)(NSString *authenticatedUserID, NSError *error))completion;

/**
 @abstract Deauthenticates the client, disposing of any previously established user identity and disallowing access to the Layer communication services until a new identity is established. All existing messaging data is purged from the database.
 */
- (void)deauthenticate;

///-------------------------------------------------------
/// @name Registering For and Receiving Push Notifications
///-------------------------------------------------------

/**
 @abstract Tells the receiver to update the device token used to deliver Push Notificaitons to the current device via the Apple Push Notification Service.
 @param deviceToken An `NSData` object containing the device token.
 @param error A reference to an `NSError` object that will contain error information in case the action was not successful.
 @return A Boolean value that determines whether the action was successful.
 @discussion The device token is expected to be an `NSData` object returned by the method application:didRegisterForRemoteNotificationsWithDeviceToken:. The device token is cached locally and is sent to Layer cloud automatically when the connection is established.
 */
- (BOOL)updateRemoteNotificationDeviceToken:(NSData *)deviceToken error:(NSError **)error;

/**
 @abstract Inspects an incoming push notification and synchronizes the client if it was sent by Layer.
 @param userInfo The user info dictionary received from the UIApplicaton delegate method application:didReceiveRemoteNotification:fetchCompletionHandler:'s `userInfo` parameter.
 @param completion The block that will be called once Layer has successfully downloaded new data associated with the `userInfo` dictionary passed in. It is your responsibility to call the UIApplication delegate method's fetch completion handler with the given `fetchResult`.
 @return A Boolean value that determines whether the push was handled. Will be `NO` if this was not a push notification meant for Layer.
 */
- (BOOL)synchronizeWithRemoteNotification:(NSDictionary *)userInfo completion:(void(^)(UIBackgroundFetchResult fetchResult, NSError *error))completion;

///----------------
/// @name Messaging
///----------------

/**
 @abstract Returns an existing conversation with a given identifier or `nil` if none could be found.
 @param identifier The identifier for an existing conversation.
 @return The conversation with the given identifier or `nil` if none could be found.
 */
- (LYRConversation *)conversationForIdentifier:(NSURL *)identifier;

/**
 @abstract Returns an existing conversation with the given set of participants or `nil` if none could be found.
 @discussion This method returns the first conversation with the given set of participants. Note that it is possible to create more than one Conversation with a given set of participants.
 @param participants An array of participants for which to query for a corresponding Conversation. Each element in the array is a string that corresponds to the user ID of the desired participant.
 @return The conversation with the given set of participants or `nil` if none could be found.
 */
- (LYRConversation *)conversationForParticipants:(NSArray *)participants;

/**
 @abstract Adds participants to a given conversation.
 @param participants An array of `providerUserID` in a form of `NSString` objects.
 @param conversation The conversation which to add the participants. Cannot be `nil`.
 @param error A pointer to an error object that, upon failure, will be set to an error describing why the participants could not be added to the conversation.
 @return A Boolean value indicating if the operation of adding participants was successful.
 */
- (BOOL)addParticipants:(NSArray *)participants toConversation:(LYRConversation *)conversation error:(NSError **)error;

/**
 @abstract Removes participants from a given conversation.
 @param participants An array of `providerUserID` in a form of `NSString` objects.
 @param conversation The conversation from which to remove the participants. Cannot be `nil`.
 @param error A pointer to an error object that, upon failure, will be set to an error describing why the participants could not be removed from the conversation.
 @return A Boolean value indicating if the operation of removing participants was successful.
 */
- (BOOL)removeParticipants:(NSArray *)participants fromConversation:(LYRConversation *)conversation error:(NSError **)error;

/**
 @abstract Sends the specified message.
 @discussion The message is enqueued for delivery during the next synchronization after basic local validation of the message state is performed. Validation
 that may be performed includes checking that the maximum number of participants has not been execeeded and that parts of the message do not have an aggregate
 size in excess of the maximum for a message.
 @param message The message to be sent. Cannot be `nil`.
 @param error A pointer to an error object that, upon failure, will be set to an error describing why the message could not be sent.
 @return A Boolean value indicating if the message passed validation and was enqueued for delivery.
 @raises NSInvalidArgumentException Raised if `message` is `nil`.
 */
- (BOOL)sendMessage:(LYRMessage *)message error:(NSError **)error;

/**
 @abstract Marks a message as being read by the current user.
 @param message The message to be marked as read.
 @param error A pointer to an error object that, upon failure, will be set to an error describing why the message could not be sent.
 @return `YES` if the message was marked as read or `NO` if the message was already marked as read.
 */
- (BOOL)markMessageAsRead:(LYRMessage *)message error:(NSError **)error;

/**
 @abstract Sets the metadata associated with an object. The object must be of the type `LYRMessage` or `LYRConversation`.
 @param metadata The metadata to set on the object.
 @param object The object on which to set the metadata.
 @return `YES` if the metadata was set successfully.
 */
- (BOOL)setMetadata:(NSDictionary *)metadata onObject:(id)object;

///------------------------------------------
/// @name Deleting Messages and Conversations
///------------------------------------------

/**
 @abstract Deletes a message.
 @param message The message to be deleted.
 @param error A pointer to an error that upon failure is set to an error object describing why the deletion failed.
 @return A Boolean value indicating if the request to delete the message was submitted for synchronization.
 @raises NSInvalidArgumentException Raised if `message` is `nil`.
 */
- (BOOL)deleteMessage:(LYRMessage *)message error:(NSError **)error;

/**
 @abstract Deletes a conversation.
 @discussion This method deletes a conversation and all associated messages for all current participants.
 @param conversation The conversation to be deleted.
 @param error A pointer to an error that upon failure is set to an error object describing why the deletion failed.
 @return A Boolean value indicating if the request to delete the conversation was submitted for synchronization.
 @raises NSInvalidArgumentException Raised if `message` is `nil`.
 */
- (BOOL)deleteConversation:(LYRConversation *)conversation error:(NSError **)error;

///--------------------------------------------
/// @name Retrieving Conversations & Messages
///--------------------------------------------

/**
 @abstract Retrieves a collection of conversation objects from the persistent store for the given list of conversation identifiers.
 @param conversationIdentifiers The set of conversation identifiers for which to retrieve the corresponding set of conversation objects. Passing `nil` 
 will return all conversations.
 @return A set of conversations objects for the given array of identifiers.
 */
- (NSSet *)conversationsForIdentifiers:(NSSet *)conversationIdentifiers;

/**
 @abstract Retrieves a collection of message objects from the persistent store for the given list of message identifiers.
 @param messageIdentifiers The set of message identifiers for which to retrieve the corresponding set of message objects. Passing `nil`
 will return all messages.
 @return An set of message objects for the given array of identifiers.
 */
- (NSSet *)messagesForIdentifiers:(NSSet *)messageIdentifiers;

/**
 @abstract Returns the collection of messages in a given conversation.
 @discussion Messages are returned in chronological order in the Conversation.
 @param conversation The conversation to retrieve the set of messages for.
 @return An set of messages for the given conversation.
 */
- (NSOrderedSet *)messagesForConversation:(LYRConversation *)conversation;

@end
