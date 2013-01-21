//
//  LMLocalLibraryBrowserViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMLocalLibraryBrowserViewController.h"

@interface LMLocalLibraryBrowserViewController ()

@end

@implementation LMLocalLibraryBrowserViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Albums", @"Albums");
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTapped:)];
        self.libraryScope = LMLocalLibraryScope;
        self.imageName = @"first";
    }
    return self;
}



#pragma Edit

- (void)addTapped:(UIBarButtonItem *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Album", @"New Album")
                                                        message:NSLocalizedString(@"Enter a name for this album.", @"Enter a name for this album.")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                              otherButtonTitles:NSLocalizedString(@"Save", @"Save"), nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *textField = [alertView textFieldAtIndex:0];
    [textField setPlaceholder:NSLocalizedString(@"Title", @"Title")];
    [textField setClearButtonMode:UITextFieldViewModeAlways];
    [alertView show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    return textField.text.length > 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // cancel. do nothing.
    }
    else if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [self.assetsLibrary addAssetsGroupAlbumWithName:textField.text
                                            resultBlock:^(ALAssetsGroup *group) {
                                                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                                            }
                                           failureBlock:^(NSError *error) {
                                               NSLog(@"could not create the group. error: %@", error);
                                           }];
    }
}

- (void)editTapped:(UIBarButtonItem *)sender
{
    NSLog(@"edit");
}

@end
