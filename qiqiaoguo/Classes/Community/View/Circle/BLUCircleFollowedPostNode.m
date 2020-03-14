//
//  BLUCircleFollowNode.m
//  Blue
//
//  Created by Bowen on 27/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleFollowedPostNode.h"
#import "BLUPost.h"
#import "BLUCircleFollowedPostUserInfoNode.h"
#import "BLUPostCommonComentNode.h"
#import "BLUPostCommonLikeNode.h"
#import "BLUCircle.h"
#import "BLUVideoIndicatorImageNode.h"

static const NSInteger BLUPostCommonNodeMaximumDisplayImageCount = 3;

@implementation BLUCircleFollowedPostNode

- (instancetype)initWithPost:(BLUPost *)post {
    if (self = [super init]) {
        NSParameterAssert([post isKindOfClass:[BLUPost class]]);

        _post = post;

        _backgroundNode = [ASDisplayNode new];
        _backgroundNode.backgroundColor = [UIColor whiteColor];

        // TODO:设置关注状态
        BLUCircleFollowedPostUserInfoFollowState state =
        [self circleFollowStateFromPost:_post];
        _userNode = [[BLUCircleFollowedPostUserInfoNode alloc] initWithPost:post
                                                                followState:state];
        [_userNode addTarget:self
                      action:@selector(tapAndShowUserDetail:)
            forControlEvents:ASControlNodeEventTouchUpInside];

        _titleNode = [ASTextNode new];
        _titleNode.maximumNumberOfLines = 1;
        _titleNode.truncationMode = NSLineBreakByTruncatingTail;
        _titleNode.attributedString =
        [[NSAttributedString alloc] initWithString:_post.title
                                        attributes:[self titleAttributes]];

        if (post.hasVideo) {
            _videoImageNode = [ASImageNode new];
            _videoImageNode.backgroundColor = [UIColor clearColor];
            _videoImageNode.image = [UIImage imageNamed:@"post-play-video-subscript"];
        }

        _contentNode = [ASTextNode new];
        _contentNode.maximumNumberOfLines = 2;
        if (_post.content) {
            _contentNode.attributedString =
            [[NSAttributedString alloc] initWithString:_post.content
                                            attributes:[self contentAttributes]];
        }

        NSMutableArray *imageNodes = [NSMutableArray new];
        [_post.photos enumerateObjectsUsingBlock:^(BLUImageRes *imageRes,
                                                   NSUInteger idx,
                                                   BOOL * _Nonnull stop) {
            if (idx < BLUPostCommonNodeMaximumDisplayImageCount) {
                BLUVideoIndicatorImageNode * imageNode =
                [[BLUVideoIndicatorImageNode alloc] initWithWebImage];
                imageNode.defaultImage = ImageNamed(@"post-image-default");
                if (_post.hasVideo) {
                    imageNode.showVideoIndicator = YES;
                }
                
                imageNode.URL = imageRes.thumbnailURL;
                imageNode.backgroundColor = BLUThemeSubTintBackgroundColor;
                [imageNodes addObject:imageNode];
            } else {
                *stop = YES;
            }
        }];

        _imageNodes = imageNodes;

        if (_post.photoCount > BLUPostCommonNodeMaximumDisplayImageCount) {
            _imageCountPrompter = [ASTextNode new];
            NSString * text =
            [NSString
             stringWithFormat:
             NSLocalizedString(@"post-common-opt-cell.image-prompt-label.title.%@",
                               @"title"),
             @(_post.photos.count)];
            _imageCountPrompter.attributedString =
            [[NSAttributedString alloc] initWithString:text
                                            attributes:[self footerAttributes]];

            _imageCountBackgroundNode = [ASDisplayNode new];
            _imageCountBackgroundNode.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
            _imageCountBackgroundNode.cornerRadius = BLUThemeNormalActivityCornerRadius;
        } else {
            _imageCountPrompter = nil;
            _imageCountBackgroundNode = nil;
        }

        _likeNode = [[BLUPostCommonLikeNode alloc] initWithLikesCount:post.likeCount liked:NO];

        _comentNode = [[BLUPostCommonComentNode alloc] initWithComentsCount:post.commentCount];

        _circleNode = [ASTextNode new];
        _circleNode.attributedString = [self attributedCircle:post.circle];

        _circleBackgroundNode = [ASControlNode new];
        _circleBackgroundNode.backgroundColor =
        [UIColor colorFromHexString:@"eeeeee"];
        _circleBackgroundNode.cornerRadius = BLUThemeNormalActivityCornerRadius;
        [_circleBackgroundNode addTarget:self
                                  action:@selector(tapAndShowCircleDetail:)
                        forControlEvents:ASControlNodeEventTouchUpInside];

        _separator = [ASDisplayNode new];
        _separator.backgroundColor = BLUThemeSubTintBackgroundColor;

        [self addSubnode:_backgroundNode];
        [self addSubnode:_userNode];
        [self addSubnode:_titleNode];
        if (_videoImageNode) {
            [self addSubnode:_videoImageNode];
        }
        [self addSubnode:_contentNode];
        if (_tagImageNode) {
            [self addSubnode:_tagImageNode];
        }
        for (ASNetworkImageNode *imageNode in _imageNodes) {
            [self addSubnode:imageNode];
        }
        if (_imageCountBackgroundNode) {
            [self addSubnode:_imageCountBackgroundNode];
        }
        if (_imageCountPrompter) {
            [self addSubnode:_imageCountPrompter];
        }
        [self addSubnode:_circleBackgroundNode];
        [self addSubnode:_circleNode];
        [self addSubnode:_likeNode];
        [self addSubnode:_comentNode];
        [self addSubnode:_separator];
    }
    return self;
}

- (NSInteger)maximumDisplayImageCount {
    return BLUPostCommonNodeMaximumDisplayImageCount;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    constrainedSize.width = [UIScreen mainScreen].bounds.size.width;
    CGFloat topInset = 0.0;
    CGFloat leftInset = 0.0;
    CGFloat contentInset = BLUThemeMargin * 4;
    CGFloat contentMargin = BLUThemeMargin * 2;
    CGFloat contentWidth = constrainedSize.width - leftInset * 2 - contentInset * 2;

    CGFloat titleNodeMaxWidth = 0;

    if (_tagImageNode) {
        titleNodeMaxWidth =
        constrainedSize.width - leftInset - contentInset - _tagImageNode.image.size.width - contentMargin;
    } else {
        titleNodeMaxWidth = contentWidth;
    }

    if (_videoImageNode) {
        titleNodeMaxWidth -= contentMargin + _videoImageNode.image.size.width;
    }

    CGSize userSize =
    [_userNode measure:CGSizeMake(contentWidth, constrainedSize.height)];

    CGSize titleSize =
    [_titleNode measure:CGSizeMake(titleNodeMaxWidth, constrainedSize.height)];
    CGSize contentSize =
    [_contentNode measure:CGSizeMake(contentWidth, constrainedSize.height)];

    CGFloat imageHeight = (contentWidth - (BLUPostCommonNodeMaximumDisplayImageCount - 1) * contentMargin) / BLUPostCommonNodeMaximumDisplayImageCount;

    [_imageCountPrompter measure:CGSizeMake(imageHeight - BLUThemeMargin * 2, imageHeight)];

    CGSize likeSize =
    [_likeNode measure:CGSizeMake(constrainedSize.width, constrainedSize.height)];
    [_comentNode measure:CGSizeMake(constrainedSize.width, constrainedSize.height)];

    [_circleNode measure:CGSizeMake(constrainedSize.width, constrainedSize.height)];

    NSInteger sectionCount = 0;

    CGFloat (^acturlMargin)(NSInteger, CGFloat) = ^ CGFloat(NSInteger count, CGFloat margin) {
        if (count > 0) {
            return margin;
        } else {
            return 0.0;
        }
    };

    CGFloat requiredHeight = topInset + contentInset;
    if (userSize.height > 0) {
        requiredHeight += userSize.height;
        sectionCount += 1;
    }

    if (titleSize.height > 0) {
        requiredHeight += titleSize.height + acturlMargin(sectionCount, contentMargin);
        sectionCount += 1;
    }

    if (contentSize.height > 0) {
        requiredHeight += acturlMargin(sectionCount, contentMargin) + contentSize.height;
        sectionCount += 1;
    }

    if (_imageNodes.count > 0) {
        requiredHeight += acturlMargin(sectionCount, contentMargin) + imageHeight;
    }

    requiredHeight += likeSize.height + acturlMargin(sectionCount, contentMargin);

    requiredHeight += contentInset + topInset;

    requiredHeight += [self separatorHeight];

    return CGSizeMake(constrainedSize.width, requiredHeight);
}

- (void)layout {
    [super layout];

    CGFloat topInset = 0.0;
    CGFloat leftInset = 0.0;
    CGFloat contentInset = BLUThemeMargin * 4;
    CGFloat contentMargin = BLUThemeMargin * 2;
    CGFloat contentWidth = self.calculatedSize.width - leftInset * 2 - contentInset * 2;
    CGFloat contentX = leftInset + contentInset;
    CGFloat lastBottom = topInset + contentInset;
    NSInteger sectionCount = 0;

    if (_userNode.calculatedSize.height > 0) {
        _userNode.frame = CGRectMake(contentX,
                                     lastBottom + sectionCount * contentMargin,
                                     _userNode.calculatedSize.width,
                                     _userNode.calculatedSize.height);
        lastBottom += _userNode.calculatedSize.height;
        sectionCount += 1;
    }

    if (_titleNode.calculatedSize.height > 0) {
        CGFloat titleX = contentX;
        if (_videoImageNode) {
            _videoImageNode.frame =
            CGRectMake(contentX,
                       lastBottom + sectionCount * contentMargin + 2,
                       _videoImageNode.image.size.width,
                       _videoImageNode.image.size.height);
        }

        titleX += contentMargin + _videoImageNode.image.size.width;
        _titleNode.frame = CGRectMake(titleX, lastBottom + sectionCount * contentMargin,
                                      _titleNode.calculatedSize.width,
                                      _titleNode.calculatedSize.height);
        lastBottom += _titleNode.calculatedSize.height;
        sectionCount += 1;
    }

    if (_contentNode.calculatedSize.height > 0) {
        _contentNode.frame = CGRectMake(contentX, lastBottom + contentMargin * sectionCount,
                                        _contentNode.calculatedSize.width,
                                        _contentNode.calculatedSize.height + BLUThemeMargin);
        lastBottom += _contentNode.calculatedSize.height;
        sectionCount += 1;
    }

    if (_imageNodes.count > 0) {
        CGFloat imageNodeX = contentX;
        CGFloat imageHeight = (contentWidth - (BLUPostCommonNodeMaximumDisplayImageCount - 1) * contentMargin) / BLUPostCommonNodeMaximumDisplayImageCount;
        for (NSInteger i = 0;
             i < BLUPostCommonNodeMaximumDisplayImageCount &&
             i < _imageNodes.count;
             ++i) {
            ASNetworkImageNode *imageNode = _imageNodes[i];
            imageNode.defaultImage = ImageNamed(@"post-image-default");
            imageNode.frame = CGRectMake(imageNodeX, lastBottom + contentMargin * sectionCount,
                                         imageHeight, imageHeight);
            imageNodeX += imageHeight + contentMargin;
        }

        lastBottom += imageHeight;
        sectionCount += 1;
    }

    CGFloat controlY = lastBottom + contentMargin * sectionCount;
    CGFloat circleVerticalMargin = BLUThemeMargin;
    CGFloat circleHorizonMargin = BLUThemeMargin;
    CGSize circleBackgroundSize =
    CGSizeMake(_circleNode.calculatedSize.width + circleHorizonMargin * 2,
               _circleNode.calculatedSize.height + circleVerticalMargin * 2);
    _circleBackgroundNode.frame =
    CGRectMake(contentX, controlY, circleBackgroundSize.width,
               circleBackgroundSize.height);

    _circleNode.frame =
    CGRectMake(contentX + circleHorizonMargin,
               controlY + circleVerticalMargin,
               _circleNode.calculatedSize.width,
               _circleNode.calculatedSize.height);

    CGFloat comentX = self.calculatedSize.width - _comentNode.calculatedSize.width - contentInset - leftInset;
    _comentNode.frame = CGRectMake(comentX, controlY, _comentNode.calculatedSize.width, _comentNode.calculatedSize.height);

    CGFloat likeX = comentX - contentMargin - _likeNode.calculatedSize.width;
    _likeNode.frame = CGRectMake(likeX, controlY, _likeNode.calculatedSize.width, _likeNode.calculatedSize.height);

    _backgroundNode.frame = CGRectMake(leftInset, topInset, contentWidth + contentInset * 2, self.calculatedSize.height - topInset * 2 - [self separatorHeight]);

    if (_imageCountPrompter && _imageCountBackgroundNode) {
        CGFloat horizonInset= BLUThemeMargin;
        CGFloat verticalInset = BLUThemeMargin / 2.0;
        CGFloat counterX = self.calculatedSize.width - leftInset - contentInset - contentMargin - _imageCountPrompter.calculatedSize.width;
        ASNetworkImageNode *imageNode = _imageNodes.lastObject;
        CGFloat counterY = imageNode.frame.size.height + imageNode.frame.origin.y - _imageCountPrompter.calculatedSize.height - contentMargin + verticalInset;
        _imageCountPrompter.frame = CGRectMake(counterX, counterY,
                                               _imageCountPrompter.calculatedSize.width,
                                               _imageCountPrompter.calculatedSize.height);

        _imageCountBackgroundNode.frame =
        CGRectMake(counterX - horizonInset, counterY - verticalInset,
                   _imageCountPrompter.calculatedSize.width + horizonInset * 2,
                   _imageCountPrompter.calculatedSize.height + verticalInset * 2);
    }

    if (_tagImageNode.image) {
        CGFloat x = self.calculatedSize.width - _tagImageNode.image.size.width - leftInset;
        CGFloat y = self.titleNode.frame.origin.y + self.titleNode.frame.size.height / 2.0 - _tagImageNode.image.size.height / 2.0;
        CGFloat width = _tagImageNode.image.size.width;
        CGFloat height = _tagImageNode.image.size.height;
        _tagImageNode.frame = CGRectMake(x, y, width, height);

        CGRect titleFrame = _titleNode.frame;
        CGFloat titleMaxWidth = self.calculatedSize.width - contentInset - width - leftInset * 2;
        titleFrame.size.width =
        titleFrame.size.width > titleMaxWidth ? titleMaxWidth : titleFrame.size.width;
        _titleNode.frame = titleFrame;
    }

    CGFloat separatorY = CGRectGetMaxY(_backgroundNode.frame);
    _separator.frame = CGRectMake(0, separatorY,
                                  self.calculatedSize.width,
                                  [self separatorHeight]);
}

- (CGFloat)separatorHeight {
    return BLUThemeMargin * 2;
}

- (void)tapAndShowCircleDetail:(id)sender {
    if ([self.delegate
         respondsToSelector:@selector(shouldShowCircleDetails:from:sender:)]) {
        [self.delegate shouldShowCircleDetails:_post.circle
                                          from:self
                                        sender:sender];
    }
}

- (void)tapAndShowUserDetail:(id)sender {
    if ([self.delegate
         respondsToSelector:@selector(shouldShowUserDetails:from:sender:)]) {
        [self.delegate shouldShowUserDetails:_post.author
                                        from:self
                                      sender:sender];
    }
}

- (BLUCircleFollowedPostUserInfoFollowState)circleFollowStateFromPost:(BLUPost *)post {
    if (post.isRecommend) {
        if (post.didFollow) {
            return BLUCircleFollowUserInfoFollowStateDidFollow;
        } else {
            return BLUCircleFollowUserInfoFollowStateFollow;
        }
    } else {
        return BLUCircleFollowUserInfoFollowStateNoFollow;
    }
}

@end

@implementation BLUCircleFollowedPostNode (Text)

- (NSDictionary *)titleAttributes {
    return @{
             NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge),
             NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#333333"],
             };
}

- (NSDictionary *)contentAttributes {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:4];
    return @{
             NSParagraphStyleAttributeName: paragraphStyle,
             NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal),
             NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#666666"],
             };
}

- (NSDictionary *)footerAttributes {
    return @{
             NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall),
             NSForegroundColorAttributeName:
                 [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1],
             };
}

- (NSAttributedString *)attributedCircle:(BLUCircle *)circle {
    BLUAssertObjectIsKindOfClass(circle, [BLUCircle class]);
    NSDictionary *attributed =
    @{NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall),
      NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#a3a3a3"]};
    return [[NSAttributedString alloc] initWithString:circle.name
                                           attributes:attributed];
}

@end
