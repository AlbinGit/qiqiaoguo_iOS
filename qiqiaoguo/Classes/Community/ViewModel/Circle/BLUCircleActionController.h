//
//  BLUCircleActionController.h
//  Blue
//
//  Created by Bowen on 25/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

@class BLUCircleMO;

@interface BLUCircleActionController : BLUViewModel

- (void)followCircleWithCircleMO:(BLUCircleMO *)circleMO;
- (void)unfollowCircleWithCircleMO:(BLUCircleMO *)circleMO;

@end
