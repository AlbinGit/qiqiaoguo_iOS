//
//  BLUApiManager+Dynamic.m
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUApiManager+Dynamic.h"
#import "BLUDynamic.h"

#define BLUApiDynamic           (BLUApiString(@"/Phone/Message/getDynamicMsgList"))

@implementation BLUApiManager (Dynamic)

- (RACSignal *)fetchDynamicWithDidRead:(BOOL)didRead pagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUApiDynamic parameters:@{@"read_status": @(didRead)} pagination:pagination resultClass:[BLUDynamic class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

@end
