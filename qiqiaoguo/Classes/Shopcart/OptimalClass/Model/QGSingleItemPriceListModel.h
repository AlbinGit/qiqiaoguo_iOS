//
//  QGSingleItemPriceListModel.h
//  LongForTianjie
//
//  Created by 杨常勇 on 15/6/15.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>
//商品价格
@interface QGSingleItemPriceListModel : NSObject
@property (nonatomic,copy)NSString*shop_price;
@property (nonatomic,copy)NSString*market_price;
@property (nonatomic,copy)NSString*sales_price;//销售价
@property (nonatomic,copy)NSString*stock;
@property (nonatomic,copy)NSString*sales_volume;
@property (nonatomic,copy)NSString*id;
@property (nonatomic,copy)NSString*attr_value_name;
@property (nonatomic,copy)NSString*attr_value_id;
@end


@interface QGSingleItemBannerList : NSObject
@property (nonatomic,copy)NSString *ori_img;

@end