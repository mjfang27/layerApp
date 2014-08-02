//
//  LSLoginTableViewController.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSLoginViewController.h"
#import "LSInputTableViewCell.h"
#import "LSButton.h"

@interface LSLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) LSButton *loginButton;
@property (nonatomic, weak) UITextField *emailField;
@property (nonatomic, weak) UITextField *passwordField;
@property (nonatomic, copy) void (^completionBlock)(LSUser *);
@end

@implementation LSLoginViewController

static NSString *const LSLoginlIdentifier = @"loginCellIdentifier";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Login";
    self.accessibilityLabel = @"Login Screen";

    [self.tableView registerClass:[LSInputTableViewCell class] forCellReuseIdentifier:LSLoginlIdentifier];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //Done button added for testing purposes
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped)];
    doneButton.accessibilityLabel = @"Done";
    [self.navigationItem setRightBarButtonItem:doneButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.emailField becomeFirstResponder];
}

#pragma mark 
#pragma mark TableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LSLoginlIdentifier forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(LSInputTableViewCell *)cell forIndexPath:(NSIndexPath *)path
{
    switch (path.row) {
        case 0:
            [cell setText:@"Email"];
            cell.textField.accessibilityLabel = @"Email";
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.textField.enablesReturnKeyAutomatically = YES;
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.delegate = self;
            self.emailField = cell.textField;
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            break;
        case 1:
            [cell setText:@"Password"];
            cell.textField.accessibilityLabel = @"Password";
            cell.textField.secureTextEntry = YES;
            cell.textField.returnKeyType = UIReturnKeySend;
            cell.textField.delegate = self;
            self.passwordField = cell.textField;
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            break;
        default:
            break;
    }
}

- (void)doneTapped
{
    [self loginTapped];
}

- (void)loginTapped
{
    LSInputTableViewCell *usernameCell = (LSInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LSInputTableViewCell *passwordCell = (LSInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    [self.APIManager authenticateWithEmail:usernameCell.textField.text password:passwordCell.textField.text completion:^(LSUser *user, NSError *error) {
        if (user) {
            if (self.completionBlock) self.completionBlock(user);
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self loginTapped];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.loginButton.enabled = (self.emailField.text.length && self.passwordField.text.length);
    return YES;
}

@end

