//
//  ASPostDetailCommentNode.m
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailCommentNode.h"
#import "BLUPostDetailCommentUserInfoNode.h"
#import "BLUComment.h"
#import "BLUPostDetailCommentReplyNode.h"
#import "BLUPost.h"

@implementation BLUPostDetailCommentNode

- (instancetype)initWithComment:(BLUComment *)comment
                           post:(BLUPost *)post
                     replyCount:(NSInteger)replyCount
                      anonymous:(BOOL)anonymous
                      separator:(BOOL)separator {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
        BLUAssertObjectIsKindOfClass(post, [BLUPost class]);
        _comment = comment;

        BOOL userAnonymous = ((post.author.userID == comment.author.userID) && anonymous == YES);

        _userNode =
        [[BLUPostDetailCommentUserInfoNode alloc] initWithComment:comment
                                                        anonymous:userAnonymous
                                                             isUp:post.author.userID == comment.author.userID];
        if (!anonymous) {
            [_userNode.userButton addTarget:self
                                     action:@selector(tapUserSectionAndShowUser:)
                           forControlEvents:ASControlNodeEventTouchUpInside];

            [_userNode              addTarget:self
                                     action:@selector(tapAndDoNothing:)
                           forControlEvents:ASControlNodeEventTouchUpInside];
        }

        [_userNode.likeButton addTarget:self
                                 action:@selector(tapAndChangeLikeState:)
                       forControlEvents:ASControlNodeEventTouchUpInside];

        _contentNode = [ASTextNode new];
        _contentNode.layerBacked = YES;
        _contentNode.attributedString =
        [self attributedContent:comment.content];

        _replyNode =
        [[BLUPostDetailCommentReplyNode alloc] initWithComment:comment
                                                          post:post
                                                    replyCount:replyCount];

        if (separator) {
            _separator = [ASDisplayNode new];
            _separator.layerBacked = YES;
            _separator.backgroundColor =
            [UIColor colorWithHue:0.83 saturation:0 brightness:0.93 alpha:1];
        }

        [self addSubnode:_userNode];
        [self addSubnode:_contentNode];
        [self addSubnode:_replyNode];
        if (_separator) {
            [self addSubnode:_separator];
        }

        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize calculatedSize = CGSizeZero;

    CGFloat contentInset = BLUThemeMargin * 4;
    CGFloat contentWidth = constrainedSize.width - contentInset * 2;

    CGSize userSize = [_userNode measure:CGSizeMake(contentWidth,
                                                    constrainedSize.height)];

    CGSize contentSize =
    [_contentNode measure:CGSizeMake(contentWidth - _userNode.avatarSize.width,
                                     constrainedSize.height)];

    CGSize replySize =
    [_replyNode measure:CGSizeMake(contentWidth - _userNode.avatarSize.width,
                                   constrainedSize.height)];

    calculatedSize.width = constrainedSize.width;
    calculatedSize.height =
    contentInset + userSize.height + contentInset +
    contentSize.height + contentInset / 2.0 +
    replySize.height + contentInset;

    return calculatedSize;
}

- (void)layout {
    [super layout];

    CGFloat contentInset = BLUThemeMargin * 4;
    CGFloat contentWidth = self.calculatedSize.width - contentInset * 2;
    CGFloat offsetY = contentInset;

    // User
    _userNode.frame = CGRectMake(contentInset, offsetY,
                                 contentWidth,
                                 _userNode.calculatedSize.height);

    offsetY = CGRectGetMaxY(_userNode.frame) + contentInset;

    _contentNode.frame =
    CGRectMake(contentInset + _userNode.avatarSize.width + BLUThemeMargin, offsetY,
               _contentNode.calculatedSize.width,
               _contentNode.calculatedSize.height);

    offsetY = CGRectGetMaxY(_contentNode.frame) + contentInset / 2.0;
    _replyNode.frame =
    CGRectMake(contentInset + _userNode.avatarSize.width, offsetY,
               _replyNode.calculatedSize.width,
               _replyNode.calculatedSize.height);

    if (_separator) {
        _separator.frame =
        CGRectMake(contentInset,
                   self.calculatedSize.height - BLUThemeOnePixelHeight,
                   self.calculatedSize.width - contentInset * 2,
                   BLUThemeOnePixelHeight);
    }
}

- (void)tapAndDoNothing:(id)sender {
    // Do nothing
}

- (void)tapUserSectionAndShowUser:(id)sender {
    if ([self.delegate
         respondsToSelector:
         @selector(shouldShowUserDetailForUser:from:sender:)]) {
        [self.delegate shouldShowUserDetailForUser:self.comment.author
                                              from:self
                                            sender:sender];
    }
}

- (void)tapAndChangeLikeState:(id)sender {
    if ([self.delegate
         respondsToSelector:
         @selector(shouldUpdateLikeStateForComment:from:sender:)]) {
        [self.delegate shouldUpdateLikeStateForComment:self.comment
                                                  from:self
                                                sender:sender];
    }
}

- (NSDictionary *)contentAttributes {
    NSMutableParagraphStyle *textStyle =
    [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    textStyle.lineSpacing = BLUThemeMargin;
    return @{
             NSFontAttributeName:
                 BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge),
             NSForegroundColorAttributeName:
                 [UIColor colorFromHexString:@"#999999"],
             NSParagraphStyleAttributeName: textStyle,
             };
}

- (NSAttributedString *)attributedContent:(NSString *)content {
    return [[NSAttributedString alloc] initWithString:content
                                           attributes:[self contentAttributes]];
}

- (void)setComment:(BLUComment *)comment {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    _comment = comment;
    [_userNode configureLikeButtonWithComment:comment];
}

@end
