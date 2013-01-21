//
//  LMAlbumGroupsBrowserViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMAlbumGroupsBrowserViewController.h"
#import "LMAssetsGroupBrowserViewController.h"

@interface LMAlbumGroupsBrowserViewController ()

@end

@implementation LMAlbumGroupsBrowserViewController

+ (instancetype)browserWithLibraryScope:(LMAssetLibraryScope)scope
{
    LMAlbumGroupsBrowserViewController *browser = [[LMAlbumGroupsBrowserViewController alloc] initWithStyle:UITableViewStylePlain];
    switch (scope) {
        case LMLocalLibraryScope:
            [browser initForLocal];
            break;
        case LMStreamLibraryScope:
            [browser initForStream];
            break;
        default:
            break;
    }
    return browser;
}

- (void)initForLocal
{
    self.wantsFullScreenLayout = YES;
    self.title = NSLocalizedString(@"Albums", @"Albums");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    self.libraryScope = LMLocalLibraryScope;
    self.imageName = @"first";
}

- (void)initForStream
{
    self.wantsFullScreenLayout = YES;
    self.title = NSLocalizedString(@"Photo Stream", @"Photo Stream");
    self.libraryScope = LMStreamLibraryScope;
    self.imageName = @"second";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.assetsLibrary = [ALAssetsLibrary new];
    self.assetsGroups = [NSMutableArray new];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group) {
            [self.assetsGroups addObject:group];
        } else {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
    };
    
    if (self.libraryScope == LMLocalLibraryScope)
    {
        NSUInteger savedPhotosGroup = ALAssetsGroupSavedPhotos;
        NSUInteger albumsGroup = ALAssetsGroupAlbum;
        [self.assetsLibrary enumerateGroupsWithTypes:savedPhotosGroup usingBlock:listGroupBlock failureBlock:failureBlock];
        [self.assetsLibrary enumerateGroupsWithTypes:albumsGroup usingBlock:listGroupBlock failureBlock:failureBlock];
    }
    else if (self.libraryScope == LMStreamLibraryScope)
    {
        NSUInteger streamGroup = ALAssetsGroupPhotoStream;
        [self.assetsLibrary enumerateGroupsWithTypes:streamGroup usingBlock:listGroupBlock failureBlock:failureBlock];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma Edit

- (void)editAction
{
    NSLog(@"edit");
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    ALAssetsGroup *group = self.assetsGroups[indexPath.row];
    
    NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
    NSString *nameAndCount = [name stringByAppendingFormat:@" (%i)", [group numberOfAssets]];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:nameAndCount];
    [attributedText setAttributes:@{ NSForegroundColorAttributeName: [UIColor lightGrayColor] }
                            range:NSMakeRange(name.length, nameAndCount.length-name.length)];
    
    [cell.textLabel setAttributedText:attributedText];
    [cell.textLabel setFont:nil];
    [cell.imageView setImage:[UIImage imageWithCGImage:[group posterImage]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMAssetsGroupBrowserViewController *albumBrowser = [LMAssetsGroupBrowserViewController browserWithAssetsGroup:self.assetsGroups[indexPath.row]];
    [self.navigationController pushViewController:albumBrowser animated:YES];
}

@end