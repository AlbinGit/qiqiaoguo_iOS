//
//  BLUApiManager+Circle.h
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager.h"

static NSString * const BLUCircleApiKeyCircleID      = @"circle_id";

@interface BLUApiManager (Circle)

- (RACSignal *)followCircleWithCircleID:(NSInteger)circleID; // Cookie
- (RACSignal *)unfollowCircleWithCircleID:(NSInteger)circleID; // Cookie


- (RACSignal *)fetchCircleWithPagination:(BLUPagination *)pagination;
- (RACSignal *)fetchCirclesWithPagination:(BLUPagination *)pagination;
- (RACSignal *)fetchRecommendedCircles:(BLUPagination *)pagination;
- (RACSignal *)fetchFollowedCircles:(BLUPagination *)pagination;

- (RACSignal *)fetchCircleWithCircleID:(NSInteger)circleID;

- (RACSignal *)fetchCirclesWithUserID:(NSInteger)userID pagination:(BLUPagination *)pagination;

- (RACSignal *)fetchCircleHot;
- (RACSignal *)searchCircleWithKeyword:(NSString *)keyword;

@end
