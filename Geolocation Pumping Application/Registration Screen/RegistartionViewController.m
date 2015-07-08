//
//  RegistartionViewController.m
//  Geolocation Pumping Application
//
//  Created by Dinesh Garg on 27/06/15.
//  Copyright (c) 2015 Himani Dinesh Garg. All rights reserved.
//

#import "RegistartionViewController.h"
#import "NSString+FormValidation.h"

@interface RegistartionViewController ()
{
    IBOutlet UITextField *textFieldFirstName;
    IBOutlet UITextField *textFieldLastName;
    IBOutlet UITextField *textFieldMiddleName;
    IBOutlet UITextField *textFieldEmailAddress;
    IBOutlet UITextField *textFieldPassword;
    IBOutlet UITextField *textFieldConfirmPassword;
    
    IBOutlet UIView *contentView;
    
    IBOutlet UIButton *buttonSubmit;
    IBOutlet UIButton *buttonCancel;
    
    
    
}
-(IBAction)buttonSubmitAction:(id)sender;
-(IBAction)buttonCancelAction:(id)sender;

@end

@implementation RegistartionViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
   NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                        toItem:self.view
                                                                      attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:rightConstraint];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
-(IBAction)buttonSubmitAction:(id)sender
{
    [textFieldEmailAddress resignFirstResponder];
    [textFieldPassword resignFirstResponder];
    [textFieldConfirmPassword resignFirstResponder];
    [textFieldFirstName resignFirstResponder];
    [textFieldLastName resignFirstResponder];
    [textFieldMiddleName resignFirstResponder];
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    else
    {
        [self postUserDetails];
    }

}
-(IBAction)buttonCancelAction:(id)sender
{
    [textFieldEmailAddress resignFirstResponder];
    [textFieldPassword resignFirstResponder];
    [textFieldConfirmPassword resignFirstResponder];
    [textFieldFirstName resignFirstResponder];
    [textFieldLastName resignFirstResponder];
    [textFieldMiddleName resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Form Validation
- (NSString *)validateForm {
    NSString *errorMessage;
    if ([textFieldEmailAddress.text length] == 0 && [textFieldPassword.text length] == 0 && [textFieldFirstName.text length] == 0 && [textFieldLastName.text length] == 0 && [textFieldConfirmPassword.text length] == 0 )  {
        errorMessage = @"Please fill the required fields";
    }else if (![textFieldFirstName.text isValidName]){
        errorMessage =@"Please enter first name";
    }else if (![textFieldLastName.text isValidName]){
        errorMessage =@"Please enter last name";
    }else if (![textFieldEmailAddress.text isValidEmail]){
        errorMessage = @"Please enter a valid email address";
    }else if (![textFieldPassword.text isValidPassword]){
        errorMessage = @"Please enter password";
    }else if (![textFieldPassword.text isMinimumPasswordLength]){
        errorMessage = @"Please enter password minimum 8 characters long";
    }else if (![textFieldConfirmPassword.text isValidPassword]){
        errorMessage =@"Please enter confirm password";
    }else if(![textFieldPassword.text isEqualToString: textFieldConfirmPassword.text]) {
        errorMessage =@"Password and confirm password does not match";
    }
    return errorMessage;
    
}

#pragma mark - Submit Register User Details 
-(void)postUserDetails
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSError *error;
        NSURL *url = [NSURL URLWithString:@"https://geolocation-pumping.herokuapp.com/api/geolocation_pumping/register"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPMethod:@"POST"];
        NSString *strName;
        strName = textFieldFirstName.text;
        if ([textFieldLastName.text length] != 0) {
            
            strName =[NSString stringWithFormat:@"%@ %@",textFieldFirstName.text,textFieldMiddleName.text];
        }
        
        NSDictionary *dictionaryRegister = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            textFieldEmailAddress.text, @"email",
                                             strName, @"first_name",
                                            textFieldLastName.text, @"last_name",
                                            textFieldPassword.text, @"password",
                                            textFieldConfirmPassword.text, @"password_confirmation",
                                         nil];
        NSDictionary *dictionary =[[NSDictionary alloc]initWithObjectsAndKeys:dictionaryRegister,@"user",nil];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        
     NSString *str =   [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"str%@",str);
        
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
                                               [[NSUserDefaults standardUserDefaults]setObject:[jsonDictionary objectForKey:@"authentication_token"] forKey:@"authentication_token"];
                                               [[NSUserDefaults standardUserDefaults]synchronize];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Registration Successful" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                   [alert show];
                                                   return ;
                                               });
                                           }
                                           else
                                           {
                                               if ([[[jsonDictionary objectForKey:@"result"]objectForKey:@"errorcode"]integerValue] == 404) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[jsonDictionary objectForKey:@"result"]objectForKey:@"messages"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    if([alertView.message isEqualToString:@"Registration Successful"])
    {
        
        HomeViewController *homeView =[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        [self.navigationController pushViewController:homeView animated:YES];
        
    }
    
}
@end
