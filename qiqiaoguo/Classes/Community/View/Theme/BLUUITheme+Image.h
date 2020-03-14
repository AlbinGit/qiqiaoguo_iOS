//
//  BLUUITheme+Image.h
//  Blue
//
//  Created by Bowen on 15/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLUUIThemeImage <NSObject>

// Common
- (UIImage *)navBackIndicatorImage;
- (UIImage *)navBackIndicatorTransitionMaskImage;
- (UIImage *)timeIcon;
- (UIImage *)moreIcon;
- (UIImage *)qqIcon;
- (UIImage *)wechatIcon;
- (UIImage *)sinaIcon;
- (UIImage *)shareIcon;
- (UIImage *)appLogo;

// User
- (UIImage *)genderMaleImage;
- (UIImage *)genderFemaleImage;
- (UIImage *)anonymousAvatar;

- (UIImage *)closedEyeIcon;
- (UIImage *)openedEyeIcon;

- (UIImage *)userFemaleAvatarIcon;
- (UIImage *)userMaleAvatarIcon;
- (UIImage *)userAvatarWhiteShadow;

- (UIImage *)userFemaleRoundRect;
- (UIImage *)userMaleRoundRect;

- (UIImage *)userGenderDeselectedIcon;
- (UIImage *)userGenderSelectedIcon;

- (UIImage *)userSettingIndicatorIcon;

- (UIImage *)userPostIcon;
- (UIImage *)userCollectionIcon;
- (UIImage *)userJoinIcon;
- (UIImage *)userSettingIcon;

// Post
- (UIImage *)postCommentIcon;
- (UIImage *)postTimeIcon;
- (UIImage *)sendPostIcon;
- (UIImage *)postTakePhotoIcon;
- (UIImage *)postDeleteIcon;

- (UIImage *)postLikeIcon;
- (UIImage *)postDislikeIcon;
- (UIImage *)postLikeNormalIcon;
- (UIImage *)postDislikeNormalIcon;

- (UIImage *)postDeselectedImageIcon;
- (UIImage *)postSelectedImageIcon;
- (UIImage *)postDeselectedCircle;

- (UIImage *)postEmbossingLineIcon;
- (UIImage *)postLeftShadeIcon;
- (UIImage *)postRightShadeIcon;

- (UIImage *)postFeatureIcon;

- (UIImage *)postJustLooikngFirstfloorIcon;
- (UIImage *)postViewAllIcon;

- (UIImage *)postAddImageIcon;

- (UIImage *)postLZ;

- (UIImage *)postPlayVideo;
- (UIImage *)postPlayVideoSubscript;

- (UIImage *)postTop;

- (UIImage *)postNoCollection;
- (UIImage *)postNoParticipated;
- (UIImage *)postNoPost;

// Circle
- (UIImage *)circleAddPurpleIcon;
- (UIImage *)circlePostCountIcon;

// Tab
- (UIImage *)tabCircleNormalIcon;
- (UIImage *)tabCircleSelectedIcon;
- (UIImage *)tabHomeNormalIcon;
- (UIImage *)tabHomeSelectedIcon;
- (UIImage *)tabMeNormalIcon;
- (UIImage *)tabMeSelectedIcon;
- (UIImage *)tabMessageNormalIcon;
- (UIImage *)tabMessageSelectedIcon;

// Guide
- (UIImage *)guide1stImage;
- (UIImage *)guide2ndImage;
- (UIImage *)guide3rdImage;
- (UIImage *)guide4thImage;

@end
