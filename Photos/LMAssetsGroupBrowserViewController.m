//
//  LMAlbumBrowserViewController.m
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMAssetsGroupBrowserViewController.h"
#import "LMAssetThumbnailCell.h"
#import "LMAppDelegate.h"


static CGFloat kItemSpacing = 5.;
static CGFloat kItemsPerLine = 4.;

static NSString *const kAssetThumbnailCellIdentifier = @"kAssetThumbnailCellIdentifier";



@interface LMAssetsGroupBrowserViewController ()

@property (nonatomic, strong) ALAssetsGroup *group;
@property (nonatomic, strong) NSMutableArray *assets;

@end



@implementation LMAssetsGroupBrowserViewController

+ (instancetype)browserWithAssetsGroup:(ALAssetsGroup *)group {
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    LMAssetsGroupBrowserViewController *browser = [[LMAssetsGroupBrowserViewController alloc] initWithCollectionViewLayout:layout];
    browser.group = group;
    return browser;
}

- (id)initWithCollectionViewLayout:(PSUICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat viewWidth = CGRectGetWidth(self.collectionView.bounds);
    CGFloat spacing = kItemSpacing;
    CGFloat itemsPerLine = kItemsPerLine;
    CGFloat itemWidth = (viewWidth - (itemsPerLine+1.)*spacing) / itemsPerLine;
    
    PSUICollectionViewFlowLayout *gridLayout = [[PSUICollectionViewFlowLayout alloc] init];
    gridLayout.minimumLineSpacing = spacing;
    gridLayout.minimumInteritemSpacing = spacing;
    gridLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    gridLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // default is UICollectionViewScrollDirectionVertical
    gridLayout.headerReferenceSize = CGSizeZero;
    gridLayout.footerReferenceSize = CGSizeZero;
    gridLayout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    
    [self.collectionView setCollectionViewLayout:gridLayout];
    
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navigationBarFrame = [[[self navigationController] navigationBar] frame];
    
    UIEdgeInsets inset = UIEdgeInsetsZero;
    inset.top = CGRectGetHeight(statusBarFrame) + CGRectGetHeight(navigationBarFrame);
    [self.collectionView setContentInset:inset];
    [self.collectionView setScrollIndicatorInsets:inset];
    
    
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerClass:[LMAssetThumbnailCell class] forCellWithReuseIdentifier:kAssetThumbnailCellIdentifier];
    
    
    self.assets = [NSMutableArray arrayWithCapacity:[self.group numberOfAssets]];
        
    [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result && index != NSNotFound) {
            [self.assets addObject:result];
        } else {
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setGroup:(ALAssetsGroup *)group {
    _group = group;
    self.title = [self.group valueForProperty:ALAssetsGroupPropertyName];
}



#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LMAssetThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAssetThumbnailCellIdentifier forIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.item];
    UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
    [cell.imageView setImage:image];
    return cell;
}

@end
