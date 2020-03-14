//
//  BLUUserLevelComponentView
//  Blue
//
//  Created by Bowen on 12/11/15.
//  Copyright © 2015年 com.boki. All rights reserved.
//

#import "BLUUserLevelComponentView.h"
#import "BLULevelSpec.h"

@implementation BLUUserLevelComponentView

- (instancetype)init {
    if (self = [super init]) {

        UIColor *leftColor = [UIColor colorFromHexString:@"#FDBA00"];
        UIColor *centerColor = [UIColor colorFromHexString:@"#FC8F01"];
        UIColor *rightColor =[UIColor colorFromHexString:@"#FA5807"];

        _floatIndicator = [UIImageView new];
        _floatIndicator.image = [UIImage imageNamed:@"user-level-float"];

        _levelLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _levelLabel.textColor = [UIColor whiteColor];

        _expLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _expLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall);
        _expLabel.textColor = [UIColor whiteColor];

        _leftLine = [BLUSolidLine new];
        _leftLine.backgroundColor = leftColor;

        _centerLine = [BLUSolidLine new];
        _centerLine.backgroundColor = centerColor;

        _rightLine = [BLUSolidLine new];
        _rightLine.backgroundColor = rightColor;

        _leftLevelLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _leftLevelLabel.font = BLUThemeBoldFontWithType(BLUUIThemeFontSizeTypeLarge);
        _leftLevelLabel.textColor = leftColor;

        _centerLevelLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _centerLevelLabel.font = BLUThemeBoldFontWithType(BLUUIThemeFontSizeTypeLarge);
        _centerLevelLabel.textColor = centerColor;

        _rightLevelLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _rightLevelLabel.font = BLUThemeBoldFontWithType(BLUUIThemeFontSizeTypeLarge);
        _rightLevelLabel.textColor = rightColor;

        _leftExpLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _leftExpLabel.font = BLUThemeBoldFontWithType(BLUUIThemeFontSizeTypeNormal);
        _leftExpLabel.textColor = leftColor;

        _centerExpLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _centerExpLabel.font = BLUThemeBoldFontWithType(BLUUIThemeFontSizeTypeNormal);
        _centerExpLabel.textColor = centerColor;

        _rightExpLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _rightExpLabel.font = BLUThemeBoldFontWithType(BLUUIThemeFontSizeTypeNormal);
        _rightExpLabel.textColor = rightColor;

        [self addSubview:_floatIndicator];
        [_floatIndicator addSubview:_levelLabel];
        [_floatIndicator addSubview:_expLabel];
        [self addSubview:_leftLine];
        [self addSubview:_centerLine];
        [self addSubview:_rightLine];
        [self addSubview:_leftLevelLabel];
        [self addSubview:_centerLevelLabel];
        [self addSubview:_rightLevelLabel];
        [self addSubview:_leftExpLabel];
        [self addSubview:_centerExpLabel];
        [self addSubview:_rightExpLabel];

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat itemWidth = self.width / 3.0;
    CGFloat lineHeight = BLUThemeMargin;

    [_floatIndicator sizeToFit];
    _floatIndicator.y = 0;
    _floatIndicator.centerX = self.floatIndex * itemWidth + itemWidth * self.floatRatio;

    [_levelLabel sizeToFit];
    _levelLabel.centerX = _floatIndicator.width / 2.0;
    _levelLabel.y = BLUThemeMargin * 2;

    [_expLabel sizeToFit];
    _expLabel.centerX = _floatIndicator.width / 2.0;
    _expLabel.y = _levelLabel.bottom;

    CGFloat indicatorBottom = _floatIndicator.bottom + BLUThemeMargin;

    _leftLine.x = 0;
    _leftLine.y = indicatorBottom;
    _leftLine.width = itemWidth;
    _leftLine.height = lineHeight;

    _centerLine.x = _leftLine.right;
    _centerLine.y = _leftLine.y;
    _centerLine.width = itemWidth;
    _centerLine.height = lineHeight;

    _rightLine.x = _centerLine.right;
    _rightLine.y = _leftLine.y;
    _rightLine.width = itemWidth;
    _rightLine.height = lineHeight;

    [_leftLevelLabel sizeToFit];
    _leftLevelLabel.centerX = _leftLine.centerX;
    _leftLevelLabel.y = _leftLine.bottom + BLUThemeMargin;

    [_centerLevelLabel sizeToFit];
    _centerLevelLabel.centerX = _centerLine.centerX;
    _centerLevelLabel.y = _centerLine.bottom + BLUThemeMargin;

    [_rightLevelLabel sizeToFit];
    _rightLevelLabel.centerX = _rightLine.centerX;
    _rightLevelLabel.y = _rightLine.bottom + BLUThemeMargin;

    [_leftExpLabel sizeToFit];
    _leftExpLabel.centerX = _leftLevelLabel.centerX;
    _leftExpLabel.y = _leftLevelLabel.bottom;

    [_centerExpLabel sizeToFit];
    _centerExpLabel.centerX = _centerLevelLabel.centerX;
    _centerExpLabel.y = _centerLevelLabel.bottom;

    [_rightExpLabel sizeToFit];
    _rightExpLabel.centerX = _rightLevelLabel.centerX;
    _rightExpLabel.y = _rightLevelLabel.bottom;
}

- (void)configWithLeftLevel:(NSInteger)leftLevel
                centerLevel:(NSInteger)centerLevel
                 rightLevel:(NSInteger)rightLevel
                    leftExp:(NSInteger)leftExp
                  centerExp:(NSInteger)centerExp
                   rightExp:(NSInteger)rightExp {
    NSString *(^lvString)(NSInteger level) = ^ NSString *(NSInteger level) {
        return [NSString stringWithFormat:@"LV%@", @(level)];
    };

    NSString *(^expString)(NSInteger exp) = ^ NSString *(NSInteger exp) {
        if (exp < 0) {
            return @"－∞";
        } else {
            return @(exp).description;
        }
    };

    _leftLevelLabel.text = lvString(leftLevel);
    _centerLevelLabel.text = lvString(centerLevel);
    _rightLevelLabel.text = lvString(rightLevel);
    _leftExpLabel.text = expString(leftExp);
    _centerExpLabel.text = expString(centerExp);
    _rightExpLabel.text = expString(rightExp);
}

- (void)setUser:(BLUUser *)user levelSpecs:(NSArray *)specs {

    _levelLabel.text = user.levelDesc;
    _expLabel.text = @(user.experience).description;

    __block BLULevelSpec *firstLevelSpec, *secondLevelSpec, *thirdLevelSpec, *userSpec;
    __block NSInteger firstLevel, secondLevel, thirdLevel, maxLevel = -1, minLevel = NSIntegerMax, userLevel = user.level;

    [specs enumerateObjectsUsingBlock:^(BLULevelSpec *spec, NSUInteger idx, BOOL * _Nonnull stop) {
        maxLevel = maxLevel > spec.rank ? maxLevel : spec.rank;
        minLevel = minLevel < spec.rank ? minLevel : spec.rank;
    }];

    if (userLevel <= minLevel) {
        userLevel = minLevel;
    }

    if (userLevel >= maxLevel) {
        userLevel = maxLevel;
    }

    if (userLevel <= minLevel) {
        firstLevel = minLevel;
        secondLevel = minLevel + 1;
        thirdLevel = minLevel + 2;
        self.floatIndex = 0;
    } else if (userLevel >= maxLevel){
        firstLevel = maxLevel - 2;
        secondLevel = maxLevel - 1;
        thirdLevel = maxLevel;
        self.floatIndex = 2;
    } else {
        firstLevel = user.level - 1;
        secondLevel = user.level;
        thirdLevel = user.level + 1;
        self.floatIndex = 1;
    }

    [specs enumerateObjectsUsingBlock:^(BLULevelSpec *spec, NSUInteger idx, BOOL * _Nonnull stop) {
        if (userLevel == spec.rank) {
            userSpec = spec;
        }
        if (spec.rank == firstLevel) {
            firstLevelSpec = spec;
        }
        if (spec.rank == secondLevel) {
            secondLevelSpec = spec;
        }
        if (spec.rank == thirdLevel) {
            thirdLevelSpec = spec;
        }
    }];

    self.floatRatio = ((CGFloat)user.experience - (CGFloat)userSpec.minimumExp) / ((CGFloat)userSpec.maximumExp - (CGFloat)userSpec.minimumExp);

    if (user.experience < userSpec.minimumExp) {
        self.floatRatio = 0.0;
    }

    if (user.experience > userSpec.maximumExp) {
        self.floatRatio = 1.0;
    }

    if (user.experience < 0) {
        self.floatRatio = 0.18;
    }

    if (firstLevelSpec && secondLevelSpec && thirdLevelSpec) {
        [self configWithLeftLevel:firstLevelSpec.rank centerLevel:secondLevelSpec.rank rightLevel:thirdLevelSpec.rank leftExp:firstLevelSpec.minimumExp centerExp:secondLevelSpec.minimumExp rightExp:thirdLevelSpec.minimumExp];
    }

    [UIView animateWithDuration:0.2 animations:^{
        CGFloat itemWidth = self.width / 3.0;
        [_floatIndicator sizeToFit];
        _floatIndicator.y = 0;
        _floatIndicator.centerX = self.floatIndex * itemWidth + itemWidth * self.floatRatio;

        [_levelLabel sizeToFit];
        _levelLabel.centerX = _floatIndicator.width / 2.0;
        _levelLabel.y = BLUThemeMargin * 2;

        [_expLabel sizeToFit];
        _expLabel.centerX = _floatIndicator.width / 2.0;
        _expLabel.y = _levelLabel.bottom;
    } completion:^(BOOL finished) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}

+ (CGFloat)userLevelViewHeight {
    return 96;
}

@end
