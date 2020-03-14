//
//  BLUUserSimpleTableCell.m
//  Blue
//
//  Created by Bowen on 12/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserSimpleTableCell.h"

@implementation BLUUserSimpleTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _titleLabel.textColor = [UIColor colorFromHexString:@"#656667"];

        _countLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _countLabel.textColor = _titleLabel.textColor;
        _countLabel.textAlignment = NSTextAlignmentCenter;

        _descLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _descLabel.textColor = _titleLabel.textColor;

        _leftLine = [BLUSolidLine new];
        _leftLine.backgroundColor = [UIColor colorFromHexString:@"#EAEBEC"];

        _rightLine = [BLUSolidLine new];
        _rightLine.backgroundColor = [UIColor colorFromHexString:@"#EAEBEC"];

        UIView *superview = self.contentView;
        [superview addSubview:_titleLabel];
        [superview addSubview:_countLabel];
        [superview addSubview:_descLabel];
        [superview addSubview:_leftLine];
        [superview addSubview:_rightLine];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        return self;
    }
    return nil;
}

- (void)setStyle:(BLUUserSimpleTableCellStyle)style {
    _style = style;
    switch (style) {
        case BLUUserSimpleTableCellStyleTitle: {
            self.titleLabel.textColor = [UIColor whiteColor];
            self.countLabel.textColor = [UIColor whiteColor];
            self.descLabel.textColor = [UIColor whiteColor];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.countLabel.textAlignment = NSTextAlignmentCenter;
            self.descLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
            self.countLabel.font = self.titleLabel.font;
            self.descLabel.font = self.titleLabel.font;
            self.contentView.backgroundColor = BLUThemeMainColor;
        } break;
        case BLUUserSimpleTableCellStyleContent: {
            self.titleLabel.textColor = [UIColor colorFromHexString:@"#656667"];
            self.countLabel.textColor = self.titleLabel.textColor;
            self.descLabel.textColor = self.titleLabel.textColor;
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.descLabel.textAlignment = NSTextAlignmentLeft;
            self.countLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);
            self.countLabel.font = self.titleLabel.font;
            self.descLabel.font = self.titleLabel.font;
        } break;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat leftRatio = 8.0 / 30.0;
    CGFloat centerRatio = 7.0 / 40.0;
    CGFloat rightRatio = 1.0 - leftRatio - centerRatio;

    CGFloat leftWidth = self.contentView.width * leftRatio;
    CGFloat centerWidth = self.contentView.width * centerRatio;
    CGFloat rightWidth = self.contentView.width * rightRatio;

    CGSize titleLabelSize = [_titleLabel sizeThatFits:CGSizeMake(leftWidth - BLUThemeMargin * 4, CGFLOAT_MAX)];
    _titleLabel.size = titleLabelSize;
    _titleLabel.x = BLUThemeMargin * 2;

    [_countLabel sizeToFit];
    _countLabel.x = leftWidth;
    _countLabel.width = centerWidth;

    CGSize descLabelSize = [_descLabel sizeThatFits:CGSizeMake(rightWidth - BLUThemeMargin * 4, CGFLOAT_MAX)];
    _descLabel.size = descLabelSize;
    _descLabel.x = leftWidth + centerWidth + BLUThemeMargin * 2;

    CGFloat contentHeight = _titleLabel.height > _descLabel.height ? _titleLabel.height : _descLabel.height;
    contentHeight += BLUThemeMargin * 6;
    _titleLabel.centerY = contentHeight / 2;
    _countLabel.centerY = _titleLabel.centerY;
    _descLabel.centerY = _titleLabel.centerY;

    _leftLine.y = 0;
    _leftLine.height = contentHeight;
    _leftLine.width = BLUThemeMargin / 2;
    _leftLine.centerX = leftWidth;

    _rightLine.y = 0;
    _rightLine.height = contentHeight;
    _rightLine.width = BLUThemeMargin / 2;
    _rightLine.centerX = leftWidth + centerWidth;

    if (self.style == BLUUserSimpleTableCellStyleTitle) {
        self.titleLabel.centerX = leftWidth / 2;
        self.countLabel.centerX = leftWidth + centerWidth / 2;
        self.descLabel.centerX = leftWidth + centerWidth + rightWidth / 2;
    }

    self.cellSize = CGSizeMake(self.contentView.width, contentHeight);
}

@end
