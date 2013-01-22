//
//  LMAppViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/21/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMAppViewController.h"
#import "LMEdgePanGestureRecognizer.h"

@interface LMAppViewController ()
@property (nonatomic, strong) UIView *mainView;
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
    view.backgroundColor = [UIColor blueColor];
    
    UIView *mainView = [[UIView alloc] initWithFrame:view.bounds];
    mainView.backgroundColor = nil;
    [view addSubview:mainView];
    
    self.view = view;
    self.mainView = mainView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildViewController:self.selectedViewController];
    [self.view addSubview:self.selectedViewController.view];
    
    LMEdgePanGestureRecognizer *pan = [[LMEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBottomEdgePan:)];
    [pan setEdge:LMEdgePanGestureRecognizerEdgeBottom];
    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Pan gesture recognizer

- (void)handleBottomEdgePan:(LMEdgePanGestureRecognizer *)recognizer
{
    CGFloat kRevealHeight = 50.;
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGAffineTransform transform;
        
        if (translation.y <= 0) {
            CGFloat d = MAX(translation.y, -kRevealHeight);
            if (translation.y < -kRevealHeight)
            {
                CGFloat extra = -kRevealHeight - translation.y;
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
        
        self.selectedViewController.view.transform = transform;
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2
                              delay:0.
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.selectedViewController.view.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished)
        {
        }];
    }
}

@end



@implementation LMAppViewControllerWindow

@end
