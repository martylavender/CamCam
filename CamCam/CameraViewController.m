//
//  CameraViewController.m
//  CamCam
//
//  Created by Marty Lavender on 7/21/15.
//  Copyright (c) 2015 Marty Lavender. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>

@interface CameraViewController ()

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (strong, nonatomic) IBOutlet UITextField *imageTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)shareButton:(id)sender;
- (IBAction)addButton:(id)sender;

@end

@implementation CameraViewController

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

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self clear];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
	self.imageView.image = chosenImage;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:NO completion:nil];
	[self.tabBarController setSelectedIndex:0];
}

- (void)clear {
	self.imageView.image = nil;
	self.imageTitle.text = nil;
}

- (IBAction)shareButton:(id)sender {
	if (self.imageView.image) {
		NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
		PFFile *photoFile = [PFFile fileWithData:imageData];
		PFObject *photo = [PFObject objectWithClassName:@"Photo"];
		photo[@"image"] = photoFile;
		photo[@"whoTook"] = [PFUser currentUser];
		photo[@"title"] = self.imageTitle.text;
		[photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (!succeeded) {
				[self showError];
			}
		}];
	}
	else {
		[self showError];
	}
	[self clear];
	[self.tabBarController setSelectedIndex:0];
}

- (IBAction)addButton:(id)sender {
	self.imagePicker = [[UIImagePickerController alloc] init];
	self.imagePicker.delegate = self;
	self.imagePicker.allowsEditing = YES;
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	else {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	self.imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
	[self presentViewController:self.imagePicker animated:NO completion:nil];
}

- (void)showError {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not post your photo, please give it another go" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
	[alert show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.imageTitle resignFirstResponder];
}







@end
