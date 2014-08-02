//
//  LSNeedHelpViewController.m
//  LayerSample
//
//  Created by Michael Fang on 8/2/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSNeedHelpViewController2.h"
#import <Parse/Parse.h>

@interface LSNeedHelpViewController2 ()

@end

@implementation LSNeedHelpViewController2

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
    // Do any additional setup after loading the view from its nib.
    NSMutableArray * givingPeople = [self queryDatabase];
    NSLog(givingPeople);
}

-(NSMutableArray*) queryDatabase {
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSDate *date = [[NSDate date] descriptionWithLocale:currentLocale];
    LSSession *session = [self.persistenceManager persistedSessionWithError:nil];
    LSUser *user = session.user;
    NSMutableArray *givingPeople = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName: @"user_calendar"];
    [query whereKey:@"Wanting" containsString:user.userID]; //current user
    [query whereKey:@"start_time" lessThan:date]; //get current time
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            NSLog(@"Retrieved that shit");
            for(PFObject *object in objects) {
                NSString *person = [object objectForKey:@"Giving"];
                [givingPeople addObject:person];
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

@end
