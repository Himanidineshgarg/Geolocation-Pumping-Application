//
//  HomeViewController.m
//  Geolocation Pumping Application
//
//  Created by Dinesh Garg on 27/06/15.
//  Copyright (c) 2015 Himani Dinesh Garg. All rights reserved.
//

#import "HomeViewController.h"
#import "ChangePasswordViewController.h"

@interface HomeViewController ()
{
    IBOutlet UILabel *labelTitle;
    
    IBOutlet UITextField *textFieldDestinationAddress;
    IBOutlet UITextField *textFieldTimeInterval;
    
    IBOutlet UIButton *buttonStartTracking;
    IBOutlet UIButton *buttonLogout;
    IBOutlet UIButton *buttonChangePassword;
    
}
-(IBAction)buttonStartTrackingAction:(id)sender;
-(IBAction)buttonLogoutAction:(id)sender;
-(IBAction)buttonchangePasswordAction:(id)sender;

@end

@implementation HomeViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions
-(IBAction)buttonStartTrackingAction:(id)sender
{
    
}
-(IBAction)buttonLogoutAction:(id)sender
{
    
}
-(IBAction)buttonchangePasswordAction:(id)sender
{
    ChangePasswordViewController *changePassword =[[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:nil];
    [self.navigationController pushViewController:changePassword animated:YES];
    
}

@end
