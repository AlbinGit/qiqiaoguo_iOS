//
//  QGMallGoodsModell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import "QGMallGoodsModell.h"

@implementation QGMallGoodsModell

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"goodsID":           @"id",
      @"goodsPrice":        @"price",
      @"Quantity":          @"quantity",
      @"imageStr":          @"cover",
      @"sizeStr":           @"size",
      @"title":             @"title"
    };
}

@end
