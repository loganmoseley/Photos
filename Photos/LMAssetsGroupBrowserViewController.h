//
//  LMAlbumBrowserViewController.h
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface LMAssetsGroupBrowserViewController : UICollectionViewController
+ (instancetype)browserWithAssetsGroup:(ALAssetsGroup *)group;
@end
