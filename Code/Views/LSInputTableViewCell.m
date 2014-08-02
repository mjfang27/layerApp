//
//  LSInputTableViewCell.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSInputTableViewCell.h"
#import "LSUIConstants.h"

@implementation LSInputTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, 300, 45)];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    self.textField.placeholder = text;
    self.textField.font = LSMediumFont(18);
    self.textField.textColor = [UIColor darkGrayColor];
    [self.textField sizeToFit];
    self.textField.frame = CGRectMake(20, 14, self.frame.size.width - 20, self.textField.frame.size.height);
    [self.contentView addSubview:self.textField];
}

@end
