//
//  LMAppViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/21/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMAppViewController.h"
#import "LMEdgePanGestureRecognizer.h"
#import "UIColor+LMStyling.h"
#import <QuartzCore/QuartzCore.h>

@interface LMAppViewController ()
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) LMScrollingTabBar *tabBar;
@property (nonatomic, getter = isTabBarOpen) BOOL tabBarOpen;
@property (nonatomic, weak) LMEdgePanGestureRecognizer *mainViewEdgePanRecognizer;
@property (nonatomic, weak) UITapGestureRecognizer *mainViewTapRecognizer;
@end

@implementation LMAppViewController

- (id)init
{
    self = [super init];
    if (self) {
        _selectedIndex = 0;
        _tabBarOpen = NO;
    }
    return self;
}

- (void)loadView
{
    self.wantsFullScreenLayout = YES;
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor offWhiteColor];
    
    UIView *mainView = [[UIView alloc] initWithFrame:view.bounds];
    mainView.backgroundColor = nil;
    mainView.opaque = YES;
    mainView.layer.borderColor = [UIColor greenColor].CGColor;
#if DEBUG
    mainView.layer.borderWidth = 1.;
#endif
    [view addSubview:mainView];
    
    CGRect tabFrame = frame;
    tabFrame.size.height = 50.;
    tabFrame.origin.y = CGRectGetMaxY(frame) - CGRectGetHeight(tabFrame);
    LMScrollingTabBar *tabBar = [[LMScrollingTabBar alloc] initWithFrame:tabFrame];
    [tabBar setDelegate:self];
    [view addSubview:tabBar];
    [view sendSubviewToBack:tabBar];
    
    self.view = view;
    self.mainView = mainView;
    self.tabBar = tabBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *buttons = [NSMutableArray array];
    
    for (UIViewController *viewController in self.viewControllers) {
        NSString *title;
        if ([viewController respondsToSelector:@selector(viewControllers)]) {
            UINavigationController *navController = (UINavigationController *)viewController;
            UIViewController *rootViewController = navController.viewControllers.count > 0 ? navController.viewControllers[0] : nil;
            if (rootViewController) {
                title = rootViewController.title;
            }
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:17]];
        [buttons addObject:button];
    }
    
    [self.tabBar setItems:buttons];
    [self.tabBar setMinimumButtonWidth:100.];
    
    if (self.selectedViewController) {
        [self addChildViewController:self.selectedViewController];
        [self.mainView addSubview:self.selectedViewController.view];
    }
    
    LMEdgePanGestureRecognizer *edgePan = [[LMEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMainViewBottomEdgePan:)];
    [edgePan setEdge:LMEdgePanGestureRecognizerEdgeBottom];
    [self.mainView addGestureRecognizer:edgePan];
    self.mainViewEdgePanRecognizer = edgePan;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMainViewTapped:)];
    [tap setEnabled:NO];
    [self.mainView addGestureRecognizer:tap];
    self.mainViewTapRecognizer = tap;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Properties

- (UIViewController *)selectedViewController
{
    return self.viewControllers.count > 0 ? self.viewControllers[self.selectedIndex] : nil;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    NSUInteger index;
    if ([self.viewControllers containsObject:selectedViewController]) {
        index = [self.viewControllers indexOfObject:selectedViewController];
    } else {
        self.viewControllers = [self.viewControllers arrayByAddingObject:selectedViewController];
        index = self.viewControllers.count-1;
    }
    self.selectedIndex = index;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (!self.viewControllers || selectedIndex >= self.viewControllers.count)
        return;
    
    [self willChangeValueForKey:@"selectedIndex"];
    
    UIViewController *oldViewController = self.viewControllers[_selectedIndex];
    [oldViewController removeFromParentViewController];
    [oldViewController.view removeFromSuperview];
    
    _selectedIndex = selectedIndex;
    
    UIViewController *newViewController = self.viewControllers[_selectedIndex];
    [self addChildViewController:newViewController];
    [self.mainView addSubview:newViewController.view];
    
    [self didChangeValueForKey:@"selectedIndex"];
    
    [self setTabBarOpen:NO];
}



#pragma mark - Pan gesture recognizer

- (void)setTabBarOpen:(BOOL)tabBarOpen
{
    [self willChangeValueForKey:@"tabBarOpen"];
    _tabBarOpen = tabBarOpen;
    if (tabBarOpen) {
        [self openTabBar];
    } else {
        [self closeTabBar];
    }
    [self didChangeValueForKey:@"tabBarOpen"];
}

- (void)openTabBar
{
    CGFloat currentTranslation = self.mainView.transform.ty;
    CGFloat maxTranslation = CGRectGetHeight(self.tabBar.frame);
    CGFloat distanceToTarget = fabsf(currentTranslation + maxTranslation);
    CGFloat maxDuration = 0.2;
    CGFloat duration = MIN(fabsf(distanceToTarget/maxTranslation), 1.0) * maxDuration;
    [UIView animateWithDuration:duration
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.mainView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.tabBar.frame));
                     }
                     completion:^(BOOL finished) {
                         self.mainViewEdgePanRecognizer.touchMargin = CGRectGetHeight(self.mainViewEdgePanRecognizer.view.frame);
                         self.mainViewTapRecognizer.enabled = YES;
                     }];
}

- (void)closeTabBar
{
    [UIView animateWithDuration:0.2
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.mainView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         self.mainViewEdgePanRecognizer.touchMargin = 20.;
                         self.mainViewTapRecognizer.enabled = NO;
                     }];
}

- (void)handleMainViewBottomEdgePan:(LMEdgePanGestureRecognizer *)recognizer
{
    CGFloat kRevealHeight = CGRectGetHeight(self.tabBar.frame);
    static CGPoint initialTranslation = {0,0};
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        initialTranslation = CGPointMake(self.mainView.transform.tx, self.mainView.transform.ty);
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGPoint targetTranslation = CGPointMake(translation.x+initialTranslation.x, translation.y+initialTranslation.y);
        
        CGAffineTransform transform;
        
        if (targetTranslation.y <= 0) {
            CGFloat d;
            CGFloat extra;
            
            d = MAX(targetTranslation.y, -kRevealHeight);
            extra = -kRevealHeight - targetTranslation.y;
            
            if (extra > 0)
            {
                CGFloat extraMax = CGRectGetHeight(recognizer.view.bounds) - kRevealHeight;
                CGFloat damped = extra/extraMax*kRevealHeight;
                d -= damped;
            }
            
            transform = CGAffineTransformMakeTranslation(0, d);
        } else {
            CGFloat scale = translation.y / CGRectGetHeight(recognizer.view.bounds) * 0.1;
            transform = CGAffineTransformMakeScale(1., 1. + scale);
            transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(0, translation.y/20.));
        }
        
        self.mainView.transform = transform;
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        BOOL shouldOpen = NO;
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        CGPoint translation = [recognizer translationInView:recognizer.view];
        
        if (self.isTabBarOpen) {
            shouldOpen = -translation.y > CGRectGetHeight(self.tabBar.frame)*2./3.;
        } else {
            shouldOpen |= -velocity.y    > recognizer.touchMargin * 5.0;
            shouldOpen |= -translation.y > recognizer.touchMargin;
        }
        
        [self setTabBarOpen:shouldOpen];
    }
}

- (void)handleMainViewTapped:(UITapGestureRecognizer *)recognizer
{
    [self setTabBarOpen:NO];
}



#pragma mark - Scrolling tab bar delegate

- (void)tabBar:(LMScrollingTabBar *)tabBar didSelectItem:(UIButton *)item // called when a new view is selected by the user (but not programatically)
{
    self.selectedIndex = tabBar.selectedIndex;
}

@end
