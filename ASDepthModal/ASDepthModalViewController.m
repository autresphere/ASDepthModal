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
    [UIView animateWithDuration:kModalViewAnimationDuration
                     animations:^{
                         self.coverView.alpha = 0;
                         self.rootViewController.view.transform = CGAffineTransformIdentity;
                         self.popupView.transform = self.initialPopupTransform;
                     }
                     completion:^(BOOL finished) {
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

- (void)presentView:(UIView *)view withBackgroundColor:(UIColor *)color popupAnimationStyle:(ASDepthModalAnimationStyle)popupAnimationStyle;
{
    UIWindow *window;
    CGRect frame;
    UIButton *dismissButton;
    
    if(color != nil)
    {
        self.view.backgroundColor = color;
    }
    
    window = [UIApplication sharedApplication].keyWindow;
    self.rootViewController = window.rootViewController;
    frame = self.rootViewController.view.frame;
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
    
    dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = self.coverView.bounds;
    [dismissButton addTarget:self action:@selector(handleCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.coverView addSubview:dismissButton];
    
    [self.coverView addSubview:self.popupView];
    self.popupView.center = CGPointMake(self.coverView.bounds.size.width/2, self.coverView.bounds.size.height/2);
    
    self.coverView.alpha = 0;
    [UIView animateWithDuration:kModalViewAnimationDuration
                     animations:^{
                         self.rootViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
                         self.coverView.alpha = 1;
                     }];
    [self animatePopupWithStyle:popupAnimationStyle];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    self.rootViewController.view.transform = CGAffineTransformIdentity;
    self.rootViewController.view.bounds = self.view.bounds;
    self.rootViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
}

+ (void)presentView:(UIView *)view
{
    [self presentView:view withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationDefault];
}

+ (void)presentView:(UIView *)view withBackgroundColor:(UIColor *)color popupAnimationStyle:(ASDepthModalAnimationStyle)popupAnimationStyle;
{
    ASDepthModalViewController *modalViewController;
    
    modalViewController = [[ASDepthModalViewController alloc] init];
    [modalViewController presentView:view withBackgroundColor:(UIColor *)color popupAnimationStyle:popupAnimationStyle];
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
