//
//  BLUApiManager+Order.h
//  Blue
//
//  Created by Bowen on 31/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUApiManager.h"

@class BLUPagination;

@interface BLUApiManager (Order)

- (RACSignal *)fetchOrderHistoryWithPagination:(BLUPagination *)pagination;
- (RACSignal *)deleteOrder:(NSNumber *)orderID;
- (RACSignal *)closeOrder:(NSNumber *)orderID;
- (RACSignal *)fetchOrderDetails:(NSNumber *)orderID;

@end
