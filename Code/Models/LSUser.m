//
//  LYRSampleParticipant.m
//  LYRSampleData
//
//  Created by Kevin Coleman on 6/4/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSUser.h"

@implementation LSUser

+ (instancetype)userFromDictionaryRepresentation:(NSDictionary *)representation
{
    LSUser *user = [LSUser new];
    user.userID = representation[@"id"];
    user.firstName = representation[@"first_name"];
    user.lastName = representation[@"last_name"];
    user.email = representation[@"email"];
    user.password = representation[@"password"];
    
    return user;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.userID = [decoder decodeObjectForKey:NSStringFromSelector(@selector(userID))];
    self.firstName = [decoder decodeObjectForKey:NSStringFromSelector(@selector(firstName))];
    self.lastName = [decoder decodeObjectForKey:NSStringFromSelector(@selector(lastName))];
    self.email = [decoder decodeObjectForKey:NSStringFromSelector(@selector(email))];
    self.password = [decoder decodeObjectForKey:NSStringFromSelector(@selector(password))];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userID forKey:NSStringFromSelector(@selector(userID))];
    [encoder encodeObject:self.firstName forKey:NSStringFromSelector(@selector(firstName))];
    [encoder encodeObject:self.lastName forKey:NSStringFromSelector(@selector(lastName))];
    [encoder encodeObject:self.email forKey:NSStringFromSelector(@selector(email))];
    [encoder encodeObject:self.password forKey:NSStringFromSelector(@selector(password))];
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (BOOL)validate:(NSError *__autoreleasing *)error
{
    if (!self.email) {
        if (error) *error = [NSError errorWithDomain:@"Registration Error" code:101 userInfo:@{ NSLocalizedDescriptionKey: @"Please enter an email in order to register" }];
        return NO;
    }
    
    if (!self.firstName) {
        if (error) *error = [NSError errorWithDomain:@"Registration Error" code:101 userInfo:@{ NSLocalizedDescriptionKey: @"Please enter an email in order to register" }];
        return NO;
    }
    
    if (!self.lastName) {
        if (error) *error = [NSError errorWithDomain:@"Registration Error" code:101 userInfo:@{ NSLocalizedDescriptionKey: @"Please enter an email in order to register" }];
        return NO;
    }
    
    if (!self.password || !self.passwordConfirmation || ![self.password isEqualToString:self.passwordConfirmation]) {
        if (error) *error = [NSError errorWithDomain:@"Registration Error" code:101 userInfo:@{ NSLocalizedDescriptionKey: @"Please enter matching passwords in order to register" }];
        return NO;
    }
    
    return YES;
}

- (NSUInteger)hash
{
    return [self.userID hash];
}

- (BOOL)isEqual:(id)object
{
    if (!object) return NO;
    if (![object isKindOfClass:[LSUser class]]) return NO;
    return [self.userID isEqualToString:[(LSUser *)object userID]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p userID=%@, firstName=%@, lastName=%@, email=%@, password=%@>",
            [self class], self, self.userID, self.firstName, self.lastName, self.email, self.password];
}

@end
