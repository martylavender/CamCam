//
//  FollowButton.h
//  CamCam
//
//  Created by Marty Lavender on 7/22/15.
//  Copyright (c) 2015 Marty Lavender. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FollowButton;
@protocol FollowButtonDelegate

- (void) followButton:(FollowButton *)button didTapWithSectionIndex:(NSInteger)index;

@end

@interface FollowButton : UIButton

@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, weak) id <FollowButtonDelegate> delegate;

@end
