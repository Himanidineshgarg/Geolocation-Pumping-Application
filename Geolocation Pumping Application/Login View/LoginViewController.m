//
//  LoginViewController.m
//  Geolocation Pumping Application
//
//  Created by Dinesh Garg on 27/06/15.
//  Copyright (c) 2015 Himani Dinesh Garg. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+FormValidation.h"


@interface LoginViewController ()
{
    IBOutlet UITextField *textfieldPassword;
    IBOutlet UITextField *textfieldEmailAddress;
    
    IBOutlet UILabel *labelTitle;
    
    IBOutlet UIButton *buttonLogin;
    IBOutlet UIButton *buttonRegisterNow;
    IBOutlet UIButton *buttonForgotPassword;
    
}
-(IBAction)buttonRegisterNowAction:(id)sender;
-(IBAction)buttonLoginAction:(id)sender;
-(IBAction)buttonForgotPasswordAction:(id)sender;

@end

@implementation LoginViewController
@synthesize HUD;
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Form Validation
- (NSString *)validateForm {
    NSString *errorMessage;
    if ([textfieldEmailAddress.text length] == 0 && [textfieldPassword.text length] == 0) {
        errorMessage = @"Please fill the required fields";
    }else if (![textfieldEmailAddress.text isValidEmail]){
        errorMessage = @"Please enter a valid email address";
    }else if (![textfieldPassword.text isValidPassword]){
        errorMessage = @"Please enter password";
    }else if (![textfieldPassword.text isMinimumPasswordLength]){
        errorMessage = @"Please enter password minimum 8 characters long";
    }
    return errorMessage;
    
}

#pragma mark - Button Actions

-(IBAction)buttonRegisterNowAction:(id)sender
{
    [textfieldEmailAddress resignFirstResponder];
    [textfieldPassword resignFirstResponder];
    RegistartionViewController *registrationView =[[RegistartionViewController alloc]initWithNibName:@"RegistartionViewController" bundle:nil];
    [self.navigationController pushViewController:registrationView animated:YES];
    
}
-(IBAction)buttonLoginAction:(id)sender
{
    [textfieldEmailAddress resignFirstResponder];
    [textfieldPassword resignFirstResponder];
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    else
    {
        [self postLoginDetails:sender];
    }
    
}
-(IBAction)buttonForgotPasswordAction:(id)sender
{
    [textfieldEmailAddress resignFirstResponder];
    [textfieldPassword resignFirstResponder];
    ForgotPasswordViewController *forgotPassword =[[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgotPassword animated:YES];
}

#pragma mark - Private Methods

#pragma mark - Post Web Service
-(void)postLoginDetails :(id)sender
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSError *error;
        NSURL *url = [NSURL URLWithString:@"https://geolocation-pumping.herokuapp.com/api/geolocation_pumping/login"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPMethod:@"POST"];
        NSDictionary *dictionaryLogin = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         textfieldEmailAddress.text, @"email",
                                         textfieldPassword.text, @"password",
                                         nil];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionaryLogin options:0 error:&error];
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
                                           NSLog(@"its probably a dictionary");
                                           NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
                                           NSLog(@"jsonDictionary - %@",[jsonDictionary objectForKey:@"result"]);
                                           
                                           if ([[jsonDictionary objectForKey:@"result"]count]==0) {
                                               NSLog(@"%@",jsonDictionary);
                                               [[NSUserDefaults standardUserDefaults]setObject:textfieldEmailAddress.text forKey:@"email"];
                                               [[NSUserDefaults standardUserDefaults]setObject:[jsonDictionary objectForKey:@"id"]forKey:@"id"];
                                               [[NSUserDefaults standardUserDefaults]setObject:[jsonDictionary objectForKey:@"first_name"] forKey:@"first_name"];
                                               [[NSUserDefaults standardUserDefaults]setObject:[jsonDictionary objectForKey:@"last_name"] forKey:@"last_name"];
                                               [[NSUserDefaults standardUserDefaults]setObject:[jsonDictionary objectForKey:@"authentication_token"] forKey:@"authentication_token"];
                                               [[NSUserDefaults standardUserDefaults]synchronize];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Login Successful" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    if([alertView.message isEqualToString:@"Login Successful"])
    {
        HomeViewController *homeView =[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        [self.navigationController pushViewController:homeView animated:YES];
        
    }
    
}

@end
