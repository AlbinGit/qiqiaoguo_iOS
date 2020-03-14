//
//  BLUPostLikedUserCell.m
//  Blue
//
//  Created by Bowen on 4/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUPostLikedUserCell.h"

@implementation BLUPostLikedUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _cellInset = BLUThemeMargin * 4;
        _contentMargin = BLUThemeMargin * 2;
        _avatarSize = 54;

        _avatarButton = [BLUAvatarButton new];
        _avatarButton.backgroundColor = BLUThemeSubTintBackgroundColor;
        _avatarButton.userInteractionEnabled = NO;

        _nicknameLabel = [UILabel new];
        _nicknameLabel.textColor =
        [UIColor colorWithHue:0 saturation:0 brightness:0.17 alpha:1];
        _nicknameLabel.font =
        BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);

        _signatureLabel = [UILabel new];
        _signatureLabel.textColor =
        [UIColor colorWithHue:0 saturation:0 brightness:0.4 alpha:1];
        _signatureLabel.font =
        BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);

        _separator = [UIView new];
        _separator.backgroundColor = BLUThemeSubTintBackgroundColor;

        [self addSubview:_avatarButton];
        [self addSubview:_nicknameLabel];
        [self addSubview:_signatureLabel];
        [self addSubview:_separator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _avatarButton.frame =
    CGRectMake(_cellInset, _cellInset, _avatarSize, _avatarSize);
    _avatarButton.cornerRadius = _avatarButton.height / 2.0;

    CGFloat nicknameWidth =
    self.contentView.width - _avatarSize - _cellInset * 2 - _contentMargin;
    CGSize nicknameSize =
    [_nicknameLabel sizeThatFits:CGSizeMake(nicknameWidth, CGFLOAT_MAX)];

    _nicknameLabel.frame =
    CGRectMake(_avatarButton.right + _contentMargin,
               _avatarButton.top + _contentMargin,
               nicknameSize.width, nicknameSize.height);

    CGSize signatureSize =
    [_signatureLabel sizeThatFits:CGSizeMake(nicknameWidth, CGFLOAT_MAX)];
    _signatureLabel.frame =
    CGRectMake(_nicknameLabel.left,
               _avatarButton.bottom - _contentMargin - signatureSize.height,
               signatureSize.width, signatureSize.height);

    _separator.frame = CGRectMake(0, _avatarButton.bottom + _cellInset,
                            self.contentView.width, BLUThemeOnePixelHeight);

    self.cellSize =
    CGSizeMake(_separator.bottom,
               self.contentView.width);
}

- (void)setModel:(id)model {
    _user = (BLUUser *)model;
    BLUAssertObjectIsKindOfClass(_user, [BLUUser class]);
    if (!self.cellForCalcingSize) {
        _avatarButton.imageURL = _user.avatar.thumbnailURL;
    }

    _nicknameLabel.text = _user.nickname;

    _signatureLabel.text = _user.signature;
}

@end
