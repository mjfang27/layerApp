//
//  LYRSampleMessage.h
//  LYRSampleData
//
//  Created by Kevin Coleman on 6/4/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYRSampleConversation.h"


@interface LYRSampleMessage : NSObject

@property (nonatomic, strong) LYRSampleConversation *conversation;
@property (nonatomic, strong) NSUUID *identifier;
@property (nonatomic, strong) NSArray *parts;
@property (nonatomic, strong) NSDate *sentAt;
@property (nonatomic, strong) NSDate *receivedAt;
@property (nonatomic, strong) NSString *sentByUserID;

+ (NSArray *)messagesForConversation:(LYRSampleConversation *)conversation;

@end
