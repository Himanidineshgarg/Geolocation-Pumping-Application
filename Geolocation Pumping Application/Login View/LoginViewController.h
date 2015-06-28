//
//  LoginViewController.h
//  Geolocation Pumping Application
//
//  Created by Dinesh Garg on 27/06/15.
//  Copyright (c) 2015 Himani Dinesh Garg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "HomeViewController.h"
#import "RegistartionViewController.h"
#import "ForgotPasswordViewController.h"

@interface LoginViewController : UIViewController<NSURLSessionDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
@property (nonatomic,retain)MBProgressHUD *HUD;

@end
