//
//  AppDelegate.m
//  OurMaps
//
//  Created by Jiangchuan Huang on 8/16/14.
//  Copyright (c) 2014 OurMaps. All rights reserved.
//

static NSString * const kLoginViewControllerID = @"LoginVC";
static NSString * const kMainViewControllerID = @"MainVC";
static NSString * const kNavigationControllerID = @"NavController";

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LoginViewController.h"
#import "ViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [GMSServices provideAPIKey:@"AIzaSyDjBPV3R5YT1jRV2ncL0eSfX6XMFieXGqc"];
    
    [Parse setApplicationId:@"VLyOUO8KgGyqLw595rBfVyA68DXJqse4Nc02ySbS"
                  clientKey:@"Ydfor3wPs0UqccXVWFgeChzCu4MlWXot2bz4QZ7Z"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    //ViewController *viewController = [[ViewController alloc] init];
    //self.window.rootViewController = viewController;
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    
    // Register for push notification
    // Register for Push Notitications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    
    if ([PFUser currentUser]) {
        NSLog(@"errr");
        // Skip right to the main VC
        [self presentMainViewController];
    }
    
    else {
        // Prompt to the login/signup interface
        [self presentLoginViewController];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Facebook oauth callback
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

// Present the correct main view
- (void)presentLoginViewController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UIStoryboard *mainStoryboard = [[self.window rootViewController] storyboard];
    LoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:kLoginViewControllerID];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
    //[self.window.rootViewController presentViewController:loginVC animated:YES completion:NULL];
}

- (void)presentMainViewController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UIStoryboard *mainStoryboard = [[self.window rootViewController] storyboard];
    ViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:kNavigationControllerID];
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];
    //[self.window.rootViewController presentViewController:mainVC animated:YES completion:NULL];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


@end
