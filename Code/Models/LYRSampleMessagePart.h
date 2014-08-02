//
//  LYRSampleMessagePart.h
//  LYRSampleData
//
//  Created by Kevin Coleman on 6/4/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYRSampleMessagePart : NSObject

@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSData *data;

+ (NSArray *)parts;

@end
