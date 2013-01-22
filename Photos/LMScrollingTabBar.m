//
//  LMScrollingTabBar.m
//  Photos
//
//  Created by Logan Moseley on 1/22/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

static CGFloat const kMinimumButtonWidth = 42.*1.5;

#import "LMScrollingTabBar.h"

@implementation LMScrollingTabBar

- (id)init
{
    self = [super init];
    if (self) {
        _tabBarFlags.delegateTabBarDidSelectItem = NO;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    self.backgroundColor = [UIColor magentaColor];
    self.pagingEnabled = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat c = (CGFloat)self.items.count;
    CGFloat maxButtonsPerPage = floorf(CGRectGetWidth(self.bounds) / kMinimumButtonWidth);
    CGFloat buttonsPerPage = MIN(c, maxButtonsPerPage);
    CGFloat w = CGRectGetWidth(self.bounds) / buttonsPerPage;
    CGFloat h = CGRectGetHeight(self.bounds);
    NSInteger i = 0;
    CGRect frame;
    for (UIButton *button in self.items) {
        frame.origin = CGPointMake(w*i++, 0);
        frame.size   = CGSizeMake(w, h);
        button.frame = frame;
    }
    self.contentSize = CGSizeMake(w*c, h);
}



#pragma mark - Properties

- (void)setDelegate:(id<LMScrollingTabBarDelegate>)delegate
{
    [super setDelegate:delegate];
    _tabBarFlags.delegateTabBarDidSelectItem = [delegate respondsToSelector:@selector(tabBar:didSelectItem:)];
}

- (void)setItems:(NSArray *)items
{
    [self willChangeValueForKey:@"items"];
    
    [_items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _items = items;
    
    for (UIButton *button in items) {
        [self addSubview:button];
    }
    
    [self didChangeValueForKey:@"items"];
    
    [self setSelectedIndex:0];
}

- (UIButton *)selectedItem
{
    return self.items.count > 0 ? self.items[self.selectedIndex] : nil;
}

- (void)setSelectedItem:(UIButton *)selectedItem
{
    NSUInteger index;
    if ([self.items containsObject:selectedItem]) {
        index = [self.items indexOfObject:selectedItem];
    } else {
        self.items = [self.items arrayByAddingObject:selectedItem];
        index = self.items.count-1;
    }
    self.selectedIndex = index;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (!self.items || selectedIndex >= self.items.count)
        return;
    [self willChangeValueForKey:@"selectedIndex"];
    _selectedIndex = selectedIndex;
    [self didChangeValueForKey:@"selectedIndex"];
}

@end
