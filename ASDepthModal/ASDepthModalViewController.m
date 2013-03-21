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
#import "ASBlurView.h"

@interface ASDepthModalViewController ()
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, assign) CGAffineTransform initialPopupTransform;;
@end

static NSTimeInterval const kModalViewAnimationDuration = 0.3;

@implementation ASDepthModalViewController
@synthesize popupView;
@synthesize rootViewController;
@synthesize coverView;

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
    ASBlurView *_blurView = (ASBlurView *) [self.rootViewController.view viewWithTag:1144];
    [UIView animateWithDuration:kModalViewAnimationDuration
                     animations:^{
                         self.coverView.alpha = 0;
                         self.rootViewController.view.transform = CGAffineTransformIdentity;
                         self.rootViewController.view.layer.cornerRadius = 0.f;
                         self.popupView.transform = self.initialPopupTransform;
                         _blurView.alpha=0.f;
                     }
                     completion:^(BOOL finished) {
                         [self.rootViewController.view.layer setMasksToBounds:NO];
                         [_blurView removeFromSuperview];
                         [self restoreRootViewController];
                     }];
}

- (void)animatePopupWithStyle:(ASDepthModalAnimationStyle)style
{
    switch (style) {
        case ASDepthModalAnimationGrow:
        {
            self.popupView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            self.initialPopupTransform = self.popupView.transform;
            [UIView animateWithDuration:kModalViewAnimationDuration
                             animations:^{
                                 self.popupView.transform = CGAffineTransformIdentity;
                             }];
        }
            break;
            
        case ASDepthModalAnimationShrink:
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

- (void)presentView:(UIView *)view withBackgroundColor:(UIColor *)color popupAnimationStyle:(ASDepthModalAnimationStyle)popupAnimationStyle Blur:(BOOL)isBlurred;
{
    UIWindow *window;
    CGRect frame;
    
    if(color != nil)
    {
        self.view.backgroundColor = color;
    }
    
    window = [UIApplication sharedApplication].keyWindow;
    self.rootViewController = window.rootViewController;
    
    
    frame = self.rootViewController.view.frame;
    if(![UIApplication sharedApplication].isStatusBarHidden)
    {
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCloseAction:)];
    [tapGesture setDelegate:self];
    [self.coverView addGestureRecognizer:tapGesture];
    
    [self.coverView addSubview:self.popupView];
    self.popupView.center = CGPointMake(self.coverView.bounds.size.width/2, self.coverView.bounds.size.height/2);
    
    self.coverView.alpha = 0;
    
    ASBlurView *_blurView = nil;
    
    if (isBlurred) {
        _blurView = [[ASBlurView alloc] initWithCoverView:self.rootViewController.view];
        _blurView.alpha = 0.f;
        _blurView.tag = 1144;
        [self.rootViewController.view addSubview:_blurView];
    }
    
    [self.rootViewController.view.layer setMasksToBounds:YES];
    [UIView animateWithDuration:kModalViewAnimationDuration
                     animations:^{
                         self.rootViewController.view.layer.cornerRadius = 12.f;
                         self.rootViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
                         self.coverView.alpha = 1;
                         _blurView.alpha=1.f;
                     }];
    [self animatePopupWithStyle:popupAnimationStyle];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view == self.coverView)
        return YES;
    return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    self.rootViewController.view.transform = CGAffineTransformIdentity;
    self.rootViewController.view.bounds = self.view.bounds;
    self.rootViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
}

+ (void)presentView:(UIView *)view
{
    [self presentView:view withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationDefault Blur:YES];
}

+ (void)presentView:(UIView *)view withBackgroundColor:(UIColor *)color popupAnimationStyle:(ASDepthModalAnimationStyle)popupAnimationStyle Blur:(BOOL)isBlurred;
{
    ASDepthModalViewController *modalViewController;
    
    modalViewController = [[ASDepthModalViewController alloc] init];
    [modalViewController presentView:view withBackgroundColor:(UIColor *)color popupAnimationStyle:popupAnimationStyle Blur:isBlurred];
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
