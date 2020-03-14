//
//  BLUCircleFollowViewModel.m
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleFollowViewModel.h"
#import "BLUApiManager+Post.h"
#import "BLUApiManager+User.h"
#import "BLUPost.h"

@implementation BLUCircleFollowViewModel

- (instancetype)init {
    if (self = [super init]) {
        _noMoreData = NO;
    }
    return self;
}

- (NSMutableArray *)posts {
    if (_posts == nil) {
        _posts = [NSMutableArray new];
    }
    return _posts;
}

- (BLUPagination *)pagination {
    if (_pagination == nil) {
        _pagination =
        [[BLUPagination alloc] initWithPerpage:20
                                         group:nil
                                         order:BLUPaginationOrderNone];
    }
    return _pagination;
}

- (RACSignal *)fetch {
    self.pagination.page = BLUPaginationPageBase;
    @weakify(self);
    
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser) {
        return [[[BLUApiManager sharedManager]
                 fetchUserWithUserID:currentUser.userID]
                flattenMap:^RACStream *(BLUUser *user) {
                    @strongify(self);
                    [BLUAppManager sharedManager].currentUser = user;
                    self.recommended = user.followingCount == 0;
                    return [[[BLUApiManager sharedManager]
                             fetchFollowPostWithPagination:self.pagination]
                            doNext:^(NSArray *posts) {
                                if (posts.count > 0) {
                                    [self.posts removeAllObjects];
                                    [self.posts addObjectsFromArray:posts];
                                    self.pagination.page++;
                                    for (BLUPost *post in self.posts) {
                                        post.recommend = self.recommended;
                                    }
                                    self.noMoreData = self.recommended;
                                } else {
                                    self.noMoreData = YES;
                                }
                            }];
                }];
    } else {
        self.recommended = YES;
        return [[[BLUApiManager sharedManager]
          fetchFollowPostWithPagination:self.pagination]
         doNext:^(NSArray *posts) {
             if (posts.count > 0) {
                 [self.posts removeAllObjects];
                 [self.posts addObjectsFromArray:posts];
                 self.pagination.page++;
                 for (BLUPost *post in self.posts) {
                     post.recommend = self.recommended;
                 }
                 self.noMoreData = self.recommended;
             } else {
                 self.noMoreData = YES;
             }
         }];
    }
}

- (RACSignal *)fetchNext {
    if (self.recommended) {
        return [RACSignal empty];
    } else {
        
        if (_pagination.page <= 1) {
            return nil;
        }
        
        @weakify(self);
        return [[[BLUApiManager sharedManager]
                 fetchFollowPostWithPagination:self.pagination]
                doNext:^(NSArray *posts) {
            @strongify(self);
            if (posts.count > 0) {
                [self.posts addObjectsFromArray:posts];
                self.pagination.page++;
                self.noMoreData = NO;
            } else {
                self.noMoreData = YES;
            }
        }];
    }
}

- (RACSignal *)followUser:(BLUUser *)user {
    return [[BLUApiManager sharedManager] followUserWithUserID:user.userID];
}


- (RACSignal *)unfollowUser:(BLUUser *)user {
    return [[BLUApiManager sharedManager] unfollowUserWithUserID:user.userID];
}

@end
