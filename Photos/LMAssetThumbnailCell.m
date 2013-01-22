//
//  LMAssetThumbnailCell.m
//  Photos
//
//  Created by Logan Moseley on 1/20/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import "LMAssetThumbnailCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LMAssetThumbnailCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setClipsToBounds:YES];
        [self.contentView setAutoresizesSubviews:YES];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView layer].borderWidth = 1.;
        [imageView layer].borderColor = [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:imageView];
        [self setImageView:imageView];
    }
    return self;
}

- (void)prepareForReuse {
    self.imageView.image = nil;
}

@end
