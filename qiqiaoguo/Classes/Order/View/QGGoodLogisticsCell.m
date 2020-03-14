//
//  QGGoodLogisticsCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/28.
//
//

#import "QGGoodLogisticsCell.h"
#import "QGLogisticsDetails.h"

@implementation QGGoodLogisticsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _contentInsets = UIEdgeInsetsMake(BLUThemeMargin * 4,
                                          BLUThemeMargin * 4,
                                          BLUThemeMargin * 4,
                                          BLUThemeMargin * 4);
        _elementSpacing = BLUThemeMargin * 2;
        
        _emphasisDotSize = CGSizeMake(20, 20);
        
        _dotSize = CGSizeMake(8, 8);
        
        _emphasisDotLeftInset = 15.0;
        _emphasisDotRightInset = 20.0;
        
        _emphasisColor = [UIColor colorFromHexString:@"#ffb400"];
        
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.timeLabel];
        
        [self.contentView.layer addSublayer:self.horizonSeparator];
        [self.contentView.layer addSublayer:self.topLine];
        [self.contentView.layer addSublayer:self.bottomLine];
        [self.contentView.layer addSublayer:self.dot];
        [self.contentView.layer addSublayer:self.emphasisDot];
        
        [self setEmphasis:NO];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    CGFloat labelX = _emphasisDotLeftInset + _emphasisDotSize.width +
    _emphasisDotRightInset;
    CGFloat labelWidth = self.contentView.width - _emphasisDotLeftInset -
    _emphasisDotSize.width - _emphasisDotRightInset - _contentInsets.right;
    
    CGSize detailSize = [self.detailLabel sizeThatFits:CGSizeMake(labelWidth,
                                                                  CGFLOAT_MAX)];
    self.detailLabel.frame = CGRectMake(labelX, _contentInsets.top,
                                        detailSize.width, detailSize.height);
    
    CGSize timeSize = [self.timeLabel sizeThatFits:CGSizeMake(labelWidth,
                                                              CGFLOAT_MAX)];
    
    CGFloat timeY = self.detailLabel.bottom + _elementSpacing;
    
    self.timeLabel.frame = CGRectMake(labelX, timeY, timeSize.width,
                                      timeSize.height);
    
    CGFloat separatorY = self.timeLabel.bottom + _contentInsets.bottom;
    
    self.horizonSeparator.frame = CGRectMake(labelX, separatorY, labelWidth,
                                             BLUThemeOnePixelHeight);
    
    CGFloat contentHeight = CGRectGetMaxY(self.horizonSeparator.frame);
    
    CGFloat lineWidth = 2.0;
    CGFloat lineHeight = contentHeight / 2.0;
    CGFloat lineX = _emphasisDotLeftInset +
    (_emphasisDotSize.width - lineWidth) / 2.0;
    
    self.topLine.frame = CGRectMake(lineX, 0, lineWidth, lineHeight);
    
    self.bottomLine.frame = CGRectMake(lineX, lineHeight, lineWidth, lineHeight);
    
    CGFloat dotX = _emphasisDotLeftInset +
    (_emphasisDotSize.width - _dotSize.width) / 2.0;
    CGFloat dotY = (contentHeight - _dotSize.height) / 2.0;
    self.dot.frame = CGRectMake(dotX, dotY, _dotSize.width, _dotSize.height);
    self.dot.cornerRadius = CGRectGetWidth(self.dot.frame) / 2.0;
    
    CGFloat emphasisX = _emphasisDotLeftInset;
    CGFloat emphasisY = (contentHeight - _emphasisDotSize.height) / 2.0;
    self.emphasisDot.frame = CGRectMake(emphasisX, emphasisY,
                                        _emphasisDotSize.width,
                                        _emphasisDotSize.height);
    self.emphasisDot.cornerRadius = CGRectGetWidth(self.emphasisDot.frame) / 2.0;
    self.cellSize = CGSizeMake(self.contentView.width,
                               CGRectGetMaxY(self.horizonSeparator.frame));
}

- (void)setModel:(id)model {
    [super setModel:model];
    _detail = (QGLogisticsDetails *)model;
    
    self.detailLabel.text = _detail.context;
    self.timeLabel.text = _detail.time;
}

- (void)setEmphasis:(BOOL)emphasis {
    _emphasis = emphasis;
    
    if (_emphasis) {
        self.detailLabel.textColor = self.emphasisColor;
        self.timeLabel.textColor = self.emphasisColor;
        self.dot.hidden = YES;
        self.emphasisDot.hidden = NO;
    } else {
        self.detailLabel.textColor = [UIColor colorFromHexString:@"#666666"];
        self.timeLabel.textColor = [UIColor colorFromHexString:@"#666666"];
        self.dot.hidden = NO;
        self.emphasisDot.hidden = YES;
    }
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [UILabel new];
        _detailLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [UILabel new];
        _timeLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);
    }
    return _timeLabel;
}

- (CALayer *)horizonSeparator {
    if (_horizonSeparator == nil) {
        _horizonSeparator = [CALayer new];
        _horizonSeparator.backgroundColor =
        BLUThemeSubTintBackgroundColor.CGColor;
    }
    return _horizonSeparator;
}

- (CALayer *)topLine {
    if (_topLine == nil) {
        _topLine = [CALayer new];
        _topLine.backgroundColor =
        BLUThemeSubTintBackgroundColor.CGColor;
    }
    return _topLine;
}

- (CALayer *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [CALayer new];
        _bottomLine.backgroundColor =
        BLUThemeSubTintBackgroundColor.CGColor;
    }
    return _bottomLine;
}

- (CALayer *)dot {
    if (_dot == nil) {
        _dot = [CALayer new];
        _dot.backgroundColor =
        BLUThemeSubTintBackgroundColor.CGColor;
    }
    return _dot;
}

- (CALayer *)emphasisDot {
    if (_emphasisDot == nil) {
        _emphasisDot = [CALayer new];
        _emphasisDot.backgroundColor = self.emphasisColor.CGColor;
        _emphasisDot.borderWidth = BLUThemeMargin;
        _emphasisDot.borderColor = [UIColor colorWithHue:0.46
                                              saturation:0.36
                                              brightness:0.85
                                                   alpha:1].CGColor;
    }
    return _emphasisDot;
}


@end
