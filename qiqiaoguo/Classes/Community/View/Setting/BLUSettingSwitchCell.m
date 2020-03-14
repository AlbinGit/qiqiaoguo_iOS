//
//  BLUSwitchSettingCell.m
//  Blue
//
//  Created by Bowen on 2/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUSettingSwitchCell.h"

static const CGFloat kPasscodeSwitchHeight = 30.0;
static const CGFloat kPasscodeSwitchWidth = 55.0;

@interface BLUSettingSwitchCell ()

@property (nonatomic, strong) BLUSolidLine *solidLine;

@end

@implementation BLUSettingSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // passcodeSwitch
        _passcodeSwitch = [UISwitch new];
        _passcodeSwitch.onTintColor = [BLUCurrentTheme mainColor];
        
        [_passcodeSwitch addTarget:self action:@selector(switchChangedValue:) forControlEvents:UIControlEventValueChanged];
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self.contentView addSubview:_passcodeSwitch];
        self.textLabel.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeLarge];

        // Solid line
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;
        [self.contentView addSubview:_solidLine];

        self.showSolidLine = YES;
    }
    return self;
}

- (void)switchChangedValue:(UISwitch *)paramSwitch {
    if ([self.delegate respondsToSelector:@selector(settingSwitchCell:didChangeSwitchValue:)]) {
        [self.delegate settingSwitchCell:self didChangeSwitchValue:paramSwitch];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Password
    _passcodeSwitch.frame = CGRectMake(self.contentView.width - kPasscodeSwitchWidth - [BLUCurrentTheme rightMargin] * 3, 0, kPasscodeSwitchWidth, kPasscodeSwitchHeight);
    _passcodeSwitch.centerY = self.contentView.centerY;
    
    // TextLabel
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.width = textLabelFrame.size.width / 2;
    self.textLabel.frame = textLabelFrame;

    _solidLine.frame = CGRectMake(self.textLabel.left, self.contentView.height - 1, self.contentView.width - self.textLabel.left - BLUThemeMargin * 4, BLUThemeOnePixelHeight);
}

- (void)setShowSolidLine:(BOOL)showSolidLine {
    _showSolidLine = showSolidLine;
    _solidLine.hidden = !_showSolidLine;
}

@end
