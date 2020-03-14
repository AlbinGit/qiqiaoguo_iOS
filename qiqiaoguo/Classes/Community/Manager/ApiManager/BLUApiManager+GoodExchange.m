//
//  BLUApiManager+GoodExchange.m
//  Blue
//
//  Created by Bowen on 25/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUApiManager+GoodExchange.h"
//#import "BLUGood.h"
#import "BLULogistics.h"
//#import "BLUGoodOrder.h"
//#import "BLUGoodMO.h"

#define BLUGoodApiGoodExchangeList           (BLUApiString(@"/exchange/list"))
#define BLUGoodApiGoodExchangeDetails        (BLUApiString(@"/exchange/detail"))
#define BLUGoodApiGoodLogisitics             (BLUApiString(@"/logistics/detail"))
#define BLUGoodApiGoodRecord                 (BLUApiString(@"/exchange/history"))
#define BLUGoodApiGoodOrderDetail            (BLUApiString(@"/exchange/order/detail"))
#define BLUGoodApiGoodExchange               (BLUApiString(@"/exchange"))

@implementation BLUApiManager (GoodExchange)

- (RACSignal *)fetchGoodExchangeListPagination:(BLUPagination *)pagination {
//    return [[[BLUApiManager sharedManager]
//             fetchWithMethod:BLUApiHttpMethodGet
//             URLString:BLUGoodApiGoodExchangeList
//             parameters:nil
//             pagination:pagination
//             resultClass:[BLUGood class]
//             objectKeyPath:BLUApiObjectKeyItems]
//            handleResponse];
    return nil;
}

- (RACSignal *)fetchGoodExchangeDetailsWithExchangeID:(NSNumber *)goodID {
//    NSDictionary *parameters = @{@"toy_exchange_id": goodID};
//    return [[[BLUApiManager sharedManager]
//             fetchWithMethod:BLUApiHttpMethodGet
//             URLString:BLUGoodApiGoodExchangeDetails
//             parameters:parameters
//             resultClass:[BLUGood class]
//             objectKeyPath:BLUApiObjectKeyItem]
//            handleResponse];
    return nil;
}

- (RACSignal *)fetchGoodLogisticsWithOrderID:(NSNumber *)orderID {
//    BLUAssertObjectIsKindOfClass(orderID, [NSNumber class]);
//    NSDictionary *parameters = @{@"order_id": orderID};
//    return [[[BLUApiManager sharedManager]
//             fetchWithMethod:BLUApiHttpMethodGet
//             URLString:BLUGoodApiGoodLogisitics
//             parameters:parameters
//             resultClass:[BLULogistics class]
//             objectKeyPath:BLUApiObjectKeyItem]
//            handleResponse];
    return nil;
}

- (RACSignal *)fetchGoodExchangeRecords:(BLUPagination *)pagination {
//    return [[[BLUApiManager sharedManager]
//             fetchWithMethod:BLUApiHttpMethodGet
//             URLString:BLUGoodApiGoodRecord
//             parameters:nil
//             pagination:pagination
//             resultClass:[BLUGoodOrder class]
//             objectKeyPath:BLUApiObjectKeyItems]
//            handleResponse];
    return nil;
}

- (RACSignal *)fetchGoodExchangeOrderDetailsWithOrderID:(NSNumber *)orderID {
//    BLUAssertObjectIsKindOfClass(orderID, [NSNumber class]);
//    NSDictionary *parameters = @{@"order_id": orderID};
//    return [[[BLUApiManager sharedManager]
//             fetchWithMethod:BLUApiHttpMethodGet
//             URLString:BLUGoodApiGoodOrderDetail
//             parameters:parameters
//             resultClass:[BLUGoodOrder class]
//             objectKeyPath:BLUApiObjectKeyItem]
//            handleResponse];
    return nil;
}

- (RACSignal *)exchangeGood:(BLUGoodMO *)good {
//    BLUAssertObjectIsKindOfClass(good, [BLUGoodMO class]);
//    NSDictionary *parameters =
//    @{@"toy_exchange_id": good.exchangeID,
//      @"pay_type": @(100)};
//    return [[[BLUApiManager sharedManager]
//             fetchWithMethod:BLUApiHttpMethodPost
//             URLString:BLUGoodApiGoodExchange
//             parameters:parameters
//             resultClass:nil
//             objectKeyPath:BLUApiObjectKeyItem]
//            handleResponse];
    return nil;
}

@end
