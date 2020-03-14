//
//  QGPaypalHttpDownload.h
//  LongForTianjie
//
//  Created by xiaoliang on 15/10/26.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"

@interface QGPaypalHttpDownload : QGHttpDownload
@property (nonatomic,strong)NSString *order_id;//订单号
@property (nonatomic,strong)NSString *platform_id;
@property (nonatomic,strong)NSString *batch_pay;
@end



/**
 *  返回数据
 */
@interface QGPaypalPayModel : QGHttpDownload
@property (nonatomic,strong)NSString *out_trade_no;//
@property (nonatomic,strong)NSString *sign_type;//
@property (nonatomic,strong)NSString *order_info;//

@property (nonatomic,strong)NSString *sign ;//

@end