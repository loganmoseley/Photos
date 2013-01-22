//
//  LMLibraryBrowserViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMLibraryBrowserViewController.h"
#import "LMAssetsGroupBrowserViewController.h"
#import "LMLocalLibraryBrowserViewController.h"
#import "LMStreamLibraryBrowserViewController.h"



static CGFloat kLibraryBrowserCellHeight = 56.;



@interface LMLibraryBrowserViewController ()

@end



@implementation LMLibraryBrowserViewController

+ (instancetype)browserWithLibraryScope:(LMAssetLibraryScope)scope {
    Class class;
    switch (scope) {
        case LMLocalLibraryScope:
            class = [LMLocalLibraryBrowserViewController class];
            break;
        case LMStreamLibraryScope:
            class = [LMStreamLibraryBrowserViewController class];
            break;
        default:
            break;
    }
    LMLibraryBrowserViewController *browser = class ? [(LMLibraryBrowserViewController *)[class alloc] initWithStyle:UITableViewStylePlain] : nil;
    return browser;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.assetsLibrary = [ALAssetsLibrary new];
    [self reloadData];
}

- (void)reloadData {
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
    
    NSOrderedSet *groups = [self assetsGroupTypes];
    for (NSNumber *nsGroup in groups) {
        ALAssetsGroupType group = [nsGroup unsignedIntegerValue];
        [self.assetsLibrary enumerateGroupsWithTypes:group usingBlock:listGroupBlock failureBlock:failureBlock];
    }
}

- (NSOrderedSet *)assetsGroupTypes {
    return nil;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    ALAssetsGroup *group = self.assetsGroups[indexPath.row];
    
    NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
    NSString *nameAndCount = [name stringByAppendingFormat:@" (%i)", [group numberOfAssets]];
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:nameAndCount];
//    [attributedText setAttributes:@{ NSForegroundColorAttributeName: [UIColor lightGrayColor] }
//                            range:NSMakeRange(name.length, nameAndCount.length-name.length)];
//    
//    [cell.textLabel setAttributedText:attributedText];
    [cell.textLabel setText:nameAndCount];
    [cell.textLabel setFont:nil];
    [cell.imageView setImage:[UIImage imageWithCGImage:[group posterImage]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LMAssetsGroupBrowserViewController *albumBrowser = [LMAssetsGroupBrowserViewController browserWithAssetsGroup:self.assetsGroups[indexPath.row]];
    [self.navigationController pushViewController:albumBrowser animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kLibraryBrowserCellHeight;
}

@end
