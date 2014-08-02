//
//  LSHomeViewController.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSAuthenticationViewController.h"
#import "LSButton.h"
#import "LSUIConstants.h"
#import "LSLoginViewController.h"
#import "LSRegistrationViewController.h"

@interface LSAuthenticationViewController ()

@property (nonatomic) UIImageView *logo;
@property (nonatomic) LSButton *registerButton;
@property (nonatomic) LSButton *loginButton;

@end

@implementation LSAuthenticationViewController

static CGFloat const LSLogoCenterY = -100;
static CGFloat const LSButtonWidthMultiple = 0.9;
static CGFloat const LSButtonHeightMultiple = 0.08;

static CGFloat const LSRegisterButtonCenterY = 140.0;
static CGFloat const LSLoginButtonTopMargin = 20.0;

- (void)viewDidLoad
{
    NSAssert(self.APIManager, @"APIManager cannot be nil");
    NSAssert(self.layerClient, @"layerClient cannot be nil");
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Home";
    self.accessibilityLabel = @"Home Screen";
    
    self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.logo.translatesAutoresizingMaskIntoConstraints = FALSE;
    [self.view addSubview:self.logo];
    
    self.registerButton = [[LSButton alloc] initWithText:@"Register"];
    self.registerButton.translatesAutoresizingMaskIntoConstraints = FALSE;
    self.registerButton.backgroundColor = LSBlueColor();
    self.registerButton.alpha = 0.8;
    self.registerButton.textLabel.textColor = [UIColor whiteColor];
    [self.registerButton addTarget:self action:@selector(registerTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
    self.loginButton =[[LSButton alloc] initWithText:@"Login"];
    self.loginButton.layer.borderColor = LSBlueColor().CGColor;
    self.loginButton.textLabel.textColor = LSBlueColor();
    self.loginButton.backgroundColor = LSGrayColor();
    self.loginButton.alpha = 0.8;
    [self.loginButton addTarget:self action:@selector(loginTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    [self setupLayoutConstraints];
}

- (void)loadView
{
    [super loadView];
}

- (void)setupLayoutConstraints
{
    //**********Logo Constraints**********//
    //Center X
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logo
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    //Center Y
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logo
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:LSLogoCenterY]];

    
    //**********Register Button Constraints**********//
    //Width
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:LSButtonWidthMultiple
                                                           constant:0]];
    //Height
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:LSButtonHeightMultiple
                                                           constant:0]];
    //Center X
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    //Center Y
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:LSRegisterButtonCenterY]];
    
    //**********Login Button Constraints**********//
    //Width
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                          attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:LSButtonWidthMultiple
                                                           constant:0]];
    //Height
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:LSButtonHeightMultiple
                                                           constant:0]];
    //Center X
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    //Top Margin
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.registerButton
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:LSLoginButtonTopMargin]];
    
}
- (void)registerTapped
{
    if (self.APIManager.authenticatedSession) NSLog(@"WARNING: you already have an authenticated user! You should be presenting authenticated UI");
    LSRegistrationViewController *registrationViewController = [[LSRegistrationViewController alloc] init];
    [registrationViewController setCompletionBlock:^(LSUser *user) {
        if (user) {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
    self.navigationController.navigationBarHidden = FALSE;
    registrationViewController.APIManager = self.APIManager;
    [self.navigationController pushViewController:registrationViewController animated:YES];
}

- (void)loginTapped
{
    if (self.APIManager.authenticatedSession) NSLog(@"WARNING: you already have an authenticated user! You should be presenting authenticated UI");
    LSLoginViewController *loginViewController = [[LSLoginViewController alloc] init];
    [loginViewController setCompletionBlock:^(LSUser *user) {
        if (user) {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
    self.navigationController.navigationBarHidden = FALSE;
    loginViewController.APIManager = self.APIManager;
    [self.navigationController pushViewController:loginViewController animated:YES];
}

@end
