//
//  ASDepthModalViewController.h
//  ASDepthModal
//
//  Created by Philippe Converset on 03/10/12.
//  Copyright (c) 2012 AutreSphere.
//

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ASDepthModalOptions) {
    ASDepthModalOptionAnimationGrow     = 1 << 0,
    ASDepthModalOptionAnimationShrink   = 1 << 1,
    ASDepthModalOptionAnimationNone     = 1 << 2,
    ASDepthModalOptionBlur              = 1 << 3,
    ASDepthModalOptionBlurNone          = 1 << 4,
    ASDepthModalOptionTapOutsideToClose = 1 << 5,
    ASDepthModalOptionTapOutsideInactive= 1 << 6
};

/*
Mostly inspired by http://lab.hakim.se/avgrund/
*/
@interface ASDepthModalViewController : UIViewController <UIGestureRecognizerDelegate>

+ (NSInteger)optionsWithStyle:(ASDepthModalOptions)style blur:(BOOL)blur tapOutsideToClose:(BOOL)tapToClose; // Helper method to create the options

+ (void)presentView:(UIView *)view withBackgroundColor:(UIColor *)color options:(NSInteger)options;

+ (void)presentView:(UIView *)view;
+ (void)dismiss;

@end
