//
//  QGHttpManager+Order.h
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import "QGHttpManager.h"

@interface QGHttpManager (Order)

+ (void)getMallOrderListWithPage:(NSInteger)page orderStatus:(NSInteger)status Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)getActivOrderListWithPage:(NSInteger)page orderStatus:(NSInteger)status Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;
+ (void)getEduOrderListWithPage:(NSInteger)page orderStatus:(NSInteger)status Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;//教育列表订单

+ (void)deleteOrderWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)cancelOrderWithOrderID:(NSInteger)orderID Reason:(NSString *)reason Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)orderRefundWithOrderID:(NSInteger)orderID Reason:(NSString *)reason Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)confirmOrderWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)getMallOrderDetailWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)getActivOrderDetailWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;
+ (void)getEduOrderDetailWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**
 *  @param type    类型.商城为0，活动订单为20
 */
+ (void)getMallOrderCancelReasonWithOrdertype:(NSInteger)type Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**
 *  @param type    类型.商城为0，活动订单为20
 */
+ (void)getMallOrderAftersalesReasonWithOrdertype:(NSInteger)type Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)getOrderLogisiticsDetailWithOrderID:(NSInteger)orderID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)OrderAftersalesWithOrderID:(NSInteger)orderID Reason:(NSString *)reason Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

@end
