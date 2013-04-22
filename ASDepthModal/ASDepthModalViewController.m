//
//  ASDepthModalViewController.m
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

#import "ASDepthModalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Blur.h"

static NSTimeInterval const kModalViewAnimationDuration = 0.3;
static CGFloat const kBlurValue = 0.2;
static CGFloat const kDefaultiPhoneCornerRadius = 4;
static CGFloat const kDefaultiPadCornerRadius = 6;

static NSInteger const kDepthModalOptionAnimationMask = 3 << 0;
static NSInteger const kDepthModalOptionBlurMask = 1 << 8;
static NSInteger const kDepthModalOptionTapMask = 1 << 9;

@interface ASDepthModalViewController ()
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, assign) CGAffineTransform initialPopupTransform;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, strong) void(^completionHandler)();
@end

@implementation ASDepthModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.view.backgroundColor = [UIColor blackColor];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;                
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)restoreRootViewController
{
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
    [self.rootViewController.view removeFromSuperview];
    self.rootViewController.view.transform = window.rootViewController.view.transform;
    window.rootViewController = self.rootViewController;
}

- (void)dismiss
{
    [UIView animateWithDuration:kModalViewAnimationDuration
                     animations:^{
                         self.coverView.alpha = 0;
                         self.rootViewController.view.transform = CGAffineTransformIdentity;
                         self.popupView.transform = self.initialPopupTransform;
                         self.blurView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.rootViewController.view.layer setMasksToBounds:NO];
                         [self.blurView removeFromSuperview];
                         [self restoreRootViewController];
                         self.rootViewController.view.layer.cornerRadius = 0;
                         
                         if (self.completionHandler) {
                             self.completionHandler();
                         }
                     }];
}

- (void)animatePopupWithStyle:(ASDepthModalOptions)options
{
    NSInteger style = (options & kDepthModalOptionAnimationMask);
    
    switch (style) {
        case ASDepthModalOptionAnimationGrow:
        {
            self.popupView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            self.initialPopupTransform = self.popupView.transform;
            [UIView animateWithDuration:kModalViewAnimationDuration
                             animations:^{
                                 self.popupView.transform = CGAffineTransformIdentity;
                             }];
        }
            break;
            
        case ASDepthModalOptionAnimationShrink:
        {
            self.popupView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            self.initialPopupTransform = self.popupView.transform;
            [UIView animateWithDuration:kModalViewAnimationDuration
                             animations:^{
                                 self.popupView.transform = CGAffineTransformIdentity;
                             }];
        }
            break;
            
        default:
            self.initialPopupTransform = self.popupView.transform;
            break;
    }
}

- (void)presentView:(UIView *)view withBackgroundColor:(UIColor *)color options:(ASDepthModalOptions)options completionHandler:(void(^)())handler
{
    UIWindow *window;
    CGRect frame;
    
    if(color != nil)
    {
        self.view.backgroundColor = color;
    }
    self.completionHandler = handler;

    window = [UIApplication sharedApplication].keyWindow;
    self.rootViewController = window.rootViewController;
    frame = self.rootViewController.view.frame;
    if(![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.rootViewController.view.layer.cornerRadius = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad?kDefaultiPadCornerRadius:kDefaultiPhoneCornerRadius);
        // Take care of the status bar only if the frame is full screen, which depends on the View controller type.
        // For example, frame is full screen with UINavigationController, but not with basic UIViewController.
        if(UIInterfaceOrientationIsPortrait(self.rootViewController.interfaceOrientation))
        {
            if(frame.size.height == window.bounds.size.height)
            {
                frame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
            }
        }
        else
        {
            if(frame.size.width == window.bounds.size.width)
            {
                frame.size.width -= [UIApplication sharedApplication].statusBarFrame.size.width;
            }
        }
    }
    self.view.transform = self.rootViewController.view.transform;
    self.rootViewController.view.transform = CGAffineTransformIdentity;
    frame.origin = CGPointZero;
    self.rootViewController.view.frame = frame;
    [self.view addSubview:self.rootViewController.view];
    window.rootViewController = self;

    self.popupView = [[UIView alloc] initWithFrame:view.frame];
    self.popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.popupView addSubview:view];
    
    self.coverView = [[UIView alloc] initWithFrame:self.rootViewController.view.bounds];
    self.coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.coverView.backgroundColor = [UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5];
    [self.view addSubview:self.coverView];
    
    if ((options & kDepthModalOptionTapMask) == ASDepthModalOptionTapOutsideToClose)
    {    
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCloseAction:)];
        tapGesture.delegate = self;
        [self.coverView addGestureRecognizer:tapGesture];
    }
    
    [self.coverView addSubview:self.popupView];
    self.popupView.center = CGPointMake(self.coverView.bounds.size.width/2, self.coverView.bounds.size.height/2);
    
    self.coverView.alpha = 0;
        
    if ((options & kDepthModalOptionBlurMask) == ASDepthModalOptionBlur) {
        UIImage *image;
        
        image = [self screenshotForView:self.rootViewController.view];
        image = [image boxblurImageWithBlur:kBlurValue];
        self.blurView = [[UIImageView alloc] initWithImage:image];
        self.blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.blurView.alpha = 0;
        [self.rootViewController.view addSubview:self.blurView];
    }
    
    [self.rootViewController.view.layer setMasksToBounds:YES];
    [UIView animateWithDuration:kModalViewAnimationDuration
                     animations:^{
                         self.rootViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
                         self.coverView.alpha = 1;
                         self.blurView.alpha = 1;
                     }];
    [self animatePopupWithStyle:options];
}

- (UIImage*)screenshotForView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    image = [UIImage imageWithData:imageData];
    
    return image;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.coverView)
        return YES;
    return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    self.rootViewController.view.transform = CGAffineTransformIdentity;
    self.rootViewController.view.bounds = self.view.bounds;
    if(self.blurView != nil)
    {
        UIImage *image;
        
        self.blurView.hidden = YES;
        image = [self screenshotForView:self.rootViewController.view];
        self.blurView.hidden = NO;
        self.blurView.image = [image boxblurImageWithBlur:kBlurValue];
    }
    self.rootViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
}

+ (void)presentView:(UIView *)view
{
    [self presentView:view backgroundColor:nil options:0 completionHandler:nil];
}

+ (void)presentView:(UIView *)view backgroundColor:(UIColor *)color options:(ASDepthModalOptions)options completionHandler:(void(^)())handler
{
    ASDepthModalViewController *modalViewController = [[ASDepthModalViewController alloc] init];
    
    [modalViewController presentView:view withBackgroundColor:(UIColor *)color options:options completionHandler:handler];
}

+ (NSInteger)optionsWithStyle:(ASDepthModalOptions)style blur:(BOOL)blur tapOutsideToClose:(BOOL)tapToClose
{
    NSInteger options;
    
    options = (NSInteger)style;
    
    if (blur)
        options |= ASDepthModalOptionBlur;
    else
        options |= ASDepthModalOptionBlurNone;
    
    
    if (tapToClose)
        options |= ASDepthModalOptionTapOutsideToClose;
    else
        options |= ASDepthModalOptionTapOutsideInactive;
    
    return options;
}

+ (void)dismiss
{
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
    if([window.rootViewController isKindOfClass:[ASDepthModalViewController class]])
    {
        ASDepthModalViewController *controller;
        
        controller = (ASDepthModalViewController *)window.rootViewController;
        [controller dismiss];
    }
}

#pragma mark - Action
- (void)handleCloseAction:(id)sender
{
    [self dismiss];
}

@end
