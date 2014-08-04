//
//  LSGiveHelpViewController.h
//  LayerSample
//
//  Created by Michael Fang on 8/2/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPersistenceManager.h"

@interface LSGiveHelpViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property UIButton* registerButton;
@property (nonatomic, strong) UIPickerView* namePicker;
@property (nonatomic, strong) LSPersistenceManager *persistenceManager; 

@end
