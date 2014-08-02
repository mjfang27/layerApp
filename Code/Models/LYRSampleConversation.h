//
//  LYRSampleConversation.h
//  LYRSampleData
//
//  Created by Kevin Coleman on 6/4/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYRSampleConversation : NSObject

@property (nonatomic, strong) NSUUID *identifier;
@property (nonatomic, strong) NSSet *participants;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSMutableArray *messages;

+ (NSSet *)sampleConversations;

@end
