//
//  QGSingleItemModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//

#import <Foundation/Foundation.h>
//商品基本信息
@interface QGSingleItemModel : NSObject
/**商品ID号*/
@property (nonatomic,copy)NSString *Id;
/**店铺ID号*/
@property (nonatomic,copy)NSString *sid;
/**商品标题*/
@property (nonatomic,copy)NSString *title;
/**创建日期*/
@property (nonatomic,copy)NSString *create_time;

@property (nonatomic,copy)NSString *update_user_id;

@property (nonatomic,copy)NSString *coverpath;
/**商品分类ID*/
@property (nonatomic,copy)NSString *category_id;

@property (nonatomic,copy)NSString *update_time;
/**商品关键字*/
@property (nonatomic,copy)NSString *keyword;

@property (nonatomic,copy)NSString *create_user_id;

@property (nonatomic,copy)NSString *goods_type_id;
/**商品的描述信息HTML格式*/
@property (nonatomic,copy)NSString *fruit_desc;

@property (nonatomic,copy)NSString *is_del;

@property (nonatomic,copy)NSString *status;

@property (nonatomic,copy)NSString *sell;
/**商品单位*/
@property (nonatomic,copy)NSString *unit;

@property (nonatomic,copy)NSString *brand;
/**已销售数量*/
@property (nonatomic,copy)NSString *sales_volume;

@property (nonatomic,copy)NSString *comment;

@property (nonatomic,copy)NSString *video_path;
/**商品附标题*/
@property (nonatomic,copy)NSString *sub_title;

@property (nonatomic,copy)NSString *jd_price;

@property (nonatomic,copy)NSString *suning_price;

@property (nonatomic,copy)NSString *tmall_price;

@property (nonatomic,copy)NSString *goods_code;

@property (nonatomic,copy)NSString *shop_name;

@property (nonatomic,copy)NSString *commentCount;
/**商品咨询电话 */
@property (nonatomic,copy)NSString *question_consultation;
/**新增,分享地址*/
@property (nonatomic,copy)NSString *share_url;
/**包邮金额*/
@property (nonatomic,copy)NSString *free_shipping_amount;
/**商品发货方式 1 国内发货 2 境外发货 3 保税区发货 商品结算和立即购买时需要提供该参数*/
@property (nonatomic,copy)NSString *goods_delivery_type;
@end
