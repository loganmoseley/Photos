//
//  LMAppViewController.h
//  Photos
//
//  Created by Logan Moseley on 1/21/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMScrollingTabBar.h"

@interface LMAppViewController : UIViewController <UIGestureRecognizerDelegate, LMScrollingTabBarDelegate>

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic) NSUInteger selectedIndex; // default 0

@end
