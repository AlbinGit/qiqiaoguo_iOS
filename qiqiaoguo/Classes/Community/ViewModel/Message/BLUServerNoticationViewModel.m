//
//  BLUServerNoticationViewModel.m
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUServerNoticationViewModel.h"
#import "BLUServerNotification.h"
#import "BLUServerNotificationMO.h"
#import "BLUApiManager+Others.h"

@interface BLUServerNoticationViewModel ()

@property (nonatomic, weak) RACDisposable *fetchDisposable;
@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, assign, readwrite) BLUServerNotificationViewModelState state;
@property (nonatomic, strong) BLUUser *currentUser;

@end

@implementation BLUServerNoticationViewModel

- (instancetype)init{
    if (self = [super init]) {
        _state = BLUServerNotificationViewModelStateNormal;
        _ServerNoticationArray = [NSMutableArray new];
        return self;
    }
    return nil;
}


- (BLUPagination *)pagination {
    if (_pagination == nil) {
        _pagination = [[BLUPagination alloc] initWithPerpage:20 group:nil order:BLUPaginationOrderNone];
    }
    return _pagination;
}

- (void)fetch {
    [self.fetchDisposable dispose];
    self.state = BLUServerNotificationViewModelStateFetching;
    @weakify(self);
    self.fetchDisposable = [[[[BLUApiManager sharedManager] fetchServerNoticationWithPagination:self.pagination]
      retry:3]
     subscribeNext:^(NSArray *notifications) {
        @strongify(self);
        self.state = BLUServerNotificationViewModelStateNormal;
         [self.ServerNoticationArray removeAllObjects];
        [self.ServerNoticationArray addObjectsFromArray:notifications];
         if ([self.delegate respondsToSelector:@selector(viewModelDidFetchNextComplete:)]) {
             [self.delegate viewModelDidFetchNextComplete:self];
         }
    } error:^(NSError *error) {
        @strongify(self);
        BLULogError(@"Error = %@", error);
        self.state = BLUServerNotificationViewModelStateFetchFailed;
    }];
}

- (void)fetchNext {
    [self.fetchDisposable dispose];
    self.state = BLUServerNotificationViewModelStateFetching;
    self.pagination.page ++;
    @weakify(self);
    self.fetchDisposable = [[[[BLUApiManager sharedManager] fetchServerNoticationWithPagination:self.pagination]
      retry:3]
     subscribeNext:^(NSArray *notifications) {
         if (notifications.count == 0) {
             if ([self.delegate respondsToSelector:@selector(shouldDiableFetchNextFromViewModel:)]) {
                 [self.delegate shouldDiableFetchNextFromViewModel:self];
             }
             return ;
         }
     
         [self.ServerNoticationArray addObjectsFromArray:notifications];
         if ([self.delegate respondsToSelector:@selector(viewModelDidFetchNextComplete:)]) {
             [self.delegate viewModelDidFetchNextComplete:self];
         }
         
         
    } error:^(NSError *error) {
        @strongify(self);
        self.state = BLUServerNotificationViewModelStateFetchFailed;
        if ([self.delegate respondsToSelector:@selector(viewModelDidFetchNextFailed:error:)]) {
            [self.delegate viewModelDidFetchNextFailed:self error:error];
        }
    }];
}



@end
