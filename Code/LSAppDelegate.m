//
//  LSAppDelegate.m
//  LayerSample
//
//  Created by Kevin Coleman on 6/10/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import <LayerKit/LayerKit.h>
#import "LSAppDelegate.h"
#import "LSAPIManager.h"
#import "LSUtilities.h"
#import "LSUIConstants.h"
#import "LSPersistenceManager.h"
#import "LSApplicationController.h"
#import "LSAuthenticatedViewController.h"

extern void LYRSetLogLevelFromEnvironment();

@interface LSAppDelegate ()

@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic, strong) LSApplicationController *applicationController;



@end

@implementation LSAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#warning INSERT YOUR APPLICATION KEY BELOW
    NSUUID *layerAppID = [[NSUUID alloc] initWithUUIDString:@"fdca482e-19c1-11e4-88db-a19800003b1a"];
    LYRClient *layerClient = [LYRClient clientWithAppID:layerAppID];
    
    // HackLayer sample leverages NSNotification center to alert the app delegate to changes in authentication state
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidAuthenticateNotification:)
                                                 name:LSUserDidAuthenticateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidDeauthenticateNotification:)
                                                 name:LSUserDidDeauthenticateNotification
                                               object:nil];
    
    self.applicationController = ApplicationController(layerClient);
    LYRSetLogLevelFromEnvironment();
    
    LSAuthenticationViewController *authenticationViewController = [LSAuthenticationViewController new];
    authenticationViewController.layerClient = layerClient;
    authenticationViewController.APIManager = self.applicationController.APIManager;
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:authenticationViewController];
    self.navigationController.navigationBarHidden = TRUE;
    self.navigationController.navigationBar.barTintColor = LSLighGrayColor();
    self.navigationController.navigationBar.tintColor = LSBlueColor();
    self.window.rootViewController = self.navigationController;
    
    LSSession *session = [self.applicationController.persistenceManager persistedSessionWithError:nil];
    
    // Checks to see if the user is already authenticated
    NSError *error = nil;
    if ([self.applicationController.APIManager resumeSession:session error:&error]) {
        NSLog(@"Session resumed: %@", session);
        [self loadContacts];
        [self presentAuthenticatedUI];
    }
    
    [self.window makeKeyAndVisible];
    
    // Declaring that I want to recieve push!
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadContacts) name:@"loadContacts" object:nil];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self loadContacts];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Application failed to register for remote notifications with error %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSError *error;
    BOOL success = [self.applicationController.layerClient updateRemoteNotificationDeviceToken:deviceToken error:&error];
    if (success) {
        NSLog(@"Application did register for remote notifications");
    } else {
        NSLog(@"Error updating Layer device token for push:%@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSError *error;
    BOOL success = [self.applicationController.layerClient synchronizeWithRemoteNotification:userInfo completion:^(UIBackgroundFetchResult fetchResult, NSError *error) {
        if (fetchResult == UIBackgroundFetchResultFailed) {
            NSLog(@"Failed processing remote notification: %@", error);
        }
        completionHandler(fetchResult);
    }];
    if (success) {
        NSLog(@"Application did remote notification sycn");
    } else {
        NSLog(@"Error handling push notification: %@", error);
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

// Notifies the app delegate that the user has authenticated
- (void)userDidAuthenticateNotification:(NSNotification *)notification
{
    NSError *error = nil;
    LSSession *session = self.applicationController.APIManager.authenticatedSession;
    BOOL success = [self.applicationController.persistenceManager persistSession:session error:&error];
    if (success) {
        NSLog(@"Persisted authenticated user session: %@", session);
    } else {
        NSLog(@"Failed persisting authenticated user: %@. Error: %@", session, error);
        LSAlertWithError(error);
    }

    [self loadContacts];
    [self presentAuthenticatedUI];
}

// Notifies the app delegate that the user has been deauthenticated
- (void)userDidDeauthenticateNotification:(NSNotification *)notification
{
    NSError *error = nil;
    BOOL success = [self.applicationController.persistenceManager persistSession:nil error:&error];
    if (success) {
        NSLog(@"Cleared persisted user session");
    } else {
        NSLog(@"Failed clearing persistent user session: %@", error);
        LSAlertWithError(error);
    }
    
    [self.applicationController.layerClient deauthenticate];
    [self.navigationController dismissViewControllerAnimated:YES completion:NO];
}

// Fetches all contacts for the Hack Layer backend and persists them to disk
- (void)loadContacts
{
    NSLog(@"Loading contacts...");
    [self.applicationController.APIManager loadContactsWithCompletion:^(NSSet *contacts, NSError *error) {
        if (contacts) {
            NSError *persistenceError = nil;
            BOOL success = [self.applicationController.persistenceManager persistUsers:contacts error:&persistenceError];
            if (success) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:contacts];
                [defaults setObject:data forKey:@"contacts"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"contactsPersited" object:nil];
                NSLog(@"Persisted contacts successfully: %@", contacts);
 

                
                
            } else {
                NSLog(@"Failed persisting contacts: %@. Error: %@", contacts, persistenceError);
                LSAlertWithError(persistenceError);
            }
        } else {
            NSLog(@"Failed loading contacts: %@", error);
            LSAlertWithError(error);
        }
    }];
}

- (void)presentAuthenticatedUI
{
    #warning PRESENT AUTHENTICATED UI HERE
    LSAuthenticatedViewController *authenticatedViewController = [[LSAuthenticatedViewController alloc] initWithNibName:@"LSHomeView" bundle:nil];
    authenticatedViewController.APIManager = self.applicationController.APIManager;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:authenticatedViewController];
    navController.navigationBar.barTintColor = LSLighGrayColor();
    navController.navigationBar.tintColor = LSBlueColor();
    
    [self.navigationController presentViewController:navController animated:YES completion:^{
        NSLog(@"Succesfully logged in!");
    }];
    
}
@end
