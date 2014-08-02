//
//  LSPersistenceManager.m
//  LayerSample
//
//  Created by Blake Watters on 6/28/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSPersistenceManager.h"

#define LSMustBeImplementedBySubclass() @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must be implemented by concrete subclass." userInfo:nil]

@interface LSInMemoryPersistenceManager : LSPersistenceManager

@property (nonatomic) NSMutableSet *users;
@property (nonatomic) LSSession *session;

@end

@interface LSOnDiskPersistenceManager : LSPersistenceManager

@property (nonatomic, readonly) NSString *path;

- (id)initWithPath:(NSString *)path;

@end

@implementation LSPersistenceManager

+ (instancetype)persistenceManagerWithInMemoryStore
{
    return [LSInMemoryPersistenceManager new];
}

+ (instancetype)persistenceManagerWithStoreAtPath:(NSString *)path
{
    return [[LSOnDiskPersistenceManager alloc] initWithPath:path];
}

- (id)init
{
    if ([self isMemberOfClass:[LSPersistenceManager class]]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to call designated initializer." userInfo:nil];
    } else {
        return [super init];
    }
}

- (BOOL)persistUsers:(NSSet *)users error:(NSError **)error
{
    LSMustBeImplementedBySubclass();
}

- (NSSet *)persistedUsersWithError:(NSError **)error
{
    LSMustBeImplementedBySubclass();
}

- (BOOL)deleteAllObjects:(NSError **)error
{
    LSMustBeImplementedBySubclass();
}

- (BOOL)persistSession:(LSSession *)session error:(NSError **)error
{
    LSMustBeImplementedBySubclass();
}

- (LSSession *)persistedSessionWithError:(NSError **)error
{
    LSMustBeImplementedBySubclass();
}

@end

@implementation LSInMemoryPersistenceManager

- (id)init
{
    self = [super init];
    if (self) {
        _users = [NSMutableSet set];
    }
    return self;
}

- (BOOL)persistUsers:(NSSet *)users error:(NSError **)error
{
    NSParameterAssert(users);
    [self.users unionSet:users];
    return YES;
}

- (NSSet *)persistedUsersWithError:(NSError **)error
{
    return self.users;
}

- (BOOL)persistSession:(LSSession *)session error:(NSError **)error
{
    self.session = session;
    return YES;
}

- (LSSession *)persistedSessionWithError:(NSError **)error
{
    return self.session;
}

- (BOOL)deleteAllObjects:(NSError **)error
{
    [self.users removeAllObjects];
    self.session = nil;
    return YES;
}

@end

@implementation LSOnDiskPersistenceManager

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _path = path;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDirectory;
        if ([fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
            if (!isDirectory) {
                [NSException raise:NSInternalInconsistencyException format:@"Failed to initialize persistent store at '%@': specified path is a regular file.", path];
            }
        } else {
            NSError *error = nil;
            BOOL success = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            if (!success) {
                [NSException raise:NSInternalInconsistencyException format:@"Failed creating persistent store at '%@': %@", path, error];
            }
        }
    }
    return self;
}

- (BOOL)persistUsers:(NSSet *)users error:(NSError **)error
{
    NSString *path = [self.path stringByAppendingPathComponent:@"Users.plist"];
    return [NSKeyedArchiver archiveRootObject:users toFile:path];
}

- (NSSet *)persistedUsersWithError:(NSError **)error
{
    NSString *path = [self.path stringByAppendingPathComponent:@"Users.plist"];
    NSSet *users = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return users;
}

- (BOOL)deleteAllObjects:(NSError **)error
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subpaths = [fileManager contentsOfDirectoryAtPath:self.path error:error];
    if (!subpaths) {
        return NO;
    }
    
    for (NSString *subpath in subpaths) {
        if ([[subpath pathExtension] isEqualToString:@"plist"]) {
            if (![fileManager removeItemAtPath:[self.path stringByAppendingPathComponent:subpath] error:error]) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)persistSession:(LSSession *)session error:(NSError **)error
{
    NSString *path = [self.path stringByAppendingPathComponent:@"Session.plist"];
    return [NSKeyedArchiver archiveRootObject:session toFile:path];
}

- (LSSession *)persistedSessionWithError:(NSError **)error
{
    NSString *path = [self.path stringByAppendingPathComponent:@"Session.plist"];
    LSSession *session = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return session;
}

@end
