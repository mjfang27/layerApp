//
//  LSNeedHelpViewController.m
//  LayerSample
//
//  Created by Michael Fang on 8/2/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSNeedHelpViewController2.h"
#import "LSMessageViewController.h"

@interface LSNeedHelpViewController2 ()

@end

@implementation LSNeedHelpViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    
    [self.buttonMessage addTarget:self
                            action:@selector(messageTapped)
                  forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) messageTapped
{
    LSMessageViewController *messageViewController = [[LSMessageViewController alloc] init];
    [self.navigationController pushViewController:messageViewController animated:YES];
}

//-(void)

@end
