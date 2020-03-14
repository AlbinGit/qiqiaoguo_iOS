//
//  BLUPostCommentViewModel.m
//  Blue
//
//  Created by Bowen on 26/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostCommentViewModel.h"
#import "BLUApiManager+Comment.h"
#import "BLUComment.h"

@interface BLUPostCommentViewModel ()

@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, strong) NSMutableArray *mComments;
@property (nonatomic, strong, readwrite) NSArray *comments;
@property (nonatomic, assign) BLUPostCommentType type;

@property (nonatomic, assign, readwrite) NSInteger commentCount;

@end

@implementation BLUPostCommentViewModel

- (instancetype)initWithPostCommentType:(BLUPostCommentType)postCommentType {
    if (self = [super init]) {
        _type = postCommentType;
    }
    return self;
}

- (BLUPagination *)pagination {
    if (_pagination == nil) {
        _pagination = [[BLUPagination alloc] initWithPerpage:20 group:nil order:BLUPaginationOrderNone];
    }
    return _pagination;
}

- (NSMutableArray *)mComments {
    if (_mComments == nil) {
        _mComments = [NSMutableArray new];
    }
    return _mComments;
}

- (void)setPostID:(NSInteger)postID {
    if (_postID != postID) {
        _mComments = nil;
        _pagination = nil;
        _postID = postID;
    }
}

- (RACSignal *)makeFetchSignal {
    RACSignal *fetchSignal = nil;
    switch (self.type) {
        case BLUPostCommentTypeForPost: {
            fetchSignal = [[BLUApiManager sharedManager] fetchCommentsForPost:self.postID pagination:self.pagination];
        } break;
        case BLUPostCommentTypeForOwner: {
            fetchSignal = [[BLUApiManager sharedManager] fetchLZCommentsForPost:self.postID pagination:self.pagination];
        } break;;
    }
    return fetchSignal;
}

- (RACSignal *)fetch {
    self.pagination.page = 1;
    RACSignal *fetchSignal = [self makeFetchSignal];
    [self.fetchDisposable dispose];
    @weakify(self);
    return [fetchSignal doNext:^(NSArray *comments) {
        @strongify(self);
        [self.mComments removeAllObjects];
        [self.mComments addObjectsFromArray:comments];
        self.comments = self.mComments;
        self.commentCount = self.mComments.count;
        self.pagination.page++;
    }];
}

- (RACSignal *)fetchNext {
    RACSignal *fetchSignal = [self makeFetchSignal];
    [self.fetchNextDisposable dispose];
    @weakify(self);
    return [fetchSignal doNext:^(NSArray *comments) {
        @strongify(self);
        if (comments.count > 0) {
            [self.mComments addObjectsFromArray:comments];
            self.comments = self.mComments;
            self.commentCount = self.mComments.count;
            self.pagination.page++;
        }
    }];
}

- (RACSignal *)fetchCommentWithCommentID:(NSInteger)commentID {
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchCommentWithCommentID:commentID] doNext:^(BLUComment *comment) {
        @strongify(self);
        [self.mComments enumerateObjectsUsingBlock:^(BLUComment *iterForComment, NSUInteger idx, BOOL * _Nonnull stop) {
            if (iterForComment.commentID == comment.commentID) {
                self.mComments[idx] = comment;
                self.commentCount = self.mComments.count;
                *stop = YES;
            }
        }];
    }];
}

- (NSInteger)deleteComment:(BLUComment *)comment {
    __block NSInteger index = 0;
    [_mComments enumerateObjectsUsingBlock:^(BLUComment *iterForComment, NSUInteger idx, BOOL * _Nonnull stop) {
        if (iterForComment.commentID == comment.commentID) {
            [_mComments removeObjectAtIndex:idx];
            self.commentCount = self.mComments.count;
            _comments = _mComments;
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (void)insertComment:(BLUComment *)comment atIndex:(NSInteger)index {
    [_mComments insertObject:comment atIndex:index];
    self.commentCount = _mComments.count;
    _comments = _mComments;
}

@end
