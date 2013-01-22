//
//  LMAppViewController.h
//  Photos
//
//  Created by Logan Moseley on 1/21/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMAppViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, strong) UIViewController *selectedViewController;
@end

@interface LMAppViewControllerWindow : UIWindow
@end
