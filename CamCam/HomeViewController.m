//
//  HomeViewController.m
//  CamCam
//
//  Created by Marty Lavender on 7/20/15.
//  Copyright (c) 2015 Marty Lavender. All rights reserved.
//

#import "HomeViewController.h"


@implementation HomeViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		// This table displays items in the Todo class
		self.parseClassName = @"Photo";
		self.pullToRefreshEnabled = YES;
		self.paginationEnabled = YES;
		self.objectsPerPage = 3;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadObjects];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - PFQueryTableViewDataSource and Delegates
- (void)objectsDidLoad:(NSError *)error {
	[super objectsDidLoad:error];
	
}

// return objects in a different indexpath order. in this case we return object based on the section, not row, the default is row
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
	return [self.objects objectAtIndex:indexPath.section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	static NSString *CellIdentifier = @"SectionHeaderCell";
	UITableViewCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	PFImageView *profileImageView = (PFImageView *)[sectionHeaderView viewWithTag:1];
	UILabel *userNameLabel = (UILabel *)[sectionHeaderView viewWithTag:2];
	UILabel *titleLabel = (UILabel *)[sectionHeaderView viewWithTag:3];
	
	PFObject *photo = [self.objects objectAtIndex:section];
	PFUser *user = [photo objectForKey:@"whoTook"];
	PFFile *profilePicture = [user objectForKey:@"profilePicture"];
	NSString *title = photo[@"title"];
	
	userNameLabel.text = user.username;
	titleLabel.text = title;
	
	profileImageView.file = profilePicture;
	[profileImageView loadInBackground];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger sections = self.objects.count;
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
	static NSString *CellIdentifier = @"PhotoCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	PFImageView *photo = (PFImageView *)[cell viewWithTag:1];
	photo.file = object[@"image"];
	[photo loadInBackground];
	
	return cell;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (PFQuery *)queryForTable {
	
}*/

@end
