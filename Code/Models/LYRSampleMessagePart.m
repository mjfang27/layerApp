//
//  LYRSampleMessagePart.m
//  LYRSampleData
//
//  Created by Kevin Coleman on 6/4/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LYRSampleMessagePart.h"

@implementation LYRSampleMessagePart

@synthesize data = _data;

+ (NSArray *)parts
{
    LYRSampleMessagePart *part1 = [[LYRSampleMessagePart alloc] init];
    part1.data = [@"This is a sample message! It is a super simple sample message because it is super long. I am doing this to test my UI cells!" dataUsingEncoding:NSUTF8StringEncoding];
    
    LYRSampleMessagePart *part2 = [[LYRSampleMessagePart alloc] init];
    part2.data = [@"This is another sample message!" dataUsingEncoding:NSUTF8StringEncoding];

    return @[part1, part2];
}

@end
