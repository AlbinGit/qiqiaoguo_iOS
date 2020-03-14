//
//  BLUCircleActionViewModel.h
//  Blue
//
//  Created by Bowen on 28/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLUCircleActionViewModel : BLUViewModel

@property (nonatomic, assign) NSInteger circleID;

- (RACSignal *)follow;
- (RACSignal *)unfollow;

@end
