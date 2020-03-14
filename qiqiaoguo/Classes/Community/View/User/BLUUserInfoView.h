//
//  BLUBaseUserInfoView.h
//  Blue
//
//  Created by Bowen on 13/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUAvatarButton.h"

typedef NS_ENUM(NSInteger, BLUUserInfoViewType) {
    BLUUserInfoViewPersonal = 0,
    BLUUserInfoViewOtherPeople,
};

@class BLUUserInfoView;

@protocol BLUUserInfoViewDelegate <NSObject>

@optional
- (void)shouldFollowUser:(BLUUser *)user fromUserInfoView:(BLUUserInfoView *)userInfoView;
- (void)shouldUnfollowUser:(BLUUser *)user fromUserInfoView:(BLUUserInfoView *)userInfoView;
- (void)shouldChatWithUser:(BLUUser *)user fromUserInfoView:(BLUUserInfoView *)userInfoView;
- (void)shouldSettingUesrInfoFromUserInfoView:(BLUUserInfoView *)userInfoView;
- (void)shouldLoginFromUserInfoView:(BLUUserInfoView *)userInfoView;

@required
- (void)shouldShowFollowingsFromUserInfoView:(BLUUserInfoView *)userInfoView;
- (void)shouldShowFollowersFromUserInfoView:(BLUUserInfoView *)userInfoView;
- (void)shouldShowCoinInfoFromUserInfoView:(BLUUserInfoView *)userInfoView;
- (void)shouldShowLevelInfoFromUserInfoView:(BLUUserInfoView *)userInfoView;

@end

@interface BLUUserInfoView : UIView

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, copy) BLUUser *user;
@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UIView *avatarBorderView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) BLUGenderButton *genderButton;
@property (nonatomic, strong) UIView *genderButtonBackgroundView;
@property (nonatomic, strong) UILabel *lvLabel;
@property (nonatomic, strong) UIButton *lvBackgroundImageView;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UIButton *coinBackgroundImageView;
@property (nonatomic, strong) UILabel *signatureLabel;

@property (nonatomic, strong) BLUSolidLine *horizonSeparator;
@property (nonatomic, strong) BLUSolidLine *verticalSeparator1;
@property (nonatomic, strong) BLUSolidLine *verticalSeparator2;
@property (nonatomic, strong) BLUSolidLine *verticalSeparator3;
@property (nonatomic, strong) UIButton *followImageButton;
@property (nonatomic, strong) UIButton *followTitleButton;
@property (nonatomic, strong) UIButton *followingCountButton;
@property (nonatomic, strong) UIButton *followingbutton;
@property (nonatomic, strong) UIButton *followerCountButton;
@property (nonatomic, strong) UIButton *followerButton;
@property (nonatomic, strong) UIButton *settingImageButton;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIButton *messageImageButton;
@property (nonatomic, strong) UIButton *messageTitleButton;
@property (nonatomic, strong) UIImageView *whiteShadowImageView;

@property (nonatomic, weak) id <BLUUserInfoViewDelegate> delegate;

+ (instancetype)userInfoViewWithType:(BLUUserInfoViewType)type;

@end
