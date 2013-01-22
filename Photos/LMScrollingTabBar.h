//
//  LMScrollingTabBar.h
//  Photos
//
//  Created by Logan Moseley on 1/22/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMScrollingTabBar;

@protocol LMScrollingTabBarDelegate <NSObject, UIScrollViewDelegate>
@optional
- (void)tabBar:(LMScrollingTabBar *)tabBar didSelectItem:(UIButton *)item; // called when a new view is selected by the user (but not programatically)
@end

@interface LMScrollingTabBar : UIScrollView
{
    struct {
        unsigned int delegateTabBarDidSelectItem:1;
    } _tabBarFlags;
}
@property (nonatomic, weak) id<LMScrollingTabBarDelegate> delegate;     // default is nil
@property (nonatomic, strong)   NSArray                  *items;        // get/set visible UIButtons. default is nil. changes not animated. shown in order
@property (nonatomic, weak)     UIButton                 *selectedItem; // will show feedback based on mode. default is nil
@property (nonatomic)           NSUInteger                selectedIndex;
@property (nonatomic)           CGFloat                   minimumButtonWidth;
@end
