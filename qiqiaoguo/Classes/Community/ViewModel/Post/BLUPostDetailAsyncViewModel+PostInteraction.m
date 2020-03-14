//
//  BLUPostDetailAsyncViewModel+PostInteraction.m
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel+PostInteraction.h"
#import "BLUPostDetailAsyncViewModelHeader.h"
#import "BLUApiManager+Post.h"

@implementation BLUPostDetailAsyncViewModel (PostInteraction)

- (void)updateUIForPost:(BLUPost *)post {
    [self contentWillChange];
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (post.didLike) {
        NSMutableArray *likedUsers;
        if (post.likedUsers.count > 0) {
            likedUsers = [NSMutableArray arrayWithArray:post.likedUsers];
            BOOL shouldAddCurrentUser = YES;
            for (BLUUser *user in likedUsers) {
                BLUAssertObjectIsKindOfClass(user, [BLUUser class]);
                if (user.userID == currentUser.userID) {
                    shouldAddCurrentUser = NO;
                    return;
                }
            }
            if (shouldAddCurrentUser) {
                [likedUsers insertObject:currentUser atIndex:0];
            }
            post.likedUsers = likedUsers;
        } else {
            post.likedUsers = @[currentUser];
        }
    } else {
        if (post.likedUsers.count > 0) {
            NSMutableArray *likedUsers = [NSMutableArray arrayWithArray:post.likedUsers];
            for (BLUUser *user in likedUsers) {
                if (user.userID == currentUser.userID) {
                    [likedUsers removeObject:user];
                    break;
                }
            }
            post.likedUsers = likedUsers;
        }
    }
    [self didChangeObject:post atIndexPath:[self postIndexPath]
            forChangeType:BLUViewModelObjectChangeTypeUpdate
             newIndexPath:nil];
    [self didChangeObject:post atIndexPath:[self postLikeIndexPath]
            forChangeType:BLUViewModelObjectChangeTypeUpdate
             newIndexPath:nil];
    [self contentDidChange];
}

#pragma mark - Post Like state

- (void)likePost {
    [self changeLikeStatelikeForPost:YES];
}

- (void)dislikePost {
    [self changeLikeStatelikeForPost:NO];
}

- (void)changeLikeStatelikeForPost:(BOOL)like {
    BLUPost *post = [self post];
    BOOL oldState = post.like;
    post.like = like;

    [self.disposable dispose];

    @weakify(self);
    if (like == YES) {
        post.likeCount++;
        self.disposable =
        [[[BLUApiManager sharedManager] likePostWithPostID:post.postID]
         subscribeError:^(NSError *error) {
             @strongify(self);
             [self dealWithLikeRequestError:error
                                    forPost:post
                               oldLikeState:oldState];
         }];
    } else {
        post.likeCount--;
        self.disposable =
        [[[BLUApiManager sharedManager] dislikePostWithPostID:post.postID]
         subscribeError:^(NSError *error) {
             @strongify(self);
             [self dealWithLikeRequestError:error
                                    forPost:post
                               oldLikeState:oldState];
         }];
    }
    [self updateUIForPost:post];
}

- (void)dealWithLikeRequestError:(NSError *)error
                         forPost:(BLUPost *)post
                    oldLikeState:(BOOL)likeState {
    [self sendError:error];
    if (post.like) {
        post.likeCount--;
    } else {
        post.likeCount++;
    }
    post.like = likeState;
    [self updateUIForPost:post];
}

#pragma mark - Post Collection state

- (void)collectPost {
    [self changeCollectStateForPost:YES];
}

- (void)cancelCollectPost {
    [self changeCollectStateForPost:NO];
}

- (void)changeCollectStateForPost:(BOOL)collect {
    BLUPost *post = [self post];
    [self.disposable dispose];

    @weakify(self);
    if (collect == YES) {
        self.disposable =
        [[[BLUApiManager sharedManager] collectPostWithPostID:post.postID] subscribeError:^(NSError *error) {
            @strongify(self);
            [self sendError:error];
        } completed:^{
            @strongify(self);
            post.collect = YES;
            [self sendSuccessMessage:NSLocalizedString(@"post-detail-async-view-model.collect-success", @"Collect success.")];
        }];
    } else {
        self.disposable =
        [[[BLUApiManager sharedManager] cancelCollectPostWithPostID:post.postID] subscribeError:^(NSError *error) {
            @strongify(self);
            [self sendError:error];
        } completed:^{
            @strongify(self);
            post.collect = NO;
            [self sendSuccessMessage:NSLocalizedString(@"post-detail-async-view-model.cancel-collect-success", @"Cancel collect success.")];
        }];
    }
}

#pragma mark - Post reply

- (void)replyToPost:(NSString *)content {
    NSParameterAssert([content isCommentContent]);
    BLUPost *post = [self post];
    @weakify(self);
    [[[BLUApiManager sharedManager] comment:content post:post.postID]
     subscribeError:^(NSError *error) {
        @strongify(self);
        [self sendError:error];
    } completed:^{
        @strongify(self);
        [self sendSuccessMessage:NSLocalizedString(@"post-detail-async-view-model.post-interaction.reply-success",
                                                   @"Send success.")];
    }];
}

@end
