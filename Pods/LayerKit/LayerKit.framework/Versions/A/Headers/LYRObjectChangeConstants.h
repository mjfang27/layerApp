//
//  LYRObjectChangeConstants.h
//  LayerKit
//
//  Created by Blake Watters on 7/13/2014
//  Copyright (c) 2014 Layer. All rights reserved.
//

///---------------------
/// @name Object Changes
///---------------------

typedef NS_ENUM(NSInteger, LYRObjectChangeType) {
	LYRObjectChangeTypeCreate,
	LYRObjectChangeTypeUpdate,
	LYRObjectChangeTypeDelete
};

/**
 @abstract A key into a change dictionary describing the change type. @see `LYRObjectChangeType` for possible types.
 */
extern NSString *const LYRObjectChangeTypeKey; // Expect values defined in the enum `LYRObjectChangeType` as `NSNumber` integer values.

/**
 @abstract A key into a change dictionary for the object that was created, updated, or deleted.
 */
extern NSString *const LYRObjectChangeObjectKey; // The `LYRConversation` or `LYRMessage` that changed.

// Only applicable to `LYRObjectChangeTypeUpdate`
extern NSString *const LYRObjectChangePropertyKey; // i.e. participants, metadata, userInfo, index
extern NSString *const LYRObjectChangeOldValueKey; // The value before synchronization
extern NSString *const LYRObjectChangeNewValueKey; // The value after synchronization
