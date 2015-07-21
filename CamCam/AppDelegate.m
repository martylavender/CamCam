//
//  AppDelegate.m
//  CamCam
//
//  Created by Marty Lavender on 7/19/15.
//  Copyright (c) 2015 Marty Lavender. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
 
	// [Optional] Power your app with Local Datastore. For more info, go to
	// https://parse.com/docs/ios_guide#localdatastore/iOS
	[Parse enableLocalDatastore];
 
	// Initialize Parse.
	[Parse setApplicationId:@""
				  clientKey:@""];
 
	// [Optional] Track statistics around application opens.
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	
	PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
	testObject[@"foo"] = @"bar";
	[testObject saveInBackground];
	
	PFObject *superMarket = [PFObject objectWithClassName:@"Supermarket"];
	
	//two different ways to write the same line of code
	[superMarket setObject:@"Apple" forKey:@"fruitItem1"];
	superMarket[@"fruitItem2"] = @"Orange";
	[superMarket saveInBackground];
	[self.window makeKeyAndVisible];
	
	[PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
	
	if (![PFUser currentUser] && ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
		[self presentLoginControllerAnimated:NO];
	}
	return YES;
}

- (void)presentLoginControllerAnimated:(BOOL)animated {
//	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//	UINavigationController *loginNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
//	[self.window.rootViewController presentViewController:loginNavigationController animated:animated completion:nil];
	PFLogInViewController *loginViewController = [[PFLogInViewController alloc] init];
	loginViewController.delegate = self;
	[loginViewController setFields:PFLogInFieldsFacebook];
	[self.window.rootViewController presentViewController:loginViewController animated:animated completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation {
	return [[FBSDKApplicationDelegate sharedInstance] application:application
														  openURL:url
												sourceApplication:sourceApplication
													   annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[FBSDKAppEvents activateApp];
}

- (void)logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user {
	FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
																   parameters:nil];
	[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
		if (!error) {
			[self facebookRequestDidLoad:result];
		}
		else {
			[self showErrorAndLogout];
		}
	}];
}

- (void)logInViewController:(PFLogInViewController * __nonnull)logInController didFailToLogInWithError:(nullable NSError *)error {
	//show error and logout
	[self showErrorAndLogout];
}

- (void)showErrorAndLogout {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login failure" message:@"Please try again" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
	[alertView show];
	[PFUser logOut];
}

- (void)facebookRequestDidLoad:(id)result {
	PFUser *user = [PFUser currentUser];
	if (user) {
		NSString *facebookName = result[@"name"];
		user.username = facebookName;
		NSString *facebookId = result[@"id"];
		user[@"facebookId"]=facebookId;
		
		NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", facebookId]];
		NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL];
		[NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self showErrorAndLogout];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	_profilePictureData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.profilePictureData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if (self.profilePictureData.length == 0 ||  !self.profilePictureData) {
		[self showErrorAndLogout];
	}
	else {
		PFFile *profilePictureFile = [PFFile fileWithData:self.profilePictureData];
		[profilePictureFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
			if (!succeeded) {
				[self showErrorAndLogout];
			}
			else {
				PFUser *user = [PFUser currentUser];
				user[@"profilePicture"] = profilePictureFile;
				[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
					if (!succeeded) {
						[self showErrorAndLogout];
					}
					else {
						[self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
					}
				}];
			}
		}];
	}
}

@end
