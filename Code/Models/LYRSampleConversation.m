//
//  LYRSampleConversation.m
//  LYRSampleData
//
//  Created by Kevin Coleman on 6/4/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LYRSampleConversation.h"
#import "LYRSampleMessage.h"
#import "LSUser.h"

@implementation LYRSampleConversation

@synthesize identifier = _identifier;
@synthesize participants = _participants;
@synthesize createdAt = _createdAt;
@synthesize messages = _messages;

+ (NSSet *)sampleConversations
{
    NSMutableArray *conversations = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [conversations addObject:[self createConversation]];
    }
    return [[NSSet alloc] initWithArray:conversations];
}

+ (instancetype)createConversation
{
    return [self conversationWithIdentifier:[NSUUID UUID]
                               participants:[LSUser participants:arc4random_uniform(10) + 1]
                                   metadata:nil
                                   userInfo:nil
                                  createdAt:[NSDate date]];
}

+ (instancetype)conversationWithIdentifier:(NSUUID *)identifier
                              participants:(NSSet *)participants
                                  metadata:(NSDictionary *)metaData
                                  userInfo:(NSDictionary *)userInfo
                                 createdAt:(NSDate *)createdAt
{
    LYRSampleConversation *conversation = [[LYRSampleConversation alloc] init];
    conversation.identifier = identifier;
    conversation.participants = participants;
    conversation.createdAt = createdAt;
    conversation.messages = [LYRSampleMessage messagesForConversation:conversation];
    return conversation;
}

@end
