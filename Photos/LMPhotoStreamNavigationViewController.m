//
//  LMPhotoStreamNavigationViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMPhotoStreamNavigationViewController.h"

@interface LMPhotoStreamNavigationViewController ()

@end

@implementation LMPhotoStreamNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
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
