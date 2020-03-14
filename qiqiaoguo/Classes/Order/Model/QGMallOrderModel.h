//
//  QGMallOrderModel.h
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import "QGModel.h"
#import "QGMallGoodsModell.h"

typedef NS_ENUM(NSInteger, QGMallOrderStatus) {
    QGMallOrderStatusAll,
    QGMallOrderStatusAudit = 1, // 审核
    QGMallOrderStatusPayment, // 待付款
    QGMallOrderStatusPrepare, // 待备货
    QGMallOrderStatusSend,    // 待发货
    QGMallOrderStatusDidSend, // 已发货
    QGMallOrderStatusComplete, // 已完成
    QGMallOrderStatusCancel = 90, // 前台取消
    QGMallOrderStatusDelete = 91, // 前台删除
    QGMallOrderStatusShutdown = 98, // 后台关闭
    QGMallOrderStatusSystemClose = 99, // 系统关闭(超时，退款 退货)
    QGMallOrderStatusSystemRefund = 103, // 待退款
    QGMallOrderStatusSystemRefunding = 104, //退款中
    QGMallOrderStatusSystemRefundFinish = 105, // 退款完成
    QGMallOrderStatusSystemRefundFailure = 106, // 退款失败
    QGMallOrderStatusSystemGoodsBack = 205,// 待退货
    QGMallOrderStatusSystemGoodsBacking = 206,// 退货中
    QGMallOrderStatusSystemGoodsBackFinish = 207,// 退货完成
    QGMallOrderStatusSystemGoodsBackFailure = 208,// 退货失败
    QGMallOrderStatusSystemExchange = 211,// 已换货
    QGMallOrderStatusSystemExchangeFailure = 212,// 换货失败
};

@interface QGMallOrderModel : QGModel
@property (nonatomic, strong) NSArray *goods;
@property (nonatomic, assign) NSInteger orderID;
@property (nonatomic, assign) QGMallOrderStatus orderStatus;
@property (nonatomic, assign) CGFloat orderAmount;
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, assign) NSInteger orderPayType;
@property (nonatomic, assign) NSInteger deliveryStatus;
@property (nonatomic, assign) NSInteger Sid;

@property (nonatomic, assign) NSInteger remainingTime;
@property (nonatomic, copy) NSString *logisticsInfo;
@property (nonatomic, copy) NSString *logisticsTime;
@property (nonatomic, copy) NSString *shipping_time;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *goodsAmount;
@property (nonatomic, copy) NSString *deliveryAmount;
@property (nonatomic, copy) NSString *PayTypeName;
@property (nonatomic, copy) NSString *orderMark;
@property (nonatomic, copy) NSString *buyerName;
@property (nonatomic, copy) NSString *buyerAddress;
@property (nonatomic, copy) NSString *buyerTel;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *orderStatusName;

@end
