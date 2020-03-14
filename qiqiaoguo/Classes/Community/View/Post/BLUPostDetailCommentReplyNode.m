//
//  BLUPostDetailCommentReplyNode.m
//  Blue
//
//  Created by Bowen on 23/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailCommentReplyNode.h"
#import "BLUComment.h"
#import "BLUCommentReply.h"
#import "BLUPostDetailCommentReplyTextNode.h"
#import "BLUPost.h"

@implementation BLUPostDetailCommentReplyNode

- (instancetype)initWithComment:(BLUComment *)comment
                           post:(BLUPost *)post
                     replyCount:(NSInteger)replyCount {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
        BLUAssertObjectIsKindOfClass(post, [BLUPost class]);
        BLUParameterAssert(replyCount >= 0);

        _comment = comment;

        [comment.replies
         enumerateObjectsUsingBlock:^(BLUCommentReply *reply,
                                      NSUInteger idx,
                                      BOOL * _Nonnull stop) {
             if (idx < replyCount) {
                 BLUPostDetailCommentReplyTextNode *textNode =
                 [[BLUPostDetailCommentReplyTextNode alloc]
                  initWithCommentReply:reply comment:comment post:post];

                 [self addSubnode:textNode];
             } else {
                 *stop = YES;
             }
        }];

        if (comment.replies.count > 0) {
            _showMoreCommentsPrompt = replyCount < comment.replyCount ? YES : NO;
        } else {
            _showMoreCommentsPrompt = NO;
        }

        if (_showMoreCommentsPrompt) {
            NSInteger numberOfRestComments = comment.replyCount - replyCount;

            _moreCommentsButtonNode = [ASButtonNode new];
            [_moreCommentsButtonNode addTarget:self
                                        action:@selector(touchAndShowMoreComments:)
                              forControlEvents:ASControlNodeEventTouchUpInside];
            [_moreCommentsButtonNode setAttributedTitle:
             [self attributedMoreComments:numberOfRestComments]
                                               forState:ASControlStateNormal];
            [self addSubnode:_moreCommentsButtonNode];
        }

        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)setReplyTextNodeDelegate:(id<BLUPostDetailCommentReplyTextNodeDelegate>)replyTextNodeDelegate {
    _replyTextNodeDelegate = replyTextNodeDelegate;
    for (BLUPostDetailCommentReplyTextNode *textNode in self.subnodes) {
        if ([textNode isKindOfClass:[BLUPostDetailCommentReplyTextNode class]]) {
            textNode.commentReplyDelegate = replyTextNodeDelegate;
        }
    }
}

+ (CGFloat)ovalDiameter {
    return BLUThemeMargin * 4;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    __block CGSize calculatedSize = CGSizeMake(constrainedSize.width, 0.0);

    CGFloat contentMargin = BLUThemeMargin * 2;
    CGFloat contentWidth = constrainedSize.width - contentMargin * 2;

    calculatedSize.height +=
    [BLUPostDetailCommentReplyNode ovalDiameter] / 2.0;

    for (BLUPostDetailCommentReplyTextNode *textNode in self.subnodes) {
        CGSize textNodeSize =
        [textNode measure:CGSizeMake(contentWidth, constrainedSize.height)];
        calculatedSize.height += contentMargin + textNodeSize.height;
    }


    if (self.subnodes.count > 0) {
        calculatedSize.height += contentMargin;
    } else {
        calculatedSize = CGSizeZero;
    }

    return calculatedSize;
}

- (void)layout {
    [super layout];
    CGFloat contentMargin = BLUThemeMargin * 2;
    __block CGFloat offsetY =
    [BLUPostDetailCommentReplyNode ovalDiameter] / 2.0;
    offsetY += contentMargin;
    CGFloat offsetX = contentMargin;
    [self.subnodes enumerateObjectsUsingBlock:^(id node, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([node isKindOfClass:[BLUPostDetailCommentReplyTextNode class]]) {
            BLUPostDetailCommentReplyTextNode *textNode =
            (BLUPostDetailCommentReplyTextNode *)node;
            textNode.frame =
            CGRectMake(offsetX, offsetY,
                       textNode.calculatedSize.width,
                       textNode.calculatedSize.height);
            offsetY += contentMargin + textNode.calculatedSize.height;
        } else if ([node isKindOfClass:[ASButtonNode class]]) {
            ASButtonNode *buttonNode =
            (ASButtonNode *)node;
            CGFloat contentWidth = self.calculatedSize.width - contentMargin * 2;
            CGFloat buttonX =
            contentWidth / 2.0 - buttonNode.calculatedSize.width / 2.0;
            buttonNode.frame =
            CGRectMake(buttonX, offsetY,
                       buttonNode.calculatedSize.width,
                       buttonNode.calculatedSize.height);
            offsetY += contentMargin + buttonNode.calculatedSize.height;
        }
    }];
}

+ (void)drawRect:(CGRect)bounds
  withParameters:(id<NSObject>)parameters
     isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock
   isRasterizing:(BOOL)isRasterizing {

    [[UIColor whiteColor] setFill];
    // 如果这里的背景颜色不放大的话，那么就会出现画的黑线
    CGRect backgroundRect =
    CGRectMake(0, 0, bounds.size.width + 1, bounds.size.width + 1);
    UIRectFill(backgroundRect);

    UIColor *backgroundColor =
    [UIColor colorWithHue:0 saturation:0 brightness:0.93 alpha:1];

    // Oval Drawing
    CGFloat ovalDiameter = [self ovalDiameter];
    CGFloat ovalX = CGRectGetMidX(bounds) - ovalDiameter / 2.0;

    UIBezierPath* ovalPath =
    [UIBezierPath bezierPathWithOvalInRect:
     CGRectMake(ovalX, 0, ovalDiameter, ovalDiameter)];
    [backgroundColor setFill];
    [ovalPath fill];

    // Rectangle Drawing
    CGFloat rectangleY = ovalDiameter / 2.0;
    CGFloat rectangleHeight = bounds.size.height - ovalDiameter / 2.0;

    UIBezierPath* rectanglePath =
    [UIBezierPath bezierPathWithRoundedRect:
     CGRectMake(0, rectangleY, bounds.size.width, rectangleHeight)
                               cornerRadius: 10];
    [backgroundColor setFill];
    [rectanglePath fill];
}

- (NSAttributedString *)attributedMoreComments:(NSInteger)numberOfRestComments {
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName: [UIColor colorWithHue:0.6 saturation:0.73 brightness:0.96 alpha:1],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal)};
    NSString *prompt =
    NSLocalizedString(@"post-detail-comment-reply-node.more-comments%@",
                      @"More comments");
    NSString *text = [NSString stringWithFormat:prompt, @(numberOfRestComments)];

    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributes];
}

- (void)touchAndShowMoreComments:(id)sender {
    if ([self.delegate
         respondsToSelector:
         @selector(shouldShowRepliesForComment:from:sender:)]) {
        [self.delegate shouldShowRepliesForComment:self.comment
                                              from:self
                                            sender:sender];
    }
}

@end
