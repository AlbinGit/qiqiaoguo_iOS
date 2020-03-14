//
//  QGActOrderDetailResultModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import <Foundation/Foundation.h>
/**
 *  返回参数
 */
@class QGActOrderDetailItemModel ;
@interface QGActOrderDetailResultModel : NSObject
@property (nonatomic,strong) NSArray *activityInfo;
@property (nonatomic,strong) QGActOrderDetailItemModel  *item;
@end


@interface QGActOrderDetailItemModel : NSObject
@property (nonatomic,strong) NSArray *goodsList;
@property (nonatomic,copy)NSString *order_number;
@property (nonatomic,copy)NSString *order_status;
@property (nonatomic,copy)NSString *goods_amount;
@property (nonatomic,copy)NSString *delivery_fee;
@property (nonatomic,copy)NSString *order_type;
@property (nonatomic,copy)NSString *online_pay_type;
@property (nonatomic,copy)NSString *online_pay_type_name;
@property (nonatomic,copy)NSString *order_memos;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *tel;
@property (nonatomic,copy)NSString *shop_name;
@property (nonatomic,copy)NSString *sid;
@end

@interface QGActOrderDetailGoodsListModel : NSObject
@property (nonatomic,copy)NSString *quantity;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy) NSString *size;
@end

@interface QGActOrderDetailActivityModel : NSObject
@property (nonatomic,copy)NSString *coverPicPop;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *coverPicOrg;
@property (nonatomic,copy)NSString *type_name;
@end