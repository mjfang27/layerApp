//
//  LYRSampleParticipant.h
//  LYRSampleData
//
//  Created by Kevin Coleman on 6/4/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSUser : NSObject <NSCoding>

+ (instancetype)userFromDictionaryRepresentation:(NSDictionary *)representation;

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *passwordConfirmation;

- (BOOL)validate:(NSError **)error;

@end
