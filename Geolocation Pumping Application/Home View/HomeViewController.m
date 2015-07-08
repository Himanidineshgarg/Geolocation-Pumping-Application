//
//  HomeViewController.m
//  Geolocation Pumping Application
//
//  Created by Dinesh Garg on 27/06/15.
//  Copyright (c) 2015 Himani Dinesh Garg. All rights reserved.
//

#import "HomeViewController.h"
#import "ChangePasswordViewController.h"
#import "LoginViewController.h"

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
    /*
    self.locationTracker = [[LocationTracker alloc]init];
    [self.locationTracker startLocationTracking];
    self.locationUpdateTimer =
    [NSTimer scheduledTimerWithTimeInterval:60
                                     target:self
                                   selector:@selector(updateLocation)
                                   userInfo:nil
                                    repeats:YES];
     */
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
    [textFieldTimeInterval resignFirstResponder];
    [textFieldDestinationAddress resignFirstResponder];
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    else
    {
        [self postDestinationAddress];
    }

}
-(IBAction)buttonLogoutAction:(id)sender
{
    [textFieldTimeInterval resignFirstResponder];
    [textFieldDestinationAddress resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to logout from the application?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
    [alert show];
}
-(IBAction)buttonchangePasswordAction:(id)sender
{
    [textFieldTimeInterval resignFirstResponder];
    [textFieldDestinationAddress resignFirstResponder];
    ChangePasswordViewController *changePassword =[[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:nil];
    [self.navigationController pushViewController:changePassword animated:YES];
    
}

#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if([alertView.message isEqualToString:@"Do you want to logout from the application?"])
        {
            [self getLogout];
        }
    }
    
    
}
#pragma mark - Validation
#pragma mark - Form Validation
- (NSString *)validateForm {
    NSString *errorMessage;
    if ([textFieldDestinationAddress.text length] == 0 && [textFieldTimeInterval.text length] == 0) {
        errorMessage = @"Please fill the required fields";
    }else if ([textFieldDestinationAddress.text length]==0){
        errorMessage = @"Please enter destination address";
    }else if ([textFieldTimeInterval.text length]==0){
        errorMessage = @"Please enter time interval";
    }
    return errorMessage;
    
}

-(void)postDestinationAddress
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSError *error;
        NSURL *url = [NSURL URLWithString:@"https://geolocation-pumping.herokuapp.com/api/geolocation_pumping/base_address"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"POST"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:textFieldDestinationAddress.text, @"address",nil];
        
        
        NSDictionary *dictionaryAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           [[NSUserDefaults standardUserDefaults]valueForKey:@"authentication_token"], @"authentication_token",
                                         dictionary,@"base_address",
                                         nil];
        [[NSUserDefaults standardUserDefaults]setInteger:[textFieldTimeInterval.text integerValue] forKey:@"timeInterval"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionaryAddress options:0 error:&error];
        NSString *getString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"getString%@",getString);
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
                                               
                                               [[NSUserDefaults standardUserDefaults]setObject:[jsonDictionary objectForKey:@"address"] forKey:@"address"];
                                               [[NSUserDefaults standardUserDefaults]setObject:[jsonDictionary objectForKey:@"id"] forKey:@"baseid"];
                                               [[NSUserDefaults standardUserDefaults]synchronize];
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{

                            
                                               UIAlertView * alert;
                                               
                                               //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
                                               if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
                                                   
                                                   alert = [[UIAlertView alloc]initWithTitle:@""
                                                                                     message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"Ok"
                                                                           otherButtonTitles:nil, nil];
                                                   [alert show];
                                                   
                                               }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
                                                   
                                                   alert = [[UIAlertView alloc]initWithTitle:@""
                                                                                     message:@"The functions of this app are limited because the Background App Refresh is disable."
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"Ok"
                                                                           otherButtonTitles:nil, nil];
                                                   [alert show];
                                                   
                                               } else{
                                                   
                                                   
                                                   
                                                   self.locationTracker = [[LocationTracker alloc]init];
                                                   [self.locationTracker startLocationTracking];
                                                
                                                   //Send the best location to server every 60 seconds
                                                   //You may adjust the time interval depends on the need of your app.
                                                   NSTimeInterval time = [[NSUserDefaults standardUserDefaults]integerForKey:@"timeInterval"];
                                                   
                                                   
                                                   
                                                   self.locationUpdateTimer =
                                                   [NSTimer scheduledTimerWithTimeInterval:time
                                                                                    target:self
                                                                                  selector:@selector(updateLocation)
                                                                                  userInfo:nil
                                                                                   repeats:YES];
                                               }
                                               });
                                                              

                                           
                                           }
                                           else
                                           {
                                               if ([[[jsonDictionary objectForKey:@"result"]objectForKey:@"errorcode"]integerValue] == 404) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[jsonDictionary objectForKey:@"result"]objectForKey:@"errorcode"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
#pragma mark - Logout Service
-(void)getLogout
{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"authentication_token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    LoginViewController *loginView =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginView animated:YES];
    
}

#pragma mark - CLLocationManagerDelegate

-(void)updateLocation {
    NSLog(@"updateLocation");
    
    [self.locationTracker updateLocationToServer];
}


@end
