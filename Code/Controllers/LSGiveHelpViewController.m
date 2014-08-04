//
//  LSGiveHelpViewController.m
//  LayerSample
//
//  Created by Michael Fang on 8/2/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSGiveHelpViewController.h"
#import "LSApplicationController.h"
#import "LSUtilities.h"
#import <LayerKit/LayerKit.h>
#import "ToastView.h"

@interface LSGiveHelpViewController ()
@property NSArray *contacts;
@property NSString *selected;
@end

@implementation LSGiveHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUUID *layerAppID = [[NSUUID alloc] initWithUUIDString:@"fdca482e-19c1-11e4-88db-a19800003b1a"];
    // Do any additional setup after loading the view from its nib.
//    LYRClient *layerClient = [LYRClient clientWithAppID:layerAppID];
    self.persistenceManager = LSPersitenceManager();

    _contacts =[[self.persistenceManager persistedUsersWithError:(nil)] allObjects];
    self.namePicker = [[UIPickerView alloc] init];
    self.namePicker.frame = CGRectMake(0, 0, 320, 216);
    [self.view addSubview:self.namePicker];
    self.namePicker.delegate = self;
    
    self.registerButton = [[UIButton alloc] init];
    

    [self.registerButton.titleLabel setText:@"Select"];
    self.registerButton.alpha = 1;
    self.registerButton.frame =CGRectMake(20, 240, 50, 25) ;
 
    [self.registerButton addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
    [self.view bringSubviewToFront:self.registerButton];
    
    
}

-(void) tapped
{
    NSString *msg = self.selected;
    [ToastView showToastInParentView:self.view withText:msg withDuration:1];
    //[self.registerButton]
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // For one column
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_contacts count]; // Numbers of rows
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return ((LSUser*)[_contacts objectAtIndex:row]).fullName; // If it's a string
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.selected = (((LSUser*)(_contacts[row])).firstName);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
