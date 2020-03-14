//
//  BLUSettingTextCell.m
//  Blue
//
//  Created by Bowen on 31/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUSettingTextCell.h"

@interface BLUSettingTextCell ()

@property (nonatomic, strong) UILabel *indicatorLabel;

@end

@implementation BLUSettingTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _indicatorLabel = [UILabel makeThemeLabelWithType:BLULabelTypeDefault];
        _indicatorLabel.textColor = BLUThemeSubDeepContentForegroundColor;
        _indicatorLabel.font = self.textLabel.font;
        [self.contentView addSubview:_indicatorLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // textLabel
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.width = textLabelFrame.size.width / 2;
    self.textLabel.frame = textLabelFrame;
    
    // Indicator label
    [_indicatorLabel sizeToFit];
    _indicatorLabel.frame = CGRectMake(self.contentView.width - BLUThemeMargin * 4 - _indicatorLabel.width, 0, _indicatorLabel.width, _indicatorLabel.width);
    _indicatorLabel.centerY = self.textLabel.centerY;
}

- (void)setText:(NSString *)text {
    _text = text;
    _indicatorLabel.text = text;
}

@end
