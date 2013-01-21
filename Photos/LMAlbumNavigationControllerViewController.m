//
//  LMAlbumNavigationControllerViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMAlbumNavigationControllerViewController.h"
#import "LMAlbumGroupsBrowserViewController.h"

@interface LMAlbumNavigationControllerViewController ()

@end

@implementation LMAlbumNavigationControllerViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        LMAlbumGroupsBrowserViewController *controller = (LMAlbumGroupsBrowserViewController *)rootViewController;
        if ([controller respondsToSelector:@selector(imageName)]) {
            NSString *imageName = controller.imageName;
            self.tabBarItem.image = imageName ? [UIImage imageNamed:imageName] : nil;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
