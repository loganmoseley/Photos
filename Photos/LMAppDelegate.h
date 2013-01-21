//
//  LMAppDelegate.h
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMAppViewController.h"

@interface LMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LMAppViewController *appController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
