//
//  LSInputTableViewCell.h
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSInputTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;

- (void)setText:(NSString *)text;

@end
