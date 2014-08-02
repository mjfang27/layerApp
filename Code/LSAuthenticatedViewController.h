//
//  LSAuthenticatedViewController.h
//  LayerSample
//
//  Created by Kevin Coleman on 8/2/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSAPIManager.h"
#import "LSPersistenceManager.h"

@interface LSAuthenticatedViewController : UIViewController

@property (nonatomic, strong) LSAPIManager *APIManager;
@property (nonatomic, retain) IBOutlet UIButton* buttonNeedHelp;
@property (nonatomic, retain) IBOutlet UIButton* buttonGiveHelp;
@property (nonatomic, strong) LSPersistenceManager* persistenceManager; 
@end
