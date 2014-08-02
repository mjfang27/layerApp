//
//  LSAppController.h
//  LayerSample
//
//  Created by Kevin Coleman on 6/30/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import "LSAPIManager.h"

/**
 @abstract The `LSAppController` class manages mission critical classes in the Layer Hackathon Sample App
 @discussion Your application should instantiate one instance of this object and pass it to view controllerrs
 that need access to its public properties.
 */

@interface LSApplicationController : NSObject

///--------------------------------
/// @name Initializing a Controller
///--------------------------------

+ (instancetype)controllerWithBaseURL:(NSURL *)baseURL layerClient:(LYRClient *)layerClient persistenceManager:(LSPersistenceManager *)persistenceManager;

/**
 @abstract The following properties service mission critical operations for the Layer Sample App and are managed by the Controller
 */

@property (nonatomic, strong) LYRClient *layerClient;
@property (nonatomic, strong) LSAPIManager *APIManager;
@property (nonatomic, strong) LSPersistenceManager *persistenceManager;

@end
