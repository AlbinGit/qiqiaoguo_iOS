//
//  BLUDynamicViewModel.m
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUDynamicViewModel.h"
#import "BLUApiManager+Dynamic.h"
#import "BLUDynamic.h"
#import "BLUDynamicMO.h"

@interface BLUDynamicViewModel ()

@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, weak) RACDisposable *fetchDisposable;
@property (nonatomic, assign, readwrite) BLUDynamicViewModelState state;

@end

@implementation BLUDynamicViewModel

- (instancetype)init{
    if (self = [super init]) {
        _state = BLUDynamicViewModelStateNormal;
        _DynamicArray = [NSMutableArray array];
        return self;
    }
    return nil;
}

- (BLUPagination *)pagination {
    if (_pagination == nil) {
        _pagination = [[BLUPagination alloc] initWithPerpage:BLUPaginationPerpageMax group:nil order:BLUPaginationOrderNone];
    }
    return _pagination;
}


- (void)fetch {
    [self.fetchDisposable dispose];
    self.state = BLUDynamicViewModelStateFetching;
    self.pagination.page = 1;
    if ([BLUAppManager sharedManager].currentUser) {
        @weakify(self);
        [[[[BLUApiManager sharedManager]
          fetchDynamicWithDidRead:NO
           pagination:self.pagination]
          retry:3]
         subscribeNext:^(NSArray *dynamics) {
             @strongify(self);
             self.state = BLUDynamicViewModelStateNormal;
             if (dynamics.count > 0) {
                 [_DynamicArray removeAllObjects];
                [_DynamicArray addObjectsFromArray:dynamics];
                 if ([self.delegate respondsToSelector:@selector(viewModelDidFetchNextComplete:)] ) {
                     [self.delegate viewModelDidFetchNextComplete:self];
                 }
             }
         } error:^(NSError *error) {
             @strongify(self);
             BLULogError(@"Error = %@", error);
             self.state = BLUDynamicViewModelStateFetchFailed;
             if ([self.delegate respondsToSelector:@selector(viewModelDidFetchNextFailed:error:)] ) {
                 [self.delegate viewModelDidFetchNextFailed:self error:error];
             }
         }];
    }
}

- (void)fetchNext {
    [self.fetchDisposable dispose];
    self.state = BLUDynamicViewModelStateFetching;
    self.pagination.page ++;
    if ([BLUAppManager sharedManager].currentUser) {
        @weakify(self);
        [[[[BLUApiManager sharedManager]
           fetchDynamicWithDidRead:NO
           pagination:self.pagination]
          retry:3]
         subscribeNext:^(NSArray *dynamics) {
             @strongify(self);
             self.state = BLUDynamicViewModelStateNormal;
             if (dynamics.count > 0) {
                 [_DynamicArray addObjectsFromArray:dynamics];
                 if ([self.delegate respondsToSelector:@selector(viewModelDidFetchNextComplete:)] ) {
                     [self.delegate viewModelDidFetchNextComplete:self];
                 }
             }
             else{
                 if ([self.delegate respondsToSelector:@selector(shouldDiableFetchNextFromViewModel:)] ) {
                     [self.delegate shouldDiableFetchNextFromViewModel:self];
                 }
             }
         } error:^(NSError *error) {
             @strongify(self);
             BLULogError(@"Error = %@", error);
             self.state = BLUDynamicViewModelStateFetchFailed;
             if ([self.delegate respondsToSelector:@selector(viewModelDidFetchNextFailed:error:)] ) {
                 [self.delegate viewModelDidFetchNextFailed:self error:error];
             }
         }];
    }
}



@end
