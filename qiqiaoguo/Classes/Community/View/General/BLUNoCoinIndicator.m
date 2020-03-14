//
//  BLUNoCoinIndicator.m
//  Blue
//
//  Created by Bowen on 17/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUNoCoinIndicator.h"

@interface BLUNoCoinIndicator ()

@property (nonatomic, assign) BOOL didConfigLayout;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation BLUNoCoinIndicator

- (instancetype)init {
    if (self = [super init]) {

        _topBackgroundImageView = [UIImageView new];
        _topBackgroundImageView.image = [UIImage imageNamed:@"common-alert-view-header"];

        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _titleLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVeryLarge);
        _titleLabel.text = NSLocalizedString(@"no-coin-indicator.title", @"Ops");
        _titleLabel.textColor = [UIColor whiteColor];

        _indicatorTextView = [UITextView new];
        _indicatorTextView.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);
        _indicatorTextView.textColor = BLUThemeSubDeepContentForegroundColor;
        _indicatorTextView.backgroundColor = BLUThemeSubTintBackgroundColor;
        _indicatorTextView.text = NSLocalizedString(@"no-coin-indicator.indicator-label.text", @"No more blue coin.");
        _indicatorTextView.scrollEnabled = NO;
        _indicatorTextView.textContainerInset = UIEdgeInsetsMake(BLUThemeMargin * 4, BLUThemeMargin * 3, BLUThemeMargin * 4, BLUThemeMargin * 3);

        _earnButton = [UIButton makeThemeButtonWithType:BLUButtonTypeSolidRoundRect];
        _earnButton.backgroundColor = BLUThemeMainColor;
        _earnButton.title = NSLocalizedString(@"no-coin-indicator.earn-button.title", @"Earn blue coin");
        _earnButton.titleColor = [UIColor whiteColor];

        _cancelButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.title = NSLocalizedString(@"no-coin-indicator.cancel-button.title", @"Cancel");
        _cancelButton.titleColor = BLUThemeMainColor;

        [self addSubview:_topBackgroundImageView];
        [_topBackgroundImageView addSubview:_titleLabel];
        [self addSubview:_indicatorTextView];
        [self addSubview:_earnButton];
        [self addSubview:_cancelButton];

        self.backgroundColor = [UIColor whiteColor];
        self.cornerRadius = 10;

        _didConfigLayout = NO;

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configLayout];
}

- (void)sizeToFit {
    [super sizeToFit];
    CGSize contentSize = [self configLayout];
    self.height = contentSize.height;
    self.width = contentSize.width;
}

- (CGSize)configLayout {

    if (_didConfigLayout) {
        return _contentSize;
    }

    CGFloat contentWidth, contentHeight;

    [_topBackgroundImageView sizeToFit];
    _topBackgroundImageView.x = 0;
    _topBackgroundImageView.y = 0;

    contentWidth = _topBackgroundImageView.width;

    [_titleLabel sizeToFit];
    _titleLabel.centerX = _topBackgroundImageView.width / 2;
    _titleLabel.centerY = _topBackgroundImageView.height / 2;

    CGSize indicatorLabelSize = [_indicatorTextView sizeThatFits:CGSizeMake(contentWidth + BLUThemeMargin * 6, CGFLOAT_MAX)];
    _indicatorTextView.x = 0;
    _indicatorTextView.y = _topBackgroundImageView.bottom;
    _indicatorTextView.width = contentWidth;
    _indicatorTextView.height = indicatorLabelSize.height;

    [_earnButton sizeToFit];
    _earnButton.x = BLUThemeMargin * 4;
    _earnButton.width = contentWidth - BLUThemeMargin * 8;
    _earnButton.y = _indicatorTextView.bottom + BLUThemeMargin * 4;

    [_cancelButton sizeToFit];
    _cancelButton.x = BLUThemeMargin * 4;
    _cancelButton.width = contentWidth - BLUThemeMargin * 8;
    _cancelButton.y = _earnButton.bottom + BLUThemeMargin * 2;

    contentHeight = _cancelButton.bottom + BLUThemeMargin * 4;

    _contentSize = CGSizeMake(contentWidth, contentHeight);
    _didConfigLayout = YES;

    return _contentSize;
}

@end
