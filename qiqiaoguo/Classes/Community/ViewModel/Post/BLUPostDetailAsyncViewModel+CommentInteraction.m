//
//  BLUPostDetailAsyncViewModel+CommentInteraction.m
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModelHeader.h"

@implementation BLUPostDetailAsyncViewModel (CommentInteraction)

#pragma mark - Like

- (void)likeComment:(BLUComment *)comment {
    [self changeLikeStateForComment:comment likeState:YES];
    [self makeChangeLikeStateRequestForComment:comment likeState:YES];
}

- (void)disLikeComment:(BLUComment *)comment {
    [self changeLikeStateForComment:comment likeState:NO];
    [self makeChangeLikeStateRequestForComment:comment likeState:NO];
}

- (void)changeLikeStateForComment:(BLUComment *)comment
                        likeState:(BOOL)likeState {
    comment.like = likeState;
    comment.likeCount += likeState == YES ? 1 : -1;
    [self updateCommentForAllComments:comment];
    [self updateCommentsUIForComment:comment];
}

- (void)makeChangeLikeStateRequestForComment:(BLUComment *)comment
                                   likeState:(BOOL)likeState {
    if (likeState) {
        @weakify(self);
        [[[BLUApiManager sharedManager] likeCommentWithCommentID:comment.commentID] subscribeError:^(NSError *error) {
            @strongify(self);
            [self changeLikeStateForComment:comment likeState:!likeState];
            [self sendError:error];
        }];
    } else {
        @weakify(self);
        [[[BLUApiManager sharedManager] dislikeCommentWithCommentID:comment.commentID] subscribeError:^(NSError *error) {
            @strongify(self);
            [self changeLikeStateForComment:comment likeState:!likeState];
            [self sendError:error];
        }];
    }
}

#pragma mark - Reply

- (void)replyToPostWithContent:(NSString *)content {
    @weakify(self);
    [[[BLUApiManager sharedManager] comment:content post:[[self post] postID]] subscribeError:^(NSError *error) {
        @strongify(self);
        [self sendError:error];
    } completed:^{
        @strongify(self);
        [self sendSuccessMessage:NSLocalizedString(@"post-detail-async-vm.reply-success",
                                                   @"Reply success!")];
        [self sendReplySuccessWithPost:[self post] content:content];

        if (self.commentType == BLUPostDetailAsyncCommentTypeDescComments) {
            [self refreshCommentsForType:BLUPostDetailAsyncCommentTypeDescComments];
        }
    }];
}

- (void)replyToCommentAtIndexPath:(NSIndexPath *)indexPath
                          content:(NSString *)content {
    return [self replyToCommentReplyAtIndexPath:indexPath
                                          reply:nil
                                        content:content];
}

- (void)replyToCommentReplyAtIndexPath:(NSIndexPath *)indexPath
                                 reply:(BLUCommentReply *)reply
                               content:(NSString *)content {

    BLUUser *author = nil;
    if (reply) {
        NSParameterAssert([reply isKindOfClass:[BLUCommentReply class]]);
        author = reply.author;
        NSParameterAssert([author isKindOfClass:[BLUUser class]]);
    }

    NSParameterAssert([content isCommentReply]);
    BLUComment *comment = (BLUComment *)[self objectAtIndexPath:indexPath];
    [self.disposable dispose];
    @weakify(self);
    self.disposable =
    [[[BLUApiManager sharedManager] replyComment:comment.commentID
                                         content:content
                                            user:author]
     subscribeError:^(NSError *error) {
         @strongify(self);
         [self sendError:error];
     } completed:^{
         @strongify(self);
         [self updateComment:comment atIndexPath:indexPath];
     }];
}

- (void)updateComment:(BLUComment *)comment atIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert([comment isKindOfClass:[BLUComment class]]);
    self.disposable =
    [[[BLUApiManager sharedManager] fetchCommentWithCommentID:comment.commentID]
     subscribeNext:^(BLUComment *paramComment) {
         NSParameterAssert([comment isKindOfClass:[BLUComment class]]);
         NSMutableArray *rows = [self rowsAtSection:indexPath.section];
         NSParameterAssert(indexPath.row >= 0 && indexPath.row < rows.count);
         [rows replaceObjectAtIndex:indexPath.row withObject:paramComment];
         [self contentWillChange];
         [self didChangeObject:paramComment atIndexPath:indexPath
                 forChangeType:BLUViewModelObjectChangeTypeDelete
                  newIndexPath:nil];
         [self didChangeObject:paramComment atIndexPath:indexPath
                 forChangeType:BLUViewModelObjectChangeTypeInsert
                  newIndexPath:nil];
         [self contentDidChange];
     } error:^(NSError *error) {
         [self sendError:error];
     }];
}

- (void)deleteCommentReplyAtIndexPath:(NSIndexPath *)indexPath
                                reply:(BLUCommentReply *)reply {

    NSParameterAssert([reply isKindOfClass:[BLUCommentReply class]]);

    [self.disposable dispose];

    @weakify(self);
    self.disposable =
    [[[BLUApiManager sharedManager] deleteReply:reply.replyID] subscribeError:^(NSError *error) {
        @strongify(self);
        [self sendError:error];
    } completed:^{
        @strongify(self);
        BLUComment *comment = [self objectAtIndexPath:indexPath];
        [self updateComment:comment atIndexPath:indexPath];
    }];

}

- (void)deleteCommentAtIndexPath:(NSIndexPath *)indexPath {
    BLUComment *comment = [self objectAtIndexPath:indexPath];
    NSParameterAssert([comment isKindOfClass:[BLUComment class]]);

    NSMutableArray *rows = [self rowsAtSection:indexPath.section];
    [self contentWillChange];
    NSArray *oldIndexPaths = [self indexPathsOfRows:rows section:indexPath.section];
    [self didChangeObjects:rows atIndexPaths:oldIndexPaths forChangeType:BLUViewModelObjectChangeTypeDelete];
    [rows removeObjectAtIndex:indexPath.row];

    NSArray *newIndexPaths = [self indexPathsOfRows:rows section:indexPath.section];
    [self didChangeObjects:rows atIndexPaths:newIndexPaths forChangeType:BLUViewModelObjectChangeTypeInsert];

    NSInteger indexOfFeaturedComment =
    [self indexForComment:comment inComments:self.featuredComments];

    if (indexOfFeaturedComment != NSNotFound) {
        NSArray *oldFeaturedIndexPaths =
        [self indexPathsOfRows:self.featuredComments
                       section:[self sectionOfRows:self.featuredComments]];
        [self didChangeObjects:self.featuredComments
                  atIndexPaths:oldFeaturedIndexPaths
                 forChangeType:BLUViewModelObjectChangeTypeDelete];
        [self.featuredComments removeObjectAtIndex:indexOfFeaturedComment];
        NSArray *newFeaturedIndexPaths =
        [self indexPathsOfRows:self.featuredComments
                       section:[self sectionOfRows:self.featuredComments]];
        [self didChangeObjects:self.featuredComments
                  atIndexPaths:newFeaturedIndexPaths
                 forChangeType:BLUViewModelObjectChangeTypeInsert];
    }

    [self contentDidChange];

    @weakify(self);
    self.disposable =
    [[[BLUApiManager sharedManager] deleteCommentWithCommentID:comment.commentID]
     subscribeError:^(NSError *error) {
         @strongify(self);
        [self sendError:error];

         NSArray * oldIndexPaths = [self indexPathsOfRows:rows section:indexPath.section];
         [self didChangeObjects:rows atIndexPaths:oldIndexPaths forChangeType:BLUViewModelObjectChangeTypeDelete];

         [rows insertObject:comment atIndex:indexPath.row];

         NSArray * newIndexPaths = [self indexPathsOfRows:rows section:indexPath.section];
         [self didChangeObjects:rows atIndexPaths:newIndexPaths forChangeType:BLUViewModelObjectChangeTypeInsert];

         if (indexOfFeaturedComment != NSNotFound) {
             NSArray *oldFeaturedIndexPaths =
             [self indexPathsOfRows:self.featuredComments
                            section:[self sectionOfRows:self.featuredComments]];
             [self didChangeObjects:self.featuredComments
                       atIndexPaths:oldFeaturedIndexPaths
                      forChangeType:BLUViewModelObjectChangeTypeDelete];

             [self.featuredComments insertObject:comment atIndex:indexOfFeaturedComment];

             NSArray *newFeaturedIndexPaths =
             [self indexPathsOfRows:self.featuredComments
                            section:[self sectionOfRows:self.featuredComments]];
             [self didChangeObjects:self.featuredComments
                       atIndexPaths:newFeaturedIndexPaths
                      forChangeType:BLUViewModelObjectChangeTypeInsert];
         }

         [self contentWillChange];

     }];
}

@end
