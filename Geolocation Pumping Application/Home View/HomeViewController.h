//
//  HomeViewController.h
//  Geolocation Pumping Application
//
//  Created by Dinesh Garg on 27/06/15.
//  Copyright (c) 2015 Himani Dinesh Garg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "LocationTracker.h"
@interface HomeViewController : UIViewController<UIAlertViewDelegate,CLLocationManagerDelegate>
@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;
@end
