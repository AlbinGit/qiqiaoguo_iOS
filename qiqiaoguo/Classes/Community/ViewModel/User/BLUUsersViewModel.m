//
//  BLUUsersViewModel.m
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUsersViewModel.h"
#import "BLUApiManager+User.h"

@interface BLUUsersViewModel ()

@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, strong, readwrite) NSArray *users;
@property (nonatomic, strong) NSMutableArray *mutableUsers;

@end

@implementation BLUUsersViewModel

- (BLUPagination *)pagination {
    if (_pagination == nil) {
        _pagination = [[BLUPagination alloc] initWithPerpage:10 group:nil order:BLUPaginationOrderNone];
    }
    return _pagination;
}

- (void)setType:(BLUUsersViewModelType)type {
    if (_type != type) {
        _type = type;
        _mutableUsers = nil;
        self.pagination.page = BLUPaginationPageBase;
    }
}

- (void)setUserID:(NSInteger)userID {
    if (_userID != userID) {
        _userID = userID;
        _mutableUsers = nil;
        self.pagination.page = BLUPaginationPageBase;
    }
}

- (NSMutableArray *)mutableUsers {
    if (_mutableUsers == nil) {
        _mutableUsers = [NSMutableArray new];
    }
    return _mutableUsers;
}

- (RACSignal *)makeFetchSignal {
    RACSignal *fetchSignal = nil;
    switch (self.type) {
        case BLUUsersViewModelTypeFollower: {
            fetchSignal = [[BLUApiManager sharedManager] fetchFollowersForUserID:self.userID pagination:self.pagination];
        } break;
        case BLUUsersViewModelTypeFollowing: {
            fetchSignal = [[BLUApiManager sharedManager] fetchFollowingsForUserID:self.userID pagination:self.pagination];
        } break;
    }
    return fetchSignal;
}

- (RACSignal *)fetch {
    RACSignal *fetchSignal = [self makeFetchSignal];
    self.pagination.page = BLUPaginationPageBase;
    [self.fetchDiaposable dispose];
    @weakify(self);
    return [fetchSignal doNext:^(NSArray *items) {
        @strongify(self);
        if (items.count > 0) {
            [self.mutableUsers removeAllObjects];
            [self.mutableUsers addObjectsFromArray:items];
            self.users = self.mutableUsers;
        }
    }];
}

- (RACSignal *)fetchNext {
    self.pagination.page++;
    if (self.pagination.page <= 1) {
        return [self sendRACError];
    }
    RACSignal *fetchSignal = [self makeFetchSignal];
    [self.fetchDiaposable dispose];

    @weakify(self);
    return [fetchSignal doNext:^(NSArray *items) {
        @strongify(self);
        if (items.count > 0) {
            [self.mutableUsers addObjectsFromArray:items];
            self.users = self.mutableUsers;
        }
    }];
}

@end
