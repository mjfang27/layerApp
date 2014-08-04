//
//  ToastView.h
//  Messaging
//
//  "Created" by Michael Fang on 7/10/14.
//  Shamelessly taken from StackOverflow, has same functionality as the Android Toast.
//  Used for showing that SAS has been activated.
//  Copyright (c) 2014 Imprivata Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property (strong, nonatomic) UILabel *textLabel;
+ (void)showToastInParentView: (UIView *)parentView withText:(NSString *)text withDuration:(float)duration;

@end