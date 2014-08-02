//
//  LSUtilities.h
//  LayerSample
//
//  Created by Kevin Coleman on 7/1/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import "LSPersistenceManager.h"
#import "LSApplicationController.h"

/**
 @abstract The `LSUtilities` class provides convenince functions for app configuration
 */

NSURL *LSRailsBaseURL();;

NSString *LSApplicationDataDirectory();

NSString *LSLayerPersistencePath();

LSPersistenceManager *LSPersitenceManager();

void LSAlertWithError(NSError *error);

LSApplicationController *ApplicationController(LYRClient *client);