//
//  BLUCircleBriefAsyncNode.m
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleBriefAsyncNode.h"
#import "BLUCircle.h"

@implementation BLUCircleBriefAsyncNode

- (instancetype)initWithCircle:(BLUCircle *)circle {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(circle, [BLUCircle class]);

        _circle = circle;

        _circleBackground = [ASDisplayNode new];
        _circleBackground.backgroundColor = [UIColor clearColor];
        _circleBackground.cornerRadius = BLUThemeHighActivityCornerRadius;
        _circleBackground.borderColor = BLUThemeMainColor.CGColor;
        _circleBackground.borderWidth = 1.0;
        _circleBackground.layerBacked = YES;

        _circleImageNode = [[ASNetworkImageNode alloc] initWithWebImage];
        _circleImageNode.URL = circle.logo.originURL;
        _circleImageNode.backgroundColor = [UIColor clearColor];
        _circleImageNode.layerBacked = YES;

        _slogonNode = [ASTextNode new];
        _slogonNode.attributedString = [self attributedSlogon:_circle.slogan];
        _slogonNode.layerBacked = YES;

        _nameNode = [ASTextNode new];
        _nameNode.attributedString = [self attributedName:_circle.name];
        _nameNode.layerBacked = YES;

        _leftLine = [ASDisplayNode new];
        _leftLine.backgroundColor = BLUThemeMainColor;
        _leftLine.layerBacked = YES;

        _rightLine = [ASDisplayNode new];
        _rightLine.backgroundColor = BLUThemeMainColor;
        _rightLine.layerBacked = YES;

        _joinBackground = [ASDisplayNode new];
        _joinBackground.cornerRadius = BLUThemeHighActivityCornerRadius;
        [self configureJoin:_circle.didFollowCircle];

        _joinNode = [ASTextNode new];
        _joinNode.hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10);
        [_joinNode addTarget:self
                      action:@selector(tapAndChangeJoinState:)
            forControlEvents:ASControlNodeEventTouchUpInside];
        _joinNode.attributedString =
        [self attributedJoin:_circle.didFollowCircle];

        [self addSubnode:_circleBackground];
        [self addSubnode:_circleImageNode];
        [self addSubnode:_slogonNode];
        [self addSubnode:_nameNode];
        [self addSubnode:_leftLine];
        [self addSubnode:_rightLine];
        [self addSubnode:_joinBackground];
        [self addSubnode:_joinNode];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize calculatedSize = CGSizeZero;
    if (constrainedSize.width <= 0) {
        constrainedSize.width = [UIScreen mainScreen].bounds.size.width;
    }

    CGFloat requiredHeight = 0;

    CGFloat contentWidth =
    constrainedSize.width - [self cellHorizonPadding] * 2 -
    [self contentMargin] * 2;

    requiredHeight += [self cellVerticalPadding] + [self contentMargin];

    requiredHeight += [self circleImageSize].height;

    requiredHeight += [self contentMargin];

    CGSize slogonSize =
    [_slogonNode measure:CGSizeMake(contentWidth, constrainedSize.height)];

    requiredHeight += slogonSize.height;

    requiredHeight += [self contentMargin];

    CGSize nameSize =
    [_nameNode measure:CGSizeMake(contentWidth, constrainedSize.height)];

    requiredHeight += nameSize.height;

    requiredHeight += [self contentMargin] * 2;

    CGSize joinSize =
    [_joinNode measure:CGSizeMake(constrainedSize.width, constrainedSize.height)];

    requiredHeight += joinSize.height + [self joinBackgroundVerticalPadding] * 2;

    requiredHeight += [self cellVerticalPadding];

    calculatedSize = CGSizeMake(constrainedSize.width, requiredHeight);

    return calculatedSize;
}

- (void)layout {
    [super layout];

    CGFloat circleImageX =
    self.calculatedSize.width / 2.0 - [self circleImageSize].width / 2.0;
    CGFloat circleImageY = [self cellVerticalPadding] + [self contentMargin];
    _circleImageNode.frame =
    CGRectMake(circleImageX, circleImageY,
               [self circleImageSize].width,
               [self circleImageSize].height);

    CGFloat slogonX =
    self.calculatedSize.width / 2.0 - _slogonNode.calculatedSize.width / 2.0;
    CGFloat slogonY = CGRectGetMaxY(_circleImageNode.frame) +
    [self contentMargin];
    _slogonNode.frame =
    CGRectMake(slogonX, slogonY,
               _slogonNode.calculatedSize.width,
               _slogonNode.calculatedSize.height);

    CGFloat nameX =
    self.calculatedSize.width / 2.0 - _nameNode.calculatedSize.width / 2.0;
    CGFloat nameY = CGRectGetMaxY(_slogonNode.frame) + [self contentMargin];
    _nameNode.frame =
    CGRectMake(nameX, nameY,
               _nameNode.calculatedSize.width,
               _nameNode.calculatedSize.height);

    CGSize joinBackgroundSize =
    CGSizeMake(_joinNode.calculatedSize.width +
               [self joinBackgroundHorizonPadding] * 2,
               _joinNode.calculatedSize.height +
               [self joinBackgroundVerticalPadding] * 2);
    CGFloat joinBackgroundX =
    self.calculatedSize.width / 2.0 - joinBackgroundSize.width / 2.0;
    CGFloat joinBackgroundY = CGRectGetMaxY(_nameNode.frame) +
    [self contentMargin] * 2;
    _joinBackground.frame =
    CGRectMake(joinBackgroundX, joinBackgroundY,
               joinBackgroundSize.width, joinBackgroundSize.height);

    CGFloat joinX =
    joinBackgroundX + [self joinBackgroundHorizonPadding];
    CGFloat joinY =
    joinBackgroundY + [self joinBackgroundVerticalPadding];
    _joinNode.frame =
    CGRectMake(joinX, joinY,
               _joinNode.calculatedSize.width,
               _joinNode.calculatedSize.height);

    CGFloat circleBackgroundX = [self cellHorizonPadding];
    CGFloat circleBackgroundY = [self cellVerticalPadding];
    CGFloat circleBackgroundHeight = CGRectGetMidY(_joinBackground.frame) -
    circleBackgroundY;
    CGFloat circleBackgroundWidth = self.calculatedSize.width -
    [self cellHorizonPadding] * 2;
    _circleBackground.frame =
    CGRectMake(circleBackgroundX, circleBackgroundY,
               circleBackgroundWidth,
               circleBackgroundHeight);

    CGFloat leftLineX = [self cellHorizonPadding] + [self contentMargin];
    CGFloat leftLineY = CGRectGetMidY(_nameNode.frame);
    CGFloat leftLineWidth = CGRectGetMinX(_nameNode.frame) -
    [self cellHorizonPadding] - [self contentMargin] * 2;
    _leftLine.frame =
    CGRectMake(leftLineX, leftLineY, leftLineWidth, BLUThemeOnePixelHeight);

    CGFloat rightLineX = CGRectGetMaxX(_nameNode.frame) +
    [self contentMargin];
    CGFloat rightLineY = leftLineY;
    CGFloat rightLineWidth =leftLineWidth;
    _rightLine.frame =
    CGRectMake(rightLineX, rightLineY, rightLineWidth, BLUThemeOnePixelHeight);
    
}

- (void)tapAndChangeJoinState:(id)sender {
    if ([self.delegate
         respondsToSelector:@selector(shouldChangeFollowStateForCircle:from:sender:)]) {
        [self.delegate shouldChangeFollowStateForCircle:_circle
                                                   from:self
                                                 sender:sender];
    }
}

- (CGFloat)cellVerticalPadding {
    return BLUThemeMargin * 4;
}

- (CGFloat)cellHorizonPadding {
    return BLUThemeMargin * 4;
}

- (CGFloat)contentMargin {
    return BLUThemeMargin * 2;
}

- (CGSize)circleImageSize {
    return CGSizeMake(80, 80);
}

- (CGFloat)joinBackgroundHorizonPadding {
    return BLUThemeMargin * 4;
}

- (CGFloat)joinBackgroundVerticalPadding {
    return BLUThemeMargin * 2;
}

- (void)configureJoin:(BOOL)didJoin {
    if (didJoin) {
        _joinBackground.backgroundColor = BLUThemeSubTintBackgroundColor;
        _joinBackground.borderColor = BLUThemeMainColor.CGColor;
        _joinBackground.borderWidth = 1.0;
    } else {
        _joinBackground.backgroundColor = BLUThemeMainColor;
        _joinBackground.borderColor = [UIColor clearColor].CGColor;
        _joinBackground.borderWidth = 0.0;
    }
    _joinNode.attributedString = [self attributedJoin:didJoin];
}

// 只调整Join部分
- (void)setCircle:(BLUCircle *)circle {
    BLUAssertObjectIsKindOfClass(circle, [BLUCircle class]);
    _circle = circle;
    [self configureJoin:_circle.didFollowCircle];
}

@end

@implementation BLUCircleBriefAsyncNode (Text)

- (NSAttributedString *)attributedSlogon:(NSString *)slogon {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName: BLUThemeMainColor,
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};
    return [[NSAttributedString alloc] initWithString:slogon
                                           attributes:attributed];
}

- (NSAttributedString *)attributedName:(NSString *)name {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName: BLUThemeMainColor,
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVeryLarge)};
    return [[NSAttributedString alloc] initWithString:name
                                           attributes:attributed];
}

- (NSAttributedString *)attributedJoin:(BOOL)didJoin {
    NSString *text = nil;
    UIColor *textColor = nil;
    if (didJoin) {
        text = NSLocalizedString(@"circle-brief-async-node.quit", @"Quit");
        textColor = BLUThemeMainColor;
    } else {
        text = NSLocalizedString(@"circle-brief-async-node.join", @"Join");
        textColor = [UIColor whiteColor];
    }
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName: textColor,
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};

    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributed];
}

@end
