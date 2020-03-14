//
//  BLUApiManager+Ad.h
//  Blue
//
//  Created by Bowen on 10/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager.h"

@interface BLUApiManager (Ad)

- (RACSignal *)fetchCircleAD;
- (RACSignal *)fetchHomeAD;

@end
