//
//  QGGoodLogisticsHeaderview.m
//  qiqiaoguo
//
//  Created by cws on 16/7/28.
//
//

#import "QGGoodLogisticsHeaderview.h"

@implementation QGGoodLogisticsHeaderview

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.promptLabel];
        [self.layer addSublayer:self.separator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.promptLabel sizeToFit];
    
    CGFloat promptX = 15.0;
    CGFloat promptY = (self.height - self.promptLabel.height) / 2.0;
    
    self.promptLabel.frame = CGRectMake(promptX, promptY,
                                        self.promptLabel.width,
                                        self.promptLabel.height);
    
    CGFloat separatorY = promptY + self.promptLabel.bottom;
    CGFloat separatorWidth = self.width - promptX * 2;
    self.separator.frame = CGRectMake(promptX, separatorY, separatorWidth,
                                      BLUThemeOnePixelHeight);
}

- (UILabel *)promptLabel {
    if (_promptLabel == nil) {
        _promptLabel = [UILabel new];
        _promptLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _promptLabel.text = @"物流详情";
        _promptLabel.textColor = QGTitleColor;
    }
    return _promptLabel;
}

- (CALayer *)separator {
    if (_separator == nil) {
        _separator = [CALayer new];
        _separator.backgroundColor = BLUThemeSubTintBackgroundColor.CGColor;
    }
    return _separator;
}

+ (CGFloat)requiredHeight {
    return 50.0;
}


@end
