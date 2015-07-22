//
//  HomeViewController.h
//  CamCam
//
//  Created by Marty Lavender on 7/20/15.
//  Copyright (c) 2015 Marty Lavender. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "FollowButton.h"


@interface HomeViewController : PFQueryTableViewController <FollowButtonDelegate>

- (NSIndexPath *)_indexPathForPaginationCell;

@end
