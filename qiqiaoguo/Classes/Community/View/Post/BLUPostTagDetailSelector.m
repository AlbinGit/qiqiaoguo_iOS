//
//  BLUPostTagDetailSelector.m
//  Blue
//
//  Created by Bowen on 9/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagDetailSelector.h"

@implementation BLUPostTagDetailSelector

- (instancetype)init  {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.userInteractionEnabled = YES;

    _allLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _allLabel.text =
    NSLocalizedString(@"post-tag-detail-selector.all-label.title", @"All");
    [_allLabel sizeToFit];

    _recommendedLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _recommendedLabel.text =
    NSLocalizedString(@"post-tag-detail-selector.recommended-label.title", @"Recommended");
    [_recommendedLabel sizeToFit];

    _allBottomLine = [UIView new];
    _recommendedBottomLine = [UIView new];
    _backgroundView = [UIToolbar new];

    [self addSubview:_backgroundView];
    [self addSubview:_allBottomLine];
    [self addSubview:_recommendedBottomLine];
    [self addSubview:_allLabel];
    [self addSubview:_recommendedLabel];

    _selectedIndex = BLUPostTagDetailSelectedIndexAll;

    [self configureUIForSelectedIndex:_selectedIndex];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _backgroundView.frame = self.bounds;

    _allBottomLine.frame =
    CGRectMake(0, self.height - BLUThemeMargin, self.width / 2.0, BLUThemeMargin);

    _recommendedBottomLine.frame =
    CGRectMake(self.width / 2.0,
               _allBottomLine.y,
               _allBottomLine.width,
               _allBottomLine.height);

    CGFloat allLabelX = self.width / 4.0 - _allLabel.width / 2.0;
    CGFloat allLabelY = (self.height - _allLabel.height) / 2.0;
    _allLabel.frame =
    CGRectMake(allLabelX, allLabelY, _allLabel.width, _allLabel.height);

    CGFloat recommendedLabelX = self.width / 4.0 * 3.0 - _recommendedLabel.width / 2.0;
    CGFloat recommendedLabelY = allLabelY;
    _recommendedLabel.frame =
    CGRectMake(recommendedLabelX, recommendedLabelY,
               _recommendedLabel.width, _recommendedLabel.height);
}

- (void)configureUIForSelectedIndex:(BLUPostTagDetailSelectedIndex)selectedIndex {
    UIColor *selectedColor = BLUThemeMainColor;
    UIColor *deselectedTextColor = [UIColor colorFromHexString:@"#666666"];
    UIColor *deselectedLineColor = nil;
    [UIView animateWithDuration:0.2 animations:^{
        switch (selectedIndex) {
            case BLUPostTagDetailSelectedIndexAll: {
                _allLabel.textColor = selectedColor;
                _recommendedLabel.textColor = deselectedTextColor;
                _allBottomLine.backgroundColor = selectedColor;
                _recommendedBottomLine.backgroundColor = deselectedLineColor;
            } break;
            case BLUPostTagDetailSelectedIndexRecommended: {
                _allLabel.textColor = deselectedTextColor;
                _recommendedLabel.textColor = selectedColor;
                _allBottomLine.backgroundColor = deselectedLineColor;
                _recommendedBottomLine.backgroundColor = selectedColor;
            } break;
        }
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    [self updateValueWithLocation:location];
}

- (void)updateValueWithLocation:(CGPoint)location {
    if (location.x <= self.width / 2.0) {
        _selectedIndex = BLUPostTagDetailSelectedIndexAll;
    } else {
        _selectedIndex = BLUPostTagDetailSelectedIndexRecommended;
    }
    [self configureUIForSelectedIndex:_selectedIndex];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

+ (CGFloat)postTagDetailSelectorHeight {
    return 44.0;
}

@end
