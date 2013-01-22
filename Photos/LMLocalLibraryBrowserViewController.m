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

- (NSOrderedSet *)assetsGroupTypes
{
    return [NSOrderedSet orderedSetWithArray:@[@(ALAssetsGroupSavedPhotos), @(ALAssetsGroupAlbum)]];
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
    } else if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        __weak LMLocalLibraryBrowserViewController *weakSelf = self;
        [self.assetsLibrary addAssetsGroupAlbumWithName:textField.text
                                            resultBlock:^(ALAssetsGroup *group) {
                                                [weakSelf.assetsGroups addObject:group];
                                                [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(weakSelf.assetsGroups.count-1) inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                                            }
                                           failureBlock:^(NSError *error) {
                                               NSLog(@"could not create the group. error: %@", error);
                                           }];
    }
}

- (void)editTapped:(UIBarButtonItem *)sender
{
    BOOL isNowEditing = !self.tableView.isEditing;
    [self.tableView setEditing:isNowEditing animated:YES];
    
    UIBarButtonSystemItem item = isNowEditing ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(editTapped:)];
    if (isNowEditing) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.assetsGroups.count inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.assetsGroups.count inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];
    rows += tableView.isEditing ? 1 : 0;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing && indexPath.row == self.assetsGroups.count) {
        static NSString *const informationIdentifier = @"kTableViewInfomationCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:informationIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:informationIdentifier];
        }
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setText:NSLocalizedString(@"Only Apple's Photos app can delete albums.", @"Only Apple's Photos app can delete albums.")];
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        [cell.textLabel setFont:nil];
        [cell.textLabel setNumberOfLines:3];
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row > 0 && indexPath.row < self.assetsGroups.count;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSInteger from = fromIndexPath.row;
    NSInteger to = toIndexPath.row;
    id a = [self.assetsGroups objectAtIndex:from];
    [self.assetsGroups removeObjectAtIndex:from];
    [self.assetsGroups insertObject:a atIndex:to];
}



#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.row == 0 ||
        proposedDestinationIndexPath.row == self.assetsGroups.count) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

@end
