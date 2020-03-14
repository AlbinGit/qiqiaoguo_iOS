//
//  QGUserInfoView.m
//  LongForTianjie
//
//  Created by cws on 16/4/22.
//  Copyright © 2016年 platomix. All rights reserved.
//

#import "QGUserInfoView.h"
@interface QGUserInfoView ()
@property (nonatomic, strong)UIButton * messeageLab;
@end
@implementation QGUserInfoView

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
        
        _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _nicknameLabel.textColor = [UIColor whiteColor];
        
        _signatureLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _signatureLabel.font = BLUThemeMainFontWithSize(14);
        _signatureLabel.textColor = [UIColor colorFromHexString:@"ffbbba"];
        _signatureLabel.numberOfLines = 2;
        _signatureLabel.textAlignment = NSTextAlignmentCenter;
        
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
        _signImageButton = [UIButton new];
        _signImageButton.image = [UIImage imageNamed:@"user-sign"];
        [_signImageButton setImage:[UIImage imageNamed:@"user-sign-finish"] forState:UIControlStateDisabled];
        [_signImageButton addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _signTitleButton = [UIButton new];
        _signTitleButton.titleFont = buttonTitleFont;
        _signTitleButton.titleColor = buttonTitleColor;
        _signTitleButton.title = @"签到";
        [_signTitleButton setTitle:@"已签到" forState:UIControlStateDisabled];
        [_signTitleButton addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        _settingImageButton = [UIButton new];
        _settingImageButton.image = [UIImage imageNamed:@"user-setting-1"];
        [_settingImageButton addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _settingTitleButton = [UIButton new];
        _settingTitleButton.titleFont = buttonTitleFont;
        _settingTitleButton.titleColor = buttonTitleColor;
        _settingTitleButton.title = @"设置";
        [_settingTitleButton addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _newsButton = [UIButton new];
        _newsButton.image = [UIImage imageNamed:@"message_icon"];
        [_newsButton addTarget:self action:@selector(newsAction) forControlEvents:UIControlEventTouchUpInside];
        _messeageLab = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 15, 15)];
        _messeageLab.cornerRadius = _messeageLab.height/2;
        _messeageLab.backgroundColor = [UIColor redColor];
        _messeageLab.titleFont = [UIFont systemFontOfSize:10];
        [_messeageLab addTarget:self action:@selector(newsAction) forControlEvents:UIControlEventTouchUpInside];
        _messeageLab.hidden = YES;
        [_newsButton addSubview:_messeageLab];
        _newsButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        
        _MessageCenterButton = [UIButton new];
        [_MessageCenterButton addTarget:self action:@selector(newsAction) forControlEvents:UIControlEventTouchUpInside];

        
        _loginButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
        _loginButton.cornerRadius = BLUThemeHighActivityCornerRadius;
        _loginButton.titleColor = [UIColor whiteColor];
        _loginButton.titleFont = self.nicknameLabel.font;
        _loginButton.borderColor = [UIColor whiteColor];
        _loginButton.borderWidth = 1;
        _loginButton.title = @"登录/注册";
        _loginButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin , BLUThemeMargin * 8, BLUThemeMargin , BLUThemeMargin * 8);
        [_loginButton addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.hidden = YES;
        
        [superview addSubview:_backgroundImageView];
        [superview addSubview:_avatarBorderView];
        [superview addSubview:_avatarButton];
        [superview addSubview:_newsButton];
        [superview addSubview:_nicknameLabel];
//        [superview addSubview:_coinBackgroundImageView];
//        [superview addSubview:_coinLabel];
        [superview addSubview:_horizonSeparator];
        [superview addSubview:_signImageButton];
        [superview addSubview:_signTitleButton];
        [superview addSubview:_followingCountButton];
        [superview addSubview:_followingbutton];
        [superview addSubview:_followerCountButton];
        [superview addSubview:_followerButton];
        [superview addSubview:_verticalSeparator1];
        [superview addSubview:_verticalSeparator2];
        [superview addSubview:_verticalSeparator3];
        [superview addSubview:_settingImageButton];
        [superview addSubview:_settingTitleButton];
        [superview addSubview:_loginButton];

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
    _backgroundImageView.userInteractionEnabled = YES;
    
    _avatarButton.y = BLUThemeMargin * 10;
    _avatarButton.size = avatarButtonSize;
    _avatarButton.centerX = self.centerX;
    _avatarButton.cornerRadius = _avatarButton.height / 2;
    
    _avatarBorderView.size = CGSizeMake(avatarButtonSize.width + BLUThemeMargin * 2, avatarButtonSize.height + BLUThemeMargin * 2);
    _avatarBorderView.centerX = _avatarButton.centerX;
    _avatarBorderView.centerY = _avatarButton.centerY;
    _avatarBorderView.cornerRadius = _avatarBorderView.height / 2;
    
    [_newsButton sizeToFit];
    _newsButton.y = _avatarButton.y - BLUThemeMargin ;
    _newsButton.x = self.width - _newsButton.width - BLUThemeMargin *4;
    
//    [_newsRedLabel sizeToFit];
//    _newsRedLabel.frame = CGRectMake(_newsButton.width - 8, 2, 8, 8);
//    _newsRedLabel.cornerRadius = _newsRedLabel.width/2;
    
    _MessageCenterButton.frame = _newsButton.frame;
    [self bringSubviewToFront:_messageImageButton];
    
    [_nicknameLabel sizeToFit];
    _nicknameLabel.y = _avatarButton.bottom + BLUThemeMargin * 3;
    _nicknameLabel.width = _nicknameLabel.width < contentWidth ? _nicknameLabel.width : contentWidth;
    _nicknameLabel.centerX = self.centerX;
    
    CGSize signatureLabelSize = [_signatureLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    _signatureLabel.size = signatureLabelSize;
    _signatureLabel.centerX = self.centerX;
    _signatureLabel.y = _nicknameLabel.bottom + BLUThemeMargin * 2;

    _horizonSeparator.width = self.width;
    _horizonSeparator.x = 0;
    _horizonSeparator.y = _nicknameLabel.bottom + BLUThemeMargin * 9;
    _horizonSeparator.height = 1 / [UIScreen mainScreen].scale;
    
    [self.followingCountButton sizeToFit];
    self.followerCountButton.width = self.width / 4 - BLUThemeMargin * 2;
    self.followingCountButton.y = self.horizonSeparator.bottom + BLUThemeMargin * 0.2 - BLUThemeMargin;
    self.followingCountButton.centerX = self.width / 8;
    
    [self.followingbutton sizeToFit];
    CGFloat followingButtonMaxWidth = self.width / 4 - BLUThemeMargin * 2;
    self.followingbutton.width = self.followingbutton.width < followingButtonMaxWidth ? self.followingbutton.width : followingButtonMaxWidth;
    self.followingbutton.y = self.followingCountButton.bottom - BLUThemeMargin * 4;
    self.followingbutton.centerX = self.followingCountButton.centerX;
    
    [self.followerCountButton sizeToFit];
    self.followerCountButton.width = self.width / 4 - BLUThemeMargin * 2;
    self.followerCountButton.y = self.followingCountButton.y;
    self.followerCountButton.centerX = self.width / 8 * 3;
    
    [self.followerButton sizeToFit];
    CGFloat followerButtonMaxWidth = followingButtonMaxWidth;
    self.followerButton.width = self.followerButton.width < followerButtonMaxWidth ? self.followerButton.width : followerButtonMaxWidth;
    self.followerButton.y = self.followingbutton.y;
    self.followerButton.centerX = self.followerCountButton.centerX;
    
    [self.signImageButton sizeToFit];
    self.signImageButton.centerX = self.width / 8 * 5;
    self.signImageButton.centerY = self.followingCountButton.centerY;
    
    [self.signTitleButton sizeToFit];
    CGFloat signTitleButtonMaxWidth = self.width / 4 - BLUThemeMargin * 2;
    self.signTitleButton.width = self.signTitleButton.width < signTitleButtonMaxWidth ? self.signTitleButton.width : signTitleButtonMaxWidth;
    self.signTitleButton.y = self.followingbutton.y;
    self.signTitleButton.centerX = self.signImageButton.centerX;
    
    [self.settingImageButton sizeToFit];
    self.settingImageButton.centerX = self.width / 8 * 7;
    self.settingImageButton.centerY = self.signImageButton.centerY;
    
    [self.settingTitleButton sizeToFit];
    CGFloat messageTitleButtonMaxWidth = self.width / 4 - BLUThemeMargin * 2;
    self.settingTitleButton.width = self.messageTitleButton.width < messageTitleButtonMaxWidth ? self.settingTitleButton.width : messageTitleButtonMaxWidth;
    self.settingTitleButton.y = self.followingbutton.y;
    self.settingTitleButton.centerX = self.settingImageButton.centerX;
    
    _verticalSeparator1.x = self.width / 4;
    _verticalSeparator1.height = self.followingbutton.bottom - self.followingCountButton.y - BLUThemeMargin * 4;
    _verticalSeparator1.width = 1 / [UIScreen mainScreen].scale;
    _verticalSeparator1.centerY = (self.height - _horizonSeparator.bottom) / 2.0 + _horizonSeparator.bottom;
    
    _verticalSeparator2.x = self.width / 4 * 2;
    _verticalSeparator2.height = self.verticalSeparator1.height;
    _verticalSeparator2.width = 1 / [UIScreen mainScreen].scale;
    _verticalSeparator2.centerY = self.verticalSeparator1.centerY;
    
    _verticalSeparator3.x = self.width / 4 * 3;
    _verticalSeparator3.height = self.verticalSeparator1.height;
    _verticalSeparator3.width = 1 / [UIScreen mainScreen].scale;
    _verticalSeparator3.centerY = self.verticalSeparator1.centerY;
    
    
    [_loginButton sizeToFit];
    _loginButton.centerY = _avatarButton.bottom + (_horizonSeparator.top - _avatarButton.bottom)/2;
    _loginButton.centerX = self.nicknameLabel.centerX;
}

- (void)setUser:(BLUUser *)user {
    _user = user;
    if (!user) {
        self.followingCountButton.title = @"0";
        self.followerCountButton.title = @"0";
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@%@",@" ",user.nickname];
        self.avatarButton.image = [UIImage imageNamed:@"user-logout-icon"];
        self.genderButton.hidden = YES;
        self.signatureLabel.hidden = YES;
        self.genderButtonBackgroundView.hidden = YES;
        self.nicknameLabel.hidden = YES;
        self.lvBackgroundImageView.hidden = YES;
        self.messeageLab.hidden = YES;
        if ([BLUAppManager sharedManager].currentUser) {
            self.loginButton.enabled = NO;
        }else
        {
            self.loginButton.enabled = YES;
        }
        self.loginButton.hidden = NO;
        

    } else {
        self.nicknameLabel.hidden = NO;
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@%@",@" ",user.nickname];
        self.signatureLabel.text = user.signatureDesc;
        self.avatarButton.user = user;
        self.signatureLabel.hidden = NO;
        
        self.signImageButton.enabled = !user.isCheckIn;
        self.signTitleButton.enabled = !user.isCheckIn;
        
        self.followingCountButton.title = @(user.followingCount).description;
        self.followerCountButton.title = @(user.followerCount).description;

//        BOOL followingEnable = user.followingCount > 0;
//        self.followingCountButton.enabled = followingEnable;
//        self.followingbutton.enabled = followingEnable;
        
//        BOOL followerEnable = user.followerCount > 0;
//        self.followerCountButton.enabled = followerEnable;
//        self.followerButton.enabled = followerEnable;

        self.loginButton.hidden = YES;
        



    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setMeassageCount:(NSInteger)MeassageCount{
    
    if (MeassageCount > 0) {
        self.messeageLab.hidden = NO;
        self.messeageLab.title = @(MeassageCount).stringValue;
    }else
    {
        self.messeageLab.hidden = YES;
    }
    
}

- (void)signAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(shouldSignActionfromUserInfoView:)]) {
        [self.delegate shouldSignActionfromUserInfoView:self];
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

//- (void)levelInfoAction:(UITapGestureRecognizer *)recognizer {
//    if ([self.delegate respondsToSelector:@selector(shouldShowLevelInfoFromUserInfoView:)]) {
//        [self.delegate shouldShowLevelInfoFromUserInfoView:self];
//    }
//}
//
//- (void)coinInfoAction:(UITapGestureRecognizer *)recognizer {
//    if ([self.delegate respondsToSelector:@selector(shouldShowCoinInfoFromUserInfoView:)]) {
//        [self.delegate shouldShowCoinInfoFromUserInfoView:self];
//    }
//}

- (void)loginBtnClick {
    if ([self.delegate respondsToSelector:@selector(shouldLoginFromUserInfoView:)]) {
        [self.delegate shouldLoginFromUserInfoView:self];
    }
}

- (void)newsAction
{
    if ([self.delegate respondsToSelector:@selector(shouldShowNewsFromUserInfoView:)]) {
        [self.delegate shouldShowNewsFromUserInfoView:self];
    }
}

@end
