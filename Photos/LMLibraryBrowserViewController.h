//
//  LMLibraryBrowserViewController.h
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, LMAssetLibraryScope) {
    LMLocalLibraryScope,
    LMStreamLibraryScope,
};

@interface LMLibraryBrowserViewController : UITableViewController
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *assetsGroups;
@property (nonatomic) LMAssetLibraryScope libraryScope;
@property (nonatomic, strong) NSString *imageName;
+ (instancetype)browserWithLibraryScope:(LMAssetLibraryScope)scope;
@end
