//
//  LoginViewController.m
//  CamCam
//
//  Created by Marty Lavender on 7/20/15.
//  Copyright (c) 2015 Marty Lavender. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.logInView.backgroundColor = [UIColor colorWithRed:49/255.0 green:150/255.0 blue:214/255.0 alpha:1.0];
	self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
	[self.logInView.facebookButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)loginButton:(id)sender {
	NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if (username.length != 0 && password.length != 0) {
		[PFUser logInWithUsernameInBackground:username password:password
										block:^(PFUser *user, NSError *error) {
											if (user) {
												// Do stuff after successful login.
												[self.navigationController dismissViewControllerAnimated:YES completion:nil];
											} else {
												// The login failed. Check error to see why.
												UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Login failed, please try again" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
												[alertView show];
											}
										}];
	} else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or Password is empty" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		
	}
}



@end
