//
//  QGUserInfoView.h
//  LongForTianjie
//
//  Created by cws on 16/4/22.
//  Copyright © 2016年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUAvatarButton.h"

typedef NS_ENUM(NSInteger, QGUserInfoViewType) {
    QGUserInfoViewPersonal = 0,
    QGUserInfoViewOtherPeople,
};

@class QGUserInfoView;

@protocol QGUserInfoViewDelegate <NSObject>

@optional
- (void)shouldSignActionfromUserInfoView:(QGUserInfoView *)userInfoView;
- (void)shouldUnfollowUser:(BLUUser *)user fromUserInfoView:(QGUserInfoView *)userInfoView;
- (void)shouldChatWithUser:(BLUUser *)user fromUserInfoView:(QGUserInfoView *)userInfoView;
- (void)shouldSettingUesrInfoFromUserInfoView:(QGUserInfoView *)userInfoView;
- (void)shouldLoginFromUserInfoView:(QGUserInfoView *)userInfoView;

@required
- (void)shouldShowFollowingsFromUserInfoView:(QGUserInfoView *)userInfoView;
- (void)shouldShowFollowersFromUserInfoView:(QGUserInfoView *)userInfoView;
//- (void)shouldShowCoinInfoFromUserInfoView:(QGUserInfoView *)userInfoView;
//- (void)shouldShowLevelInfoFromUserInfoView:(QGUserInfoView *)userInfoView;
- (void)shouldShowNewsFromUserInfoView:(QGUserInfoView *)userInfoView;


@end
@interface QGUserInfoView : UIView
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
@property (nonatomic, strong) UIButton *newsButton;
@property (nonatomic, strong) UIButton *newsRedLabel;
@property (nonatomic, strong) UIButton *MessageCenterButton;

@property (nonatomic, strong) BLUSolidLine *horizonSeparator;
@property (nonatomic, strong) BLUSolidLine *verticalSeparator1;
@property (nonatomic, strong) BLUSolidLine *verticalSeparator2;
@property (nonatomic, strong) BLUSolidLine *verticalSeparator3;
@property (nonatomic, strong) UIButton *signImageButton;
@property (nonatomic, strong) UIButton *signTitleButton;
@property (nonatomic, strong) UIButton *followingCountButton;
@property (nonatomic, strong) UIButton *followingbutton;
@property (nonatomic, strong) UIButton *followerCountButton;
@property (nonatomic, strong) UIButton *followerButton;
@property (nonatomic, strong) UIButton *settingImageButton;
@property (nonatomic, strong) UIButton *settingTitleButton;
@property (nonatomic, strong) UIButton *messageImageButton;
@property (nonatomic, strong) UIButton *messageTitleButton;
@property (nonatomic, strong) UIImageView *whiteShadowImageView;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, assign) NSInteger MeassageCount;

@property (nonatomic, weak) id <QGUserInfoViewDelegate> delegate;


@end
