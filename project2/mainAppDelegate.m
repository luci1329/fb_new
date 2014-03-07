//
//  luciAppDelegate.m
//  project2
//
//  Created by io on 9/25/13.
//  Copyright (c) 2013 luci. All rights reserved.
//

#import "mainAppDelegate.h"
#import "FacebookViewController.h"

@implementation mainAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.mainVC = [[MainViewController alloc] init];
    [FBProfilePictureView class];
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSession activeSession] handleOpenURL:url];
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
    NSLog(@"Did enter background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[FBSession activeSession] handleDidBecomeActive];
    
    /*if (FBSession.activeSession.isOpen) {
        UINavigationController* navController = (UINavigationController*)self.window.rootViewController;
        UITabBarController* tab = (UITabBarController*)navController.topViewController;
        MainViewController* main = [tab.viewControllers objectAtIndex:0];
        [main performSegueWithIdentifier:@"FBLoggedIn" sender:main];
    }*/
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(int)sessionStateChanged: (FBSession*) session
                     state: (FBSessionState) state
                     error: (NSError*) error
{
    int stateVal = -1;
    switch (state) {
        case FBSessionStateOpen:{
            // HANDLE LOGIN
            UINavigationController* navController;
            UITabBarController* tab;
            MainViewController* main;
            if ([self.window.rootViewController isKindOfClass: UINavigationController.class]) {
                navController = (UINavigationController*)self.window.rootViewController;
                if ([navController.topViewController isKindOfClass:[UITabBarController class]]) {
                    tab = (UITabBarController*)navController.topViewController;
                    if ([[tab.viewControllers objectAtIndex:0] isKindOfClass:[MainViewController class]]) {
                        main = [tab.viewControllers objectAtIndex:0];
                        stateVal = 1;
                        NSLog(@"STATE : Cached token available or user has logged in.");
                        [main performSegueWithIdentifier:@"FBLoggedIn" sender:main];
                    }
                    else NSLog(@"Introspection failed");
                }
                else NSLog(@"Introspection failed");
            }
            else NSLog(@"Introspection failed");
        }
        break;
        case FBSessionStateClosed:
            NSLog(@"STATE : Session closed, user token cached.");
        case FBSessionStateClosedLoginFailed:
            NSLog(@"STATE : Logout.");
            [[FBSession activeSession] closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    if (error) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    return stateVal;
}
-(int)openSession
{
    __block int stateVal = -1;
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession* session,FBSessionState state,NSError* error){
        if (!error) {
            stateVal = [self sessionStateChanged:session state:state error:error];
        }
        else NSLog(@"%@",error.localizedDescription);
    }];
    return stateVal;
}

@end
