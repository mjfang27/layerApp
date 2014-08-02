//
//  LSRegistrationViewController.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSRegistrationViewController.h"
#import "LSInputTableViewCell.h"
#import "LSButton.h"
#import "LSAppDelegate.h"
#import "LSUser.h"

@interface LSRegistrationViewController () <UITextFieldDelegate, UITableViewDelegate>

@property (nonatomic, strong) LSButton *registerButton;
@property (nonatomic, weak) UITextField *firstNameField;
@property (nonatomic, weak) UITextField *lastNameField;
@property (nonatomic, weak) UITextField *emailField;
@property (nonatomic, weak) UITextField *passwordField;
@property (nonatomic, weak) UITextField *passwordConfirmationField;

@property (nonatomic, copy) void (^completionBlock)(LSUser *);

@end

@implementation LSRegistrationViewController

static NSString *const LSRegistrationCellIdentifier = @"registrationCellIdentifier";

- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Register";
    self.accessibilityLabel = @"Register Screen";
    
    //Done button added for testing purposes
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped)];
    doneButton.accessibilityLabel = @"Done";
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    [self.tableView registerClass:[LSInputTableViewCell class] forCellReuseIdentifier:LSRegistrationCellIdentifier];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.firstNameField becomeFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LSRegistrationCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(LSInputTableViewCell *)cell forIndexPath:(NSIndexPath *)path
{
    cell.textField.delegate = self;
    cell.textField.returnKeyType = UIReturnKeyNext;
    cell.textField.enablesReturnKeyAutomatically = YES;
    switch (path.row) {
        case 0:
            [cell setText:@"First Name"];
            cell.textField.accessibilityLabel = @"First Name";
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            self.firstNameField = cell.textField;
            break;
        case 1:
            [cell setText:@"Last Name"];
            cell.textField.accessibilityLabel = @"Last Name";
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            self.lastNameField = cell.textField;
            break;
        case 2:
            [cell setText:@"Email Address"];
            cell.textField.accessibilityLabel = @"Email";
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.emailField = cell.textField;
            break;
        case 3:
            [cell setText:@"Password"];
            cell.textField.secureTextEntry = TRUE;
            cell.textField.accessibilityLabel = @"Password";
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.passwordField = cell.textField;
            break;
        case 4:
            [cell setText:@"Confirm"];
            cell.textField.secureTextEntry = TRUE;
            cell.textField.accessibilityLabel = @"Confirmation";
            self.passwordConfirmationField = cell.textField;
            cell.textField.returnKeyType = UIReturnKeySend;
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            break;
        default:
            break;
    }
}

- (void)doneTapped
{
    [self registerTapped];
}

- (void)registerTapped
{
    LSInputTableViewCell *firstNameCell = (LSInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LSInputTableViewCell *lastNameCell = (LSInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    LSInputTableViewCell *emailCell = (LSInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    LSInputTableViewCell *passwordCell = (LSInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    LSInputTableViewCell *confirmationCell = (LSInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];

    LSUser *user = [[LSUser alloc] init];
    [user setFirstName:firstNameCell.textField.text];
    [user setLastName:lastNameCell.textField.text];
    [user setEmail:emailCell.textField.text];
    [user setPassword:passwordCell.textField.text];
    [user setPasswordConfirmation:confirmationCell.textField.text];
    
    [self.APIManager registerUser:user completion:^(LSUser *user, NSError *error) {
        if (user) {
            if (self.completionBlock) self.completionBlock(user);
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Registration Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

#pragma mark
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstNameField) {
        [self.lastNameField becomeFirstResponder];
    } else if (textField == self.lastNameField) {
        [self.emailField becomeFirstResponder];
    } else if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self.passwordConfirmationField becomeFirstResponder];
    } else if (textField == self.passwordConfirmationField) {
        [self registerTapped];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.registerButton.enabled = (self.firstNameField.text.length && self.lastNameField.text.length && self.emailField.text.length && self.passwordField.text.length && self.passwordConfirmationField.text.length);
    return YES;
}

@end
