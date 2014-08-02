//
//  LSButton.h
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// SBW: What's up with the shadow API's? I'd probably use a category on UIButton if this stuff is really useful
@interface LSButton : UIButton

@property (nonatomic, strong) UILabel *textLabel;

- (id)initWithText:(NSString *)text;

@end
