//
//  QGShopCarModel.m
//  qiqiaoguo
//
//  Created by cws on 16/7/23.
//
//

#import "QGShopCarModel.h"

@implementation QGShopCarModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{@"goodsID":           @"id",
      @"storeID":           @"sid",
      @"goodsPrice":        @"sales_price",
      @"goodsInventory":    @"stock",
      @"goodsName":         @"title",
      };
}

@end
