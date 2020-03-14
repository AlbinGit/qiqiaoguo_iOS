//
//  BLUCommentReplyTextView.m
//  Blue
//
//  Created by Bowen on 16/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

static NSString *const kTapAuthorNicknameTag    = @"kTapAuthorNicknameTag";;
static NSString *const kTapTargetNicknameTag    = @"kTapTargetNicknameTag";
static NSString *const kTapContentTag           = @"kTapContentTag";
static NSString *const kLongPressContentTag     = @"kLongPressContentTag";

#import "BLUCommentReplyTextView.h"
#import "BLUPost.h"
#import "BLUComment.h"

@interface BLUCommentReplyTextView ()

@property (nonatomic, assign) BOOL authorShouldBeAnonymous;
@property (nonatomic, assign) BOOL targetShouldBeAnonymous;

@end

@implementation BLUCommentReplyTextView

#pragma mark - UITextView.

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.editable = NO;
    self.selectable = NO;
    self.scrollEnabled = NO;

    self.backgroundColor = [UIColor clearColor];

    UITapGestureRecognizer *tapTextView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapText:)];
    UILongPressGestureRecognizer *longPressTextView = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressText:)];

    [self addGestureRecognizer:tapTextView];
    [self addGestureRecognizer:longPressTextView];
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    if (action == @selector(report:) || action == @selector(copy:)) {
        return YES;
    }

    if ([BLUAppManager sharedManager].currentUser.userID == self.commentReply.author.userID) {
        if (action == @selector(delete:)) {
            return YES;
        }
    }

    return NO;
}

#pragma mark - Model.

- (void)setCommentReply:(BLUCommentReply *)commentReply post:(BLUPost *)post comment:(BLUComment *)comment {

    _commentReply = [commentReply copy];

    if (commentReply.author.userID == post.author.userID) {
        _authorShouldBeAnonymous = post.anonymousEnable;
    }

    if (commentReply.target.userID == post.author.userID) {
        _targetShouldBeAnonymous = post.anonymousEnable;
    }

    NSString *authorNickname = _authorShouldBeAnonymous ? [BLUUser anonymousNickname] : commentReply.author.nickname;
    NSString *targetNickname = _targetShouldBeAnonymous ? [BLUUser anonymousNickname] : commentReply.target.nickname;

    NSMutableAttributedString *authorNicknameAttributeString;
    NSMutableAttributedString *replyAttributeString;
    NSMutableAttributedString *targetNicknameAttributeString;
    NSMutableAttributedString *contentAttributeString;

    if (authorNickname.length > 0) {
        authorNicknameAttributeString = [[NSMutableAttributedString alloc] initWithString:authorNickname];
        [authorNicknameAttributeString addAttribute:NSForegroundColorAttributeName value:BLUThemeMainColor range:NSMakeRange(0, authorNicknameAttributeString.length)];
        [authorNicknameAttributeString addAttribute:kTapAuthorNicknameTag value:@(YES) range:NSMakeRange(0, authorNicknameAttributeString.length)];
    }

    replyAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", NSLocalizedString(@"comment-reply-text-view.reply", @"Reply")]];
    [replyAttributeString addAttribute:NSForegroundColorAttributeName value:BLUThemeSubDeepContentForegroundColor range:NSMakeRange(0, replyAttributeString.length)];

    if (targetNickname.length > 0) {
        targetNicknameAttributeString = [[NSMutableAttributedString alloc] initWithString:targetNickname];
        [targetNicknameAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, targetNicknameAttributeString.length)];
    }

    if (commentReply.content.length > 0) {
        contentAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@": %@", commentReply.content]];
        [contentAttributeString addAttribute:NSForegroundColorAttributeName value:BLUThemeSubDeepContentForegroundColor range:NSMakeRange(0, contentAttributeString.length)];
        [contentAttributeString addAttribute:kTapContentTag value:@(YES) range:NSMakeRange(0, contentAttributeString.length)];
        [contentAttributeString addAttribute:kLongPressContentTag value:@(YES) range:NSMakeRange(0, contentAttributeString.length)];
    }

    NSTextAttachment *lzAttachment = [[NSTextAttachment alloc] init];
    lzAttachment.image = [UIImage imageNamed:@"post-lz"];
    NSAttributedString *lzAttachmentString = [NSAttributedString attributedStringWithAttachment:lzAttachment];

    NSMutableAttributedString * mutableAttributedString = [[NSMutableAttributedString alloc] init];

    if (authorNicknameAttributeString) {
        [mutableAttributedString appendAttributedString:authorNicknameAttributeString];
    }

    if (post.author.userID == commentReply.author.userID) {
        [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [mutableAttributedString appendAttributedString:lzAttachmentString];
        [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }

    if (commentReply.target && targetNicknameAttributeString && replyAttributeString) {
        [mutableAttributedString appendAttributedString:replyAttributeString];
        [mutableAttributedString appendAttributedString:targetNicknameAttributeString];
    }

    if (contentAttributeString) {
        [mutableAttributedString appendAttributedString:contentAttributeString];
    }

    [mutableAttributedString addAttribute:NSFontAttributeName value:BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal) range:NSMakeRange(0, mutableAttributedString.length)];

    self.attributedText = mutableAttributedString;
}

- (void)setCommentReply:(BLUCommentReply *)commentReply {
    [self setCommentReply:commentReply post:nil comment:nil];
}

#pragma mark - Action.

- (void)tapText:(UITapGestureRecognizer *)recognizer {
    BLULogDebug(@"");
    NSUInteger characterIndex = [self characterIndexWithGestureLocation:[recognizer locationInView:self]];

    if ([self valueWithCharacterIndex:characterIndex attribute:kTapAuthorNicknameTag]) {
        if (!_authorShouldBeAnonymous) {
            [self transitionToAuthor];
        }
    }

    if ([self valueWithCharacterIndex:characterIndex attribute:kTapContentTag]) {
        [self reply:self];
    }
}

- (void)longPressText:(UILongPressGestureRecognizer *)recognizer {
    BLULogDebug(@"");

    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        NSUInteger characterIndex = [self characterIndexWithGestureLocation:[recognizer locationInView:self]];

        if ([self valueWithCharacterIndex:characterIndex attribute:kLongPressContentTag]) {
            BLULogDebug(@"show menu");
            CGPoint location = [recognizer locationInView:self];
            CGRect frame = CGRectMake(location.x, location.y, BLUThemeMargin * 2, BLUThemeMargin * 2);
            [self showMenuControllerWithFrame:frame];
        }
    }
}

- (void)report:(id)sender {
    BLULogDebug(@"");
    if ([self.commentReplyDelegate respondsToSelector:@selector(shouldReportReply:commentReplyTextView:)] && self.commentReply) {
        [self.commentReplyDelegate shouldReportReply:[BLUCommentReply replyInfoWithReply:self.commentReply] commentReplyTextView:self];
    }
}

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.attributedText.string];
}

- (void)delete:(id)sender {
    BLULogDebug(@"");
    if ([self.commentReplyDelegate respondsToSelector:@selector(shouldDeleteReply:commentReplyTextView:)] && self.commentReply) {
        [self.commentReplyDelegate shouldDeleteReply:[BLUCommentReply replyInfoWithReply:self.commentReply] commentReplyTextView:self];
    }
}

- (void)reply:(id)sender {
    BLULogDebug(@"");
    if ([self.commentReplyDelegate respondsToSelector:@selector(shouldReplyToReply:commentReplyTextView:)]) {
        [self.commentReplyDelegate shouldReplyToReply:[BLUCommentReply replyInfoWithReply:self.commentReply] commentReplyTextView:self];
    }
}

- (void)transitionToAuthor {
    BLULogDebug(@"");
    if ([self.userTransitionDelegate respondsToSelector:@selector(shouldTransitToUser:fromView:sender:)] && self.commentReply.author) {
        [self.userTransitionDelegate shouldTransitToUser:[BLUUser userInfoWithUser:self.commentReply.author] fromView:self sender:self];
    }
}

- (void)transitionToTarget {
    BLULogDebug(@"");
    if ([self.userTransitionDelegate respondsToSelector:@selector(shouldTransitToUser:fromView:sender:)] && self.commentReply.target) {
        [self.userTransitionDelegate shouldTransitToUser:[BLUUser userInfoWithUser:self.commentReply.target] fromView:self sender:self];
    }
}

#pragma mark - Menu.

- (NSArray *)menuItems {
    UIMenuItem *reportItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"comment-reply-text-view.menu-item.title.report", @"Report") action:@selector(report:)];
    return @[reportItem];
}

- (void)showMenuControllerWithFrame:(CGRect)frame {
    [self becomeFirstResponder];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect:frame inView:self];
    [menuController setMenuItems:[self menuItems]];
    [menuController setMenuVisible:YES animated:YES];
}

#pragma mark - Text.

- (NSUInteger)characterIndexWithGestureLocation:(CGPoint)location {
    location.x -= self.textContainerInset.left;
    location.y -= self.textContainerInset.top;
    return [self.layoutManager characterIndexForPoint:location inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
}

- (id)valueWithCharacterIndex:(NSUInteger)characterIndex attribute:(id)attribute {
    if (characterIndex < self.textStorage.length) {
        NSRange range;
        return [self.attributedText attribute:attribute atIndex:characterIndex effectiveRange:&range];
    } else {
        return nil;
    }
}

@end
