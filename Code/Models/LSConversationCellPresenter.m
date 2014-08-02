//
//  LSConversationCellPresenter.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/29/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSConversationCellPresenter.h"
#import "LSUser.h"

@interface LSPersistenceManager ()

- (LSUser *)userWithIdentifier:(NSString *)userID;

@end

@interface LSConversationCellPresenter ()

@property (nonatomic, strong) LSPersistenceManager *persistenceManager;

@end

@implementation LSConversationCellPresenter

+ (instancetype)presenterWithConversation:(LYRConversation *)conversation message:(LYRMessage *)message persistanceManager:(LSPersistenceManager *)persistenceManager
{
    return [[self alloc] initWithConversation:conversation message:message persistenceManager:persistenceManager];
}
            
- (id)initWithConversation:(LYRConversation *)conversation message:(LYRMessage *)message persistenceManager:(LSPersistenceManager *)persistenceManager
{
    self = [super init];
    if (self) {
        _conversation = conversation;
        _message = message;
        _persistenceManager = persistenceManager;
    }
    return self;
}

- (NSString *)conversationLabel
{
    NSArray *sortedParticipantNames = [self sortedFullNamesForParticiapnts:self.conversation.participants];
    return [self conversationLabelForParticipantNames:sortedParticipantNames];
}

- (UIImage *)conversationImage
{
    return nil;
}

- (NSArray *)sortedFullNamesForParticiapnts:(NSSet *)participantIDs
{
    NSError *error;
    LSSession *session = [self.persistenceManager persistedSessionWithError:&error];
    LSUser *authenticatedUser = session.user;
    
    NSMutableArray *fullNames = [NSMutableArray new];
    NSSet *persistedUsers = [self.persistenceManager persistedUsersWithError:&error];
    for (NSString *userID in participantIDs) {
        for (LSUser *persistedUser in persistedUsers) {
            if ([userID isEqualToString:persistedUser.userID] && ![userID isEqualToString:authenticatedUser.userID]) {
                [fullNames addObject:persistedUser.fullName];
            }
        }
    }
    return [fullNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSString *)conversationLabelForParticipantNames:(NSArray *)participantNames
{
    NSString *conversationLabel;
    if (participantNames.count > 0) {
        conversationLabel = [participantNames objectAtIndex:0];
        for (int i = 1; i < participantNames.count; i++) {
            conversationLabel = [NSString stringWithFormat:@"%@, %@", conversationLabel, [participantNames objectAtIndex:i]];
        }
    }
    return conversationLabel;
}
@end
