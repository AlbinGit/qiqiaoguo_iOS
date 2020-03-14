//
//  BLUPostCommonNode.m
//  Blue
//
//  Created by Bowen on 11/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommonNode.h"
#import "BLUPost.h"
#import "BLUPostCommonAuthorNode.h"
#import "BLUPostCommonLikeNode.h"
#import "BLUPostCommonComentNode.h"
#import "BLUVideoIndicatorImageNode.h"

static const NSInteger BLUPostCommonNodeMaximumDisplayImageCount = 3;

@interface BLUPostCommonNode ()

@end

@implementation BLUPostCommonNode

- (instancetype)initWithPost:(BLUPost *)post {
    if (self = [super init]) {
        NSParameterAssert([post isKindOfClass:[BLUPost class]]);
        

        _post = post;
        _backgroundNode = [ASDisplayNode new];
        _backgroundNode.backgroundColor = [UIColor whiteColor];
        _backgroundNode.cornerRadius = BLUThemeHighActivityCornerRadius;

        if (post.hasVideo) {
            _videoImageNode = [ASImageNode new];
            _videoImageNode.backgroundColor = [UIColor clearColor];
            _videoImageNode.image = [UIImage imageNamed:@"post-play-video-subscript"];
        }

        _titleNode = [ASTextNode new];
        _titleNode.maximumNumberOfLines = 1;
        _titleNode.flexShrink = YES;
        _titleNode.truncationMode = NSLineBreakByTruncatingTail;
        _titleNode.attributedString =
        [[NSAttributedString alloc] initWithString:_post.title
                                        attributes:[self titleAttributes]];

        _contentNode = [ASTextNode new];
        _contentNode.maximumNumberOfLines = 2;
        if (_post.content != NULL) {
            _contentNode.attributedString =
            [[NSAttributedString alloc] initWithString:_post.content
                                            attributes:[self contentAttributes]];
        }

        if (_post.postType == BLUPostTypeFeature ||
            _post.isTop) {
            _tagImageNode = [ASImageNode new];
            _tagImageNode.backgroundColor = [UIColor clearColor];
            if (_post.isTop) {
                _tagImageNode.image = [UIImage imageNamed:@"post-common-recommended"];
            } else {
                _tagImageNode.image = [UIImage imageNamed:@"post-common-featured"];
            }
        } else {
            _tagImageNode = nil;
        }

        NSMutableArray *imageNodes = [NSMutableArray new];
        [_post.photos enumerateObjectsUsingBlock:^(BLUImageRes *imageRes,
                                                   NSUInteger idx,
                                                   BOOL * _Nonnull stop) {
            if (idx < BLUPostCommonNodeMaximumDisplayImageCount) {
                BLUVideoIndicatorImageNode * imageNode =
                [[BLUVideoIndicatorImageNode alloc] initWithWebImage];
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
        

        _authorNode = [[BLUPostCommonAuthorNode alloc] initWithAuthor:post.author
                                                           createDate:post.createDate
                                                            anonymous:_post.anonymousEnable];
        _authorNode.flexShrink = YES;

        _likeNode = [[BLUPostCommonLikeNode alloc] initWithLikesCount:post.likeCount liked:NO];

        _comentNode = [[BLUPostCommonComentNode alloc] initWithComentsCount:post.commentCount];

        for (ASDisplayNode *node in self.subnodes) {
            node.layerBacked = YES;
        }

        [self addSubnode:_backgroundNode];
        if (_videoImageNode) {
            [self addSubnode:_videoImageNode];
        }
        [self addSubnode:_titleNode];
        [self addSubnode:_contentNode];
        if (_tagImageNode) {
            [self addSubnode:_tagImageNode];
        }
        for (BLUVideoIndicatorImageNode *imageNode in _imageNodes) {
            [self addSubnode:imageNode];
        }
        if (_imageCountBackgroundNode) {
            [self addSubnode:_imageCountBackgroundNode];
        }
        if (_imageCountPrompter) {
            [self addSubnode:_imageCountPrompter];
        }
        [self addSubnode:_authorNode];
        [self addSubnode:_likeNode];
        [self addSubnode:_comentNode];
    }
    return self;
}

- (NSInteger)maximumDisplayImageCount {
    return BLUPostCommonNodeMaximumDisplayImageCount;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {

    if (constrainedSize.width <= 0) {
        constrainedSize.width = [UIScreen mainScreen].bounds.size.width;
    }

    CGFloat topInset = BLUThemeMargin * 2;
    CGFloat leftInset = BLUThemeMargin * 4;
    CGFloat contentInset = BLUThemeMargin * 4;
    CGFloat contentMargin = BLUThemeMargin * 2;
    CGFloat contentWidth = constrainedSize.width - leftInset * 2 - contentInset * 2;

    CGFloat titleNodeMaxWidth = constrainedSize.width;

    if (_tagImageNode) {
        titleNodeMaxWidth =
        constrainedSize.width - leftInset - contentInset - _tagImageNode.image.size.width - contentMargin;
    } else {
        titleNodeMaxWidth = contentWidth;
    }

    if (_videoImageNode) {
        titleNodeMaxWidth -= contentMargin + _videoImageNode.image.size.width;
    }

    CGSize titleSize =
    [_titleNode measure:CGSizeMake(titleNodeMaxWidth, constrainedSize.height)];
    CGSize contentSize =
    [_contentNode measure:CGSizeMake(contentWidth, constrainedSize.height)];

    CGFloat imageHeight = (contentWidth - (BLUPostCommonNodeMaximumDisplayImageCount - 1) * contentMargin) / BLUPostCommonNodeMaximumDisplayImageCount;

    [_imageCountPrompter measure:CGSizeMake(imageHeight - BLUThemeMargin * 2, imageHeight)];

    CGSize likeSize =
    [_likeNode measure:CGSizeMake(constrainedSize.width, constrainedSize.height)];
    CGSize comentSize =
    [_comentNode measure:CGSizeMake(constrainedSize.width, constrainedSize.height)];

    CGFloat authorWidth = contentWidth - likeSize.width - comentSize.width - contentMargin * 2;
    CGSize authorSize = [_authorNode measure:CGSizeMake(authorWidth, constrainedSize.height)];

    NSInteger sectionCount = 0;

    CGFloat (^acturlMargin)(NSInteger, CGFloat) = ^ CGFloat(NSInteger count, CGFloat margin) {
        if (count > 0) {
            return margin;
        } else {
            return 0.0;
        }
    };

    CGFloat requiredHeight = topInset + contentInset;
    if (titleSize.height > 0) {
        requiredHeight += titleSize.height;
        sectionCount += 1;
    }

    if (contentSize.height > 0) {
        requiredHeight += acturlMargin(sectionCount, contentMargin) + contentSize.height;
        sectionCount += 1;
    }

    if (_imageNodes.count > 0) {
        requiredHeight += acturlMargin(sectionCount, contentMargin) + imageHeight;
    }

    requiredHeight += authorSize.height + acturlMargin(sectionCount, contentMargin);

    requiredHeight += contentInset + topInset;

    return CGSizeMake(constrainedSize.width, requiredHeight);
}

- (void)layout {
    [super layout];

    CGFloat topInset = BLUThemeMargin * 2;
    CGFloat leftInset = BLUThemeMargin * 4;
    CGFloat contentInset = BLUThemeMargin * 4;
    CGFloat contentMargin = BLUThemeMargin * 2;
    CGFloat contentWidth = self.calculatedSize.width - leftInset * 2 - contentInset * 2;
    CGFloat contentX = leftInset + contentInset;
    CGFloat lastBottom = topInset + contentInset;
    NSInteger sectionCount = 0;

    if (_titleNode.calculatedSize.height > 0) {

        CGFloat titleX = contentX;

        if (_videoImageNode) {
            _videoImageNode.frame = CGRectMake(contentX, lastBottom + sectionCount * contentMargin, _videoImageNode.image.size.width, _videoImageNode.image.size.height);
            titleX += contentMargin + _videoImageNode.image.size.width;
        }

        _titleNode.frame = CGRectMake(titleX, lastBottom + sectionCount * contentMargin,
                                      _titleNode.calculatedSize.width,
                                      _titleNode.calculatedSize.height);
        lastBottom += _titleNode.calculatedSize.height;
        sectionCount += 1;

        CGFloat videoImageY = CGRectGetMinY(_titleNode.frame) + (_titleNode.calculatedSize.height - _videoImageNode.image.size.height) / 2;
        CGRect videoImageFrame = _videoImageNode.frame;
        videoImageFrame.origin.y = videoImageY;
        _videoImageNode.frame = videoImageFrame;
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
    _authorNode.frame = CGRectMake(contentX, controlY,
                                   _authorNode.calculatedSize.width, _authorNode.calculatedSize.height);

    CGFloat comentX = self.calculatedSize.width - _comentNode.calculatedSize.width - contentInset - leftInset;
    _comentNode.frame = CGRectMake(comentX, controlY, _comentNode.calculatedSize.width, _comentNode.calculatedSize.height);

    CGFloat likeX = comentX - contentMargin - _likeNode.calculatedSize.width;
    _likeNode.frame = CGRectMake(likeX, controlY, _likeNode.calculatedSize.width, _likeNode.calculatedSize.height);

    _backgroundNode.frame = CGRectMake(leftInset, topInset, contentWidth + contentInset * 2, self.calculatedSize.height - topInset * 2);
    
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
}

@end

@implementation BLUPostCommonNode (TextStyle)

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
            [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1],
    };
}

@end
