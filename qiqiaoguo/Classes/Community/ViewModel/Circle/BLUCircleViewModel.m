//
//  BLUCircleViewModel.m
//  Blue
//
//  Created by Bowen on 25/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircleViewModel.h"
#import "BLUApiManager+Circle.h"
#import "BLUCircleMO.h"

@interface BLUCircleViewModel ()

@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, strong) NSMutableArray *mCircles;
@property (nonatomic, copy, readwrite) BLUCircle *circle;

@end

@implementation BLUCircleViewModel

- (instancetype)initWithFetchCircleType:(BLUFetchCircleType)type {
    if (self = [super init]) {
        _fetchCircleType = type;
    }
    return self;
}

- (BLUPagination *)pagination {
    if (_pagination == nil) {
        _pagination = [[BLUPagination alloc] initWithPerpage:20 group:nil order:BLUPaginationOrderNone];
    }
    return _pagination;
}

- (void)setCircleID:(NSInteger)circleID {
    if (_circleID != circleID) {
        _mCircles = nil;
        _circle = nil;
        _pagination = nil;
        _circleID = circleID;
    }
}

- (NSMutableArray *)mCircles {
    if (_mCircles == nil) {
        _mCircles = [NSMutableArray new];
    }
    return _mCircles;
}

- (RACSignal *)makeFetchSignal {
    RACSignal *fetchSignal = nil;
    switch (self.fetchCircleType) {
        case BLUFetchCircleTypeOne: {
            fetchSignal = [[BLUApiManager sharedManager] fetchCircleWithCircleID:self.circleID];
        } break;
        case BLUFetchCircleTypeAll: {
            fetchSignal = [[BLUApiManager sharedManager] fetchCirclesWithPagination:self.pagination];
        } break;
        case BLUFetchCircleTypeFollowed: {
            if (self.user) {
                fetchSignal = [[BLUApiManager sharedManager] fetchFollowedCircles:self.pagination];
            } else {
                fetchSignal = [RACSignal empty];
            }
        } break;
        case BLUFetchCircleTypeRecommended : {
            fetchSignal = [[BLUApiManager sharedManager] fetchRecommendedCircles:self.pagination];
        } break;
        default: break;
    }
    return fetchSignal;
}

- (RACSignal *)fetch {
    self.pagination.page = 1;
    RACSignal *fetchSignal = [self makeFetchSignal];
    [self.fetchDisposable dispose];
    [self.mCircles removeAllObjects];
    self.circles = nil;
    BLULogInfo(@"type = %@, pagination = %@", @(self.fetchCircleType), self.pagination);
    if (self.fetchCircleType == BLUFetchCircleTypeOne) {
        @weakify(self);
        return [fetchSignal doNext:^(BLUCircle *circle) {
            @strongify(self);
            self.circle = circle;
        }];
    } else {
        @weakify(self);
        return [fetchSignal doNext:^(NSArray *circles) {
            @strongify(self);
            if (circles.count > 0) {
                [self.mCircles removeAllObjects];
                [self.mCircles addObjectsFromArray:circles];
                self.circles = self.mCircles;
                self.pagination.page++;
            }
        }];
    }
}

- (RACSignal *)fetchNext {
    RACSignal *fetchSignal = [self makeFetchSignal];
    
    [self.fetchNextDisposable dispose];
    BLULogInfo(@"type = %@, pagination = %@", @(self.fetchCircleType), self.pagination);
    
    if (self.fetchCircleType == BLUFetchCircleTypeOne) {
        return [RACSignal empty];
    } else {
        @weakify(self);
        return [fetchSignal doNext:^(NSArray *posts) {
            @strongify(self);
            if (posts.count > 0) {
                [self.mCircles addObjectsFromArray:posts];
                self.circles = self.mCircles;
                self.pagination.page++;
            }
        }];
    }
}

@end
