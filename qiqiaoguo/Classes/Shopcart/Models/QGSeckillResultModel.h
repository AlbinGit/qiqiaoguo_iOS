//
//  QGSeckillResultModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/13.
//
//

#import <UIKit/UIKit.h>

@interface QGSeckillResultModel : NSObject
@property (nonatomic, strong) NSMutableArray *seckillingList;

@property (nonatomic, strong) NSString *cover;
@end


@interface QGSeckillListModel  : NSObject
/**限时抢购ID*/
@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *buy_limit;

/**限时抢购商品ID*/
@property (nonatomic, strong) NSString *sid;
/**限时抢购商品分类ID*/
@property (nonatomic, strong) NSString *title;
/**限时抢购价格*/
@property (nonatomic, strong) NSString *sub_title;

@property (nonatomic, strong) NSMutableArray *items;
/**限时抢购开始时间*/
@property (nonatomic, strong) NSString *start_time;
/**限时抢购开始时间*/
@property (nonatomic, strong) NSString *end_time;
/**限时抢购商品图片*/
@property (nonatomic, strong) NSString *coverpath;

@property (nonatomic, strong) NSString *seckilling_no;
@end


@interface QGSeckillListItemModel : NSObject
/**已售限时抢购商品数*/
@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *sales_price;
/**限时抢购活动编号*/
@property (nonatomic, strong) NSString *seckilling_no;
/**限时抢购商品原销售价*/
@property (nonatomic, strong) NSString *market_price;

@property (nonatomic, strong) NSString *stock;

@property (nonatomic, strong) NSString *delivery_type;

@property (nonatomic, strong) NSString *sales_volume;
/**限时抢购商品图片*/
@property (nonatomic, strong) NSString *coverpath;



/**限时抢购开始时间*/
@property (nonatomic, strong) NSString *start_time;
/**限时抢购开始时间*/
@property (nonatomic, strong) NSString *end_time;
@end
