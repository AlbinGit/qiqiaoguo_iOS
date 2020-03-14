//
//  BLUUserSimpleCell.m
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserSimpleCell.h"

@implementation BLUUserSimpleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UIView *superview = self.contentView;

        _avatarButton = [BLUAvatarButton new];
        _avatarButton.userInteractionEnabled = NO;

        _genderButton = [BLUGenderButton new];

        _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];

        _signatureLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _signatureLabel.numberOfLines = 1;

        _separator = [BLUSolidLine new];
        _separator.backgroundColor = BLUThemeSubTintBackgroundColor;

        [superview addSubview:_avatarButton];
//        [superview addSubview:_genderButton];
        [superview addSubview:_nicknameLabel];
        [superview addSubview:_signatureLabel];
        [superview addSubview:_separator];

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_nicknameLabel sizeToFit];
    [_signatureLabel sizeToFit];

    CGSize avatarButtonSize = CGSizeMake(48, 48);
    CGSize genderButtonSize = CGSizeMake(_nicknameLabel.height - BLUThemeMargin * 2, _nicknameLabel.height - BLUThemeMargin * 2);

    _avatarButton.x = BLUThemeMargin * 3;
    _avatarButton.y = BLUThemeMargin * 3;
    _avatarButton.size = avatarButtonSize;
    _avatarButton.cornerRadius = _avatarButton.height / 2;

    CGFloat maxTextWidth = self.contentView.width - _avatarButton.right - BLUThemeMargin * 7 - genderButtonSize.width;
    _nicknameLabel.x = _avatarButton.right + BLUThemeMargin * 2;
    _nicknameLabel.width = _nicknameLabel.width < maxTextWidth ? _nicknameLabel.width : maxTextWidth;

    _genderButton.x = _nicknameLabel.right + BLUThemeMargin * 2;
    _genderButton.size = genderButtonSize;

    _signatureLabel.x = _nicknameLabel.x;
    _signatureLabel.width = self.contentView.width - _avatarButton.right - BLUThemeMargin * 5;

    _nicknameLabel.y = _avatarButton.centerY - (_nicknameLabel.height + _signatureLabel.height + BLUThemeMargin * 2) / 2;
    _signatureLabel.y = _nicknameLabel.bottom + BLUThemeMargin * 2;
    _genderButton.y = _nicknameLabel.bottom - genderButtonSize.height - BLUThemeMargin;

    _separator.y = _avatarButton.bottom > _signatureLabel.bottom ? _avatarButton.bottom : _signatureLabel.bottom;
    _separator.y += BLUThemeMargin * 3;
    _separator.x = BLUThemeMargin * 2;
    _separator.width = self.contentView.width - BLUThemeMargin * 4;
    _separator.height = BLUThemeOnePixelHeight;

    self.cellSize = CGSizeMake(self.contentView.width, _separator.bottom);
}

- (void)setModel:(id)model {
    NSParameterAssert([model isKindOfClass:[BLUUser class]]);
    _user = (BLUUser *)model;

    _avatarButton.image = nil;
    if (!self.cellForCalcingSize) {
        _avatarButton.user = _user;
    }

    _genderButton.gender = _user.gender;

    _nicknameLabel.text = _user.nickname;
    _signatureLabel.text = _user.signatureDesc;
}

@end
