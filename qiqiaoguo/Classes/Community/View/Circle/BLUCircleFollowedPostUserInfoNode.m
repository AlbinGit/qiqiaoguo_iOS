//
//  BLUCircleFollowUserInfoNode.m
//  Blue
//
//  Created by Bowen on 27/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleFollowedPostUserInfoNode.h"
#import "BLUPost.h"
#import "BLUUserGenderImageNode.h"

#define kLevelTextColor ([UIColor colorWithHue:0.11 saturation:0.64 brightness:0.83 alpha:1])
static const NSInteger kAvatarNodeHeight = 32;

@implementation BLUCircleFollowedPostUserInfoNode

- (instancetype)initWithPost:(BLUPost *)post
                 followState:(BLUCircleFollowedPostUserInfoFollowState)state {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(post, [BLUPost class]);

        _post = post;
        _anonymous = NO;
        _state = state;

        // Avatar
        _avatarNode = [[ASNetworkImageNode alloc] initWithWebImage];
        _avatarNode.layerBacked = YES;
        _avatarNode.clipsToBounds = YES;
        _avatarNode.backgroundColor = BLUThemeSubTintBackgroundColor;
        [self configAvatarWithUser:post.author anonymous:_anonymous];

        // Nickname
        _nicknameNode = [ASTextNode new];
        _nicknameNode.layerBacked = YES;
        _nicknameNode.maximumNumberOfLines = 1;
        _nicknameNode.attributedString =
        [self attributedNickname:post.author.nickname anonymous:_anonymous];

        // Gender
//        _genderNode =
//        [self makeGenderWithUser:post.author anonymous:_anonymous];
//        _genderNode.layerBacked = YES;

        //Level
//        _levelNode = [ASTextNode new];
//        _levelNode.layerBacked = YES;
//        _levelNode.attributedString =
//        [self attributedLevel:post.author.levelDesc];

//        _levelBackground = [ASDisplayNode new];
//        _levelBackground.layerBacked = YES;
//        _levelBackground.borderWidth = 1.0;
//        _levelBackground.borderColor = kLevelTextColor.CGColor;
//        _levelBackground.cornerRadius = BLUThemeNormalActivityCornerRadius;

        // Time
        _timeImageNode = [ASImageNode new];
        _timeImageNode.layerBacked = YES;
        _timeImageNode.backgroundColor = [UIColor clearColor];
        _timeImageNode.image = [BLUCurrentTheme timeIcon];

        _timeTextNode = [ASTextNode new];
        _timeImageNode.layerBacked = YES;
        _timeTextNode.attributedString =
        [self attributedTime:post.createDate.postTime];

        _followNode = [ASTextNode new];

        _followBackground = [ASControlNode new];
        _followBackground.cornerRadius = BLUThemeNormalActivityCornerRadius;
        _followBackground.hitTestSlop = UIEdgeInsetsMake(-20, -10, -20, -10);
        [_followBackground addTarget:self
                              action:@selector(tapAndChangeFollowState:)
                    forControlEvents:ASControlNodeEventTouchUpInside];
        [self configureFollowWithState:state];

        [self addSubnode:_avatarNode];
        [self addSubnode:_nicknameNode];
//        if (_genderNode) {
//            [self addSubnode:_genderNode];
//        }
//        [self addSubnode:_levelNode];
//        [self addSubnode:_levelBackground];
        [self addSubnode:_timeImageNode];
        [self addSubnode:_timeTextNode];
        [self addSubnode:_followBackground];
        [self addSubnode:_followNode];
    }
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize calculatedSize = CGSizeZero;

    CGFloat margin = BLUThemeMargin;

    CGSize nicknameSize =
    [_nicknameNode measure:CGSizeMake(constrainedSize.width,
                                      constrainedSize.height)];

    [_timeTextNode measure:CGSizeMake(constrainedSize.width,
                                      constrainedSize.height)];

    CGSize levelSize =
    [_levelNode measure:CGSizeMake(constrainedSize.width,
                                   constrainedSize.height)];

    CGSize followSize =
    [_followNode measure:CGSizeMake(constrainedSize.width, [self iconHeight])];
    followSize = [self followNodeSizeFromCalculatedSize:followSize];

    CGFloat levelWidth = levelSize.width + BLUThemeMargin * 2;
    CGFloat nicknameMaxWidth =
    constrainedSize.width - levelWidth - followSize.width - margin * 2 - kAvatarNodeHeight - margin * 2;
    if (!_anonymous) {
        nicknameMaxWidth -= [self iconHeight] - margin;
    }
    nicknameSize =
    [_nicknameNode measure:CGSizeMake(nicknameMaxWidth,
                                      constrainedSize.height)];

    calculatedSize.width = constrainedSize.width;
    calculatedSize.height = kAvatarNodeHeight;

    return calculatedSize;
}

- (void)layout {
    [super layout];
    CGFloat margin = BLUThemeMargin;

    // Avatar
    _avatarNode.frame =
    CGRectMake(0, 0, kAvatarNodeHeight, kAvatarNodeHeight);
    _avatarNode.cornerRadius = CGRectGetHeight(_avatarNode.frame) / 2.0;

    // Nickname
    CGFloat nicknameNodeX = CGRectGetMaxX(_avatarNode.frame) + margin;
    _nicknameNode.frame =
    CGRectMake(nicknameNodeX, 0,
               _nicknameNode.calculatedSize.width,
               _nicknameNode.calculatedSize.height);

    CGFloat iconHeight = [self iconHeight];

    // Gender
//    if (_genderNode) {
//        CGFloat genderHeight = iconHeight;
//        CGFloat genderX = CGRectGetMaxX(_nicknameNode.frame) + margin;
//        CGFloat genderY = CGRectGetMidY(_nicknameNode.frame) - genderHeight / 2.0;
//        _genderNode.frame =
//        CGRectMake(genderX, genderY, genderHeight, genderHeight);
//    }

    // Level
//    CGFloat levelBackgroundHeight = iconHeight;
//    CGFloat levelBackgroundWidth =
//    _levelNode.calculatedSize.width + BLUThemeMargin * 2;
//    CGFloat levelBackgroundX = 0;
//    if (_genderNode) {
//        levelBackgroundX = CGRectGetMaxX(_genderNode.frame) + margin;
//    } else {
//        levelBackgroundX = CGRectGetMaxX(_nicknameNode.frame) + margin;
//    }
//    CGFloat levelBackgroundY =
//    CGRectGetMidY(_nicknameNode.frame) - levelBackgroundHeight / 2.0;
//    _levelBackground.frame =
//    CGRectMake(levelBackgroundX, levelBackgroundY,
//               levelBackgroundWidth, levelBackgroundHeight);
//
//    CGFloat levelTextNodeX = levelBackgroundX + BLUThemeMargin;
//    CGFloat levelTextNodeY =
//    CGRectGetMidY(_levelBackground.frame) -
//    _levelNode.calculatedSize.height / 2.0;
//    _levelNode.frame =
//    CGRectMake(levelTextNodeX, levelTextNodeY,
//               _levelNode.calculatedSize.width,
//               _levelNode.calculatedSize.height);

    // Follow
    CGSize followBackgroundSize =
    [self followNodeSizeFromCalculatedSize:_followNode.calculatedSize];
    CGFloat followBackgroundX = self.calculatedSize.width -
    followBackgroundSize.width;
    CGFloat followBackgroundY = CGRectGetMinY(_avatarNode.frame);
    _followBackground.frame =
    CGRectMake(followBackgroundX, followBackgroundY,
               followBackgroundSize.width,
               followBackgroundSize.height);

    CGFloat followNodeX = followBackgroundX +
    (followBackgroundSize.width - _followNode.calculatedSize.width) / 2.0;
    CGFloat followNodeY = followBackgroundY +
    (followBackgroundSize.height - _followNode.calculatedSize.height) / 2.0;
    _followNode.frame =
    CGRectMake(followNodeX, followNodeY,
               _followNode.calculatedSize.width,
               _followNode.calculatedSize.height);

    // Time
    CGFloat timeImageHeight = 10.0;
    CGFloat timeImageX = nicknameNodeX;
    CGFloat timeImageY = CGRectGetMaxY(_avatarNode.frame) - timeImageHeight;
    _timeImageNode.frame =
    CGRectMake(timeImageX, timeImageY,
               timeImageHeight, timeImageHeight);

    CGFloat timeTextX = CGRectGetMaxX(_timeImageNode.frame) + margin;
    CGFloat timeTextY =
    timeImageY + (timeImageHeight - _timeTextNode.calculatedSize.height) / 2.0;
    _timeTextNode.frame =
    CGRectMake(timeTextX, timeTextY,
               _timeTextNode.calculatedSize.width,
               _timeTextNode.calculatedSize.height);
}

// 只对关注进行更改
- (void)setPost:(BLUPost *)post {
    BLUAssertObjectIsKindOfClass(post, [BLUPost class]);
    _post = post;

    
}

- (void)configAvatarWithUser:(BLUUser *)user
                   anonymous:(BOOL)anonymous {
    if (anonymous) {
        _avatarNode.image = [BLUCurrentTheme anonymousAvatar];
    } else {
        _avatarNode.URL = user.avatar.thumbnailURL;
    }
}

- (void)configureFollowWithState:(BLUCircleFollowedPostUserInfoFollowState)state {
    _followBackground.borderColor = BLUThemeMainColor.CGColor;

    switch (state) {
        case BLUCircleFollowUserInfoFollowStateFollow: {
            _followBackground.hidden = NO;
            _followNode.hidden = NO;
            _followBackground.backgroundColor = BLUThemeMainColor;
            _followNode.attributedString = [self attributedFollowWithState:state];
            _followBackground.borderWidth = 0.0;
            _followBackground.borderColor = [UIColor clearColor].CGColor;
        } break;
        case BLUCircleFollowUserInfoFollowStateDidFollow: {
            _followBackground.hidden = NO;
            _followNode.hidden = NO;
            _followBackground.backgroundColor = [UIColor clearColor];
            _followNode.attributedString = [self attributedFollowWithState:state];
            _followBackground.borderWidth = 1.0;
            _followBackground.borderColor = BLUThemeMainColor.CGColor;
        } break;
        case BLUCircleFollowUserInfoFollowStateNoFollow: {
            _followBackground.hidden = YES;
            _followNode.hidden = YES;
        } break;
    }
    [self setNeedsLayout];
}

- (BLUUserGenderImageNode *)makeGenderWithUser:(BLUUser *)user
                                     anonymous:(BOOL)anonymous {
    if (anonymous) {
        return nil;
    } else {
        BLUUserGenderImageNode *node =
        [[BLUUserGenderImageNode alloc] initWithGender:user.gender];
        return node;
    }
}

- (NSAttributedString *)attributedFollowWithState:(BLUCircleFollowedPostUserInfoFollowState)state {
    NSString *text;
    UIColor *textColor;

    switch (state) {
        case BLUCircleFollowUserInfoFollowStateFollow: {
            text = NSLocalizedString(@"circle-followed-post-user-info-node.follow", @"Follow");
            textColor = [UIColor whiteColor];
        } break;
        case BLUCircleFollowUserInfoFollowStateDidFollow: {
            text = NSLocalizedString(@"circle-followed-post-user-info-node.did-follow", @"Followed");
            textColor = BLUThemeMainColor;
        } break;
        case BLUCircleFollowUserInfoFollowStateNoFollow: {
            return nil;
        } break;
    }

    NSDictionary *attributes =
    @{NSForegroundColorAttributeName: textColor,
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall)};

    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributes];
}

- (NSAttributedString *)attributedNumberOfLikes:(NSInteger)numberOfLikes {
    NSDictionary *numberOfLikesAttributes = @{
                                              NSForegroundColorAttributeName: BLUThemeMainColor,
                                              NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall),
                                              };
    NSString *text = @(numberOfLikes).description;
    return [[NSAttributedString alloc] initWithString:text
                                           attributes:numberOfLikesAttributes];
}

- (NSAttributedString *)attributedNickname:(NSString *)nickname anonymous:(BOOL)anonymous{
    return [[NSAttributedString alloc] initWithString:nickname
                                           attributes:[self nicknameAttributes]];
}

- (NSAttributedString *)attributedFloor:(NSString *)floorDesc {
    return [[NSAttributedString alloc] initWithString:floorDesc
                                           attributes:[self timeAttributes]];
}

- (NSAttributedString *)attributedTime:(NSString *)time {
    return [[NSAttributedString alloc] initWithString:time
                                           attributes:[self timeAttributes]];
}

- (NSAttributedString *)attributedLevel:(NSString *)level {
    return [[NSAttributedString alloc] initWithString:level
                                           attributes:[self levelAttributes]];
}

- (NSDictionary *)nicknameAttributes {
    return @{
             NSFontAttributeName:
                 BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge),
             NSForegroundColorAttributeName:
                 [UIColor colorFromHexString:@"#999999"],
             };
}

- (NSDictionary *)timeAttributes {
    return @{
             NSFontAttributeName:
                 BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall),
             NSForegroundColorAttributeName:
                 [UIColor colorFromHexString:@"#c1c1c1"],
             };
}

- (NSDictionary *)levelAttributes {
    return @{
             NSFontAttributeName:
                 BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall),
             NSForegroundColorAttributeName:
                 kLevelTextColor,
             };
}

- (CGFloat)iconHeight {
    return 14.0;
}

- (CGSize)avatarSize {
    return CGSizeMake(kAvatarNodeHeight, kAvatarNodeHeight);
}

- (CGFloat)followNodeVerticalMargin {
    return BLUThemeMargin * 1;
}

- (CGFloat)followNodeHorizonMargin {
    return BLUThemeMargin * 2.5;
}

- (CGSize)followNodeSizeFromCalculatedSize:(CGSize)size {
    return CGSizeMake([self followNodeHorizonMargin] * 5,
                      size.height + [self followNodeVerticalMargin] * 3);
}

- (void)tapAndChangeFollowState:(id)sender {
    if ([self.delegate
         respondsToSelector:@selector(shouldChangeFollowStateForUser:from:sender:)]) {
        [self.delegate shouldChangeFollowStateForUser:self.post.author
                                                 from:self
                                               sender:sender];
    }
}

@end
