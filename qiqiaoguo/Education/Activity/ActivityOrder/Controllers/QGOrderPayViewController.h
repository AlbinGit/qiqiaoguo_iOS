//
//  QGOrderPayViewController.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/28.
//
//


#import "QGViewController.h"
#import "QGSelectAddressView.h"

@interface QGOrderPayViewController : QGViewController
@property (nonatomic,strong)NSString *is_batch_pay;//在线支付的订单是否为批量在线支付付款 此参数在调起支付配置数据时将会用到
@property (nonatomic,strong)NSString *pay_amount;//在线支付的订单金额
@property (nonatomic,strong)NSString *order_id;//在线支付的订单单号
@property (nonatomic,strong)NSString *order_type;//支付的订单类型
@property (nonatomic,assign)QGConfirmOrderType ConfirmOrderType;//商品类型
@property (nonatomic,copy)NSString *activity_id;
@property (nonatomic,copy) NSString *edu_id;
@end
