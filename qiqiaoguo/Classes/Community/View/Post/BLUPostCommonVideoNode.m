//
//  BLUPostCommonVideoNode.m
//  Blue
//
//  Created by Bowen on 2/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUPostCommonVideoNode.h"
#import "BLUPost.h"
#import "BLUPostCommonVideoNode+TextStyle.h"

@implementation BLUPostCommonVideoNode

- (instancetype)initWithPost:(BLUPost *)post {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(post, [BLUPost class]);
        _post = post;

        _contentMargin = UIEdgeInsetsMake(BLUThemeMargin * 2,
                                          BLUThemeMargin * 4,
                                          BLUThemeMargin * 2,
                                          BLUThemeMargin * 4);
        _contentPadding = UIEdgeInsetsMake(BLUThemeMargin * 3,
                                           BLUThemeMargin * 3,
                                           BLUThemeMargin * 3,
                                           BLUThemeMargin * 3);
        _elementSpacing = BLUThemeMargin * 3;
        _videoCoverSize = CGSizeMake(100, 73);

        _background = [ASDisplayNode new];
        _background.backgroundColor = [UIColor whiteColor];
        _background.cornerRadius = BLUThemeHighActivityCornerRadius;

        _videoIndicator = [ASImageNode new];
        _videoIndicator.image = [UIImage imageNamed:@"post-common-video-indicator"];

        _videoCover = [ASNetworkImageNode new];
        _videoCover.backgroundColor = BLUThemeSubTintBackgroundColor;
        _videoCover.URL = post.videoCoverURL;

        _titleNode = [ASTextNode new];
        _titleNode.maximumNumberOfLines = 2;
        _titleNode.attributedString =
        [self attributedTitlte:self.post.title];

        _timeNode = [ASTextNode new];
        _timeNode.maximumNumberOfLines = 1;
        _timeNode.attributedString =
        [self attributedTime:self.post.createDate.postTime];

        _numberOfCommentsNode = [ASButtonNode new];
        _numberOfCommentsNode.contentSpacing = BLUThemeMargin;
        _numberOfCommentsNode.laysOutHorizontally = YES;
        [_numberOfCommentsNode
         setAttributedTitle:
         [self attributedNumberOfComments:@(self.post.commentCount)]
         forState:ASControlStateNormal];
        [_numberOfCommentsNode
         setImage:[UIImage imageNamed:@"post-common-video-number-of-comment"]
         forState:ASControlStateNormal];

        _numberOfViewsNode = [ASButtonNode new];
        _numberOfViewsNode.contentSpacing = BLUThemeMargin;
        _numberOfViewsNode.laysOutHorizontally = YES;
        [_numberOfViewsNode
         setAttributedTitle:[self attributedNumberOfViews:@(self.post.accessCount)]
         forState:ASControlStateNormal];
        [_numberOfViewsNode
         setImage:[UIImage imageNamed:@"post-common-video-number-of-views"]
         forState:ASControlStateNormal];

        self.backgroundColor = BLUThemeSubTintBackgroundColor;

        for (ASDisplayNode *node in self.subnodes) {
            node.layerBacked = YES;
        }

        [self addSubnode:_background];
        [_background addSubnode:_videoCover];
        [_videoCover addSubnode:_videoIndicator];
        [_background addSubnode:_titleNode];
        [_background addSubnode:_timeNode];
        [_background addSubnode:_numberOfViewsNode];
        [_background addSubnode:_numberOfCommentsNode];
    }
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize calculateSize = constrainedSize;
    calculateSize.height = _videoCoverSize.height + _contentMargin.bottom +
    _contentMargin.top + _contentPadding.top + _contentPadding.bottom;
    CGFloat titleWidth = constrainedSize.width - _contentMargin.left -
    _contentPadding.left - _videoCoverSize.width - _elementSpacing -
    _contentPadding.right - _contentMargin.right;
    [_titleNode measure:CGSizeMake(titleWidth, CGFLOAT_MAX)];
    CGSize numberOfViewsSize =
    [_numberOfViewsNode measure:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGSize numberOfCommentsSize =
    [_numberOfCommentsNode measure:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat timeWidth = titleWidth - _elementSpacing - numberOfViewsSize.width -
    _elementSpacing - numberOfCommentsSize.width;
    [_timeNode measure:CGSizeMake(timeWidth, CGFLOAT_MAX)];
    return calculateSize;
}

- (void)layout {
    [super layout];

    CGRect backgroundFrame;
    backgroundFrame.origin.x = _contentMargin.left;
    backgroundFrame.origin.y = _contentMargin.top;
    backgroundFrame.size.width =
    self.calculatedSize.width - _contentMargin.left - _contentMargin.right;
    backgroundFrame.size.height =
    self.calculatedSize.height - _contentMargin.top - _contentMargin.bottom;
    _background.frame = backgroundFrame;

    CGRect videoCoverFrame;
    videoCoverFrame.origin.x = _contentPadding.top;
    videoCoverFrame.origin.y = _contentPadding.left;
    videoCoverFrame.size =  _videoCoverSize;
    _videoCover.frame = videoCoverFrame;

    CGRect videoIndicatorFrame;
    videoIndicatorFrame.size = _videoIndicator.image.size;
    videoIndicatorFrame.origin.x =
    (CGRectGetWidth(videoCoverFrame) - videoIndicatorFrame.size.width) / 2.0;
    videoIndicatorFrame.origin.y =
    (CGRectGetHeight(videoCoverFrame) - videoIndicatorFrame.size.height) / 2.0;
    _videoIndicator.frame = videoIndicatorFrame;


    CGRect titleFrame;
    titleFrame.size = _titleNode.calculatedSize;
    titleFrame.origin.x = CGRectGetMaxX(videoCoverFrame) + _elementSpacing;
    titleFrame.origin.y = videoCoverFrame.origin.y;
    _titleNode.frame = titleFrame;

    CGRect timeFrame;
    timeFrame.size = _timeNode.calculatedSize;
    timeFrame.origin.x = titleFrame.origin.x;
    timeFrame.origin.y = CGRectGetMaxY(videoCoverFrame) - timeFrame.size.height;
    _timeNode.frame = timeFrame;

    CGRect commentFrame;
    commentFrame.size = _numberOfCommentsNode.calculatedSize;
    commentFrame.origin.x = CGRectGetWidth(backgroundFrame) -
    _contentPadding.right - commentFrame.size.width;
    commentFrame.origin.y = CGRectGetMaxY(videoCoverFrame) - commentFrame.size.height;
    _numberOfCommentsNode.frame = commentFrame;

    CGRect viewsFrame;
    viewsFrame.size = _numberOfViewsNode.calculatedSize;
    viewsFrame.origin.x = commentFrame.origin.x - _elementSpacing -
    viewsFrame.size.width;
    viewsFrame.origin.y = CGRectGetMaxY(videoCoverFrame) - viewsFrame.size.height;
    _numberOfViewsNode.frame = viewsFrame;
}

@end
