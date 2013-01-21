//
//  LMStreamLibraryBrowserViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMStreamLibraryBrowserViewController.h"

@interface LMStreamLibraryBrowserViewController ()

@end

@implementation LMStreamLibraryBrowserViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Photo Stream", @"Photo Stream");
        self.libraryScope = LMStreamLibraryScope;
        self.imageName = @"second";
    }
    return self;
}

@end
