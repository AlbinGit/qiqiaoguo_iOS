//
//  BLUPostDetailUserInfoNode.m
//  Blue
//
//  Created by Bowen on 21/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailUserInfoNode.h"
#import "BLUUserGenderImageNode.h"

#define kLevelTextColor ([UIColor colorWithHue:0.11 saturation:0.64 brightness:0.83 alpha:1])
static const NSInteger kAvatarNodeHeight = 44;

@implementation BLUPostDetailUserInfoNode

- (instancetype)initWithUser:(BLUUser *)user
                    postTime:(NSString *)postTime
                   anonymous:(BOOL)anonymous{
    if (self = [super init]) {

        BLUAssertObjectIsKindOfClass(user, [BLUUser class]);
        _anonymous = anonymous;

        _avatarNode = [[ASNetworkImageNode alloc] initWithWebImage];
        _avatarNode.clipsToBounds = YES;
        _avatarNode.backgroundColor = BLUThemeSubTintBackgroundColor;
        if (_anonymous) {
            _avatarNode.image = [BLUCurrentTheme anonymousAvatar];
        } else {
            if (user.avatar.thumbnailURL) {
                _avatarNode.URL = user.avatar.thumbnailURL;
            } else {
                _avatarNode.image = [UIImage imageNamed:@"user_default_icon"];
            }
        }

        _nicknameNode = [ASTextNode new];
        _nicknameNode.maximumNumberOfLines = 1;

        if (_anonymous) {
            _nicknameNode.attributedString =
            [[NSAttributedString alloc]
             initWithString:NSLocalizedString(@"post-detail-user-info-node.anonymous.nickname",
                                              @"Anonymous")
             attributes:[self nicknameAttributes]];
        } else {
            _nicknameNode.attributedString =
            [[NSAttributedString alloc] initWithString:user.nickname
                                            attributes:[self nicknameAttributes]];
        }

//        if (!_anonymous) {
//            _genderNode =
//            [[BLUUserGenderImageNode alloc] initWithGender:user.gender];
//        }

//        if (!_anonymous) {
//            _levelNode = [ASTextNode new];
//            _levelNode.attributedString =
//            [[NSAttributedString alloc] initWithString:user.levelDesc
//                                            attributes:[self levelAttributes]];
//
//            _levelBackground = [ASDisplayNode new];
//            _levelBackground.borderWidth = 1.0;
//            _levelBackground.borderColor = kLevelTextColor.CGColor;
//            _levelBackground.cornerRadius = BLUThemeNormalActivityCornerRadius;
//        }

        // Time
        _timeImageNode = [ASImageNode new];
        _timeImageNode.layerBacked = YES;
        _timeImageNode.backgroundColor = [UIColor clearColor];
        _timeImageNode.image = [BLUCurrentTheme timeIcon];

        _timeNode = [ASTextNode new];
        _timeNode.attributedString =
        [[NSAttributedString alloc] initWithString:postTime
                                        attributes:[self timeAttributes]];

        [self addSubnode:_avatarNode];
        [self addSubnode:_nicknameNode];
//        if (_genderNode) {
//            [self addSubnode:_genderNode];
//        }
//        if (_levelNode) {
//            [self addSubnode:_levelNode];
//        }
//        if (_levelBackground) {
//            [self addSubnode:_levelBackground];
//        }
        [self addSubnode:_timeImageNode];
        [self addSubnode:_timeNode];

        for (ASDisplayNode *node in self.subnodes) {
            node.layerBacked = YES;
        }

        if (_anonymous) {
            self.layerBacked = YES;
        }

    }
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize calculateSize = constrainedSize;

    [_timeNode measure:CGSizeMake(constrainedSize.width,
                                  constrainedSize.height)];
    CGSize levelSize = CGSizeZero;
//    if (_levelNode) {
//        levelSize =
//        [_levelNode measure:CGSizeMake(constrainedSize.width,
//                                       constrainedSize.height)];
//    }

    CGFloat genderHeight = 16.0;
//    CGFloat nicknameSectionWidth =
//    constrainedSize.width + genderHeight + levelSize.width + BLUThemeMargin * 4;
//    if (_anonymous) {
//        nicknameSectionWidth -= genderHeight + BLUThemeMargin * 2;
//    }

    CGFloat nicknameSectionWidth = constrainedSize.width;
    if (!_anonymous) {
        nicknameSectionWidth -= genderHeight + BLUThemeMargin * 2;
    }
    nicknameSectionWidth -= levelSize.width + BLUThemeMargin * 2;
    nicknameSectionWidth -= kAvatarNodeHeight + BLUThemeMargin * 2;

    [_nicknameNode measure:CGSizeMake(nicknameSectionWidth,
                                      constrainedSize.height)];


    calculateSize.height = kAvatarNodeHeight;

    return calculateSize;
}



- (void)layout {
    [super layout];

    _avatarNode.frame =
    CGRectMake(0, 0, kAvatarNodeHeight, kAvatarNodeHeight);
    _avatarNode.cornerRadius = CGRectGetHeight(_avatarNode.frame) / 2.0;

    CGFloat nicknameNodeY = kAvatarNodeHeight / 4.0 - _nicknameNode.calculatedSize.height / 2.0;
    CGFloat nicknameNodeX = kAvatarNodeHeight + BLUThemeMargin * 2;
    _nicknameNode.frame =
    CGRectMake(nicknameNodeX, nicknameNodeY,
               _nicknameNode.calculatedSize.width,
               _nicknameNode.calculatedSize.height);


//    if (_genderNode) {
//        CGFloat genderNodeX =
//        CGRectGetMaxX(_nicknameNode.frame) + BLUThemeMargin * 2;
//        CGFloat genderNodeHeight = [self iconHeight];
//        _genderNode.frame =
//        CGRectMake(genderNodeX,
//                   CGRectGetMidY(_nicknameNode.frame) - genderNodeHeight / 2.0,
//                   genderNodeHeight, genderNodeHeight);
//
//    }
//
//    if (_levelNode) {
//        CGFloat levelNodeX;
//        if (_genderNode) {
//            levelNodeX =
//            CGRectGetMaxX(_genderNode.frame) + BLUThemeMargin * 2;
//        } else {
//            levelNodeX =
//            CGRectGetMaxX(_nicknameNode.frame) + BLUThemeMargin * 2;
//        }
//        CGFloat levelNodeY =
//        CGRectGetMidY(_nicknameNode.frame) - _levelNode.calculatedSize.height / 2.0;
//        _levelNode.frame =
//        CGRectMake(levelNodeX, levelNodeY,
//                   _levelNode.calculatedSize.width,
//                   _levelNode.calculatedSize.height);
//
//        CGFloat levelBackgroundWidth = CGRectGetWidth(_levelNode.frame) + BLUThemeMargin * 2.0;
//        CGFloat levelBackgroundX =
//        levelNodeX -
//        (levelBackgroundWidth - _levelNode.calculatedSize.width) / 2.0 - 0.5;
//        CGFloat levelBackgroundY =
//        levelNodeY + ([self iconHeight] - _levelNode.calculatedSize.height);
//        _levelBackground.frame =
//        CGRectMake(levelBackgroundX, levelBackgroundY, levelBackgroundWidth,
//                   [self iconHeight]);
//    }

    CGFloat timeNodeY =
    kAvatarNodeHeight / 4.0 * 3.0  - _timeNode.calculatedSize.height / 2.0;

    CGFloat timeImageNodeHeight = 10.0;
    CGFloat timeImageNodeX = nicknameNodeX;
    CGFloat timeImageNodeY = timeNodeY;
    _timeImageNode.frame =
    CGRectMake(timeImageNodeX, timeImageNodeY,
               timeImageNodeHeight, timeImageNodeHeight);

    CGFloat timeNodeX = CGRectGetMaxX(_timeImageNode.frame) + BLUThemeMargin;
    timeNodeY = timeNodeY + (timeImageNodeHeight - _timeNode.calculatedSize.height) / 2.0;
    _timeNode.frame =
    CGRectMake(timeNodeX, timeNodeY,
               _timeNode.calculatedSize.width,
               _timeNode.calculatedSize.height);
}

- (CGFloat)iconHeight {
    return 12.0;
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

@end
