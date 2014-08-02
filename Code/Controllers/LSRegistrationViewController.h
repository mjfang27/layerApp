//
//  LSRegistrationViewController.h
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSAPIManager.h"

@interface LSRegistrationViewController : UITableViewController

@property (nonatomic, strong) LSAPIManager *APIManager;

/**
 @abstract Sets a block to be executed upon completion of the registration.
 @param completion A block to be executed when the registration controller has finished its work.
 */
- (void)setCompletionBlock:(void (^)(LSUser *user))completion;

@end
