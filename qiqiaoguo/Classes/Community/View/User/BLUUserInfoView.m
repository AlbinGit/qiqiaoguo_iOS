//
//  BLUBaseUserInfoView.m
//  Blue
//
//  Created by Bowen on 13/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUUserInfoView.h"

@interface _BLUOtherUserInfoView: BLUUserInfoView

@end

@interface _BLUPersonalUserInfoView: BLUUserInfoView

@property (nonatomic, strong) UIButton *loginButton;

@end

@interface BLUUserInfoView ()

@end

@implementation BLUUserInfoView

+ (instancetype)userInfoViewWithType:(BLUUserInfoViewType)type {
    switch (type) {
        case BLUUserInfoViewOtherPeople: {
            return [_BLUOtherUserInfoView new];
        } break;
        case BLUUserInfoViewPersonal: {
            return [_BLUPersonalUserInfoView new];
        } break;
        default: {
            return [_BLUPersonalUserInfoView new];
        } break;
    }
}

- (instancetype)init {
    if (self = [super init]) {

        UIView *superview = self;

        _backgroundImageView = [UIImageView new];
        _backgroundImageView.backgroundColor = [UIColor clearColor];

        _avatarButton = [BLUAvatarButton new];
        _avatarButton.borderWidth = 0;

        _avatarBorderView = [UIView new];
        _avatarBorderView.borderColor = [UIColor colorWithWhite:1.0 alpha:0.25];
        _avatarBorderView.borderWidth = BLUThemeMargin;

//        _genderButtonBackgroundView = [UIView new];
//        _genderButtonBackgroundView.backgroundColor = [UIColor whiteColor];
//
//        _genderButton = [[BLUGenderButton alloc] initWithGenderButtonType:BLUGenderButtonTypeRoundRect];

        _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _nicknameLabel.textColor = [UIColor whiteColor];

//        _signatureLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
//        _signatureLabel.font = BLUThemeMainFontWithSize(14);
//        _signatureLabel.textColor = [UIColor colorFromHexString:@"ffbbba"];
//        _signatureLabel.numberOfLines = 2;
//        _signatureLabel.textAlignment = NSTextAlignmentCenter;

//        
//        UIFont *lvBtnTitleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall);
//        UIColor *vBtnTitleColor = [UIColor whiteColor];
//        _lvBackgroundImageView = [UIButton buttonWithType:UIButtonTypeCustom];
//        _lvBackgroundImageView.layer.borderWidth = 1.0;
////        _lvBackgroundImageView.title = [NSString stringWithFormat:@"LV%@", @(user.level)];
//        _lvBackgroundImageView.titleFont = lvBtnTitleFont;
//        _lvBackgroundImageView.titleColor = vBtnTitleColor;
//        _lvBackgroundImageView.contentEdgeInsets = UIEdgeInsetsMake(3,10, 3, 10);
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
//        _lvBackgroundImageView.layer.borderColor = borderColorRef;
//
//        
//        _lvLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
//        _lvLabel.textColor = [UIColor whiteColor];
//        _lvLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall);
//        _lvLabel.textAlignment = NSTextAlignmentCenter;
//
//        _coinBackgroundImageView = [UIButton new];
//        _coinBackgroundImageView.image = [UIImage imageNamed:@"user-coin-info"];
//        [_coinBackgroundImageView addTarget:self action:@selector(coinInfoAction:) forControlEvents:UIControlEventTouchUpInside];
//
//        _coinLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
//        _coinLabel.textColor = [UIColor whiteColor];
//        _coinLabel.font = _lvLabel.font;
//        _coinLabel.textAlignment = NSTextAlignmentCenter;

        _horizonSeparator = [BLUSolidLine new];
        _verticalSeparator1 = [BLUSolidLine new];
        _verticalSeparator2 = [BLUSolidLine new];
        _verticalSeparator3 = [BLUSolidLine new];
        UIColor *separatorColor = [UIColor colorWithWhite:1.0 alpha:0.5];

        _horizonSeparator.backgroundColor = separatorColor;
        _verticalSeparator1.backgroundColor = separatorColor;
        _verticalSeparator2.backgroundColor = separatorColor;
        _verticalSeparator3.backgroundColor = separatorColor;

        UIFont *buttonTitleFont = BLUThemeMainFontWithSize(12);
        UIColor *buttonTitleColor = [UIColor whiteColor];
        _followImageButton = [UIButton new];
        [_followImageButton addTarget:self action:@selector(followOrUnfollowAction:) forControlEvents:UIControlEventTouchUpInside];

        _followTitleButton = [UIButton new];
        _followTitleButton.titleFont = buttonTitleFont;
        _followTitleButton.titleColor = buttonTitleColor;
        [_followTitleButton addTarget:self action:@selector(followOrUnfollowAction:) forControlEvents:UIControlEventTouchUpInside];

        _followingCountButton = [UIButton new];
        _followingCountButton.titleFont = BLUThemeMainFontWithSize(28);
        _followingCountButton.titleColor = buttonTitleColor;
        [_followingCountButton addTarget:self action:@selector(showFollowingsAction:) forControlEvents:UIControlEventTouchUpInside];

        _followingbutton = [UIButton new];
        _followingbutton.titleFont = buttonTitleFont;
        _followingbutton.titleColor = buttonTitleColor;
        _followingbutton.title = NSLocalizedString(@"user-info-view.following-button.title", @"Following");
        [_followingbutton addTarget:self action:@selector(showFollowingsAction:) forControlEvents:UIControlEventTouchUpInside];

        _followerCountButton = [UIButton new];
        _followerCountButton.titleFont = _followingCountButton.titleFont;
        _followerCountButton.titleColor = _followingCountButton.titleColor;
        [_followerCountButton addTarget:self action:@selector(showFollowersAction:) forControlEvents:UIControlEventTouchUpInside];

        _followerButton = [UIButton new];
        _followerButton.titleFont = _followingbutton.titleFont;
        _followerButton.titleColor = _followingbutton.titleColor;
        _followerButton.title = NSLocalizedString(@"user-info-view.foller-button.title", @"Follower");
        [_followerButton addTarget:self action:@selector(showFollowersAction:) forControlEvents:UIControlEventTouchUpInside];

        _settingButton = [UIButton new];
        _settingButton.titleEdgeInsets = UIEdgeInsetsMake(0, BLUThemeMargin * 2, 0, 0);
        _settingButton.titleFont = _nicknameLabel.font;
        _settingButton.title = NSLocalizedString(@"user-info-view.setting-button.title", @"Edit");
        _settingButton.image = [UIImage imageNamed:@"user-setting"];
        [_settingButton addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];

        _messageImageButton = [UIButton new];
        _messageImageButton.image = [UIImage imageNamed:@"user-private-message"];
        [_messageImageButton addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];

        _messageTitleButton = [UIButton new];
        _messageTitleButton.titleFont = buttonTitleFont;
        _messageTitleButton.titleColor = buttonTitleColor;
        _messageTitleButton.title = NSLocalizedString(@"user-info-view.message-title-button.title", @"Message");
        [_messageTitleButton addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];

        [superview addSubview:_backgroundImageView];
        [superview addSubview:_avatarBorderView];
        [superview addSubview:_avatarButton];
        [superview addSubview:_nicknameLabel];
//        [superview addSubview:_genderButtonBackgroundView];
//        [superview addSubview:_genderButton];
//        [superview addSubview:_lvBackgroundImageView];
//        [superview addSubview:_lvLabel];
//        [superview addSubview:_coinBackgroundImageView];
//        [superview addSubview:_coinLabel];
//        [superview addSubview:_signatureLabel];
        [superview addSubview:_horizonSeparator];
        [superview addSubview:_verticalSeparator1];
        [superview addSubview:_verticalSeparator2];
        [superview addSubview:_verticalSeparator3];
        [superview addSubview:_followImageButton];
        [superview addSubview:_followTitleButton];
        [superview addSubview:_followingCountButton];
        [superview addSubview:_followingbutton];
        [superview addSubview:_followerCountButton];
        [superview addSubview:_followerButton];
        [superview addSubview:_settingImageButton];
        [superview addSubview:_settingButton];
        [superview addSubview:_messageImageButton];
        [superview addSubview:_messageTitleButton];

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize avatarButtonSize = CGSizeMake(92, 92);
//    CGSize genderButtonSize = CGSizeMake(18, 18);
    CGFloat contentWidth = self.width - BLUThemeMargin * 12;

    _backgroundImageView.frame = self.bounds;

    _avatarButton.y = BLUThemeMargin * 10;
    _avatarButton.size = avatarButtonSize;
    _avatarButton.centerX = self.centerX;
    _avatarButton.cornerRadius = _avatarButton.height / 2;

    _avatarBorderView.size = CGSizeMake(avatarButtonSize.width + BLUThemeMargin * 2, avatarButtonSize.height + BLUThemeMargin * 2);
    _avatarBorderView.centerX = _avatarButton.centerX;
    _avatarBorderView.centerY = _avatarButton.centerY;
    _avatarBorderView.cornerRadius = _avatarBorderView.height / 2;

//    _genderButton.size = genderButtonSize;
//    _genderButton.centerX = self.centerX;
//    _genderButton.centerY = _avatarButton.bottom;
//    _genderButton.cornerRadius = _genderButton.height / 2;
//    _genderButton.backgroundColor = [UIColor whiteColor];
//
//    _genderButtonBackgroundView.width = _genderButton.width + BLUThemeMargin / 2.0;
//    _genderButtonBackgroundView.height = _genderButton.height + BLUThemeMargin / 2.0;
//    _genderButtonBackgroundView.centerX = _genderButton.centerX;
//    _genderButtonBackgroundView.centerY = _genderButton.centerY;
//    _genderButtonBackgroundView.cornerRadius = _genderButtonBackgroundView.height / 2.0;

    [_nicknameLabel sizeToFit];
    _nicknameLabel.y = _avatarButton.bottom + BLUThemeMargin * 2;
    _nicknameLabel.width = _nicknameLabel.width < contentWidth ? _nicknameLabel.width : contentWidth;
    _nicknameLabel.centerX = self.centerX;
//
//    [_lvBackgroundImageView sizeToFit];
//    _lvBackgroundImageView.centerX = self.centerX;
//    _lvBackgroundImageView.y = _nicknameLabel.bottom + BLUThemeMargin * 3;
//    _lvBackgroundImageView.layer.cornerRadius = _lvBackgroundImageView.height/2;
//
//    [_lvLabel sizeToFit];
//    _lvLabel.x = _lvBackgroundImageView.x + _lvBackgroundImageView.height;
//    _lvLabel.width = _lvBackgroundImageView.width - _lvBackgroundImageView.height;
//    _lvLabel.centerY = _lvBackgroundImageView.centerY;
//

//    CGSize signatureLabelSize = [_signatureLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
//    _signatureLabel.size = signatureLabelSize;
//    _signatureLabel.centerX = self.centerX;
//    _signatureLabel.y = _nicknameLabel.bottom + BLUThemeMargin * 3;

    _horizonSeparator.width = self.width;
    _horizonSeparator.x = 0;
    _horizonSeparator.y = _nicknameLabel.bottom + BLUThemeMargin * 4;
    _horizonSeparator.height = 1 / [UIScreen mainScreen].scale;
    
    
//    [_coinBackgroundImageView sizeToFit];
//    _coinBackgroundImageView.x = self.width - _coinBackgroundImageView.width;
//    _coinBackgroundImageView.y = _lvBackgroundImageView.bottom + BLUThemeMargin * 2.5;
//    
//    [_coinLabel sizeToFit];
//    _coinLabel.x = _coinBackgroundImageView.x + _coinBackgroundImageView.height;
//    _coinLabel.width = _coinBackgroundImageView.width - _coinBackgroundImageView.height;
//    _coinLabel.centerY = _coinBackgroundImageView.centerY;

}

- (void)setUser:(BLUUser *)user {
    _user = user;
    if ([user isDefaultUser]) {
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@%@",@" ",user.nickname];
//        self.avatarButton.image = [UIImage imageNamed:@"user_default_icon"];
//        self.signatureLabel.hidden = YES;
//        self.genderButton.hidden = YES;
//        self.genderButtonBackgroundView.hidden = YES;
    } else {
        if (user.nickname == nil) {
            self.nicknameLabel.text = [NSString stringWithFormat:@"%@",@" "];
        }else
        {
            self.nicknameLabel.text = [NSString stringWithFormat:@"%@",user.nickname];
        }
        
//        self.genderButton.gender = user.gender;
//        self.signatureLabel.text = user.signatureDesc;
        self.avatarButton.user = user;
//        self.signatureLabel.hidden = NO;
//        self.genderButton.hidden = NO;
//        self.genderButtonBackgroundView.hidden = NO;
//        self.lvBackgroundImageView.title = [NSString stringWithFormat:@"LV%@", @(user.level)];
//        self.lvLabel.text = [NSString stringWithFormat:@"LV%@", @(user.level)];
//        self.coinLabel.text = @(user.coin).description;
        self.followingCountButton.title = @(user.followingCount).description;
        self.followerCountButton.title = @(user.followerCount).description;
        if (user.didFollow) {
            self.followImageButton.image = [UIImage imageNamed:@"user-followed"];
            self.followTitleButton.title = NSLocalizedString(@"user-info-view.follow-title-button.title.unfollow", @"Unfollow");
        } else {
            self.followImageButton.image = [UIImage imageNamed:@"user-unfollowed"];
            self.followTitleButton.title = NSLocalizedString(@"user-info-view.follow-title-button.title.follow", @"follow");
        }

        BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
        BOOL messageEnable = currentUser.userID != user.userID;
        self.messageTitleButton.enabled = messageEnable;
        self.messageImageButton.enabled = messageEnable;

        BOOL followingEnable = user.followingCount > 0;
        self.followingCountButton.enabled = followingEnable;
        self.followingbutton.enabled = followingEnable;

        BOOL followerEnable = user.followerCount > 0;
        self.followerCountButton.enabled = followerEnable;
        self.followerButton.enabled = followerEnable;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)followOrUnfollowAction:(id)sender {
    if (self.user.didFollow) {
        if ([self.delegate respondsToSelector:@selector(shouldUnfollowUser:fromUserInfoView:)]) {
            [self.delegate shouldUnfollowUser:self.user fromUserInfoView:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(shouldFollowUser:fromUserInfoView:)]) {
            [self.delegate shouldFollowUser:self.user fromUserInfoView:self];
        }
    }
}

- (void)showFollowingsAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shouldShowFollowingsFromUserInfoView:)]) {
        [self.delegate shouldShowFollowingsFromUserInfoView:self];
    }
}

- (void)showFollowersAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shouldShowFollowersFromUserInfoView:)]) {
        [self.delegate shouldShowFollowersFromUserInfoView:self];
    }
}

- (void)chatAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shouldChatWithUser:fromUserInfoView:)]) {
        [self.delegate shouldChatWithUser:self.user fromUserInfoView:self];
    }
}

- (void)settingAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shouldSettingUesrInfoFromUserInfoView:)]) {
        [self.delegate shouldSettingUesrInfoFromUserInfoView:self];
    }
}

- (void)levelInfoAction:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(shouldShowLevelInfoFromUserInfoView:)]) {
        [self.delegate shouldShowLevelInfoFromUserInfoView:self];
    }
}

- (void)coinInfoAction:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(shouldShowCoinInfoFromUserInfoView:)]) {
        [self.delegate shouldShowCoinInfoFromUserInfoView:self];
    }
}

@end

@implementation _BLUOtherUserInfoView

- (void)setUser:(BLUUser *)user {
    [super setUser:user];
//    self.lvBackgroundImageView.enabled = NO;
//    self.lvBackgroundImageView.userInteractionEnabled = NO;
//    self.coinBackgroundImageView.enabled = NO;
//    self.coinBackgroundImageView.userInteractionEnabled = NO;
//    self.coinBackgroundImageView.hidden = YES;
//    self.coinLabel.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.followingCountButton sizeToFit];
    self.followerCountButton.width = self.width / 4 - BLUThemeMargin * 2;
    self.followingCountButton.y = self.horizonSeparator.bottom + BLUThemeMargin * 0.2 - BLUThemeMargin;
    self.followingCountButton.centerX = self.width / 8 * 3;

    [self.followingbutton sizeToFit];
    CGFloat followingButtonMaxWidth = self.width / 4 - BLUThemeMargin * 2;
    self.followingbutton.width = self.followingbutton.width < followingButtonMaxWidth ? self.followingbutton.width : followingButtonMaxWidth;
    self.followingbutton.y = self.followingCountButton.bottom - BLUThemeMargin * 4;
    self.followingbutton.centerX = self.followingCountButton.centerX;

    self.verticalSeparator1.x = self.width / 4;
    self.verticalSeparator1.height = self.followingbutton.bottom - self.followingCountButton.y - BLUThemeMargin * 4;
    self.verticalSeparator1.width = 1 / [UIScreen mainScreen].scale;
    self.verticalSeparator1.centerY = (self.height - self.horizonSeparator.bottom) / 2.0 + self.horizonSeparator.bottom;

    [self.followerCountButton sizeToFit];
    self.followerCountButton.width = self.width / 4 - BLUThemeMargin * 2;
    self.followerCountButton.y = self.followingCountButton.y;
    self.followerCountButton.centerX = self.width / 8 * 5;

    [self.followerButton sizeToFit];
    CGFloat followerButtonMaxWidth = followingButtonMaxWidth;
    self.followerButton.width = self.followerButton.width < followerButtonMaxWidth ? self.followerButton.width : followerButtonMaxWidth;
    self.followerButton.y = self.followingbutton.y;
    self.followerButton.centerX = self.followerCountButton.centerX;

    self.verticalSeparator2.x = self.width / 4 * 2;
    self.verticalSeparator2.height = self.verticalSeparator1.height;
    self.verticalSeparator2.width = 1 / [UIScreen mainScreen].scale;
    self.verticalSeparator2.centerY = self.verticalSeparator1.centerY;

    self.verticalSeparator3.x = self.width / 4 * 3;
    self.verticalSeparator3.height = self.verticalSeparator1.height;
    self.verticalSeparator3.width = 1 / [UIScreen mainScreen].scale;
    self.verticalSeparator3.centerY = self.verticalSeparator1.centerY;

    [self.followImageButton sizeToFit];
    self.followImageButton.centerX = self.width / 8;
    self.followImageButton.centerY = self.followingCountButton.centerY;

    [self.followTitleButton sizeToFit];
    CGFloat followTitleButtonMaxWidth = self.width / 4 - BLUThemeMargin * 2;
    self.followTitleButton.width = self.followTitleButton.width < followTitleButtonMaxWidth ? self.followTitleButton.width : followTitleButtonMaxWidth;
    self.followTitleButton.y = self.followingbutton.y;
    self.followTitleButton.centerX = self.followImageButton.centerX;

    [self.messageImageButton sizeToFit];
    self.messageImageButton.centerX = self.width / 8 * 7;
    self.messageImageButton.centerY = self.followImageButton.centerY;

    [self.messageTitleButton sizeToFit];
    CGFloat messageTitleButtonMaxWidth = self.width / 4 - BLUThemeMargin * 2;
    self.messageTitleButton.width = self.messageTitleButton.width < messageTitleButtonMaxWidth ? self.messageTitleButton.width : messageTitleButtonMaxWidth;
    self.messageTitleButton.y = self.followingbutton.y;
    self.messageTitleButton.centerX = self.messageImageButton.centerX;
}

@end


@implementation _BLUPersonalUserInfoView

- (instancetype)init {
    if (self = [super init]) {
        self.loginButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
        self.loginButton.cornerRadius = BLUThemeHighActivityCornerRadius;
        self.loginButton.titleColor = [UIColor whiteColor];
        self.loginButton.titleFont = self.nicknameLabel.font;
        self.loginButton.borderColor = [UIColor whiteColor];
        self.loginButton.borderWidth = 1;
        self.loginButton.title = NSLocalizedString(@"user-info-view.logint-button.title", @"Login/Register");
        self.loginButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin * 3, BLUThemeMargin * 8, BLUThemeMargin * 3, BLUThemeMargin * 8);
        [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.loginButton];
        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.followingCountButton sizeToFit];
    self.followerCountButton.width = self.width / 4 - BLUThemeMargin * 2;
    self.followingCountButton.y = self.horizonSeparator.bottom + BLUThemeMargin * 0.2 - BLUThemeMargin;
    self.followingCountButton.centerX = self.width / 8;

    [self.followingbutton sizeToFit];
    CGFloat followingButtonMaxWidth = self.width / 4 - BLUThemeMargin * 2;
    self.followingbutton.width = self.followingbutton.width < followingButtonMaxWidth ? self.followingbutton.width : followingButtonMaxWidth;
    self.followingbutton.y = self.followingCountButton.bottom - BLUThemeMargin * 4;
    self.followingbutton.centerX = self.followingCountButton.centerX;

    self.verticalSeparator1.x = self.width / 4;
    self.verticalSeparator1.height = self.followingbutton.bottom - self.followingCountButton.y - BLUThemeMargin * 4;
    self.verticalSeparator1.width = 1 / [UIScreen mainScreen].scale;
    self.verticalSeparator1.centerY = (self.height - self.horizonSeparator.bottom) / 2.0 + self.horizonSeparator.bottom;

    [self.followerCountButton sizeToFit];
    self.followerCountButton.width = self.width / 4 - BLUThemeMargin * 2;
    self.followerCountButton.y = self.followingCountButton.y;
    self.followerCountButton.centerX = self.width / 8 * 3;

    [self.followerButton sizeToFit];
    CGFloat followerButtonMaxWidth = followingButtonMaxWidth;
    self.followerButton.width = self.followerButton.width < followerButtonMaxWidth ? self.followerButton.width : followerButtonMaxWidth;
    self.followerButton.y = self.followingbutton.y;
    self.followerButton.centerX = self.followerCountButton.centerX;

    self.verticalSeparator2.x = self.width / 4 * 2;
    self.verticalSeparator2.height = self.verticalSeparator1.height;
    self.verticalSeparator2.width = 1 / [UIScreen mainScreen].scale;
    self.verticalSeparator2.centerY = self.verticalSeparator1.centerY;

    [self.settingButton sizeToFit];
    self.settingButton.width = self.settingButton.width < self.settingButton.width ? self.settingButton.width : (self.width / 2 - BLUThemeMargin * 2);
    self.settingButton.centerX = self.width / 4 * 3;
    self.settingButton.centerY = self.verticalSeparator2.centerY;

    [self.loginButton sizeToFit];
    self.loginButton.y = self.nicknameLabel.bottom + 40;
    self.loginButton.centerX = self.nicknameLabel.centerX;
}

- (void)setUser:(BLUUser *)user {
    [super setUser:user];
    BOOL showUserInfo = [user isDefaultUser] ? YES : NO;
    BOOL showLoginButton = [user isDefaultUser] ? NO: YES;

    self.followingCountButton.hidden = showUserInfo;
    self.followingbutton.hidden = showUserInfo;
    self.verticalSeparator1.hidden = showUserInfo;
    self.followerButton.hidden = showUserInfo;
    self.followerCountButton.hidden = showUserInfo;
    self.verticalSeparator2.hidden = showUserInfo;
    self.verticalSeparator3.hidden = showUserInfo;
    self.settingButton.hidden = showUserInfo;
    self.horizonSeparator.hidden = showUserInfo;
    self.signatureLabel.hidden = showUserInfo;
    self.lvLabel.hidden = showUserInfo;
    self.lvBackgroundImageView.hidden = showUserInfo;
    self.coinLabel.hidden = showUserInfo;
    self.coinBackgroundImageView.hidden = showUserInfo;

    self.loginButton.hidden = showLoginButton;

    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self setNeedsDisplay];
}

- (void)loginAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shouldLoginFromUserInfoView:)]) {
        [self.delegate shouldLoginFromUserInfoView:self];
    }
}

@end

