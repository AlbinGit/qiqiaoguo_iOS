//
//  BLUCircleActionViewModel.m
//  Blue
//
//  Created by Bowen on 28/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircleActionViewModel.h"
#import "BLUApiManager+Circle.h"

@implementation BLUCircleActionViewModel

- (RACSignal *)follow {
    return [[BLUApiManager sharedManager] followCircleWithCircleID:self.circleID];
}

- (RACSignal *)unfollow {
    return [[BLUApiManager sharedManager] unfollowCircleWithCircleID:self.circleID];
}

@end
