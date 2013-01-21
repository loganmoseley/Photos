//
//  LMAppViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/21/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMAppViewController.h"

@interface LMAppViewController ()

@end

@implementation LMAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    self.wantsFullScreenLayout = YES;
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildViewController:self.viewController];
    [self.view addSubview:self.viewController.view];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [pan setCancelsTouchesInView:YES];
    [pan setDelegate:self];
    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Pan gesture recognizer

- (void)panned:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    NSLog(@"translation: %@", NSStringFromCGPoint(translation));
}

- (NSArray *)gestureRecognizers
{
    return self.view.gestureRecognizers;
}

#pragma mark Delegate

// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    static CGFloat const kReceivingTouchMargin = 20.;
    
    CGPoint location = [touch locationInView:gestureRecognizer.view];
    CGRect viewBounds = gestureRecognizer.view.frame;
    viewBounds.origin = CGPointZero;
    
    bool viewContainsPoint = CGRectContainsPoint(viewBounds, location);
    if (!viewContainsPoint) return NO;
    
    CGRect insetBounds = CGRectInset(viewBounds, kReceivingTouchMargin, kReceivingTouchMargin);
    bool insetContainsPoint = CGRectContainsPoint(insetBounds, location);
    if (insetContainsPoint) return NO;
    
    return YES;
}

@end



@implementation LMAppViewControllerWindow

@end
