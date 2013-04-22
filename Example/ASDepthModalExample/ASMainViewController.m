//
//  ASMainViewController.m
//  ASDepthModal
//
//  Created by Philippe Converset on 03/10/12.
//  Copyright (c) 2012 AutreSphere. All rights reserved.
//

#import "ASMainViewController.h"
#import "ASDepthModalViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ASMainViewController ()
@property (nonatomic, strong) NSArray *configurationColors;
@property (nonatomic, strong) NSArray *configurationStyles;
@end

@implementation ASMainViewController
@synthesize configurationColors;

- (void)setupConfigurations
{
    self.configurationColors = [NSArray arrayWithObjects:@"black (default)", @"pattern", nil];
    self.configurationStyles = [NSArray arrayWithObjects:@"grow (default)", @"shrink", @"none", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.popupView.layer.cornerRadius = 12;
    self.popupView.layer.shadowOpacity = 0.7;
    self.popupView.layer.shadowOffset = CGSizeMake(6, 6);
    self.popupView.layer.shouldRasterize = YES;
    self.popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [self setupConfigurations];
    [self.colorTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.styleTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.colorTableView.backgroundColor = [UIColor whiteColor];
    self.colorTableView.backgroundView = nil;
    self.styleTableView.backgroundColor = [UIColor whiteColor];
    self.styleTableView.backgroundView = nil;
    
    UIScrollView *scrollView;
    
    scrollView = (UIScrollView *)self.styleTableView.superview.superview;
    scrollView.contentSize = self.styleTableView.superview.bounds.size;
    scrollView.alwaysBounceVertical = NO;
}

#pragma mark - Actions
- (IBAction)showModalViewAction:(id)sender
{
    UIColor *color = nil;
    ASDepthModalOptions style = ASDepthModalOptionAnimationGrow;
    ASDepthModalOptions options;
    NSInteger colorConfigurationIndex;
    NSInteger styleConfigurationIndex;    
    
    colorConfigurationIndex = [self.colorTableView indexPathForSelectedRow].row;
    if(colorConfigurationIndex == 1)
    {
        UIImage *image;
        
        // This image comes from http://www.numero111.com/wp-content/uploads/2010/11/ist2_7360872-elegant-abstract-wallpaper-pattern-background-tiles-seamlessly.jpg
        image = [UIImage imageNamed:@"pattern1.jpg"];
        color = [UIColor colorWithPatternImage:image];
    }
    
    styleConfigurationIndex = [self.styleTableView indexPathForSelectedRow].row;
    if(styleConfigurationIndex == 1)
    {
        style = ASDepthModalOptionAnimationShrink; 
    }
    else if(styleConfigurationIndex == 2)
    {
        style = ASDepthModalOptionAnimationNone;
    }

    options = style | (self.blurSwitch.on?ASDepthModalOptionBlur:ASDepthModalOptionBlurNone) | (self.tapOutsideSwitch.on?ASDepthModalOptionTapOutsideToClose:ASDepthModalOptionTapOutsideInactive);
    
    [ASDepthModalViewController presentView:self.popupView
                            backgroundColor:color
                                    options:options
                          completionHandler:^{
                              NSLog(@"Modal view closed.");
                          }];
}

- (IBAction)closePopupAction:(id)sender
{
    [ASDepthModalViewController dismiss];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.colorTableView)
    {
        return self.configurationColors.count;
    }
    else
    {
        return self.configurationStyles.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == self.colorTableView)
    {
        return @"Back view color";
    }
    else
    {
        return @"Popup animation effect";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSArray *titles;
    
    titles = (tableView == self.colorTableView?self.configurationColors:self.configurationStyles);
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)viewDidUnload {
    [self setBlurSwitch:nil];
    [self setTapOutsideSwitch:nil];
    [super viewDidUnload];
}
@end
