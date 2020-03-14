//
//  BLUUserSimpleInfoView.m
//  Blue
//
//  Created by Bowen on 12/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserSimpleInfoView.h"

@implementation BLUUserSimpleInfoView

- (instancetype)init {
    if (self = [super init]) {

        self.backgroundColor = BLUThemeSubTintBackgroundColor;

        _backgroundImageView = [UIImageView new];
        _backgroundImageView.backgroundColor = [UIColor randomColor];
        _backgroundImageView.image = [UIImage imageNamed:@"user-simple-info-bkg"];

        _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _nicknameLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVeryLarge);
        _nicknameLabel.textColor = [UIColor whiteColor];

        _avatarButton = [BLUAvatarButton new];
        _avatarButton.backgroundColor = BLUThemeSubTintBackgroundColor;

        _avatarBackgroundView = [UIView new];
        _avatarBackgroundView.backgroundColor = BLUThemeSubTintBackgroundColor;

        [self addSubview:_backgroundImageView];
        [self addSubview:_nicknameLabel];
        [self addSubview:_avatarBackgroundView];
        [self addSubview:_avatarButton];

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _backgroundImageView.frame = self.bounds;

    [_nicknameLabel sizeToFit];
    CGFloat nicknameLabelMaxWidth = self.width - BLUThemeMargin * 8;
    _nicknameLabel.width =
    _nicknameLabel.width < nicknameLabelMaxWidth ?
    _nicknameLabel.width : nicknameLabelMaxWidth;
    _nicknameLabel.centerX = self.centerX;
    _nicknameLabel.y = BLUThemeMargin * 8;

    CGSize avatarButtonSize = CGSizeMake(68, 68);
    _avatarButton.size = avatarButtonSize;
    _avatarButton.cornerRadius = _avatarButton.height / 2.0 + 0.01;
    _avatarButton.centerX = self.centerX;
    _avatarButton.y = self.height - _avatarButton.height;

    CGSize avatarBackgroundViewSize = CGSizeMake(76, 76);
    _avatarBackgroundView.size = avatarBackgroundViewSize;
    _avatarBackgroundView.centerX = _avatarButton.centerX;
    _avatarBackgroundView.centerY = _avatarButton.centerY;
    _avatarBackgroundView.cornerRadius = _avatarBackgroundView.height / 2.0;

    _backgroundImageView.height = self.height - _avatarButton.height / 2;

}

- (void)setUser:(BLUUser *)user {
    _user = user;
    _nicknameLabel.text = user.nickname;
    _avatarButton.user = user;
}

+ (CGFloat)userSimpleInfoViewHeight {
    return 200;
}

@end
