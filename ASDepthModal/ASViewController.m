//
//  ASViewController.m
//  ASDepthModal
//
//  Created by Philippe Converset on 03/10/12.
//  Copyright (c) 2012 AutreSphere. All rights reserved.
//

#import "ASViewController.h"
#import "ASDepthModalViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ASViewController ()
@property (nonatomic, strong) NSArray *configurationColors;
@property (nonatomic, strong) NSArray *configurationStyles;
@property (nonatomic, strong) NSArray *configurationRootStyles;
@end

@implementation ASViewController
@synthesize configurationColors;

- (void)setupConfigurations
{
    self.configurationColors = [NSArray arrayWithObjects:@"black (default)", @"pattern", nil];
    self.configurationStyles = [NSArray arrayWithObjects:@"grow (default)", @"shrink", @"none", nil];
    self.configurationRootStyles = [NSArray arrayWithObjects:@"grow", @"shrink (default)", @"none", nil];
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
    [self.rootStyleTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.colorTableView.backgroundColor = [UIColor whiteColor];
    self.colorTableView.backgroundView = nil;
    self.styleTableView.backgroundColor = [UIColor whiteColor];
    self.styleTableView.backgroundView = nil;
    self.rootStyleTableView.backgroundColor = [UIColor whiteColor];
    self.rootStyleTableView.backgroundView = nil;
    
    UIScrollView *scrollView;
    
    scrollView = (UIScrollView *)self.styleTableView.superview.superview;
    scrollView.contentSize = self.styleTableView.superview.bounds.size;
    scrollView.alwaysBounceVertical = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)showModalViewAction:(id)sender
{
    UIColor *color = nil;
    ASDepthModalAnimationStyle style = ASDepthModalAnimationDefault;
    ASDepthModalAnimationStyle rootStyle = ASDepthModalAnimationDefault;
    NSInteger colorConfigurationIndex;
    NSInteger styleConfigurationIndex;
    NSInteger rootStyleConfigurationIndex;
    
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
        style = ASDepthModalAnimationShrink;
    }
    else if(styleConfigurationIndex == 2)
    {
        style = ASDepthModalAnimationNone;
    }
    
    rootStyleConfigurationIndex = [self.rootStyleTableView indexPathForSelectedRow].row;
    if(rootStyleConfigurationIndex == 1)
    {
        rootStyle = ASDepthModalAnimationShrink;
    }
    else if(rootStyleConfigurationIndex == 2)
    {
        rootStyle = ASDepthModalAnimationNone;
    }

    [ASDepthModalViewController presentView:self.popupView withBackgroundColor:color popupAnimationStyle:style rootViewAnimationStyle:rootStyle];
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
    else if (tableView == self.rootStyleTableView)
    {
        return @"Popup effect";
    }
    else
    {
        return @"Root effect";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSArray *titles;
    
    titles = (tableView == self.colorTableView?self.configurationColors:tableView==self.styleTableView?self.configurationStyles:self.configurationRootStyles);
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

@end
