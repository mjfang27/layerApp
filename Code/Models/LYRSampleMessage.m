//
//  LYRSampleMessage.m
//  LYRSampleData
//
//  Created by Kevin Coleman on 6/4/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LYRSampleMessage.h"
#import "LSUser.h"
#import "LYRSampleMessagePart.h"

@implementation LYRSampleMessage

+ (NSMutableArray *)messagesForConversation:(LYRSampleConversation *)conversation
{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    for (int i = 0; i < 30; i++) {
        [messages addObject:[self messageWithConversation:conversation]];
    }
    return messages;
}

+ (instancetype)messageWithConversation:(LYRSampleConversation *)conversation
{
    int count = (int)conversation.participants.count;
    int number = arc4random_uniform(count);
    NSUInteger participantNumber = (NSUInteger)number;
    LSUser *participant = [[conversation.participants allObjects] objectAtIndex:participantNumber];
    
    return [self messageWithConversation:conversation
                              identifier:[NSUUID UUID]
                                   parts:[LYRSampleMessagePart parts]
                                  sentAt:[NSDate date]
                              receivedAt:[NSDate date]
                            sentByUserID:participant.identifier];
}

+ (instancetype)messageWithConversation:(LYRSampleConversation *)conversation
                             identifier:(NSUUID *)identifier
                                  parts:(NSArray*)parts
                                 sentAt:(NSDate *)sentAt
                             receivedAt:(NSDate *)receivedAt
                           sentByUserID:(NSString *)userID
{
    LYRSampleMessage *message = [[LYRSampleMessage alloc] init];
    message.conversation = conversation;
    message.identifier = identifier;
    message.parts = parts;
    message.sentAt = sentAt;
    message.receivedAt = receivedAt;
    message.sentByUserID = userID;
    return message;
}

- (NSString *)text
{
    LYRSampleMessagePart *part = [self.parts objectAtIndex:0];
    NSString *text = [[NSString alloc] initWithData:part.data encoding:NSUTF8StringEncoding];
    return text;
}

- (NSString *)sender
{
    LSUser *participant = [LSUser participantWithNumber:[self.sentByUserID intValue]];
    return participant.fullName;
}

- (NSDate *)date
{
    return self.sentAt;
}

@end
