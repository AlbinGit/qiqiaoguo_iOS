//
//  BLUIndicatorSettingCell.m
//  Blue
//
//  Created by Bowen on 2/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUSettingIndicatorCell.h"

@interface BLUSettingIndicatorCell ()

@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) BLUSolidLine *solidLine;

@end

@implementation BLUSettingIndicatorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // IndicatorImage
        _indicatorImageView = [UIImageView new];
        _indicatorImageView.image = [UIImage imageNamed:@"common-navigation-right-gray-icon"];
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self.contentView addSubview:_indicatorImageView];
        self.textLabel.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeLarge];
        
        // Solid line
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;
        [self.contentView addSubview:_solidLine];
    
        self.showSolidLine = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat indicatorImageViewWidth = [BLUCurrentTheme leftMargin] * 4;
    
    // textLabel
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.width = textLabelFrame.size.width / 2;
    self.textLabel.frame = textLabelFrame;
   
    // indicatorImageView
    _indicatorImageView.frame = CGRectMake(self.contentView.width - [BLUCurrentTheme rightMargin] * 4 - indicatorImageViewWidth, 0, indicatorImageViewWidth, indicatorImageViewWidth);
    _indicatorImageView.centerY = self.contentView.centerY;

    _solidLine.frame = CGRectMake(self.textLabel.left, self.contentView.height - 1, self.contentView.width - self.textLabel.left - BLUThemeMargin * 4, BLUThemeOnePixelHeight);
}

- (void)setShowSolidLine:(BOOL)showSolidLine {
    _showSolidLine = showSolidLine;
    _solidLine.hidden = !_showSolidLine;
}

@end
