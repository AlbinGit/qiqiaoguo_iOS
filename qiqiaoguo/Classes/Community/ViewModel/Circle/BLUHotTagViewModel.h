//
//  BLUHotTagViewModel.h
//  Blue
//
//  Created by cws on 16/4/5.
//  Copyright © 2016年 com.boki. All rights reserved.
//

#import "BLUViewModel.h"
#import "BLUCircleAdViewModel.h"


@class BLUHotTagViewModel;

@protocol BLUHotTagViewModelDelegate <NSObject>
- (void)shouldRefreshTags:(NSArray *)tags fromViewModel:(BLUHotTagViewModel *)hotTagViewModel;
- (void)shouldHandleFetchError:(NSError *)error fromViewModel:(BLUHotTagViewModel *)hotTagViewModel;
@end


@interface BLUHotTagViewModel : BLUViewModel

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, weak) RACDisposable *fetchDisposable;
@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, weak) id <BLUHotTagViewModelDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL noMoreData;

- (RACSignal *)fetch;
- (RACSignal *)fetchNext;

@end
