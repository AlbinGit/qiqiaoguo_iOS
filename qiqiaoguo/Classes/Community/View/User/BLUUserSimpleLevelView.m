//
//  BLUUserSimpleLevelView.m
//  Blue
//
//  Created by Bowen on 12/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserSimpleLevelView.h"

@implementation BLUUserSimpleLevelView

- (instancetype)init {
    if (self = [super init]) {

        _levelImageView = [UIImageView new];
        _levelImageView.image = [UIImage imageNamed:@"user-level-white"];

        _expImageView = [UIImageView new];
        _expImageView.image = [UIImage imageNamed:@"user-level-exp"];

        _levelLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _levelLabel.textColor = [UIColor colorFromHexString:@"#FEC402"];

        _expLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _expLabel.textColor = _levelLabel.textColor;

        [self addSubview:_levelImageView];
        [self addSubview:_expImageView];
        [_levelImageView addSubview:_levelLabel];
        [_expImageView addSubview:_expLabel];

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_levelLabel sizeToFit];
    [_expLabel sizeToFit];
    [_levelImageView sizeToFit];
    [_expImageView sizeToFit];

    CGFloat iconHeight = _levelImageView.height;

    _levelImageView.width = iconHeight * 1.8 + _levelLabel.width;
    _levelImageView.height = iconHeight;

    _expImageView.width = iconHeight * 1.8 + _expLabel.width;
    _expImageView.height = iconHeight;

    _levelLabel.x = iconHeight * 1.3;
    _levelLabel.centerY = iconHeight / 2;

    _expLabel.x = iconHeight * 1.3;
    _expLabel.centerY = iconHeight / 2;

    _levelImageView.x = self.width / 2 - _levelImageView.width - BLUThemeMargin * 2;
    _levelImageView.y = self.nicknameLabel.bottom + BLUThemeMargin * 4;

    _expImageView.x = self.width / 2 + BLUThemeMargin * 2;
    _expImageView.y = _levelImageView.y;
}

- (void)setUser:(BLUUser *)user {
    [super setUser:user];
    _levelLabel.text = user.levelDesc;
    _expLabel.text = @(user.experience).description;
}

@end
