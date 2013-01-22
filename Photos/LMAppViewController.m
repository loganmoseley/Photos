//
//  LMAppViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/21/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMAppViewController.h"
#import "LMEdgePanGestureRecognizer.h"
#import "LMScrollingTabBar.h"

@interface LMAppViewController ()
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) LMScrollingTabBar *tabBar;
@property (nonatomic, getter = isTabBarOpen) BOOL tabBarOpen;
@property (nonatomic, weak) LMEdgePanGestureRecognizer *edgePanRecognizer;
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
    view.backgroundColor = [UIColor blueColor];
    
    UIView *mainView = [[UIView alloc] initWithFrame:view.bounds];
    mainView.backgroundColor = nil;
    [view addSubview:mainView];
    
    CGRect tabFrame = frame;
    tabFrame.size.height = 50.;
    tabFrame.origin.y = CGRectGetMaxY(frame) - CGRectGetHeight(tabFrame);
    LMScrollingTabBar *tabBar = [[LMScrollingTabBar alloc] initWithFrame:tabFrame];
    [view addSubview:tabBar];
    [view sendSubviewToBack:tabBar];
    
    self.view = view;
    self.mainView = mainView;
    self.tabBar = tabBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *one = [UIButton buttonWithType:UIButtonTypeInfoLight];
    UIButton *two = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [self.tabBar setItems:@[one, two]];
    
    if (self.selectedViewController) {
        [self addChildViewController:self.selectedViewController];
        [self.mainView addSubview:self.selectedViewController.view];
    }
    
    LMEdgePanGestureRecognizer *edgePan = [[LMEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBottomEdgePan:)];
    [edgePan setEdge:LMEdgePanGestureRecognizerEdgeBottom];
    [self.mainView addGestureRecognizer:edgePan];
    self.edgePanRecognizer = edgePan;
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
    [UIView animateWithDuration:0.2
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.mainView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.tabBar.frame));
                     }
                     completion:^(BOOL finished) {
                         self.edgePanRecognizer.touchMargin = CGRectGetHeight(self.edgePanRecognizer.view.frame);
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
                         self.edgePanRecognizer.touchMargin = 20.;
                     }];
}

- (void)handleBottomEdgePan:(LMEdgePanGestureRecognizer *)recognizer
{
    CGFloat kRevealHeight = CGRectGetHeight(self.tabBar.frame);
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGAffineTransform transform;
        
        if (translation.y <= 0) {
            CGFloat d;
            BOOL isDamping;
            CGFloat extra;
            
            if (self.isTabBarOpen) {
                d = -kRevealHeight;
                isDamping = YES;
                extra = -translation.y;
            } else {
                d = MAX(translation.y, -kRevealHeight);
                isDamping = translation.y < -kRevealHeight;
                extra = -kRevealHeight - translation.y;
            }
            
            if (isDamping)
            {
                CGFloat extraMax = CGRectGetHeight(recognizer.view.bounds) - kRevealHeight;
                CGFloat damped = extra/extraMax*kRevealHeight;
                d -= damped;
            }
            transform = CGAffineTransformMakeTranslation(0, d);
        } else {
            CGFloat scale = translation.y / CGRectGetHeight(recognizer.view.bounds);
            transform = CGAffineTransformMakeScale(1., 1. + scale);
            transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(0, translation.y/2.));
        }
        
        self.mainView.transform = transform;
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        BOOL shouldOpen = NO;
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        CGPoint translation = [recognizer translationInView:recognizer.view];
        
        if (self.isTabBarOpen) {
            shouldOpen = -translation.y > CGRectGetHeight(self.tabBar.frame)*2./3.;
        } else {
            shouldOpen |= velocity.y < -100.;
            shouldOpen |= -translation.y > CGRectGetHeight(self.tabBar.frame)*2./3.;
        }
        
        [self setTabBarOpen:shouldOpen];
    }
}



#pragma mark - Scrolling tab bar delegate

- (void)tabBar:(LMScrollingTabBar *)tabBar didSelectItem:(UIButton *)item // called when a new view is selected by the user (but not programatically)
{
    self.selectedIndex = tabBar.selectedIndex;
}

@end
