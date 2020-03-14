//
//  QGSearchPromptHeader.m
//  qiqiaoguo
//
//  Created by cws on 16/7/8.
//
//

#import "QGSearchPromptHeader.h"

@implementation QGSearchPromptHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _titleInsets = UIEdgeInsetsMake(BLUThemeMargin * 2, BLUThemeMargin * 2,
                                        BLUThemeMargin * 2, BLUThemeMargin * 2);
        
        _titleLabel = [UILabel new];
        _titleLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _titleLabel.textColor =
        [UIColor colorWithHue:0 saturation:0 brightness:0.33 alpha:1];
        
        _separator = [CALayer new];
        _separator.backgroundColor =
        [UIColor colorWithHue:0 saturation:0 brightness:0.9 alpha:1].CGColor;
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView.layer addSublayer:_separator];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).equalTo(@(self.titleInsets.left));
        make.centerY.equalTo(self.contentView);
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat separatorY = self.contentView.height - QGOnePixelLineHeight;
    
    _separator.frame = CGRectMake(0, separatorY, self.contentView.width, QGOnePixelLineHeight);
}

+ (CGFloat)headerHeight {
    return 32.0 + QGOnePixelLineHeight;
}

@end
