//
//  LSHomeViewController.h
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>
#import "LSAPIManager.h"

/**
 @abtract The `LSAuthenticationViewController` presents a user interface that allows the user to login or register for an account.
 */
@interface LSAuthenticationViewController : UIViewController

@property (nonatomic) LYRClient *layerClient;
@property (nonatomic) LSAPIManager *APIManager;

@end
