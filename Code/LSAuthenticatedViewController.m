//
//  LSAuthenticatedViewController.m
//  LayerSample
//
//  Created by Kevin Coleman on 8/2/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSAuthenticatedViewController.h"
//#import "LSNeedHelpViewController.h"
#import "LSGiveHelpViewController.h"
#import "LSNeedHelpViewController2.h"

@interface LSAuthenticatedViewController ()

@end

@implementation LSAuthenticatedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    
    [self.buttonNeedHelp addTarget:self
                                       action:@selector(needHelpTapped)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.buttonGiveHelp addTarget:self
                            action:@selector(giveHelpTapped)
                  forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
}

- (void)logout
{
    [self.APIManager deauthenticateWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Deauthenticated...");
    }];
}


-(void) needHelpTapped
{
    LSNeedHelpViewController2 *needHelpViewController = [[LSNeedHelpViewController2 alloc] init];
    [self.navigationController pushViewController:needHelpViewController animated:YES];

}

-(void) giveHelpTapped
{
    LSGiveHelpViewController *giveHelpViewController = [[LSGiveHelpViewController alloc] init];
    [self.navigationController pushViewController:giveHelpViewController animated:YES];
}

@end
