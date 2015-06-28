//
//  AppDelegate.h
//  Geolocation Pumping Application
//
//  Created by Dinesh Garg on 26/06/15.
//  Copyright (c) 2015 Himani Dinesh Garg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain)LoginViewController *loginView;

@property (nonatomic, retain)HomeViewController *homeView;

@property (nonatomic, retain)UINavigationController *navigationController;


@end

