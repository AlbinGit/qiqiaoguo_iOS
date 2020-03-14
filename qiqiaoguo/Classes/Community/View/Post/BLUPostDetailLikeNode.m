//
//  BLUPostDetailLikeNode.m
//  Blue
//
//  Created by Bowen on 31/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailLikeNode.h"
#import "BLUPost.h"

@implementation BLUPostDetailLikeNode

- (instancetype)initWithPost:(BLUPost *)post {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(post, [BLUPost class]);

        _post = post;

        _contentInset = BLUThemeMargin * 4;
        _contentMargin = BLUThemeMargin * 2;
        _likeUsersSpacing = BLUThemeMargin * 2;
        _likedUserWidth = 24.0;
        _likeButtonHeight = 56.0;
        // Like button
        _likeButton = [ASImageNode new];
        _likeButton.backgroundColor = [UIColor clearColor];
        [_likeButton addTarget:self
                        action:@selector(tapAndChangeLikeState:)
              forControlEvents:ASControlNodeEventTouchUpInside];
        [self configureLikeButtonWithPost:post];

        // Liked user nodes
        NSMutableArray *likedUserNodes = [NSMutableArray new];
        for (NSInteger i = 0; i < _post.likedUsers.count; i++) {
            ASNetworkImageNode *userNode =
            [[ASNetworkImageNode alloc] initWithWebImage];
            userNode.backgroundColor = BLUThemeSubTintBackgroundColor;
            BLUUser *user = _post.likedUsers[i];
            userNode.URL = user.avatar.thumbnailURL;
            [userNode addTarget:self
                         action:@selector(tapAndShowUser:)
               forControlEvents:ASControlNodeEventTouchUpInside];
            [likedUserNodes addObject:userNode];
        }
        _likedUserNodes = likedUserNodes;

        // Show like users button
        _showlikeUsersButton = [ASImageNode new];
        _showlikeUsersButton.image =
        [UIImage imageNamed:@"post-detail-more-liked-users"];
        [_showlikeUsersButton addTarget:self
                                 action:@selector(tapAndShowLikedUsers:)
                       forControlEvents:ASControlNodeEventTouchUpInside];

        // Like prompt node
        _likePromptNode = [ASTextNode new];
        _likePromptNode.attributedString =
        [self attributedNumberOfLikedUsers:_post.likeCount];
        [_likePromptNode addTarget:self
                            action:@selector(tapAndShowLikedUsers:)
                  forControlEvents:ASControlNodeEventTouchUpInside];

        [self addSubnode:_likeButton];
        for (ASNetworkImageNode *node in _likedUserNodes) {
            [self addSubnode:node];
        }
        [self addSubnode:_showlikeUsersButton];
        [self addSubnode:_likePromptNode];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}

- (void)setPost:(BLUPost *)post {
    _post = post;
    [_likedUserNodes enumerateObjectsUsingBlock:^(ASNetworkImageNode *node, NSUInteger idx, BOOL * _Nonnull stop) {
        [node removeFromSupernode];
    }];
    _likedUserNodes = nil;

    NSMutableArray *likedUserNodes = [NSMutableArray new];
    for (NSInteger i = 0; i < _post.likedUsers.count; ++i) {
        ASNetworkImageNode *userNode =
        [[ASNetworkImageNode alloc] initWithWebImage];
        userNode.backgroundColor = BLUThemeSubTintBackgroundColor;
        BLUUser *user = _post.likedUsers[i];
        userNode.URL = user.avatar.thumbnailURL;
        [userNode addTarget:self
                     action:@selector(tapAndShowUser:)
           forControlEvents:ASControlNodeEventTouchUpInside];
        [likedUserNodes addObject:userNode];
    }
    _likedUserNodes = likedUserNodes;

    for (ASNetworkImageNode *node in _likedUserNodes) {
        [self addSubnode:node];
    }

    _likePromptNode.attributedString =
    [self attributedNumberOfLikedUsers:_post.likeCount];

    [self configureLikeButtonWithPost:post];

    [self setNeedsLayout];
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize calculateSize = CGSizeZero;

    [_likePromptNode
     measure:CGSizeMake(constrainedSize.width, constrainedSize.height)];

    calculateSize.height += _contentInset;
    calculateSize.height += _likeButtonHeight;
    if (_likedUserNodes.count > 0) {
        calculateSize.height += _contentInset;
        calculateSize.height += _likedUserWidth;
    }

    calculateSize.height += _contentInset;
    return calculateSize;
}

- (void)layout {
    [super layout];
    CGFloat likeButtonX = self.calculatedSize.width / 2.0 -
    _likeButtonHeight / 2.0;
    _likeButton.frame =
    CGRectMake(likeButtonX, _contentInset,
               _likeButtonHeight, _likeButtonHeight);

    for (ASNetworkImageNode *node in _likedUserNodes) {
        node.hidden = YES;
        node.frame = CGRectZero;
    }

    _likePromptNode.hidden = YES;
    _likePromptNode.frame = CGRectZero;

    _showlikeUsersButton.hidden = YES;
    _showlikeUsersButton.frame = CGRectZero;

    if (_likedUserNodes.count > 0) {
        CGFloat contentWidth = self.calculatedSize.width - _contentInset * 2;
        CGFloat likedUserNodeX = _contentInset;
        CGFloat likedUserNodeY =
        CGRectGetMaxY(_likeButton.frame) + _contentInset;

        CGFloat userRequiredWidth = _likedUserWidth + _contentMargin;

        CGFloat userSectionWidth =
        contentWidth - self.likePromptNode.calculatedSize.width;

        __block CGFloat remainingWidth = userSectionWidth;
        __block CGFloat offset = likedUserNodeX;

        [_likedUserNodes
         enumerateObjectsUsingBlock:^(ASNetworkImageNode *node,
                                      NSUInteger idx,
                                      BOOL * _Nonnull stop) {
            if (remainingWidth > (userRequiredWidth * 2)) {
                node.cornerRadius = _likedUserWidth / 2.0;
                node.clipsToBounds = YES;
                node.hidden = NO;
                node.frame =
                CGRectMake(offset, likedUserNodeY,
                           _likedUserWidth, _likedUserWidth);
                offset += userRequiredWidth;
                remainingWidth -= userRequiredWidth;
            } else if (remainingWidth > (userRequiredWidth * 1)) {
                _showlikeUsersButton.hidden = NO;
                _showlikeUsersButton.frame =
                CGRectMake(offset, likedUserNodeY,
                           _likedUserWidth, _likedUserWidth);
                offset += userRequiredWidth;
                remainingWidth -= userRequiredWidth;
                *stop = YES;
            } else {
                *stop = YES;
            }

        }];

        _likePromptNode.hidden = NO;
        CGFloat likePromptNodeX =
        self.calculatedSize.width - _contentInset -
        _likePromptNode.calculatedSize.width;
        CGFloat likePromptNodeY =
        likedUserNodeY + (_likedUserWidth / 2.0 -
                          _likePromptNode.calculatedSize.height / 2.0);
        _likePromptNode.frame =
        CGRectMake(likePromptNodeX, likePromptNodeY,
                   _likePromptNode.calculatedSize.width,
                   _likePromptNode.calculatedSize.height);


        if (_showlikeUsersButton.hidden == NO) {
            NSInteger count = 0.0;
            CGFloat acturlWidth = CGRectGetWidth(_showlikeUsersButton.frame);

            count += 1;

            for (ASNetworkImageNode *node in _likedUserNodes) {
                if (node.hidden == NO) {
                    acturlWidth += CGRectGetWidth(node.frame);
                    count += 1;
                }
            }

            CGFloat likedUserMargin = (userSectionWidth - acturlWidth) / count;

            CGFloat offset = _contentInset;

            for (ASNetworkImageNode *node in _likedUserNodes) {
                if (node.hidden == NO) {
                    CGFloat y = CGRectGetMinY(node.frame);
                    CGFloat width = CGRectGetWidth(node.frame);
                    CGFloat height = CGRectGetHeight(node.frame);
                    node.frame = CGRectMake(offset, y, width, height);
                    offset += width + likedUserMargin;
                }
            }

            CGFloat y = CGRectGetMinY(_showlikeUsersButton.frame);
            CGFloat width = CGRectGetWidth(_showlikeUsersButton.frame);
            CGFloat height = CGRectGetHeight(_showlikeUsersButton.frame);
            _showlikeUsersButton.frame =
            CGRectMake(offset, y, width, height);
        }
    }
}

- (void)tapAndChangeLikeState:(id)sender {
    if ([self.delegate
         respondsToSelector:@selector(shouldChangeLikeStateForPost:from:sender:)]) {
        [self.delegate shouldChangeLikeStateForPost:self.post
                                               from:self
                                             sender:sender];
    }
}

- (void)tapAndShowLikedUsers:(id)sender {
    if ([self.delegate
         respondsToSelector:@selector(shouldShowLikedUsersForPost:from:sender:)]) {
        [self.delegate shouldShowLikedUsersForPost:self.post
                                              from:self
                                            sender:self];
    }
}

- (void)tapAndShowUser:(id)sender {
    NSInteger index = [self.likedUserNodes indexOfObject:sender];
    BLUParameterAssert(index != NSNotFound && index < self.post.likedUsers.count);
    BLUUser *user = [self.post.likedUsers objectAtIndex:index];
    if ([self.delegate
         respondsToSelector:@selector(shouldShowUserDetailsForUser:from:sender:)]) {
        [self.delegate shouldShowUserDetailsForUser:user
                                               from:self
                                             sender:sender];
    }
}

- (void)configureLikeButtonWithPost:(BLUPost *)post {
    BLUAssertObjectIsKindOfClass(post, [BLUPost class]);
    if (post.didLike) {
        _likeButton.image = [UIImage imageNamed:@"post-dislike-large"];
    } else {
        _likeButton.image = [UIImage imageNamed:@"post-like-large"];
    }
}

- (CGFloat)contentMaxWidth {
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    return MAX(height, width);
}

- (NSAttributedString *)attributedNumberOfLikedUsers:(NSInteger)number {
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"post-detail-node.liked-user-button.title-%@", @"Like"), @(number)];
    return [[NSAttributedString alloc] initWithString:text
                                           attributes:[self circleFromAttributes]];
}

- (NSDictionary *)circleFromAttributes {
    return @{
             NSFontAttributeName:
                 BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal),
             NSForegroundColorAttributeName:
                 [UIColor colorFromHexString:@"#999999"],
             };
}

@end
