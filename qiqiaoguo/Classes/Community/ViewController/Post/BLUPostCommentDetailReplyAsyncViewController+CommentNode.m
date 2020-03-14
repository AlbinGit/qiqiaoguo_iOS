//
//  BLUPostCommentDetailReplyAsyncViewController+CommentNode.m
//  Blue
//
//  Created by Bowen on 26/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommentDetailReplyAsyncViewController+CommentNode.h"
#import "BLUComment.h"
#import "BLUPost.h"
#import "BLUPostCommentDetailAsyncViewModel.h"
#import "BLUOtherUserViewController.h"
#import "BLUReportViewModel.h"
#import "BLUCommentReply.h"
#import "BLUPostDetailCommentReplyTextNode.h"

@implementation BLUPostCommentDetailReplyAsyncViewController (CommentNode)

#pragma mark - Comment node
- (void)shouldUpdateLikeStateForComment:(BLUComment *)comment
                                   from:(BLUPostDetailCommentNode *)node
                                 sender:(id)sender {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    if (comment.didLike) {
        [self.viewModel dislikeComment];
    } else {
        [self.viewModel likeComment];
    }
}

- (void)shouldShowUserDetailForUser:(BLUUser *)user
                               from:(BLUPostDetailCommentNode *)node
                             sender:(id)sender {
    BLUAssertObjectIsKindOfClass(user, [BLUUser class]);
    BLUOtherUserViewController *vc =
    [[BLUOtherUserViewController alloc] initWithUserID:user.userID];
    [self pushViewController:vc];
}

#pragma mark - Text node

- (void)shouldReplyToCommentReply:(BLUCommentReply *)reply
                             from:(BLUPostDetailCommentReplyTextNode *)node {
    [self replyToReply:reply];
}

- (void)shouldDeleteCommentReply:(BLUCommentReply *)reply
                            from:(BLUPostDetailCommentReplyTextNode *)node {
    [self.viewModel deleteReply:reply];
}

- (void)shouldReportCommentReply:(BLUCommentReply *)reply
                            from:(BLUPostDetailCommentReplyTextNode *)node {

    BLUReportViewModel *reportViewModel =
    [[BLUReportViewModel alloc ]
     initWithObjectID:reply.replyID
     viewController:self
     sourceView:node.view
     sourceRect:node.bounds
     sourceType:BLUReportSourceTypeReply];

    [reportViewModel showReportSheet];
}

- (void)shouldShowUserDetails:(BLUUser *)user
                         from:(BLUPostDetailCommentReplyTextNode *)node {
    BLUAssertObjectIsKindOfClass(user, [BLUUser class]);
    BLUOtherUserViewController *vc =
    [[BLUOtherUserViewController alloc] initWithUserID:user.userID];
    [self pushViewController:vc];
}

@end
