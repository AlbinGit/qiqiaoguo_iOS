//
//  BLULogOutSettingCell.m
//  Blue
//
//  Created by Bowen on 2/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUSettingLogOutCell.h"

@implementation BLUSettingLogOutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // TitleLabel
        _titleLabel = [UILabel new];
        _titleLabel.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeLarge];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [BLUCurrentTheme mainColor];
        [self.contentView addSubview:_titleLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = self.contentView.frame;
}

@end
