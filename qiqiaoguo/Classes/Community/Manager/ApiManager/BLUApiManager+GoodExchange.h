//
//  BLUApiManager+GoodExchange.h
//  Blue
//
//  Created by Bowen on 25/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUApiManager.h"

@class BLUGood;
@class BLUGoodMO;

@interface BLUApiManager (GoodExchange)

- (RACSignal *)fetchGoodExchangeListPagination:(BLUPagination *)pagination;

- (RACSignal *)fetchGoodExchangeDetailsWithExchangeID:(NSNumber *)goodID;

- (RACSignal *)fetchGoodLogisticsWithOrderID:(NSNumber *)orderID;

- (RACSignal *)fetchGoodExchangeRecords:(BLUPagination *)pagination;

- (RACSignal *)fetchGoodExchangeOrderDetailsWithOrderID:(NSNumber *)orderID;

- (RACSignal *)exchangeGood:(BLUGoodMO *)good;

@end
