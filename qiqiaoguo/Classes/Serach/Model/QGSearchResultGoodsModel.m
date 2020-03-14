//
//  QGSearchResultGoodsModel.m
//  qiqiaoguo
//
//  Created by cws on 16/7/10.
//
//

#import "QGSearchResultGoodsModel.h"

@implementation QGSearchResultGoodsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"goodsTitle": @"title",
             @"goodsImageStr": @"coverpath",
             @"salesVolume": @"sales_volume",
             @"goodsID": @"id",
             @"salesPrice": @"sales_price",
             @"deliveryType": @"delivery_type",
             };
}

@end
