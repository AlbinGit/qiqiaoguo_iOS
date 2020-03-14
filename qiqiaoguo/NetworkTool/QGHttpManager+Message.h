//
//  QGHttpManager+Message.h
//  qiqiaoguo
//
//  Created by cws on 16/6/30.
//
//

#import "QGHttpManager.h"

@interface QGHttpManager (Message)

/**获取代金券消息列表*/
+ (void)getCardMessageWithPage:(NSNumber *)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**获取活动消息列表*/
+ (void)getActivMessageWithPage:(NSNumber *)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**获取订单消息列表*/
+ (void)getOrderMessageWithPage:(NSNumber *)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**获取教育订单消息列表*/
+ (void)getEduMessageWithPage:(NSNumber *)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

@end
