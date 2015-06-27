//
//  ViewController.m
//  Geolocation Pumping Application
//
//  Created by Dinesh Garg on 26/06/15.
//  Copyright (c) 2015 Himani Dinesh Garg. All rights reserved.
//

#import "ViewController.h"
#import "NSString+FormValidation.h"
@interface ViewController ()
{
    IBOutlet UITextField *textfieldFirstName;
    IBOutlet UITextField *textFieldLastName;
    IBOutlet UITextField *textfieldEmailAddress;
    
    IBOutlet UILabel *labelTitle;
    
    IBOutlet UIButton *buttonSignUp;
}
-(IBAction)buttonSignUpAction:(id)sender;

@end

@implementation ViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
-(IBAction)buttonSignUpAction:(id)sender
{
    
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    else
    {
        [self postSignUpDetails];
        
    }
}

#pragma mark - Form Validation
- (NSString *)validateForm {
    NSString *errorMessage;
    if (![textfieldFirstName.text isValidName]){
        errorMessage = @"Please enter first name";
    } else if (![textFieldLastName.text isValidName]){
        errorMessage = @"Please enter last name";
    } else if (![textfieldEmailAddress.text isValidEmail]){
        errorMessage = @"Please enter a valid email address";
    }
    return errorMessage;
    
}

-(void)postSignUpDetails
{
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo": @"bar"};
    [manager POST:@"http://example.com/resources.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
     */
}
@end
