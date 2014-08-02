//
//  KIFUITestActor+LSAdditions.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/11/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "KIFUITestActor+LSAdditions.h"

@implementation KIFUITestActor (LSAdditions)

- (void)navigateToLoginPage
{
    [self tapViewWithAccessibilityLabel:@"Login/Sign Up"];
    [self tapViewWithAccessibilityLabel:@"Skip this ad"];
}

- (void)returnToLoggedOutHomeScreen
{
    [self tapViewWithAccessibilityLabel:@"Logout"];
    [self tapViewWithAccessibilityLabel:@"Logout"]; // Dismiss alert.
}

@end
