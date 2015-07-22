//
//  ParseViewController.m
//  CamCam
//
//  Created by Marty Lavender on 7/20/15.
//  Copyright (c) 2015 Marty Lavender. All rights reserved.
//

#import "ParseViewController.h"

@interface ParseViewController ()

@end

@implementation ParseViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.logInView.backgroundColor = self.logInView.backgroundColor = [UIColor colorWithRed:49/255.0 green:150/255.0 blue:214/255.0 alpha:1.0];
	self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
	[self.logInView.facebookButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.logInView.facebookButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
	
	CGRect frame = self.logInView.logo.frame;
	frame.origin.y = 150;
	self.logInView.logo.frame = frame;
	frame = self.logInView.facebookButton.frame;
	frame.origin.y = 300;
	self.logInView.facebookButton.frame = frame;
}

@end
