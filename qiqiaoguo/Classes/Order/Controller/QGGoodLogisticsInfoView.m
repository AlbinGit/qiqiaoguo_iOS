//
//  QGGoodLogisticsInfoView.m
//  qiqiaoguo
//
//  Created by cws on 16/7/28.
//
//

#import "QGGoodLogisticsInfoView.h"
#import "BLULogistics.h"

@implementation QGGoodLogisticsInfoView

- (instancetype)init {
    if (self = [super init]) {
        _contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        _imageSize = CGSizeMake(60, 60);
        _elementSpacing = BLUThemeMargin * 2;
        _separatorHeight = BLUThemeMargin * 2;
        
        [self addSubview:self.imageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.codeLabel];
        [self.layer addSublayer:self.separator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(_contentInsets.left,
                                      _contentInsets.top,
                                      _imageSize.width,
                                      _imageSize.height);
    
    CGFloat labelWidth = self.width - self.imageView.right -
    _elementSpacing - _contentInsets.right;
    
    CGSize nameSize = [self.nameLabel sizeThatFits:CGSizeMake(labelWidth,
                                                              CGFLOAT_MAX)];
    CGSize codeSize = [self.codeLabel sizeThatFits:CGSizeMake(labelWidth,
                                                              CGFLOAT_MAX)];
    
    CGFloat nameX = self.imageView.right + _elementSpacing;
    CGFloat nameY = self.imageView.y +
    (self.imageView.height - nameSize.height - codeSize.height - _elementSpacing);
    
    self.nameLabel.frame = CGRectMake(nameX, nameY, nameSize.width,
                                      nameSize.height);
    
    CGFloat codeY = self.nameLabel.bottom + _elementSpacing;
    self.codeLabel.frame = CGRectMake(nameX, codeY, codeSize.width,
                                      codeSize.height);
    
    CGFloat separatorY = self.imageView.bottom + _contentInsets.bottom;
    self.separator.frame = CGRectMake(0, separatorY, self.width,
                                      _separatorHeight);
}

+ (CGFloat)requiredHeight {
    return 90.0 + BLUThemeMargin * 2;
}

- (void)setLogistics:(BLULogistics *)logistics {
    _logistics = logistics;
    self.nameLabel.attributedText = [self attributedName:_logistics.name];
    self.codeLabel.attributedText = [self attributedCode:_logistics.code];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_logistics.imageCover]];
    [self setNeedsLayout];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = BLUThemeSubTintBackgroundColor;
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel new];
        _nameLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}

- (UILabel *)codeLabel {
    if (_codeLabel == nil) {
        _codeLabel = [UILabel new];
        _codeLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _codeLabel.numberOfLines = 1;
    }
    return _codeLabel;
}

- (CALayer *)separator {
    if (_separator == nil) {
        _separator = [CALayer new];
        _separator.backgroundColor = BLUThemeSubTintBackgroundColor.CGColor;
    }
    return _separator;
}

- (NSAttributedString *)attributedName:(NSString *)name {
    NSString *prompt =
    NSLocalizedString(@"good-logistics-info-view.name-prompt", @"Company: ");
    return [self attributedStringWithPrompt:prompt content:name];
}

- (NSAttributedString *)attributedCode:(NSString *)code {
    NSString *prompt =
    NSLocalizedString(@"good-logistics-info-view.code-prompt", @"Code: ");
    return [self attributedStringWithPrompt:prompt content:code];
}

- (NSAttributedString *)attributedStringWithPrompt:(NSString *)prompt content:(NSString *)content {
    NSString *str = [NSString stringWithFormat:@"%@%@", prompt, content];
    NSDictionary *fontAttr =
    @{NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};
    NSMutableAttributedString *attrStr =
    [[NSMutableAttributedString alloc] initWithString:str attributes:fontAttr];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorFromHexString:@"#666666"]
                    range:[str rangeOfString:prompt]];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorFromHexString:@"#333333"]
                    range:[str rangeOfString:content]];
    return attrStr;
}

@end
