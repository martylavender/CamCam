//
//  SignUpViewController.m
//  CamCam
//
//  Created by Marty Lavender on 7/20/15.
//  Copyright (c) 2015 Marty Lavender. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)signupButton:(id)sender {
	NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if (username.length != 0 && password.length != 0) {
		PFUser *user = [PFUser user];
		user.username = username;
		user.password = password;
		
		[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (!error) {
				// Hooray! Let them use the app now.
				[self.navigationController dismissViewControllerAnimated:YES completion:nil];
			} else {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error signing up" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
				[alertView show];
				
			}
		}];
	} else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or Password is empty" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		
	}
	
}

@end
