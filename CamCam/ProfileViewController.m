//
//  ProfileViewController.m
//  CamCam
//
//  Created by Marty Lavender on 7/22/15.
//  Copyright (c) 2015 Marty Lavender. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "AppDelegate.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumberLabel;
- (IBAction)logoutButton:(id)sender;



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
	self.profileImageView.layer.masksToBounds = YES;
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self updateUserStatus];
}

- (void)updateUserStatus {
	PFUser *user = [PFUser currentUser];
	self.profileImageView.file = user[@"profilePicture"];
	[self.profileImageView loadInBackground];
	self.usernameLabel.text = user.username;
	
	PFQuery *followingQuery = [PFQuery queryWithClassName:@"Activity"];
	[followingQuery whereKey:@"fromUser" equalTo:user];
	[followingQuery whereKey:@"type" equalTo:@"follow"];
	[followingQuery findObjectsInBackgroundWithBlock:^(NSArray *followingActvities, NSError *error) {
		if (!error)  {
			self.followingNumberLabel.text = [[NSNumber numberWithInteger:followingActvities.count] stringValue];
		}
	}];

	PFQuery *followerQuery = [PFQuery queryWithClassName:@"Activity"];
	[followerQuery whereKey:@"toUser" equalTo:user];
	[followerQuery whereKey:@"type" equalTo:@"follow"];
	[followerQuery findObjectsInBackgroundWithBlock:^(NSArray *followerActvities, NSError *error) {
		if (!error)  {
			self.followerNumberLabel.text = [[NSNumber numberWithInteger:followerActvities.count] stringValue];
		}
	}];
}


- (PFQuery *)queryForTable {
	if (![PFUser currentUser] || ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
		return nil;
	}
	PFQuery *followingQuery = [PFQuery queryWithClassName:@"Activity"];
	[followingQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
	[followingQuery whereKey:@"type" equalTo:@"follow"];
	
	PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:@"Photo"];
	[photosFromFollowedUsersQuery whereKey:@"whoTook" matchesKey:@"toUser" inQuery:followingQuery];
	
	PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:@"Photo"];
	[photosFromFollowedUsersQuery whereKey:@"whoTook" equalTo:[PFUser currentUser]];
	
	PFQuery *superQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromCurrentUserQuery,photosFromFollowedUsersQuery, nil]];
	[superQuery includeKey:@"whoTook"];
	[superQuery orderByDescending:@"createdAt"];
	return superQuery;
}





- (IBAction)logoutButton:(id)sender {
	[PFUser logOut];
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	[appDelegate presentLoginControllerAnimated:YES];
}

@end
