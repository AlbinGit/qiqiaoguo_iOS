//
//  BLUPostDetailAsyncViewController+PostDetailCommentNode.m
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController+PostDetailCommentNode.h"
#import "BLUPostDetailAsyncViewModel+CommentInteraction.h"
#import "BLUComment.h"
#import "BLUOtherUserViewController.h"
#import "BLUPostCommentDetailReplyAsyncViewController.h"
#import "BLUPostDetailAsyncViewModelHeader.h"
#import "BLUReportViewModel.h"
#import "BLUPostDetailCommentReplyTextNode.h"
#import "BLUContentReplyView.h"

@implementation BLUPostDetailAsyncViewController (PostDetailCommentNode)

#pragma mark - CommentNode

- (void)shouldUpdateLikeStateForComment:(BLUComment *)comment
                                   from:(BLUPostDetailCommentNode *)node
                                 sender:(id)sender {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);

    if ([self loginIfNeeded]) {
        return;
    }

    if (comment.didLike) {
        [self.viewModel disLikeComment:comment];
    } else {
        [self.viewModel likeComment:comment];
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

#pragma mark - Reply node

- (void)shouldShowRepliesForComment:(BLUComment *)comment
                               from:(BLUPostDetailCommentReplyNode *)replyNode
                             sender:(id)sender {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    if (comment) {
        BLUPostCommentDetailReplyAsyncViewController *vc =
        [[BLUPostCommentDetailReplyAsyncViewController alloc]
         initWithComment:comment
         post:[self.viewModel post]];

        [self pushViewController:vc];
    }
}

#pragma mark - Text node

- (void)shouldReplyToCommentReply:(BLUCommentReply *)reply
                             from:(BLUPostDetailCommentReplyTextNode *)node {
    BLUComment *comment = [self targetCommentFromReply:reply];

    if (comment) {
        BLUPostCommentDetailReplyAsyncViewController *vc =
        [[BLUPostCommentDetailReplyAsyncViewController alloc]
         initWithComment:comment
         post:[self.viewModel post]];
        [vc setTargetReply:reply];

        [self pushViewController:vc];
    }
}

- (void)shouldShowUserDetails:(BLUUser *)user
                         from:(BLUPostDetailCommentReplyTextNode *)node {
    BLUAssertObjectIsKindOfClass(user, [BLUUser class]);
    BLUOtherUserViewController *vc =
    [[BLUOtherUserViewController alloc] initWithUserID:user.userID];
    [self pushViewController:vc];
}

- (void)shouldDeleteCommentReply:(BLUCommentReply *)reply
                            from:(BLUPostDetailCommentReplyTextNode *)node {
    BLUComment *comment = [self targetCommentFromReply:reply];
    NSIndexPath *indexPath = [self.viewModel indexPathForComment:comment];
    [self.viewModel deleteCommentReplyAtIndexPath:indexPath reply:reply];
}

- (BLUComment *)targetCommentFromReply:(BLUCommentReply *)reply {
    NSArray *comments = [self.viewModel currentComments];
    BLUComment *targetComment = nil;
    for (BLUComment *comment in comments) {
        for (BLUCommentReply *iReply in comment.replies) {
            if (iReply.replyID == reply.replyID) {
                targetComment = comment;
                break;
            }
        }
    }
    return targetComment;
}

- (void)shouldReportCommentReply:(BLUCommentReply *)reply
                            from:(BLUPostDetailCommentReplyTextNode *)node {
    BLUReportViewModel *reportViewModel =
    [[BLUReportViewModel alloc ] initWithObjectID:reply.replyID
                                   viewController:self
                                       sourceView:node.view
                                       sourceRect:node.view.bounds
                                       sourceType:BLUReportSourceTypeReply];
    [reportViewModel showReportSheet];
}

@end
