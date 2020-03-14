//
//  BLUPostDetailCommentReplyAsyncViewModel.m
//  Blue
//
//  Created by Bowen on 25/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommentDetailAsyncViewModel.h"
#import "BLUComment.h"
#import "BLUApiManager+Comment.h"
#import "BLUCommentReply.h"

@implementation BLUPostCommentDetailAsyncViewModel

- (instancetype)initWithCommentID:(NSInteger)commentID {
    if (self = [super init]) {
        BLUParameterAssert(commentID > 0);
        _commentID = commentID;
    }
    return self;
}

#pragma mark - Comment

- (void)replyComment:(NSString *)content {
    BLUParameterAssert([content isCommentContent]);
    if (_comment == nil) {
        return;
    }
    @weakify(self);
    [[[BLUApiManager sharedManager]
      replyComment:self.comment.commentID
      content:content
      user:nil]
     subscribeError:^(NSError *error) {
        @strongify(self);
        [self sendError:error];
    } completed:^{
        @strongify(self);
        [self updateComment];
    }];
}

- (void)likeComment {
    if (_comment == nil) {
        return;
    }

    [self changeLikeState:YES];
    [self didChangeComment];
}

- (void)dislikeComment {
    if (_comment == nil) {
        return;
    }

    [self changeLikeState:NO];
    [self didChangeComment];
}

- (void)changeLikeState:(BOOL)likeState {

    if (_comment == nil) {
        return;
    }

    self.comment.like = likeState;
    self.comment.likeCount += likeState == YES ? 1 : -1;

    void (^purgeForError)(NSError *) = ^(NSError *error) {
        [self changeLikeState:!likeState];
        [self didChangeComment];
        [self sendError:error];
    };

    if (likeState) {
        [[[BLUApiManager sharedManager]
          likeCommentWithCommentID:self.comment.commentID]
         subscribeError:^(NSError *error) {
            purgeForError(error);
        }];
    } else {
        [[[BLUApiManager sharedManager]
          dislikeCommentWithCommentID:self.comment.commentID]
         subscribeError:^(NSError *error) {
            purgeForError(error);
        }];
    }
}

- (void)updateComment {
    @weakify(self);
    [[[BLUApiManager sharedManager]
      fetchCommentWithCommentID:_commentID]
     subscribeNext:^(BLUComment *comment) {
        @strongify(self);
        BLUAssertObjectIsKindOfClass(comment, [BLUComment class])
        self.comment = comment;
         [self didChangeComment];
    } error:^(NSError *error) {
        @strongify(self);
        [self sendError:error];
    }];
}

#pragma mark - Reply

- (void)replyToReply:(BLUCommentReply *)reply content:(NSString *)content {
    BLUAssertObjectIsKindOfClass(reply, [BLUCommentReply class]);

    if (_comment == nil) {
        return;
    }

    @weakify(self);
    [[[BLUApiManager sharedManager] replyComment:self.comment.commentID
                                         content:content
                                            user:reply.author]
     subscribeError:^(NSError *error) {
        @strongify(self);
        [self sendError:error];
    } completed:^{
        @strongify(self);
        [self updateComment];
    }];
}

- (void)deleteReply:(BLUCommentReply *)reply {
    BLUAssertObjectIsKindOfClass(reply, [BLUCommentReply class]);

    if (_comment == nil) {
        return;
    }

    @weakify(self);
    [[[BLUApiManager sharedManager]
      deleteReply:reply.replyID]
     subscribeError:^(NSError *error) {
        @strongify(self);
        [self sendError:error];
    } completed:^{
        @strongify(self);
        [self updateComment];
    }];
}

#pragma mark - Delegate

- (void)didChangeComment {
    if ([self.delegate
         respondsToSelector:@selector(viewModel:didChangeComment:)]) {
        [self.delegate viewModel:self didChangeComment:self.comment];
    }
}

- (void)sendSuccessMessage:(NSString *)message {
    if ([self.delegate
         respondsToSelector:@selector(viewModel:didSuccessWithMessage:)]) {
        [self.delegate viewModel:self didSuccessWithMessage:message];
    }
}

- (void)sendError:(NSError *)error {
    if ([self.delegate
         respondsToSelector:@selector(viewModel:didMeetError:)]) {
        [self.delegate viewModel:self didMeetError:error];
    }
}

@end
