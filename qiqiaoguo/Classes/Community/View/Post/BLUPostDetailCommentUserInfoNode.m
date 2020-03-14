//
//  BLUPostDetailCommentUserInfoNode.m
//  Blue
//
//  Created by Bowen on 23/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailCommentUserInfoNode.h"
#import "BLUComment.h"
#import "BLUUserGenderImageNode.h"

#define kLevelTextColor ([UIColor colorWithHue:0.11 saturation:0.64 brightness:0.83 alpha:1])
static const NSInteger kAvatarNodeHeight = 32;

@implementation BLUPostDetailCommentUserInfoNode

- (instancetype)initWithComment:(BLUComment *)comment
                      anonymous:(BOOL)anonymous
                           isUp:(BOOL)isUp {
    if (self = [super init]) {

        BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
        _isUp = isUp;

        _anonymous = anonymous;

        // Avatar
        _avatarNode = [[ASNetworkImageNode alloc] initWithWebImage];
        _avatarNode.layerBacked = YES;
        _avatarNode.clipsToBounds = YES;
        _avatarNode.backgroundColor = BLUThemeSubTintBackgroundColor;
        [self configAvatarWithUser:comment.author anonymous:anonymous];

        // Nickname
        _nicknameNode = [ASTextNode new];
        _nicknameNode.layerBacked = YES;
        _nicknameNode.maximumNumberOfLines = 1;
        _nicknameNode.attributedString =
        [self attributedNickname:comment.author.nickname anonymous:anonymous];

        // User button
        _userButton = [ASButtonNode new];
        _userButton.backgroundColor = [UIColor clearColor];

        // Gender
//        if (!_anonymous) {
//            _genderNode =
//            [self makeGenderWithUser:comment.author anonymous:anonymous];
//            _genderNode.layerBacked = YES;
//        }

//        //Level
//        if (!_anonymous) {
//            _levelNode = [ASTextNode new];
//            _levelNode.layerBacked = YES;
//            _levelNode.attributedString =
//            [self attributedLevel:comment.author.levelDesc];
//
//            _levelBackground = [ASDisplayNode new];
//            _levelBackground.layerBacked = YES;
//            _levelBackground.borderWidth = 1.0;
//            _levelBackground.borderColor = kLevelTextColor.CGColor;
//            _levelBackground.cornerRadius = BLUThemeNormalActivityCornerRadius;
//        }

        _upColor = kLevelTextColor;
        if (_isUp) {
            _upNode = [ASTextNode new];
            _upNode.layerBacked = YES;
            _upNode.attributedString = [self attributedUp];

            _upBackground = [ASDisplayNode new];
            _upBackground.clipsToBounds = YES;
            _upBackground.layerBacked = YES;
            _upBackground.backgroundColor = _upColor;
            _upBackground.borderWidth = 1.0;
            _upBackground.borderColor = _upColor.CGColor;
            _upBackground.cornerRadius = BLUThemeNormalActivityCornerRadius;
        }

        // floor
        _floorNode = [ASTextNode new];
        _floorNode.layerBacked = YES;
        _floorNode.attributedString =
        [self attributedFloor:comment.floorDesc];

        // Time
        _timeImageNode = [ASImageNode new];
        _timeImageNode.layerBacked = YES;
        _timeImageNode.backgroundColor = [UIColor clearColor];
        _timeImageNode.image = [BLUCurrentTheme timeIcon];

        _timeTextNode = [ASTextNode new];
        _timeImageNode.layerBacked = YES;
        _timeTextNode.attributedString =
        [self attributedTime:comment.createDate.postTime];

        _likeButton = [ASButtonNode new];
        _likeButton.imageNode.backgroundColor = [UIColor clearColor];
        _likeButton.contentSpacing = BLUThemeMargin;
        _likeButton.hitTestSlop = UIEdgeInsetsMake(-20, -20, -20, -20);
        [self configureLikeButtonWithComment:comment];

        [self addSubnode:_avatarNode];
        [self addSubnode:_nicknameNode];
        [self addSubnode:_userButton];
//        if (_genderNode) {
//            [self addSubnode:_genderNode];
//        }
//        if (_levelBackground) {
//            [self addSubnode:_levelBackground];
//        }
//        if (_levelNode) {
//            [self addSubnode:_levelNode];
//        }
        if (_upNode != nil && _upBackground != nil) {
            [self addSubnode:_upBackground];
            [self addSubnode:_upNode];
        }
        [self addSubnode:_floorNode];
        [self addSubnode:_timeImageNode];
        [self addSubnode:_timeTextNode];
        [self addSubnode:_likeButton];
    }
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize calculatedSize = CGSizeZero;

    CGFloat margin = BLUThemeMargin;

    [_timeTextNode measure:CGSizeMake(constrainedSize.width,
                                  constrainedSize.height)];

    CGSize levelSize = CGSizeZero;
    if (_levelNode) {
        levelSize =
        [_levelNode measure:CGSizeMake(constrainedSize.width,
                                       constrainedSize.height)];
    }

    CGSize upSize = CGSizeZero;
    if (_upNode) {
        upSize =
        [_upNode measure:CGSizeMake(constrainedSize.width,
                                    constrainedSize.height)];
    }

    [_floorNode measure:CGSizeMake(constrainedSize.width,
                                   constrainedSize.height)];

    CGSize likeSize =
    [_likeButton measure:CGSizeMake(constrainedSize.width,
                                    constrainedSize.height)];

    CGFloat levelWidth = 0.0;
    if (_levelNode) {
        levelWidth = levelSize.width + margin + BLUThemeMargin * 2;
    } else {
        levelWidth = 0.0;
    }

    CGFloat upWidth = 0.0;
    if (_upNode) {
        upWidth = upSize.width + margin + BLUThemeMargin * 2;
    } else {
        upWidth = 0;
    }

    CGFloat nicknameMaxWidth = constrainedSize.width;
    nicknameMaxWidth -= kAvatarNodeHeight + margin;
    nicknameMaxWidth -= levelWidth;
    nicknameMaxWidth -= upWidth;
    nicknameMaxWidth -= likeSize.width + margin;
    if (!_anonymous) {
        nicknameMaxWidth -= [self iconHeight] + margin;
    }
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

    _userButton.frame = CGRectMake(0, 0, CGRectGetMaxX(_nicknameNode.frame),
                                   kAvatarNodeHeight);

    // Gender
    if (_genderNode) {
        CGFloat genderHeight = iconHeight;
        CGFloat genderX = CGRectGetMaxX(_nicknameNode.frame) + margin;
        CGFloat genderY = CGRectGetMidY(_nicknameNode.frame) - genderHeight / 2.0;
        _genderNode.frame =
        CGRectMake(genderX, genderY, genderHeight, genderHeight);
    }

    // Level
    if (_levelNode && _levelBackground) {
        // Level
        CGFloat levelBackgroundHeight = iconHeight + BLUThemeOnePixelHeight * 2;
        CGFloat levelBackgroundWidth =
        _levelNode.calculatedSize.width + BLUThemeMargin * 2;
        CGFloat levelBackgroundX = 0;
        if (_genderNode) {
            levelBackgroundX = CGRectGetMaxX(_genderNode.frame) + margin;
        } else {
            levelBackgroundX = CGRectGetMaxX(_nicknameNode.frame) + margin;
        }
        CGFloat levelBackgroundY =
        CGRectGetMidY(_nicknameNode.frame) - levelBackgroundHeight / 2.0;
        _levelBackground.frame =
        CGRectMake(levelBackgroundX, levelBackgroundY,
                   levelBackgroundWidth, levelBackgroundHeight);

        CGFloat levelTextNodeX =
        levelBackgroundX + BLUThemeMargin + BLUThemeOnePixelHeight;
        CGFloat levelTextNodeY =
        CGRectGetMidY(_levelBackground.frame) -
        _levelNode.calculatedSize.height / 2.0 - BLUThemeOnePixelHeight;
        _levelNode.frame =
        CGRectMake(levelTextNodeX, levelTextNodeY,
                   _levelNode.calculatedSize.width,
                   _levelNode.calculatedSize.height);
    }

    // Up
    if (_upNode != nil && _upBackground != nil) {


        CGFloat upBackgroundHeight = iconHeight + BLUThemeOnePixelHeight * 2;
        CGFloat upBackgroundWidth =
        _upNode.calculatedSize.width + BLUThemeMargin * 2 + BLUThemeOnePixelHeight;

        CGFloat upBackgroundX = CGRectGetMaxX(_nicknameNode.frame) + margin;
        upBackgroundX = _genderNode != nil ?
        CGRectGetMaxX(_genderNode.frame) + margin : upBackgroundX;
        upBackgroundX = _levelBackground != nil ?
        CGRectGetMaxX(_levelBackground.frame) + margin : upBackgroundX;

        CGFloat upBackgroundY =
        CGRectGetMidY(_nicknameNode.frame) - upBackgroundHeight / 2.0;

        _upBackground.frame = CGRectMake(upBackgroundX, upBackgroundY,
                                         upBackgroundWidth, upBackgroundHeight);

        CGFloat upX = upBackgroundX + BLUThemeMargin + BLUThemeOnePixelHeight;
        CGFloat upY =
        CGRectGetMidY(_upBackground.frame) -
        _upNode.calculatedSize.height / 2.0 - BLUThemeOnePixelHeight;
        _upNode.frame = CGRectMake(upX, upY,
                                   _upNode.calculatedSize.width,
                                   _upNode.calculatedSize.height);
    }

    // Like
    CGFloat likeX = self.calculatedSize.width -
    _likeButton.calculatedSize.width;
    CGFloat likeY =
    CGRectGetMidY(_nicknameNode.frame) - _likeButton.calculatedSize.height / 2.0;
    _likeButton.frame =
    CGRectMake(likeX, likeY,
               _likeButton.calculatedSize.width,
               _likeButton.calculatedSize.height);

    // Floor
    CGFloat floorX = nicknameNodeX;
    CGFloat floorY =
    CGRectGetMaxY(_avatarNode.frame) - _floorNode.calculatedSize.height;
    _floorNode.frame =
    CGRectMake(floorX, floorY,
               _floorNode.calculatedSize.width,
               _floorNode.calculatedSize.height);

    // Time
    CGFloat timeImageHeight = 10.0;
    CGFloat timeImageX = CGRectGetMaxX(_floorNode.frame) + margin * 3;
    CGFloat timeImageY = floorY + (_floorNode.calculatedSize.height - timeImageHeight) / 2.0;
    _timeImageNode.frame =
    CGRectMake(timeImageX, timeImageY,
               timeImageHeight, timeImageHeight);

    CGFloat timeTextX = CGRectGetMaxX(_timeImageNode.frame) + margin;
    _timeTextNode.frame =
    CGRectMake(timeTextX, floorY,
               _timeTextNode.calculatedSize.width,
               _timeTextNode.calculatedSize.height);
}

- (void)configAvatarWithUser:(BLUUser *)user
                   anonymous:(BOOL)anonymous {
    if (anonymous) {
        _avatarNode.image = [BLUCurrentTheme anonymousAvatar];
    } else {
        if (user.avatar.thumbnailURL) {
            _avatarNode.URL = user.avatar.thumbnailURL;
        } else {
            _avatarNode.image = user.gender == BLUUserGenderMale ?
            [UIImage imageNamed:@"user-male-avatar-icon"] :
            [UIImage imageNamed:@"user-female-avatar-icon"];
        }
    }
}

- (void)configureLikeButtonWithComment:(BLUComment *)comment {
    [_likeButton setAttributedTitle:
     [self attributedNumberOfLikes:comment.likeCount]
                           forState:ASControlStateNormal];

    if (comment.didLike) {
        [_likeButton setImage:[BLUCurrentTheme postLikeNormalIcon]
                     forState:ASControlStateNormal];
    } else {
        [_likeButton setImage:[BLUCurrentTheme postDislikeNormalIcon]
                     forState:ASControlStateNormal];
    }
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
    if (anonymous) {
        nickname = NSLocalizedString(@"post-detail-user-info-node.anonymous.nickname",
                                     @"Anonymous");
    }
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

- (NSAttributedString *)attributedUp {
    return [[NSAttributedString alloc]
            initWithString:NSLocalizedString(@"post-detal-comment-user-info-node.up",
                                             @"Up")
            attributes:[self upAttributes]];
}

- (NSDictionary *)nicknameAttributes {
    return
    @{NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge),
      NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#999999"]};
}

- (NSDictionary *)timeAttributes {
    return
    @{NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall),
      NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#c1c1c1"]};
}

- (NSDictionary *)levelAttributes {
    return
    @{NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall),
      NSForegroundColorAttributeName: kLevelTextColor};
}

- (NSDictionary *)upAttributes {
    return
    @{NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall),
      NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (CGFloat)iconHeight {
    return 12.0;
}

- (CGSize)avatarSize {
    return CGSizeMake(kAvatarNodeHeight, kAvatarNodeHeight);
}

@end

