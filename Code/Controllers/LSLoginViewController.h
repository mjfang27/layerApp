//
//  LSLoginTableViewController.h
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSAPIManager.h"

@class LSUser, LYRClient;

@interface LSLoginViewController : UITableViewController

@property (nonatomic, strong) LSAPIManager *APIManager;

- (void)setCompletionBlock:(void (^)(LSUser *user))completion;

@end
