//
//  BLUUserCoinTaskCell.m
//  Blue
//
//  Created by Bowen on 12/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserCoinTaskCell.h"

@implementation BLUUserCoinTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _titleLabel.textColor = [UIColor colorFromHexString:@"#3F4041"];

        _coinIcon = [UIImageView new];
        _coinIcon.image = [UIImage imageNamed:@"user-coin-gold"];

        _coinLabel = [UILabel new];
        _coinLabel.textColor = [UIColor colorFromHexString:@"#999A9B"];

        _finishButton = [UIButton makeThemeButtonWithType:BLUButtonTypeSolidRoundRect];
        _finishButton.titleFont = _titleLabel.font;
        _finishButton.titleColor = [UIColor whiteColor];
        _finishButton.contentEdgeInsets = UIEdgeInsetsMake(0, BLUThemeMargin * 2, 0, BLUThemeMargin * 2);

        _topLine = [BLUSolidLine new];
//        _topLine.backgroundColor = [UIColor colorFromHexString:@"#DFE0E0"];
        _topLine.backgroundColor = BLUThemeSubTintBackgroundColor;

        _bottomLine = [BLUSolidLine new];
        _bottomLine.backgroundColor = _topLine.backgroundColor;

        UIView *superview = self.contentView;
        [superview addSubview:_titleLabel];
        [superview addSubview:_coinIcon];
        [superview addSubview:_coinLabel];
        [superview addSubview:_finishButton];
        [superview addSubview:_topLine];
        [superview addSubview:_bottomLine];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_titleLabel sizeToFit];
    _titleLabel.x = BLUThemeMargin * 4;
    _titleLabel.y = BLUThemeMargin * 4;

    _coinIcon.width = _titleLabel.height - BLUThemeMargin * 2;
    _coinIcon.height = _titleLabel.height - BLUThemeMargin * 2;
    _coinIcon.centerX = self.contentView.centerX - BLUThemeMargin;
    _coinIcon.centerY = _titleLabel.centerY;

    [_coinLabel sizeToFit];
    _coinLabel.x = _coinIcon.right + BLUThemeMargin * 1.5;
    _coinLabel.centerY = _coinIcon.centerY;

    [_finishButton sizeToFit];
    _finishButton.height = _titleLabel.height;
    _finishButton.x = self.contentView.width - _finishButton.width - BLUThemeMargin * 4;
    _finishButton.centerY = _titleLabel.centerY;

    _topLine.frame = CGRectMake(0, 0, self.contentView.width, BLUThemeMargin);
    _bottomLine.frame = CGRectMake(0, self.titleLabel.bottom + BLUThemeMargin * 4 - BLUThemeMargin, self.contentView.width, BLUThemeMargin);

    self.cellSize = CGSizeMake(self.contentView.width, self.titleLabel.bottom + BLUThemeMargin * 4);

}

@end
