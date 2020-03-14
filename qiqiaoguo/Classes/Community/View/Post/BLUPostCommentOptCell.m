//
//  BLUPostCommentOptCell.m
//  Blue
//
//  Created by Bowen on 7/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostCommentOptCell.h"
#import "BLUComment.h"
#import "BLUPostCommentReplyUIComponent.h"
#import "BLUCommentReply.h"
#import "BLUCommentReplyTextView.h"
#import "BLUPost.h"

static const NSInteger kMaxReplyCount = 2;

@interface BLUPostCommentOptCell ()

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *lzButton;
@property (nonatomic, strong) UILabel *lvLabel;
@property (nonatomic, strong) UILabel *floorLabel;
@property (nonatomic, strong) UIView *replyContainer;
@property (nonatomic, strong) NSArray *replyTextViews;
@property (nonatomic, strong) UIButton *moreRpeliesButton;

@property (nonatomic, assign) BOOL shouldShowContent;
@property (nonatomic, assign) BOOL shouldShowReplies;
@property (nonatomic, assign) BOOL shouldShowLZ;

@property (nonatomic, assign) BOOL anonymous;

@property (nonatomic, assign, readwrite) NSInteger maxReplyCount;


@end

@implementation BLUPostCommentOptCell

#pragma mark - UITableViewCell.

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *superview = self.contentView;
        superview.layer.shouldRasterize = YES;
        superview.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        superview.backgroundColor = BLUThemeMainTintBackgroundColor;
        
        // Content label
        _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];

        // Liked button
        _likeButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
        _likeButton.tintColor = BLUThemeMainColor;
        [_likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];

        // Lz button
        _lzButton = [UIButton makeThemeButtonWithType:BLUButtonTypeSolidRoundRect];
        _lzButton.contentEdgeInsets = UIEdgeInsetsMake(0, [BLUCurrentTheme leftMargin], 0, [BLUCurrentTheme rightMargin]);
        _lzButton.titleColor = [UIColor whiteColor];
        _lzButton.title = NSLocalizedString(@"post-comment-opt-cell.lzButton.title", @"LZ");
        _lzButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall);

        // Level
//        _lvLabel = [UILabel new];
//        _lvLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall);
//        _lvLabel.textColor = [UIColor colorFromHexString:@"#cc9318"];
//        _lvLabel.borderWidth = 1.0;
//        _lvLabel.borderColor = _lvLabel.textColor;
//        _lvLabel.cornerRadius = BLUThemeNormalActivityCornerRadius;

        // floor button
        _floorLabel = [UILabel new];
        _floorLabel.numberOfLines = 1;
        _floorLabel.font = self.timeButton.titleFont;
        _floorLabel.textColor = self.timeButton.titleColor;

        // Solid line
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;

        // Reply container
        _replyContainer = [UIView new];
        _replyContainer.backgroundColor = BLUThemeSubTintBackgroundColor;
        _replyContainer.cornerRadius = BLUThemeHighActivityCornerRadius;

        // More replies button
        _moreRpeliesButton = [UIButton new];
        _moreRpeliesButton.titleColor = [UIColor colorFromHexString:@"4386f4"];
        _moreRpeliesButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);
        [_moreRpeliesButton addTarget:self action:@selector(showMoreReplies:) forControlEvents:UIControlEventTouchUpInside];

        _anonymous = NO;
        _maxReplyCount = kMaxReplyCount;

        [superview addSubview:_contentLabel];
        [superview addSubview:_likeButton];
        [superview addSubview:_lzButton];
//        [superview addSubview:_lvLabel];
        [superview addSubview:_floorLabel];
        [superview addSubview:_solidLine];
        [superview addSubview:_replyContainer];

        [_replyContainer addSubview:_moreRpeliesButton];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.replyContainer.hidden = YES;
    for (BLUCommentReplyTextView *textView in _replyTextViews) {
        [textView removeFromSuperview];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_likeButton sizeToFit];
     _likeButton.frame = CGRectMake(self.contentView.width - _likeButton.width - BLUThemeMargin * 3, 0, _likeButton.width, _likeButton.height);

    self.genderButton.width -= BLUThemeMargin;
    self.genderButton.height = self.genderButton.width;

    if (_lvLabel.hidden == NO) {
        [_lvLabel sizeToFit];
        _lvLabel.height = self.genderButton.height;
    } else {
        _lvLabel.frame = CGRectZero;
    }

    if (_shouldShowLZ) {
        [_lzButton sizeToFit];
        _lzButton.height = self.genderButton.height;
    } else {
        _lzButton.frame = CGRectZero;
    }

    CGFloat nicknameLabelMaxWidth = self.contentView.width - self.nicknameLabel.left - (self.contentView.width - self.likeButton.left) - BLUThemeMargin * 2;
    nicknameLabelMaxWidth -= _lvLabel.hidden == NO ? (_lvLabel.width + BLUThemeMargin) : 0;
    nicknameLabelMaxWidth -= self.genderButton.hidden == NO ? (self.genderButton.width + BLUThemeMargin) : 0;
    nicknameLabelMaxWidth -= _shouldShowLZ ? (_lzButton.width + BLUThemeMargin) : 0;
    self.nicknameLabel.width = self.nicknameLabel.width < nicknameLabelMaxWidth ? self.nicknameLabel.width : nicknameLabelMaxWidth;

//    self.genderButton.x = self.nicknameLabel.right + BLUThemeMargin;
//    self.genderButton.centerY = self.nicknameLabel.centerY;

    self.likeButton.centerY = self.nicknameLabel.centerY;

//    if (_lvLabel.hidden == NO) {
//        _lvLabel.x = self.genderButton.hidden == NO ? (self.genderButton.right + BLUThemeMargin) : BLUThemeMargin;
//        _lvLabel.centerY = self.nicknameLabel.centerY;
//    } else {
//        _lvLabel.frame = CGRectZero;
//    }

    if (_shouldShowLZ) {
        _lzButton.x = _lvLabel.hidden == NO ? (_lvLabel.right + BLUThemeMargin) : (self.genderButton.hidden == NO ? (self.genderButton.right + BLUThemeMargin) : self.nicknameLabel.right + BLUThemeMargin);
        _lzButton.centerY = self.nicknameLabel.centerY;
    } else {
        _lzButton.frame = CGRectZero;
    }

    self.likeButton.centerY = self.nicknameLabel.centerY;

    [_floorLabel sizeToFit];
    _floorLabel.frame = CGRectMake(self.nicknameLabel.left, self.avatarButton.bottom - _floorLabel.height, _floorLabel.width, _floorLabel.height);
    CGFloat maxTimeButtonWidth = self.contentView.width - self.nicknameLabel.left - BLUThemeMargin * 6 - _floorLabel.width;
    CGFloat timeButtonWidth = 0.0;
    if (self.timeButton.width < maxTimeButtonWidth) {
        timeButtonWidth = self.timeButton.width;
    } else {
        timeButtonWidth = maxTimeButtonWidth;
    }
    self.timeButton.frame = CGRectMake(self.timeButton.x + _floorLabel.width + BLUThemeMargin * 3, self.timeButton.y, timeButtonWidth, self.timeButton.height);

    if (self.shouldShowContent) {
        CGSize contentLabelSize = [_contentLabel sizeThatFits:CGSizeMake(self.contentView.width - BLUThemeMargin * 3 - self.nicknameLabel.left, CGFLOAT_MAX)];
        _contentLabel.frame = CGRectMake(self.nicknameLabel.left, self.cellSize.height + BLUThemeMargin * 2, self.contentView.width - BLUThemeMargin * 3 - self.nicknameLabel.left, contentLabelSize.height);
    } else {
        _contentLabel.frame = CGRectZero;
    }

    if (self.shouldShowReplies) {

        _replyContainer.hidden = NO;

        // TODO
        CGFloat containerY = self.shouldShowContent ? self.contentLabel.bottom + BLUThemeMargin * 2 : self.cellSize.height + BLUThemeMargin * 2;
        CGFloat containerWidth = self.contentView.width - BLUThemeMargin * 3 - self.nicknameLabel.left;

        __block CGFloat offsetY = 0;
        CGFloat offsetX = BLUThemeMargin;
        [_replyTextViews enumerateObjectsUsingBlock:^(BLUCommentReplyTextView *textView, NSUInteger idx, BOOL * _Nonnull stop) {
            CGSize textViewSize = [textView sizeThatFits:CGSizeMake(containerWidth - BLUThemeMargin * 2, CGFLOAT_MAX)];
            textView.frame = CGRectMake(offsetX, offsetY - BLUThemeMargin, textViewSize.width, textViewSize.height);
            offsetY = -BLUThemeMargin + textView.bottom;
        }];

        if (_moreRpeliesButton.hidden == NO) {
            [_moreRpeliesButton sizeToFit];
            _moreRpeliesButton.frame = CGRectMake(0, offsetY, _moreRpeliesButton.width, _moreRpeliesButton.height);
            _moreRpeliesButton.centerX = containerWidth / 2;
        }

        _replyContainer.frame = CGRectMake(self.nicknameLabel.left, containerY, containerWidth, _moreRpeliesButton.hidden ? offsetY : _moreRpeliesButton.bottom + BLUThemeMargin * 2);
    } else {
        _replyContainer.hidden = YES;
        _replyContainer.frame = CGRectZero;
    }

    CGFloat solidLineY = self.cellSize.height + (self.shouldShowContent ? self.contentLabel.height + BLUThemeMargin * 2 : 0) + (self.shouldShowReplies ? self.replyContainer.height + BLUThemeMargin * 2 : 0) + BLUThemeMargin * 2;
    _solidLine.frame = CGRectMake(self.avatarButton.left, solidLineY, self.contentView.width - self.avatarButton.left * 2, BLUThemeOnePixelHeight);

    self.cellSize = CGSizeMake(self.contentView.width, _solidLine.bottom);
}

#pragma mark - Model.

- (void)setModel:(id)model
        postUser:(BLUUser *)postUser
            post:(BLUPost *)post
shouldShowCompleteReplies:(BOOL)showCompleteReplies
        delegate:(id <BLUPostCommentActionDelegate>)delegate
replytTextViewDelegate:(id <BLUCommentReplyTextViewDelegate>)replyTextViewDelegate
  userTransition:(id <BLUUserTransitionDelegate>)userTransitionDelegate {

    if (showCompleteReplies) {
        self.maxReplyCount = 0;
    } else {
        self.maxReplyCount = kMaxReplyCount;
    }

    _comment = (BLUComment *)model;
    _postUser = postUser;

    _replyTextViewDelegate = replyTextViewDelegate;
    self.userTransitionDelegate = userTransitionDelegate;
    self.delegate = delegate;

    _shouldShowContent = _comment.content.length > 0;
    _shouldShowReplies = _comment.replies.count > 0;
    _shouldShowLZ = _comment.author.userID == _postUser.userID;
    _anonymous = _shouldShowLZ == YES && post.anonymousEnable == YES ? YES : NO;

    if (_shouldShowLZ) {
        [self setUser:_comment.author anonymous:post.anonymousEnable];
    } else {
        self.user = _comment.author;
    }

//    self.genderButton.hidden = _anonymous;

    self.time = _comment.createDate.postTime;
    _contentLabel.attributedText = [NSAttributedString contentAttributedStringWithContent:self.comment.content];
    _contentLabel.hidden = !self.shouldShowContent;
    _floorLabel.text = self.comment.floorDesc;

    self.lvLabel.text = [NSString stringWithFormat:@" %@ ", _comment.author.levelDesc];
    self.lvLabel.hidden = post.anonymousEnable;

    if (_comment.didLike) {
        _likeButton.image = [BLUCurrentTheme postDislikeNormalIcon];
    } else {
        _likeButton.image = [BLUCurrentTheme postLikeNormalIcon];
    }

    _likeButton.title = [NSString stringWithFormat:@" %@", @(_comment.likeCount)];

    _lzButton.hidden = !_shouldShowLZ;

    if (_shouldShowReplies) {
        NSMutableArray *replyTextViews = [NSMutableArray new];
        [_comment.replies enumerateObjectsUsingBlock:^(BLUCommentReply *reply, NSUInteger idx, BOOL * _Nonnull stop) {
            BLUCommentReplyTextView *textView = [BLUCommentReplyTextView new];
            [textView setCommentReply:reply post:post comment:_comment];
            textView.commentReplyDelegate = replyTextViewDelegate;
            textView.userTransitionDelegate = userTransitionDelegate;
            [_replyContainer addSubview:textView];
            [replyTextViews addObject:textView];
            if (self.maxReplyCount > 0) {
                if (idx == self.maxReplyCount - 1) {
                    *stop = YES;
                }
            }
        }];
        _replyTextViews = replyTextViews;

        NSInteger remainRepliesCount = _comment.replies.count - _replyTextViews.count;
        if (remainRepliesCount > 0) {
            _moreRpeliesButton.hidden = NO;
            _moreRpeliesButton.title = [NSString stringWithFormat:NSLocalizedString(@"post-comment-cell.more-replies-button.title %@", @"More replies"), @(remainRepliesCount)];
        } else {
            _moreRpeliesButton.hidden = YES;
        }
    } else {
        _moreRpeliesButton.hidden = YES;
    }
}

- (NSDictionary *)commentInfo {
    NSDictionary *info = nil;
    if (self.comment) {
        info = @{BLUCommentKeyComment: self.comment};
    }
    return info;
}

#pragma mark - Handler.

- (void)likeAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(shouldLikeComment:fromView:sender:)]) {
        if (self.comment.didLike) {
            [self.delegate shouldDislikeComment:[self commentInfo] fromView:self sender:button];
        } else {
            [self.delegate shouldLikeComment:[self commentInfo] fromView:self sender:button];
        }
    }
}

- (void)replyAction:(id)sender {
    // TODO
    BLULogDebug(@"");
}

- (void)transitToUserAction:(id)sender {
    if (_anonymous) {
        return ;
    }
    if ([self.userTransitionDelegate respondsToSelector:@selector(shouldTransitToUser:fromView:sender:)]) {
        if ([sender isKindOfClass:[BLUAvatarButton class]]) {
            BLUAvatarButton *avatarButton = sender;
            if (avatarButton.user) {
                NSDictionary *userInfo = @{BLUUserKeyUser: avatarButton.user};
                [self.userTransitionDelegate shouldTransitToUser:userInfo fromView:self sender:sender];
            }
        }
    }
}

- (void)showMoreReplies:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shouldShowMoreRepliesForComment:formView:sender:)]) {
        [self.delegate shouldShowMoreRepliesForComment:[self commentInfo] formView:self sender:sender];
    }
}

@end
