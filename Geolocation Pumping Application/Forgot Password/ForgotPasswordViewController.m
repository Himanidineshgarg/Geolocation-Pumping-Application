//
//  ForgotPasswordViewController.m
//  Geolocation Pumping Application
//
//  Created by Dinesh Garg on 27/06/15.
//  Copyright (c) 2015 Himani Dinesh Garg. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "NSString+FormValidation.h"

@interface ForgotPasswordViewController ()
{
    IBOutlet UITextField *textFieldEmailAddress;
    
    IBOutlet UIButton *buttonSend;
    IBOutlet UIButton *buttonCancel;
}
-(IBAction)buttonSendAction:(id)sender;
-(IBAction)buttonCancelAction:(id)sender;


@end

@implementation ForgotPasswordViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Button Actions
-(IBAction)buttonSendAction:(id)sender
{
    [textFieldEmailAddress resignFirstResponder];
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    else
    {
        [self postForgotPasswordDetails];
    }
    
}
-(IBAction)buttonCancelAction:(id)sender
{
    [textFieldEmailAddress resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Validation
- (NSString *)validateForm {
    NSString *errorMessage;
    
    if (![textFieldEmailAddress.text isValidEmail]){
        errorMessage = @"Please enter a valid email address";
    }    return errorMessage;
    
}
#pragma mark - Private Methods

#pragma mark Post Forgot Password Web Service
-(void)postForgotPasswordDetails
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSError *error;
        NSURL *url = [NSURL URLWithString:@"https://geolocation-pumping.herokuapp.com/api/geolocation_pumping/forgot_password"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"POST"];
        NSDictionary *dictionaryForgotPassword = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  textFieldEmailAddress.text, @"email",
                                                  nil];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionaryForgotPassword options:0 error:&error];
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
                                           NSLog(@"jsonDictionary - %@",jsonDictionary);
                                           if ([[jsonDictionary objectForKey:@"status"]integerValue]== 500) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to connect with the server.Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                   [alert show];
                                               });
                                               
                                           }
                                           else
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Password has been sent to the registered email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                   [alert show];
                                               });
                                           }
                                           
                                       }
                                       
                                   }
                                   else
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to connect with the server.Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                           [alert show];
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

#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"Password has been sent to the registered email address"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

@end
