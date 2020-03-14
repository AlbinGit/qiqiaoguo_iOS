//
//  BLUUserInfoViewModel.m
//  Blue
//
//  Created by Bowen on 24/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUUserViewModel.h"
#import "BLUApiManager+User.h"

@implementation BLUUserViewModel

- (RACSignal *)fetch {
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchUserWithUserID:self.userID] doNext:^(BLUUser *user) {
        @strongify(self);
        self.user = user;
    }];
}

- (RACSignal *)follow {
    return [[BLUApiManager sharedManager] followUserWithUserID:self.userID];
}

- (RACSignal *)unfollow {
    return [[BLUApiManager sharedManager] unfollowUserWithUserID:self.userID];
}

@end
