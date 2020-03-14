//
//  QGStoreDetailModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//
/**
 *imageList：商品图片列表
 priceList：商品组合价格列表，实体中：
 id＝组合商品的商品id（不是 goods_id）;
 stock＝组合商品库存;
 sales_price＝组合商品销售价格;
 attr_value_name＝组合属性名称;
 attr_value_id＝组合属性 id，由多个属性id 组合成，形如 1_102_107 表示 由 attrList 里，属性项id 为1 、 102 、107 的多个属性项组成；属性项组成规则是 按 id 从小到大排序，中间用 _ 连接;
 attrList：商品属性列表
 当attrList 为空时（长度为零），priceList 只有一个对象，用其对象 id 作为下单用的商品id, 界面不用选择属性；
 当attrList 不为空时，attrList 每一个对象就是一个商品属性项（如：颜色 ），一个属性项里有一到多个属性（如：红色，蓝色，黄色 ）；
 attribute_id＝属性项id
 attribute_name＝属性项名称
 attribute_value ＝ 属性项 里的属性数组
 id=属性id，用于组合后，查找 priceList 里对应 的 attr_value_id，即可得到组合属性对应 的商品 id
 value=属性名
 */

#import <Foundation/Foundation.h>
#import "QGTagListModel.h"
#import "BLUShareObject.h"
/**
 *  请求参数
 */
@interface QGStoreDetailDownload : QGHttpDownload
/**平台ID号*/
@property (nonatomic, copy) NSString *platform_id;

@property (nonatomic, copy) NSString *goods_id;//商品 id (用于获取商品信息)
@property (nonatomic,strong) NSString *seckilling_no;

@end


@interface QGSkillDetailDownload : QGHttpDownload
/**平台ID号*/
@property (nonatomic, copy) NSString *platform_id;

@property (nonatomic, copy) NSString *goods_id;//商品 id (用于获取商品信息)
@property (nonatomic,strong) NSString *seckilling_no;

@end



/**
 *  返回参数
 */

@class QGStoreDetailShopInfoModel,QGStoreDetailItemModel;

@interface QGStoreDetailModel : NSObject

@property (nonatomic,strong) QGStoreDetailItemModel *item;
@property (nonatomic,strong) QGStoreDetailShopInfoModel *shopInfo;

@end


@interface QGStoreDetailItemModel : NSObject <BLUShareObject>

@property (nonatomic,copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *coverpath;
@property (nonatomic, copy) NSString *sub_title;

@property (nonatomic, copy) NSString *sales_price;

@property (nonatomic, copy) NSString *sales_volume;

@property (nonatomic, copy) NSString *delivery_type;

@property (nonatomic, copy) NSString *fruit_desc;

@property (nonatomic, copy) NSString *click;
@property (nonatomic,copy) NSString *sid;

@property (nonatomic,strong) QGSeckillListModel *seckillingInfo;
@property (nonatomic, copy) NSString *sales_price_tip;//销售价格范围
@property (nonatomic,copy) NSString *market_price_tip;//市场价格范围

@property (nonatomic, copy) NSString *isFollowed;//是否已关注
@property (nonatomic,copy) NSString *following_count;//关注人数
@property (nonatomic, copy) NSString *sharUrl;
@property (nonatomic,strong) NSMutableArray *imageList;
@property (nonatomic,strong) NSMutableArray *priceList;
@property (nonatomic,strong) NSMutableArray *attrList;

@end

@interface QGStoreDetailShopInfoModel : NSObject
@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *cover_photo;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *id;

@property (nonatomic,strong) NSArray *tagList;
@property (nonatomic,copy) NSString *service_id;

@end
@interface QGStoreDetailImageListModel : NSObject

@property (nonatomic, copy) NSString *image_url;


@property (nonatomic, copy) NSString *id;


@end
