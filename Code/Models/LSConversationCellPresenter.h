//
//  LSConversationCellPresenter.h
//  LayerSample
//
//  Created by Kevin Coleman on 6/29/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSPersistenceManager.h"
#import "LYRConversation.h"
#import "LYRMessage.h"
#import "LSUser.h"

/**
 @abstract The `LSConversationCellPresenter` class models a conversation object and is used to present conversation information to the user interface
 */

@interface LSConversationCellPresenter : NSObject

///-------------------------------
/// @name Initializing a Presenter
///-------------------------------

+ (instancetype)presenterWithConversation:(LYRConversation *)conversation message:(LYRMessage *)message persistanceManager:(LSPersistenceManager *)persistenceManager;

- (NSString *)conversationLabel;

- (UIImage *)conversationImage;

//KC: Method made public for testing purposes
- (NSString *)conversationLabelForParticipantNames:(NSArray *)participantNames;

@property (nonatomic, strong) LYRConversation *conversation;
@property (nonatomic, strong) LYRMessage *message;

@end
