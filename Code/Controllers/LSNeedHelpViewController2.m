//
//  LSNeedHelpViewController.m
//  LayerSample
//
//  Created by Michael Fang on 8/2/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSNeedHelpViewController2.h"
#import <Parse/Parse.h>
#import "LSMessageViewController.h"
#import "LSUtilities.h"

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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // For one column
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.givingPeople count]; // Numbers of rows
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return ([self.givingPeople objectAtIndex:row]); // If it's a string
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.persistenceManager = LSPersitenceManager();
    // Do any additional setup after loading the view from its nib.
    NSArray * givingPeople = [self queryDatabaseWithCompletion:^(NSArray *givingPeople, NSError *error) {
        if (givingPeople == nil) return;
        self.givingPeople = givingPeople;
        self.giverPicker = [[UIPickerView alloc] init];
        
        self.giverPicker.frame =CGRectMake(0, 100, self.giverPicker.frame.size.width, self.giverPicker.frame.size.height);
        [self.view addSubview:self.giverPicker];
        self.giverPicker.delegate = self;
    }];
}

-(NSMutableArray*) queryDatabaseWithCompletion:(void(^)(NSArray *givingPeople, NSError *error))completion
{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    LSSession *session = [self.persistenceManager persistedSessionWithError:nil];
    LSUser *user = session.user;
    NSMutableArray *givingPeople = [[NSMutableArray alloc] init];
    NSLog(@"The user id is: %@: ", user.email);
    PFQuery *query = [PFQuery queryWithClassName: @"user_calendar"];
    [query whereKey:@"Wanting" containsString:user.email]; //current user
    [query whereKey:@"start_date" lessThan:date]; //get current time
    [query whereKey:@"end_date" greaterThan:date];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            NSLog(@"Retrieved that shit");
            for(PFObject *object in objects) {
                NSString *person = [object objectForKey:@"Giver"];
                [givingPeople addObject:person];
            }
            if (givingPeople.count > 0) {
                completion(givingPeople, nil);
            } else {
                completion(nil, nil);
            }
        } else {
            NSLog(@"Errorrrrr");
        }
    }];
    return givingPeople;
    
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

@end
