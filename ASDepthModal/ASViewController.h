//
//  ASViewController.h
//  ASDepthModal
//
//  Created by Philippe Converset on 03/10/12.
//  Copyright (c) 2012 AutreSphere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) IBOutlet UITableView *colorTableView;
@property (strong, nonatomic) IBOutlet UITableView *styleTableView;
@property (strong, nonatomic) IBOutlet UITableView *rootStyleTableView;

- (IBAction)showModalViewAction:(id)sender;
- (IBAction)closePopupAction:(id)sender;

@end
