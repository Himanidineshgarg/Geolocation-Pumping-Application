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
    [textFieldRetypeOldPassword resignFirstResponder];
    [textFieldNewPassword resignFirstResponder];
    [textFieldOldPassword resignFirstResponder];
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    else
    {
        [self postChangePassordWebService];
    }
    
    
}
-(IBAction)buttonCancelAction:(id)sender
{
    [textFieldRetypeOldPassword resignFirstResponder];
    [textFieldNewPassword resignFirstResponder];
    [textFieldOldPassword resignFirstResponder];
    
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
    } else if (![textFieldNewPassword.text isMinimumPasswordLength]){
        errorMessage = @"Please enter password minimum 8 characters long";
    }else if (![textFieldRetypeOldPassword.text isValidPassword]){
        errorMessage = @"Please enter confirm password";
    }else if(![textFieldNewPassword.text isEqualToString: textFieldRetypeOldPassword.text]) {
        errorMessage =@"New password and confirm password does not match";
    }
    return errorMessage;
    
}

#pragma mark - Change Password Web Service
-(void)postChangePassordWebService
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSError *error;
        NSURL *url = [NSURL URLWithString:@"https://geolocation-pumping.herokuapp.com/api/geolocation_pumping/change_password"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"POST"];
        NSDictionary *dictionaryChangePassord = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                 [[NSUserDefaults standardUserDefaults]valueForKey:@"authentication_token"], @"authentication_token",
                                                 textFieldOldPassword.text, @"current_password",textFieldNewPassword.text,@"password",textFieldRetypeOldPassword.text,@"password_confirmation", nil];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionaryChangePassord options:0 error:&error];
        [request setHTTPBody:postData];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       
                                   });
                                   NSError *jsonError = nil;
                                   if (error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to connect with the server.Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                           [alert show];
                                           return ;
                                           
                                       });
                                   }
                                   else
                                   { if ([data length]>0) {
                                       id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                                       
                                       if ([jsonObject isKindOfClass:[NSArray class]]) {
                                           NSArray *jsonArray = (NSArray *)jsonObject;
                                           NSLog(@"%@",jsonArray);
                                           
                                       }
                                       else {
                                           NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
                                           NSLog(@"jsonDictionary - %@",[jsonDictionary objectForKey:@"result"]);
                                           
                                           if ([[[jsonDictionary objectForKey:@"result"]objectForKey:@"rstatus" ]integerValue]==1) {
                                               NSLog(@"%@",jsonDictionary);
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Password has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                   [alert show];
                                                   return ;
                                               });
                                           }
                                           else
                                           {
                                               if ([[[jsonDictionary objectForKey:@"result"]objectForKey:@"errorcode"]integerValue] == 404) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Email or Password is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                       [alert show];
                                                       return ;
                                                       
                                                   });
                                                   
                                               }
                                           }
                                           
                                       }
                                       
                                   }
                                   else
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to connect with the server.Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                           [alert show];
                                           return ;
                                       });
                                   }
                                       
                                       
                                   }
                                   
                                   
                                   
                               }];
        
    }
    else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please check your internet connection and try again later" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
        
    }
    
    
}
#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"Password has been updated"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"authentication_token"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        LoginViewController *loginView =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginView animated:YES];
        
    }
    
}
@end
