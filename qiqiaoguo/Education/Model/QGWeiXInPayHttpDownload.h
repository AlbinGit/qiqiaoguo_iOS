//
//  QGWeiXInPayHttpDownload.h
//  LongForTianjie
//
//  Created by xiaoliang on 15/10/21.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"

@interface QGWeiXInPayHttpDownload : QGHttpDownload
@property (nonatomic,strong)NSString *batch_pay;//批量付款
@property (nonatomic,strong)NSString *order_id;//订单号
@property (nonatomic,strong)NSString *platform_id;//

@end
/**
 *  返回数据
 */
@interface QGWeiXInPayModel : QGHttpDownload
@property (nonatomic,strong)NSString *sign;//
@property (nonatomic,strong)NSString *partnerid;//
@property (nonatomic,strong)NSString *wxpackage;//

@property (nonatomic,strong)NSString *pay_order_type ;//
@property (nonatomic,strong)NSString *noncestr;//
@property (nonatomic,strong)NSString *timestamp;//
@property (nonatomic,strong)NSString *appid;//
@property (nonatomic,strong)NSString *prepayid;//
@end
