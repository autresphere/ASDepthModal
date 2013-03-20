//
//  ASBlurView.h
//  ASDepthModal
//
//  Created by Shady A. Elyaski on 3/20/13.
//  Copyright (c) 2013 Mash ltd. All rights reserved.
//  Code used from https://github.com/rnystrom/RNBlurModalView
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import "UIImage+Blur.h"

@interface ASBlurView : UIImageView
- (id)initWithCoverView:(UIView*)view;
@end
