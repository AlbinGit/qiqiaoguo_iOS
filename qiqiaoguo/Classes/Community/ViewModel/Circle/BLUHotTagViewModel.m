//
//  BLUHotTagViewModel.m
//  Blue
//
//  Created by cws on 16/4/5.
//  Copyright © 2016年 com.boki. All rights reserved.
//

#import "BLUHotTagViewModel.h"
#import "BLUApiManager+Post.h"


@interface BLUHotTagViewModel ()

@property (nonatomic, assign, readwrite) BOOL noMoreData;

@end

@implementation BLUHotTagViewModel


- (NSArray *)tags {
    if (_tags == nil) {
        _tags = [NSMutableArray new];
    }
    return _tags;
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

- (RACSignal *)fetch
{
//    BLULogDebug(@"调用了拉取标签方法");
    self.pagination.page = 1;
    self.noMoreData = NO;
    RACSignal *fetchSignal = [[BLUApiManager sharedManager] fetchHotTagForPagination:self.pagination];
    
    [self.fetchDisposable dispose];
    @weakify(self);
    return [fetchSignal doNext:^(NSArray *tags) {
        @strongify(self);
        if (tags.count > 0) {
            [self.tags removeAllObjects];
            [self.tags addObjectsFromArray:tags];
//            BLULogDebug(@"完成了拉取标签方法");
        }
        if ([self.delegate respondsToSelector:@selector(shouldRefreshTags:fromViewModel:)])
        {
            [self.delegate shouldRefreshTags:tags fromViewModel:self];
        }
    }];
}

- (RACSignal *)fetchNext
{
    self.pagination.page ++;
    
    RACSignal *fetchSignal = [[BLUApiManager sharedManager] fetchHotTagForPagination:self.pagination];
    
    [self.fetchDisposable dispose];
    @weakify(self);
    return [fetchSignal doNext:^(NSArray *tags) {
        @strongify(self);
        if (tags.count > 0) {
            [self.tags addObjectsFromArray:tags];
        }else
        {
            self.noMoreData = YES;
        }
    }];

}

@end
