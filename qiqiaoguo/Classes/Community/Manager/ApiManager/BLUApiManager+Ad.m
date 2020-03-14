//
//  BLUApiManager+Ad.m
//  Blue
//
//  Created by Bowen on 10/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager+Ad.h"
#import "BLUAd.h"

#define BLUAdApiHomeAD           (BLUApiString(@"/ad/1"))
#define BLUAdApiCircleAD         (BLUApiString(@"/ad/circle_v2"))


@implementation BLUApiManager (Ad)

- (RACSignal *)fetchHomeAD {
    BLULogInfo(@"Fetch home ad");
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUAdApiHomeAD parameters:nil resultClass:[BLUAd class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchCircleAD {
    BLULogInfo(@"Fetch circle ad");
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUAdApiCircleAD parameters:nil resultClass:[BLUAd class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

@end
