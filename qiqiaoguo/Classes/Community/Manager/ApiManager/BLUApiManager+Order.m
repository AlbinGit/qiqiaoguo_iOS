//
//  BLUApiManager+Order.m
//  Blue
//
//  Created by Bowen on 31/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUApiManager+Order.h"
//#import "BLUGoodOrder.h"

#define BLUOrderApiHistory           (BLUApiString(@"/order/history"))
#define BLUOrderApiClose             (BLUApiString(@"/order/close"))
#define BLUOrderApiDelete            (BLUApiString(@"/order/delete"))
#define BLUOrderApiDetails           (BLUApiString(@"/order/detail"))

@implementation BLUApiManager (Order)


- (RACSignal *)fetchOrderHistoryWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodGet
             URLString:BLUOrderApiHistory
             parameters:nil
             pagination:pagination
//             resultClass:[BLUGoodOrder class]
             resultClass:nil
             objectKeyPath:BLUApiObjectKeyItems]
            handleResponse];
}

- (RACSignal *)deleteOrder:(NSNumber *)orderID {
    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodGet
             URLString:BLUOrderApiDelete
             parameters:@{@"order_id": orderID}
             resultClass:nil
             objectKeyPath:nil]
            handleResponse];
}

- (RACSignal *)closeOrder:(NSNumber *)orderID {
    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodGet
             URLString:BLUOrderApiDelete
             parameters:@{@"order_id": orderID}
             resultClass:nil
             objectKeyPath:nil]
            handleResponse];
}

- (RACSignal *)fetchOrderDetails:(NSNumber *)orderID {
    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodGet
             URLString:BLUOrderApiDetails
             parameters:@{@"order_id": orderID}
//             resultClass:[BLUGoodOrder class]
             resultClass:nil
             objectKeyPath:BLUApiObjectKeyItem]
            handleResponse];
}

@end
