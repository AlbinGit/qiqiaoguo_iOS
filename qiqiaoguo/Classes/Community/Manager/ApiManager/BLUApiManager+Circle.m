//
//  BLUApiManager+Circle.m
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager+Circle.h"
#import "BLUCircle.h"
#import "BLUApiManager+User.h"

#define BLUCircleApiFollowCircle        (BLUApiString(@"/circle/follow"))
#define BLUCircleApiUserCircles         (BLUApiString(@"/circles/my"))
#define BLUCircleApiRecommendedCircles  (BLUApiString(@"/circles/recommended"))
#define BLUCircleApiCircles             (BLUApiString(@"/circles/all"))
#define BLUCircleApiCircle             (BLUApiString(@"/circle/detail"))
#define BLUCircleApiCircleHot           (BLUApiString(@"/circles/hot"))
#define BLUCircleApiCircleSearch        (BLUApiString(@"/circles/search"))

#define QQGCircleApiRecommendedCircles  (QQGApiString(@"/circles/recommended"))

@implementation BLUApiManager (Circle)

- (RACSignal *)followCircleWithCircleID:(NSInteger)circleID {
    BLULogInfo(@"circle id = %@", @(circleID));
    NSDictionary *parameters = @{BLUCircleApiKeyCircleID: @(circleID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUCircleApiFollowCircle parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)unfollowCircleWithCircleID:(NSInteger)circleID {
    BLULogInfo(@"circle id = %@", @(circleID));
    NSDictionary *parameters = @{BLUCircleApiKeyCircleID: @(circleID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodDelete URLString:BLUCircleApiFollowCircle parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)fetchCircleWithPagination:(BLUPagination *)pagination {
    BLULogInfo(@"pagination = %@", pagination);
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [pagination configMutableDictionary:parameters];
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCircleApiCircle parameters:parameters resultClass:[BLUCircle class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchCirclesWithPagination:(BLUPagination *)pagination {
    BLULogInfo(@"pagination = %@", pagination);
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [pagination configMutableDictionary:parameters];
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCircleApiCircles parameters:parameters resultClass:[BLUCircle class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchRecommendedCircles:(BLUPagination *)pagination {
    BLULogInfo(@"pagination = %@", pagination);
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCircleApiRecommendedCircles parameters:nil pagination:pagination resultClass:[BLUCircle class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
    
}


- (RACSignal *)fetchFollowedCircles:(BLUPagination *)pagination {
    BLULogInfo(@"pagination = %@", pagination);
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCircleApiUserCircles parameters:nil pagination:pagination resultClass:[BLUCircle class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchCircleWithCircleID:(NSInteger)circleID {
    BLULogInfo(@"circle id = %@", @(circleID));
    NSDictionary *parameters = @{BLUCircleApiKeyCircleID: @(circleID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCircleApiCircle parameters:parameters resultClass:[BLUCircle class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)fetchCirclesWithUserID:(NSInteger)userID pagination:(BLUPagination *)pagination{
    BLULogInfo(@"User id = %@, pagination = %@", @(userID), pagination);
    NSDictionary *parameters = @{BLUUserApiKeyUserID: @(userID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCircleApiUserCircles parameters:parameters pagination:pagination resultClass:[BLUCircle class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchCircleHot {
    NSDictionary *parameters = @{@"page": @(1), @"per_page": @(1000)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCircleApiCircleHot parameters:parameters resultClass:[BLUCircle class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)searchCircleWithKeyword:(NSString *)keyword {
    BLULogInfo(@"keyword = %@", keyword);
    NSDictionary *parameters = @{@"circle_keyword": keyword, @"page": @(1), @"per_page": @(1000)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCircleApiCircleSearch parameters:parameters resultClass:[BLUCircle class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

@end
