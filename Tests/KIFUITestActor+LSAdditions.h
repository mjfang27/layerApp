//
//  KIFUITestActor+LSAdditions.h
//  LayerSample
//
//  Created by Kevin Coleman on 6/11/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "KIFUITestActor.h"
#import <KIF/KIF.h>

@interface KIFUITestActor (LSAdditions)

- (void)navigateToLoginPage;

- (void)returnToLoggedOutHomeScreen;

@end
