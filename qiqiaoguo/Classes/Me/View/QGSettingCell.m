//
//  QGSettingCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/12.
//
//

#import "QGSettingCell.h"

@interface QGSettingCell ()

@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) BLUSolidLine *solidLine;
@property (nonatomic, strong) UILabel *indicatorLabel;

@end

@implementation QGSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // IndicatorImage
        _indicatorImageView = [UIImageView new];
        _indicatorImageView.image = [UIImage imageNamed:@"Cell_arrow"];
        
        _indicatorLabel = [UILabel makeThemeLabelWithType:BLULabelTypeDefault];
        _indicatorLabel.textColor = BLUThemeSubDeepContentForegroundColor;
        _indicatorLabel.font = self.textLabel.font;
        [self.contentView addSubview:_indicatorLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self.contentView addSubview:_indicatorImageView];
        self.textLabel.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeLarge];
        self.textLabel.textColor = QGTitleColor;
        
        // Solid line
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;
        [self.contentView addSubview:_solidLine];
        
        self.showSolidLine = NO;
        self.showCache = NO;
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
    
     // Indicator label
    [_indicatorLabel sizeToFit];
    _indicatorLabel.frame = CGRectMake(self.contentView.width - BLUThemeMargin * 4 - _indicatorLabel.width, 0, _indicatorLabel.width, _indicatorLabel.width);
    _indicatorLabel.centerY = self.textLabel.centerY;
    
    // indicatorImageView
    _indicatorImageView.frame = CGRectMake(self.contentView.width - [BLUCurrentTheme rightMargin] * 4 - indicatorImageViewWidth, 0, indicatorImageViewWidth, indicatorImageViewWidth);
    _indicatorImageView.centerY = self.contentView.centerY;
    
    _solidLine.frame = CGRectMake(self.textLabel.left, self.contentView.height - 1, self.contentView.width - self.textLabel.left - BLUThemeMargin * 4, BLUThemeOnePixelHeight);
}

- (void)setShowSolidLine:(BOOL)showSolidLine {
    _showSolidLine = showSolidLine;
    _solidLine.hidden = !_showSolidLine;
}

- (void)setShowCache:(BOOL)showCache{
    _showCache = showCache;
    _indicatorLabel.hidden = !_showCache;
    _indicatorImageView.hidden = _showCache;
}

- (void)setText:(NSString *)text {
    _text = text;
    _indicatorLabel.text = text;
}

@end
