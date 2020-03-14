//
//  BLUUserInfoViewModel.h
//  Blue
//
//  Created by Bowen on 24/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLUUserViewModel : BLUViewModel

@property (nonatomic, copy) BLUUser *user;
@property (nonatomic, assign) NSInteger userID;

- (RACSignal *)fetch;
- (RACSignal *)follow;
- (RACSignal *)unfollow;

@end
