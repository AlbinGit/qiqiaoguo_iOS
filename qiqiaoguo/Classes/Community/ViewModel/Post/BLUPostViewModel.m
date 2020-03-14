//
//  BLUPostViewModel.m
//  Blue
//
//  Created by Bowen on 24/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostViewModel.h"
#import "BLUApiManager+Post.h"
#import "BLUPost.h"

@interface BLUPostViewModel ()

@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, strong) NSMutableArray *mPosts;
@property (nonatomic, strong, readwrite) NSArray *posts;
@property (nonatomic, assign, readwrite) BLUPostType type;
@property (nonatomic, assign, readwrite) NSInteger fetchCount;
@property (nonatomic, assign, readwrite) BOOL noMoreData;

@end

@implementation BLUPostViewModel

- (instancetype)initWithPostType:(BLUPostType)type {
    if (self = [super init]) {
        _type = type;
        _fetchCount = 0;
        _locked = NO;
        _noMoreData = NO;
    }
    return self;
}

- (BLUPagination *)pagination {
    if (_pagination == nil) {
        _pagination = [[BLUPagination alloc] initWithPerpage:10 group:nil order:BLUPaginationOrderNone];
    }
    return _pagination;
}

- (void)setUserID:(NSInteger)userID {
    if (_userID != userID) {
        _mPosts = nil;
        _pagination = nil;
        _userID = userID;
    }
}

- (NSMutableArray *)mPosts {
    if (_mPosts == nil) {
        _mPosts = [NSMutableArray new];
    }
    return _mPosts;
}

- (RACSignal *)makeFetchSignal {
    RACSignal *fetchSignal = nil;
    switch (self.type) {
        case BLUPostTypeRecommended: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchRecommendedPosts:self.pagination];
        } break;
        case BLUPostTypeForUser: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchPostsForUser:self.userID
                           pagination:self.pagination];
        } break;
        case BLUPostTypeForCircle: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchPostsForCircle:self.circleID
                           pagination:self.pagination];
        } break;
        case BLUPostTypeFresh: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchFreshPostsForCircle:self.circleID
                           pagination:self.pagination];
        } break;
        case BLUPostTypeEssential: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchEssentialPostsForCircle:self.circleID
                           pagination:self.pagination];
        } break;
        case BLUPostTypeForCollection: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchCollectedPostsForUser:self.userID
                           pagination:self.pagination];
        } break;
        case BLUPostTypeForParticipated: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchParticipatedPostsForUser:self.userID
                           pagination:self.pagination];
        } break;
        case BLUPostTypeHot: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchHotPostWithPagination:self.pagination];
        } break;
        case BLUPostTypeTag: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchPostsWithTag:self.tagID
                           pagination:self.pagination];
        } break;
        case BLUPostTypeTagRecommended: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchRecommendedPostsWithTag:self.tagID
                           pagination:self.pagination];
        } break;
        case BLUPostTypeGoodVideos: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchGoodVideoPostsWithGoodID:self.goodID
                           pagination:self.pagination];
        } break;
        case BLUPostTypeGoodRelevant: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchGoodRelevantPostsWithGoodID:self.goodID
                           pagination:self.pagination];
        } break;
        case BLUPostTypeGoodEvaluation: {
            fetchSignal = [[BLUApiManager sharedManager]
                           fetchGoodEvaluationPostsWithGoodID:self.goodID
                           pagination:self.pagination];
        } break;
        default: {
        } break;
    }
    return fetchSignal;
}

- (RACSignal *)makeDeleteSignalForPost:(BLUPost *)post {
    RACSignal *deleteSignal = nil;
    switch (self.type) {
        case BLUPostTypeForCollection: {
            deleteSignal = [[BLUApiManager sharedManager]
                            cancelCollectPostWithPostID:post.postID];
        } break;
        case BLUPostTypeForUser: {
            deleteSignal = [[BLUApiManager sharedManager]
                            deletePostForUserWithPostID:post.postID];
        } break;
        default: {
            deleteSignal = nil;
        } break;
    }
    return deleteSignal;
}

- (RACSignal *)fetch {
    self.pagination.page = 1;
    self.noMoreData = NO;
    RACSignal *fetchSignal = [self makeFetchSignal];
    [self.fetchDisposable dispose];
    @weakify(self);
    return [fetchSignal doNext:^(NSArray *posts) {
        @strongify(self);
        [self.mPosts removeAllObjects];
        [self.mPosts addObjectsFromArray:posts];
        self.posts = self.mPosts;
        self.pagination.page++;
        self.fetchCount++;
    }];
}

- (RACSignal *)fetchNext {

    RACSignal *fetchSignal = [self makeFetchSignal];
    if (self.pagination.page <= 1) {
        return [self sendRACError];
    }
    [self.fetchNextDisposable dispose];
    @weakify(self);
    return [fetchSignal doNext:^(NSArray *posts) {
        @strongify(self);
        
        if (posts.count > 0) {
            [self.mPosts addObjectsFromArray:posts];
            self.posts = self.mPosts;
            self.pagination.page++;
        } else {
            self.noMoreData = YES;
        }
    }];
}

- (RACSignal *)deletePost:(BLUPost *)post {
    RACSignal *deleteSignal = [self makeDeleteSignalForPost:post];
    if (deleteSignal) {
        @weakify(self);
        return [deleteSignal doCompleted:^{
            @strongify(self);
            for (BLUPost *p in self.mPosts) {
                if (p.postID == post.postID) {
                    [self.mPosts removeObject:p];
                    break;
                }
            }
        }];
    } else {
        return [RACSignal empty];
    }
}

@end
