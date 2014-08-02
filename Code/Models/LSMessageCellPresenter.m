//
//  LSMessageCellPresenter.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/30/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSMessageCellPresenter.h"
#import "LYRConversation.h"

@interface LSMessageCellPresenter ()

@property (nonatomic) LSPersistenceManager *persistenceManager;
@property (nonatomic) NSIndexPath *indexPath;


@end

@implementation LSMessageCellPresenter

+ (instancetype)presenterWithMessages:(NSOrderedSet *)messages indexPath:(NSIndexPath *)indexPath persistanceManager:(LSPersistenceManager *)persistenceManager;
{
    return [[self alloc] initWithMessage:messages indexPath:indexPath persistenceManager:persistenceManager];
}

- (id)initWithMessage:(NSOrderedSet *)messages indexPath:(NSIndexPath *)indexPath persistenceManager:(LSPersistenceManager *)persistenceManager
{
    self = [super init];
    if (self) {
        _message = [messages objectAtIndex:indexPath.section];
        _messages = messages;
        _persistenceManager = persistenceManager;
        _indexPath = indexPath;
    }
    return self;
}

- (BOOL)messageWasSentByAuthenticatedUser
{
    NSError *error;
    LSSession *session = [self.persistenceManager persistedSessionWithError:&error];
    LSUser *authenticatedUser = session.user;
    
    if ([self.message.sentByUserID isEqualToString:authenticatedUser.userID]) {
        return YES;
    }
    return NO;
}

- (NSString *)labelForMessageSender
{
    NSError *error;
    NSArray *persistedUsers = [[self.persistenceManager persistedUsersWithError:&error] allObjects];
    LSUser *sender;
    for (LSUser *user in persistedUsers) {
        if ([[user valueForKeyPath:@"userID"] isEqualToString:self.message.sentByUserID]) {
            sender = user;
        }
    }
    return sender.fullName;
}

- (UIImage *)imageForMessageSender
{
    return [UIImage imageNamed:@"kevin"];
}

- (NSUInteger)indexForPart
{
    return (NSUInteger)self.indexPath.row;
}

- (BOOL)shouldShowSenderImage
{
    LYRMessage *message = [self.messages objectAtIndex:self.indexPath.section];
    LYRMessage *previousMessage;
    
    //If there is a previous message...
    if (self.messages.count > 0 && self.messages.count - 1 > self.indexPath.section) {
        previousMessage = [self.messages objectAtIndex:(self.indexPath.section + 1)];
    }
    
    //Check if it was sent by the same user as the current message
    if ([previousMessage.sentByUserID isEqualToString:message.sentByUserID]) {
        return NO;
    } else {
        return YES;
        
    }
}

- (BOOL)shouldShowSenderLabel
{
    // If there are only two people in a conversation, no need for labels
    if (3 > self.message.conversation.participants.count) {
        return FALSE;
    }
    
    // If the message was send by the authenticated user, no need for label
    if ([self messageWasSentByAuthenticatedUser]) return FALSE;
    
    // If there are no previous messages, show a label
    if (self.indexPath.section == 0 ) return TRUE;
    
    LYRMessage *message = [self.messages objectAtIndex:self.indexPath.section];
    LYRMessage *nextMessage;
    
    //If there is a next message....
    if (self.indexPath.section > 0 && self.messages.count - 1 >= self.indexPath.section) {
        nextMessage = [self.messages objectAtIndex:(self.indexPath.section - 1)];
    } else {
        return NO;
    }
    
    //Check if it was sent by the same user as the current message
    if ([nextMessage.sentByUserID isEqualToString:message.sentByUserID]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)shouldShowTimeStamp
{
    if (self.indexPath.section == 0 ) return TRUE;
    
    LYRMessage *message = [self.messages objectAtIndex:self.indexPath.section];
    LYRMessage *previousMessage;
    
    //If there is a previous message....
    if (self.indexPath.section > 0 && self.messages.count - 1 >= self.indexPath.section) {
        previousMessage = [self.messages objectAtIndex:(self.indexPath.section - 1)];
    } else {
        return NO;
        
    }
    
    //Check if last message was more than 1hr ago
    double interval = [message.receivedAt timeIntervalSinceDate:previousMessage.receivedAt];
    if (interval > (60 * 60)) {
        return YES;
    } else {
        return NO;
    }
}

@end
