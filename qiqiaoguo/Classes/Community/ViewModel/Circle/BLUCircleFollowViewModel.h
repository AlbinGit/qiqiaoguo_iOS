//
//  BLUCircleFollowViewModel.h
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

@class BLUPost;

@interface BLUCircleFollowViewModel : BLUViewModel

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, assign) BOOL recommended;
@property (nonatomic, assign) BOOL noMoreData;

- (RACSignal *)fetch;
- (RACSignal *)fetchNext;
- (RACSignal *)followUser:(BLUUser *)user;
- (RACSignal *)unfollowUser:(BLUUser *)user;

@end
