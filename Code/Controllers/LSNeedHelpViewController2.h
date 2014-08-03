//
//  LSNeedHelpViewController.h
//  LayerSample
//
//  Created by Michael Fang on 8/2/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPersistenceManager.h"

@interface LSNeedHelpViewController2 : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) IBOutlet UILabel *onCallName;
@property (nonatomic, retain) IBOutlet UIButton* buttonMessage;
@property (nonatomic, strong) NSArray *givingPeople;
@property (nonatomic, strong) LSPersistenceManager *persistenceManager;
@property (nonatomic, strong) UIPickerView* giverPicker; 

@end
