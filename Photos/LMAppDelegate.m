//
//  LMAppDelegate.m
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMAppDelegate.h"
#import "LMLibraryBrowserNavigationController.h"
#import "LMLibraryBrowserViewController.h"
#import "LMAppViewController.h"

@interface LMAppDelegate ()
@end

@implementation LMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *viewController1 = [LMLibraryBrowserViewController browserWithLibraryScope:LMLocalLibraryScope];
    UINavigationController *navController1 = [[LMLibraryBrowserNavigationController alloc] initWithRootViewController:viewController1];
    UIViewController *viewController2 = [LMLibraryBrowserViewController browserWithLibraryScope:LMStreamLibraryScope];
    UINavigationController *navController2 = [[LMLibraryBrowserNavigationController alloc] initWithRootViewController:viewController2];
    
    self.appController = [[LMAppViewController alloc] init];
    self.appController.viewControllers = @[navController1, navController2];
    
    self.window.rootViewController = self.appController;
    [self.window makeKeyAndVisible];
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
