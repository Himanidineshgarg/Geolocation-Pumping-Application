//
//  ChangePasswordViewController.m
//  Geolocation Pumping Application
//
//  Created by Dinesh Garg on 27/06/15.
//  Copyright (c) 2015 Himani Dinesh Garg. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "NSString+FormValidation.h"

@interface ChangePasswordViewController ()
{
    IBOutlet UITextField *textFieldNewPassword;
    IBOutlet UITextField *textFieldOldPassword;
    IBOutlet UITextField *textFieldRetypeOldPassword;
    
    IBOutlet UIButton *buttonSubmit;
    IBOutlet UIButton *buttonCancel;
    
}
-(IBAction)buttonSubmitAction:(id)sender;
-(IBAction)buttonCancelAction:(id)sender;
@end

@implementation ChangePasswordViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
-(IBAction)buttonSubmitAction:(id)sender
{
    
}
-(IBAction)buttonCancelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Validation
- (NSString *)validateForm {
    
    NSString *errorMessage;
     if ([textFieldNewPassword.text length]==0 && [textFieldOldPassword.text length]==0 && [textFieldRetypeOldPassword.text length]==0 ) {
     errorMessage = @"Please fill the required fields";
     }else if (![textFieldOldPassword.text isValidPassword]){
     errorMessage = @"Please enter old password";
     }else if (![textFieldNewPassword.text isValidPassword]){
     errorMessage = @"Please enter new password";
     }else if (![textFieldRetypeOldPassword.text isValidPassword]){
         errorMessage = @"Please enter confirm password";
     }
//     else if (![textfieldPassword.text isMinimumPasswordLength]){
//     errorMessage = @"Please enter password minimum 8 characters long";
//     }
    
    return errorMessage;
    
}


@end
