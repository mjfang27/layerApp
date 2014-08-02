//
//  LSButton.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSButton.h"
#import "LSUIConstants.h"

@interface LSButton ()

@end

@implementation LSButton


- (id)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.text = text;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.accessibilityLabel = [NSString stringWithFormat:@"%@ Button", text];
        self.textLabel.font = LSMediumFont(20);
        self.textLabel.userInteractionEnabled = FALSE;
        self.backgroundColor = LSBlueColor();
        [self addSubview:self.textLabel];
        [self setupLayoutConstraints];
    }
    return self;
}

- (void)setupLayoutConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                       constant:0]];
}


@end
