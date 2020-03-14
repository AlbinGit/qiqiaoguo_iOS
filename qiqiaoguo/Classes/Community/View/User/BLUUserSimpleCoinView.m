//
//  BLUUserSimpleCoinView.m
//  Blue
//
//  Created by Bowen on 12/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserSimpleCoinView.h"

@implementation BLUUserSimpleCoinView

- (instancetype)init {
    if (self = [super init]) {

        _coinImageView = [UIImageView new];
        _coinImageView.image = [UIImage imageNamed:@"user-coin-white"];

        _coinLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _coinLabel.textColor = [UIColor colorFromHexString:@"#FEC402"];

        [self addSubview:_coinImageView];
        [_coinImageView addSubview:_coinLabel];

        return self;
    }

    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_coinLabel sizeToFit];
    [_coinImageView sizeToFit];

    CGFloat iconHeight = _coinImageView.height;

    _coinImageView.width = iconHeight * 1.8 + _coinLabel.width;
    _coinImageView.height = iconHeight;

    _coinLabel.x = iconHeight * 1.3;
    _coinLabel.centerY = iconHeight / 2;

    _coinImageView.centerX = self.centerX;
    _coinImageView.y = self.nicknameLabel.bottom + BLUThemeMargin * 4;
}

- (void)setUser:(BLUUser *)user {
    [super setUser:user];
    // TODO
    _coinLabel.text = @(user.coin).description;
}

@end
