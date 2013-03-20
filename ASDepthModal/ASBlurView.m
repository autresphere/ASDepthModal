//
//  ASBlurView.m
//  ASDepthModal
//
//  Created by Shady A. Elyaski on 3/20/13.
//  Copyright (c) 2013 Mash ltd. All rights reserved.
//  Code used from https://github.com/rnystrom/RNBlurModalView
//

#import "ASBlurView.h"

@implementation ASBlurView {
    UIView *_coverView;
}

- (id)initWithCoverView:(UIView *)view {
    if (self = [super initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)]) {
        _coverView = view;
        UIImage *blur = [_coverView screenshot];
        self.image = [blur boxblurImageWithBlur:.2f];
    }
    return self;
}


@end