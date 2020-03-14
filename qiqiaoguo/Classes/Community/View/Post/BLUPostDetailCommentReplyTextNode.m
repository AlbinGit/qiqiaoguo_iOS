//
//  BLUPostDetailCommentReplyTextNode.m
//  Blue
//
//  Created by Bowen on 23/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailCommentReplyTextNode.h"
#import "BLUCommentReply.h"
#import "BLUComment.h"
#import "BLUPost.h"

static NSString *const BLUPostDetailCommentReplyTextNodeAuthorTappedLinkedName =
@"BLUPostDetailCommentReplyTextNodeAuthorTappedLinkedName";
static NSString *const BLUPostDetailCommentReplyTextNodeContentTappedLinkedName =
@"BLUPostDetailCommentReplyTextNodeContentTappedLinkedName";
static NSString *const BLUPostDetailCommentReplyTextNodeContentLongPressedLinkedName =
@"BLUPostDetailCommentReplyTextNodeContentLongPressedLinkedName";

@implementation BLUPostDetailCommentReplyTextNode

- (instancetype)initWithCommentReply:(BLUCommentReply *)reply
                             comment:(BLUComment *)comment
                                post:(BLUPost *)post {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(reply, [BLUCommentReply class]);
        BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
        BLUAssertObjectIsKindOfClass(post, [BLUPost class]);

        _reply = reply;
        _comment = comment;
        _post = post;
        self.delegate = self;
        self.linkAttributeNames = [self replyLinkedAttributes];
        self.userInteractionEnabled = YES;
        self.highlightStyle = ASTextNodeHighlightStyleLight;
        self.longPressCancelsTouches = YES;

        self.attributedString =
        [self attributedStringWithCommentReply:reply
                                       comment:comment
                                          post:post];
    }
    return self;
}

- (void)didLoad {
    self.layer.as_allowsHighlightDrawing = YES;
    [super didLoad];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)report:(id)sender {
    if ([self.commentReplyDelegate
         respondsToSelector:@selector(shouldReportCommentReply:from:)]) {
        [self.commentReplyDelegate shouldReportCommentReply:_reply from:self];
    }
}

- (void)copyReplyContent:(id)sender {
    [[UIPasteboard generalPasteboard] setString:_reply.content];
}

- (void)deleteReply:(id)sender {
    if ([self.commentReplyDelegate
         respondsToSelector:@selector(shouldDeleteCommentReply:from:)]) {
        [self.commentReplyDelegate shouldDeleteCommentReply:_reply from:self];
    }
}

- (NSArray *)menuItems {
    UIMenuItem *copyItem =
    [[UIMenuItem alloc] initWithTitle:
     NSLocalizedString(@"post-detail-comment-reply-text-node.copy", @"Copy")
                               action:@selector(copyReplyContent:)];

    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser.userID == _reply.author.userID) {
        UIMenuItem *deleteItem =
        [[UIMenuItem alloc] initWithTitle:
         NSLocalizedString(@"post-detail-comment-reply-text-node.delete", @"Delete")
                                   action:@selector(deleteReply:)];
        return @[copyItem, deleteItem];
    } else {
        UIMenuItem *reportItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"comment-reply-text-view.menu-item.title.report", @"Report") action:@selector(report:)];
        return @[copyItem, reportItem];
    }
}

- (void)showMenuControllerWithFrame:(CGRect)frame {
    [self becomeFirstResponder];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect:frame inView:self.view];
    [menuController setMenuItems:[self menuItems]];
    [menuController setMenuVisible:YES animated:YES];
    [menuController update];
}

@end

@implementation BLUPostDetailCommentReplyTextNode (Text)

- (NSAttributedString *)attributedStringWithCommentReply:(BLUCommentReply *)reply
                                                 comment:(BLUComment *)comment
                                                    post:(BLUPost *)post {
    BLUAssertObjectIsKindOfClass(reply, [BLUCommentReply class]);
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    BLUAssertObjectIsKindOfClass(post, [BLUPost class]);


    BOOL fromAnonymous = NO;
    BOOL toAnonymous = NO;
    if (post.anonymousEnable) {
        fromAnonymous = reply.author.userID == post.author.userID;
        toAnonymous = reply.target.userID == post.author.userID;
    } else {
        fromAnonymous = NO;
        toAnonymous = NO;
    }
    BOOL isUp = post.author.userID == reply.author.userID;

    NSMutableAttributedString *attrStr = [NSMutableAttributedString new];

    NSAttributedString *authorStr =
    [self attributedAuthorNickname:reply.author.nickname
                            author:reply.author
                         anonymous:fromAnonymous
                              isUp:isUp];

    NSAttributedString *contentStr =
    [self attributedContent:reply.content commentReply:reply];

    NSAttributedString *colonStr = [self attributedColon];

    [attrStr appendAttributedString:authorStr];

    if (reply.target) {
        NSAttributedString *targetStr = nil;
        if (toAnonymous) {
            targetStr =
            [self attributedTargetNickname:
             NSLocalizedString(@"post-detail-comment-reply-text-node.anoymous", @"Anonymous")];
        } else {
            targetStr =
            [self attributedTargetNickname:reply.target.nickname];
        }

        NSAttributedString *replyStr =
        [self attributedReply];

        [attrStr appendAttributedString:replyStr];
        [attrStr appendAttributedString:targetStr];
        [attrStr appendAttributedString:colonStr];
        [attrStr appendAttributedString:contentStr];
    } else {
        [attrStr appendAttributedString:colonStr];
        [attrStr appendAttributedString:contentStr];
    }

    return attrStr;
}

- (NSString *)authorTappedLinkedName {
    return BLUPostDetailCommentReplyTextNodeAuthorTappedLinkedName;
}

- (NSString *)contentTappedLinkedName {
    return BLUPostDetailCommentReplyTextNodeContentTappedLinkedName;
}

- (NSString *)contentLongPressedLinkedName {
    return BLUPostDetailCommentReplyTextNodeContentLongPressedLinkedName;
}

- (NSDictionary *)linkAttributes {
    return
    @{ NSFontAttributeName : [UIFont systemFontOfSize:15.0],
       NSForegroundColorAttributeName: [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0],
       NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
}

- (NSArray *)replyLinkedAttributes {
    return @[[self authorTappedLinkedName],
             [self contentTappedLinkedName],
             [self contentLongPressedLinkedName]];
}

- (NSAttributedString *)attributedAuthorNickname:(NSString *)nickname
                                          author:(BLUUser *)author
                                       anonymous:(BOOL)anonymous
                                            isUp:(BOOL)isUp {
    BLUParameterAssert(nickname.length > 0);
    BLUAssertObjectIsKindOfClass(author, [BLUUser class]);


    NSDictionary *attributes = nil;
    if (anonymous) {
        attributes =
        @{ NSForegroundColorAttributeName: [self authorColor],
           NSFontAttributeName: [self commonFont]};
    } else {
        attributes =
        @{ NSForegroundColorAttributeName: [self authorColor],
           NSFontAttributeName: [self commonFont],
           [self authorTappedLinkedName]: author};
    }

    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSString *anonymousStr =
    NSLocalizedString(@"post-detail-comment-reply-text-node.anoymous", @"Anonymous");
    nickname = anonymous ? anonymousStr : nickname;
    NSAttributedString *attrNickname =
    [[NSAttributedString alloc] initWithString:nickname attributes:attributes];
    [text appendAttributedString:attrNickname];

    if (isUp) {
        NSTextAttachment *upAttachment = [NSTextAttachment new];
        upAttachment.image = [UIImage imageNamed:@"post-comment-reply-up"];
        CGRect boundsOfUp = upAttachment.bounds;
        boundsOfUp.origin.y -= BLUThemeMargin / 2;
        boundsOfUp.size = upAttachment.image.size;
        upAttachment.bounds = boundsOfUp;
        NSAttributedString *upStr = [NSAttributedString attributedStringWithAttachment:upAttachment];
        NSAttributedString *spaceStr = [[NSAttributedString alloc] initWithString:@" "
                                                                       attributes:attributes];
        [text appendAttributedString:spaceStr];
        [text appendAttributedString:upStr];
    }

    return text;
}

- (NSAttributedString *)attributedColon {
    NSDictionary *attributes =
    @{ NSForegroundColorAttributeName: [self replyColor],
       NSFontAttributeName: [self commonFont]};

    NSAttributedString *attrStr =
    [[NSAttributedString alloc] initWithString:@" : "
                                    attributes:attributes];

    return attrStr;
}

- (NSAttributedString *)attributedReply {

    NSDictionary *attributes =
    @{ NSForegroundColorAttributeName: [self replyColor],
       NSFontAttributeName: [self commonFont]};

    NSString *text =
    [NSString stringWithFormat:@" %@ ",
     NSLocalizedString(@"post-detail-comment-reply-text-node.reply", @"Reply")];

    NSAttributedString *attrStr =
    [[NSAttributedString alloc] initWithString:text
                                    attributes:attributes];

    return attrStr;
}

- (NSAttributedString *)attributedTargetNickname:(NSString *)nickname {
    BLUParameterAssert(nickname.length > 0);

    NSDictionary *attributes =
    @{ NSForegroundColorAttributeName: [self targetColor],
       NSFontAttributeName: [self commonFont]};

    NSAttributedString *attrStr =
    [[NSAttributedString alloc] initWithString:nickname
                                    attributes:attributes];

    return attrStr;
}

- (NSAttributedString *)attributedContent:(NSString *)content
                             commentReply:(BLUCommentReply *)reply{
    BLUParameterAssert(content.length > 0);
    BLUAssertObjectIsKindOfClass(reply, [BLUCommentReply class]);

    NSDictionary *attributes =
    @{ NSForegroundColorAttributeName: [self contentColor],
       NSFontAttributeName: [self commonFont],
       BLUPostDetailCommentReplyTextNodeContentLongPressedLinkedName: reply,
       BLUPostDetailCommentReplyTextNodeContentTappedLinkedName: reply};

    NSAttributedString *attrStr =
    [[NSAttributedString alloc] initWithString:content
                                    attributes:attributes];
    
    return attrStr;
}

- (UIFont *)commonFont {
    return BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);
}

- (UIColor *)authorColor {
    return BLUThemeMainColor;
}

- (UIColor *)replyColor {
    return [UIColor colorWithHue:0.58 saturation:0.02 brightness:0.42 alpha:1];
}

- (UIColor *)targetColor {
    return [UIColor colorWithHue:0.6 saturation:0.38 brightness:0.05 alpha:1];
}

- (UIColor *)contentColor {
    return [UIColor colorWithHue:0.58 saturation:0.02 brightness:0.36 alpha:1];
}

@end

@implementation BLUPostDetailCommentReplyTextNode (Delegate)

- (void)textNode:(ASTextNode *)textNode
tappedLinkAttribute:(NSString *)attribute
           value:(id)value
         atPoint:(CGPoint)point
       textRange:(NSRange)textRange {
    if ([attribute isEqualToString:BLUPostDetailCommentReplyTextNodeAuthorTappedLinkedName]) {
        BLULogDebug(@"value = %@", value);
        if ([self.commentReplyDelegate
             respondsToSelector:@selector(shouldShowUserDetails:from:)]) {
            [self.commentReplyDelegate shouldShowUserDetails:value from:self];
        }
    } else if ([attribute isEqualToString:BLUPostDetailCommentReplyTextNodeContentTappedLinkedName]) {
        BLULogDebug(@"value = %@", value);
        if ([self.commentReplyDelegate
             respondsToSelector:@selector(shouldReplyToCommentReply:from:)]) {
            BLUCommentReply *reply = (BLUCommentReply *)value;
            if (reply.author.userID != [BLUAppManager sharedManager].currentUser.userID) {
                [self.commentReplyDelegate shouldReplyToCommentReply:value from:self];
            }
        }
    } else {
        return;
    }
}

- (void)textNode:(ASTextNode *)textNode
longPressedLinkAttribute:(NSString *)attribute
           value:(id)value
         atPoint:(CGPoint)point
       textRange:(NSRange)textRange {
    if ([attribute isEqualToString:BLUPostDetailCommentReplyTextNodeContentLongPressedLinkedName] ||
        [attribute isEqual:BLUPostDetailCommentReplyTextNodeContentTappedLinkedName]) {
        BLULogDebug(@"value = %@", value);
        [self showMenuControllerWithFrame:CGRectMake(point.x, point.y, 0, 0)];
    } else {
        return;
    }
}

- (BOOL)textNode:(ASTextNode *)textNode
shouldHighlightLinkAttribute:(NSString *)attribute
           value:(id)value
         atPoint:(CGPoint)point {
    if ([attribute isEqual:BLUPostDetailCommentReplyTextNodeAuthorTappedLinkedName] ||
        [attribute isEqual:BLUPostDetailCommentReplyTextNodeContentTappedLinkedName] ||
        [attribute isEqual:BLUPostDetailCommentReplyTextNodeContentLongPressedLinkedName]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)textNode:(ASTextNode *)textNode shouldLongPressLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point {
    if ([attribute isEqual:BLUPostDetailCommentReplyTextNodeContentLongPressedLinkedName]) {
        return YES;
    } else if ([attribute isEqual:BLUPostDetailCommentReplyTextNodeContentTappedLinkedName]){
        return YES;
    } else {
        return NO;
    }
}

@end
