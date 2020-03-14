//
//  QGHttpManager+Order.m
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import "QGHttpManager+Order.h"
#import "QGMallOrderModel.h"
#import "QGActivOrderModel.h"
#import "BLULogistics.h"

#define QGMallOrderList         (BLUApiString(@"/Phone/Order/getMallOrderList"))
#define QGActivOrderList         (BLUApiString(@"/Phone/Order/getActivityOrderList"))

#define QGEduOrderList         (BLUApiString(@"/Phone/Order/getEduOrderList"))

#define QGMallOrderDetail        (BLUApiString(@"/Phone/Order/getMallOrderDetails"))
#define QGActivOrderDetail       (BLUApiString(@"/Phone/Order/getActivityOrderDetails"))
#define QGEduOrderDetail        (BLUApiString(@"/Phone/Order/getEduOrderDetails"))

#define QGMallOrderDelete         (BLUApiString(@"/Phone/Order/deleteOrder"))
#define QGMallOrderCancel        (BLUApiString(@"/Phone/Order/cancelOrder"))
#define QGMallOrderConfirm         (BLUApiString(@"/Phone/Order/confirmOrder"))
#define QGMallOrderPlace        (BLUApiString(@"/Phone/Order/placeOrder"))

#define QGMallOrderCancelReason   (BLUApiString(@"/Phone/Order/getCancelOrderReasonList"))
#define QGMallOrderAfterReason   (BLUApiString(@"/Phone/Order/getAfterSaleReasonList"))
#define QGOrderLogisiticsDetail   (BLUApiString(@"/Phone/Order/getLogisticsDetails"))
#define QGOrderAfterService   (BLUApiString(@"/Phone/Order/applyAfterService"))


@implementation QGHttpManager (Order)

+ (void)getMallOrderListWithPage:(NSInteger)page orderStatus:(NSInteger)status Success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    [self GET:QGMallOrderList params:@{@"platform_id":PLATFORMID,@"page":@(page),@"order_status":@(status)} resultClass:[QGMallOrderModel class] objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
        
    }];
}

+ (void)getActivOrderListWithPage:(NSInteger)page orderStatus:(NSInteger)status Success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    [self GET:QGActivOrderList params:@{@"platform_id":PLATFORMID,@"page":@(page),@"order_status":@(status)} resultClass:[QGMallOrderModel class] objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
        
    }];
}
+ (void)getEduOrderListWithPage:(NSInteger)page orderStatus:(NSInteger)status Success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    [self GET:QGEduOrderList params:@{@"platform_id":PLATFORMID,@"page":@(page),@"order_status":@(status)} resultClass:[QGMallOrderModel class] objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
        
    }];
}


+ (void)deleteOrderWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self POST:QGMallOrderDelete params:@{@"order_id":@(orderID),@"platform_id":PLATFORMID} resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)cancelOrderWithOrderID:(NSInteger)orderID Reason:(NSString *)reason Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setDictionary:@{@"order_id":@(orderID),@"platform_id":PLATFORMID}];
    if (reason.length > 0) {
        [dic setObject:reason forKey:@"reason"];
    }
                                
    
    [self POST:QGMallOrderCancel params:dic resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)orderRefundWithOrderID:(NSInteger)orderID Reason:(NSString *)reason Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setDictionary:@{@"order_id":@(orderID),@"platform_id":PLATFORMID}];
    if (reason.length > 0) {
        [dic setObject:reason forKey:@"reason"];
    }
    
    
    [self POST:QGMallOrderCancel params:dic resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)confirmOrderWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self POST:QGMallOrderConfirm params:@{@"order_id":@(orderID),@"platform_id":PLATFORMID} resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)placeOrderWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self POST:QGMallOrderPlace params:@{@"order_id":@(orderID),@"platform_id":PLATFORMID} resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}


+ (void)getMallOrderDetailWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    [self GET:QGMallOrderDetail params:@{@"platform_id":PLATFORMID,@"order_id":@(orderID)} resultClass:[QGMallOrderModel class] objectKeyPath:QGApiObjectKeyItem success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
        
    }];
}

+ (void)getActivOrderDetailWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    [self GET:QGActivOrderDetail params:@{@"platform_id":PLATFORMID,@"order_id":@(orderID)} resultClass:[QGActivOrderModel class] objectKeyPath:QGApiObjectKeyExtra success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
        
    }];
}
+ (void)getEduOrderDetailWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    [self GET:QGEduOrderDetail params:@{@"platform_id":PLATFORMID,@"order_id":@(orderID)} resultClass:[QGActivOrderModel class] objectKeyPath:QGApiObjectKeyExtra success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
        
    }];
}
+ (void)getMallOrderCancelReasonWithOrdertype:(NSInteger)type Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
 
    [self GET:QGMallOrderCancelReason params:@{@"platform_id":PLATFORMID,@"order_type":@(type)} resultClass:nil objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

+ (void)getMallOrderAftersalesReasonWithOrdertype:(NSInteger)type Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self GET:QGMallOrderAfterReason params:@{@"platform_id":PLATFORMID} resultClass:nil objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

+ (void)getOrderLogisiticsDetailWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self GET:QGOrderLogisiticsDetail params:@{@"order_id":@(orderID),@"platform_id":PLATFORMID} resultClass:[BLULogistics class] objectKeyPath:QGApiObjectKeyItem success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)OrderAftersalesWithOrderID:(NSInteger)orderID Reason:(NSString *)reason Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setDictionary:@{@"order_id":@(orderID),@"platform_id":PLATFORMID}];
    if (reason.length > 0) {
        [dic setObject:reason forKey:@"reason"];
    }
    
    
    [self POST:QGOrderAfterService params:dic resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

@end
