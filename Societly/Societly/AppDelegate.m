//
//  AppDelegate.m
//  Societly
//
//  Created by Lauri Eskor on 18/09/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "AppDelegate.h"
#import "Database.h"

#import "CompassViewController.h"
#import "MainViewController.h"
#import "CandidateListViewController.h"
#import "EmailViewController.h"
#include "Database+QuestionSet.h"
#import "NavigationHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>

@interface AppDelegate ()<GIDSignInDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Montserrat-Regular" size:17.0], NSFontAttributeName,nil]];
  
  NSError* configureError;
  [[GGLContext sharedInstance] configureWithError: &configureError];
  NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
  
  [GIDSignIn sharedInstance].delegate = self;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    // Ready database for first use
    [[Database sharedInstance] saveContext:nil];

    [NavigationHelper setupFirstViewOnWindow:self.window];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  if ([url.absoluteString hasPrefix:@"fb327706334256435"]) {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
  } else {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
  }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
  if ([url.absoluteString hasPrefix:@"fb327706334256435"]) {
    return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];
  } else {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the application terminates.
  [[Database sharedInstance] saveContext:nil];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
  // Perform any operations on signed in user here.
  //NSString *userId = user.userID;                  // For client-side use only!
  //NSString *idToken = user.authentication.idToken; // Safe to send to the server
  //NSString *fullName = user.profile.name;
  //NSString *givenName = user.profile.givenName;
  //NSString *familyName = user.profile.familyName;
  //NSString *email = user.profile.email;
  // ...
  NSString *accessToken = user.authentication.accessToken;
  //NSString *refreshToken = user.authentication.refreshToken;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"googleSignin" object:accessToken];

}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
  // Perform any operations when the user disconnects from app here.
  // ...
}

@end
