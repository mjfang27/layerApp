//
//  LSSession.m
//  LayerSample
//
//  Created by Blake Watters on 6/28/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSSession.h"

@implementation LSSession

+ (instancetype)sessionWithAuthenticationToken:(NSString *)authenticationToken user:(LSUser *)user
{
    return [[self alloc] initWithAuthenticationToken:authenticationToken user:user];
}

- (id)initWithAuthenticationToken:(NSString *)authenticationToken user:(LSUser *)user
{
    NSParameterAssert(authenticationToken);
    NSParameterAssert(user);
    
    self = [super init];
    if (self) {
        _authenticationToken = authenticationToken;
        _user = user;
    }
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to call designated initializer." userInfo:nil];
}

- (id)initWithCoder:(NSCoder *)decoder
{    
    NSString *authenticationToken = [decoder decodeObjectForKey:@"authenticationToken"];
    LSUser *user = [decoder decodeObjectForKey:@"user"];
    return [self initWithAuthenticationToken:authenticationToken user:user];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.authenticationToken forKey:@"authenticationToken"];
    [encoder encodeObject:self.user forKey:@"user"];
}

- (NSUInteger)hash
{
    return [self.authenticationToken hash] ^ [self.user.userID hash];
}

- (BOOL)isEqual:(id)object
{
    if (!object) return NO;
    if (![object isKindOfClass:[LSSession class]]) return NO;
    LSSession *otherSession = object;
    return [self.authenticationToken isEqualToString:otherSession.authenticationToken] && [self.user isEqual:otherSession.user];
}

@end
