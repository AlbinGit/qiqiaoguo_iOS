//
//  BLUPostDetailAsyncViewModel+Fetch.m
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModelHeader.h"

@implementation BLUPostDetailAsyncViewModel (Fetch)

- (void)fetchAll {
    [self.disposable dispose];
    @weakify(self);
    self.disposable =
    [[[BLUApiManager sharedManager] fetchPostDetail:self.postID]
     subscribeNext:^(BLUPost *post) {
        @strongify(self);
        [self didReload];
   
        if (post) {
            NSParameterAssert([post isKindOfClass:[BLUPost class]]);
            [self contentWillChange];
            [self insertOrUpdatePost:post];
            [self contentDidChange];
            if (post.commentCount > 0) {
                [self shouldShowNoCommentPrompt:NO];
                self.featuredCommentsPagination.page = BLUPaginationPageBase;
                self.disposable =
                [[[BLUApiManager sharedManager]
                  fetchFeaturedCommentsForPost:self.postID
                  pagination:self.featuredCommentsPagination]
                 subscribeNext:^(NSArray *featuredComments) {
                    [self dealWithFetchedFeaturedComments:featuredComments];
                } error:^(NSError *error) {
                    [self sendError:error];
                    [self fetchComments];
                } completed:^{
                    self.featuredCommentsPagination.page++;
                    [self fetchComments];
                }];
            } else {
                [self shouldShowNoCommentPrompt:YES];
            }
        }
    } error:^(NSError *error) {
        @strongify(self);
        [self didReload];
        [self sendError:error];
    }];
}

- (void)dealWithFetchedFeaturedComments:(NSArray *)comments {
    [self dealWithFetchedComments:comments
                          forRows:self.featuredComments
                  shouldRefreshUI:YES];
}

- (void)dealWithFetchedComments:(NSArray *)comments
                        forRows:(NSArray *)rows
                shouldRefreshUI:(BOOL)refresh {
    if (comments) {
        BLUAssertObjectIsKindOfClass(comments, [NSArray class]);
        if (comments.count > 0) {
            [self shouldShowNoCommentPrompt:NO];

            [self contentWillChange];

            if (refresh) {
                if (rows == self.featuredComments) {
                    [self deleteAllFeaturedComments];
                } else {
                    [self deleteAllComments];
                }
            }

            if (rows == self.featuredComments) {
                [self addFeaturedComments:comments];
            } else {
                [self addComments:comments];
            }

            [self contentDidChange];
        }
    }
}

- (RACSignal *)makeFetchSignalFromCommentType:(BLUPostDetailAsyncCommentType)type {
    RACSignal *signal = nil;

    BLUPagination *pagination = [self paginationForCommentType:type];
    BOOL isOwner = [self isOwnerCommentsForCommentType:type];

    if (isOwner) {
        signal = [[BLUApiManager sharedManager]
                  fetchLZCommentsForPost:self.postID
                  pagination:pagination];
    } else {
        signal = [[BLUApiManager sharedManager]
                  fetchCommentsForPost:self.postID
                  pagination:pagination];
    }

    return signal;
}

- (RACSignal *)makeFetchSignalFromCommentType:(BLUPostDetailAsyncCommentType)type
                                   pagination:(BLUPagination *)pagination {
    RACSignal *signal = nil;

    BOOL isOwner = [self isOwnerCommentsForCommentType:type];

    if (isOwner) {
        signal = [[BLUApiManager sharedManager]
                  fetchLZCommentsForPost:self.postID
                  pagination:pagination];
    } else {
        signal = [[BLUApiManager sharedManager]
                  fetchCommentsForPost:self.postID
                  pagination:pagination];
    }

    return signal;
}

- (void)fetchPost {
    [self.disposable dispose];
    @weakify(self);
    self.disposable =
    [[[BLUApiManager sharedManager] fetchPostDetail:self.postID]
     subscribeNext:^(BLUPost *post) {
        @strongify(self);
        if (post) {
            NSParameterAssert([post isKindOfClass:[BLUPost class]]);
            [self contentWillChange];
            [self insertOrUpdatePost:post];
            [self contentDidChange];
            if (post.commentCount > 0) {
                [self shouldShowNoCommentPrompt:NO];
            } else {
                [self shouldShowNoCommentPrompt:YES];
            }
        }
    } error:^(NSError *error) {
        @strongify(self);
        [self sendError:error];
    }];
}

- (void)fetchFeatureComments {
    [self.disposable dispose];
    self.featuredCommentsPagination.page = BLUPaginationPageBase;
    @weakify(self);
    self.disposable =
    [[[BLUApiManager sharedManager]
      fetchFeaturedCommentsForPost:self.postID
      pagination:self.featuredCommentsPagination]
     subscribeNext:^(NSArray *comments) {
        @strongify(self);
        [self dealWithFetchedFeaturedComments:comments];
    } error:^(NSError *error) {
        @strongify(self);
        [self sendError:error];
    } completed:^{
        @strongify(self);
        self.featuredCommentsPagination.page++;
    }];
}

- (void)fetchComments {
    [self fetchCommentsWithBasePage:YES forType:self.commentType];
}

- (void)fetchMoreComments {
    [self fetchCommentsWithBasePage:NO forType:self.commentType];
}

- (void)fetchCommentsWithBasePage:(BOOL)basePage forType:(BLUPostDetailAsyncCommentType)type {
    BLUPagination *currentPagination = [self paginationForCommentType:type];

    if (basePage) {
        currentPagination.page = BLUPaginationPageBase;
    }

    NSMutableArray *currentComments = [self commentsForCommentType:type];

    RACSignal *signal = [self makeFetchSignalFromCommentType:self.commentType];
    [self.disposable dispose];
    @weakify(self);
    self.disposable =
    [signal subscribeNext:^(NSArray *comments) {
        @strongify(self);
        [self dealWithFetchedComments:comments
                              forRows:currentComments
                      shouldRefreshUI:basePage];
    } error:^(NSError *error) {
        @strongify(self);
        if (basePage == NO) {
            [self didLoadMoreData];
        }
        [self sendError:error];
    } completed:^{
        if (basePage == NO) {
            [self didLoadMoreData];
        }
        currentPagination.page++;
    }];
}

- (void)refreshCommentsForType:(BLUPostDetailAsyncCommentType)type {
    BLUPagination *currentPagination = [self paginationForCommentType:type];
    BLUPagination *pagination = [currentPagination copy];
    pagination.page = BLUPaginationPageBase;

    NSMutableArray *currentComments = [self commentsForCommentType:type];

    RACSignal *signal = [self makeFetchSignalFromCommentType:type
                                                  pagination:pagination];

    @weakify(self);
    self.disposable =
    [signal subscribeNext:^(NSArray *comments) {
        @strongify(self);
        if (comments.count > 0) {
            [self contentWillChange];
            NSMutableArray *complementComments = [NSMutableArray new];
            [comments enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BLUComment *iComment, NSUInteger idx, BOOL * _Nonnull stop) {
                BOOL complementFlag = YES;
                for (BLUComment *jComment in currentComments) {
                    if (jComment.commentID == iComment.commentID) {
                        complementFlag = NO;
                        [self updateComment:iComment forComments:currentComments];
                        break;
                    }
                }

                if (complementFlag) {
                    [complementComments addObject:iComment];
                }
            }];

            if (complementComments.count > 0) {
                for (BLUComment *comment in complementComments) {
                    [self insertComment:comment toViewComment:currentComments atIndex:0];
                }
            }

            [self contentDidChange];
        }

    } error:^(NSError *error) {
        @strongify(self);
        [self sendError:error];
    } completed:^{
        @strongify(self);
        [self sendSuccessMessage:nil];
    }];

}

- (BOOL)shouldFetchForNewType:(BLUPostDetailAsyncCommentType)type {
    NSArray *comments = [self currentComments];
    return !(comments.count > 0);
}

@end
