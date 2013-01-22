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

@end

@implementation LMAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    self.wantsFullScreenLayout = YES;
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blueColor];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.viewController];
    [self.view addSubview:self.viewController.view];
    
    LMEdgePanGestureRecognizer *pan = [[LMEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [pan setEdge:LMEdgePanGestureRecognizerEdgeBottom];
    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Pan gesture recognizer

- (void)panned:(LMEdgePanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGRect frame = self.viewController.view.frame;
        frame.origin.y = translation.y;
        self.viewController.view.frame = frame;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.viewController.view.frame;
            frame.origin = CGPointZero;
            self.viewController.view.frame = frame;
        }];
    }
}

@end



@implementation LMAppViewControllerWindow

@end
