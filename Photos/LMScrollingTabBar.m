//
//  LMScrollingTabBar.m
//  Photos
//
//  Created by Logan Moseley on 1/22/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMScrollingTabBar.h"
#import "UIColor+LMStyling.h"

static CGFloat const kMinimumButtonWidthDefault = 60.;

@implementation LMScrollingTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tabBarFlags.delegateTabBarDidSelectItem = NO;
        _minimumButtonWidth = kMinimumButtonWidthDefault;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceHorizontal = YES;
        self.backgroundColor = [UIColor offWhiteColor];
        self.pagingEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat c = (CGFloat)self.items.count;
    CGFloat maxButtonsPerPage = floorf(CGRectGetWidth(self.bounds) / self.minimumButtonWidth);
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



#pragma mark - Buttons

- (void)buttonTapped:(UIButton *)sender
{
    NSUInteger index;
    if ([self.items containsObject:sender]) {
        [self setSelectedItem:sender];
        if (_tabBarFlags.delegateTabBarDidSelectItem) {
            [self.delegate tabBar:self didSelectItem:sender];
        }
    } else {
        index = NSNotFound;
    }
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
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
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
    
//    UIButton *old = [self selectedItem];
//    [old setSelected:NO];
    
    [self willChangeValueForKey:@"selectedIndex"];
    _selectedIndex = selectedIndex;
    [self didChangeValueForKey:@"selectedIndex"];
    
//    UIButton *new = self.items[selectedIndex];
//    [new setSelected:YES];
}

@end
