//
//  QGMallOrderModel.m
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import "QGMallOrderModel.h"
#import "QGMallGoodsModell.h"

@implementation QGMallOrderModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"goods":                 @"goodsList",
      @"orderID":               @"id",
      @"orderNum":              @"order_number",
      @"orderStatus":           @"order_status",
      @"orderAmount":           @"order_amount",
      @"orderType":             @"order_type",
      @"orderPayType":          @"online_pay_type",
      @"deliveryStatus":        @"delivery_status",
      @"Sid":                   @"sid",
      @"goodsAmount":           @"goods_amount",
      @"deliveryAmount":        @"delivery_fee",
      @"PayTypeName":           @"online_pay_type_name",
      @"orderMark":             @"order_memos",
      @"buyerName":             @"username",
      @"buyerAddress":          @"address",
      @"buyerTel":              @"tel",
      @"shopName":              @"shop_name",
      @"logisticsInfo":         @"logistics_info",
      @"logisticsTime":         @"logistics_time",
      @"shipping_time":         @"shipping_time",
      @"create_time":           @"create_time",
      @"remainingTime":         @"close_time",
      @"orderStatusName":       @"order_status_name",
      };
    
}

+ (NSValueTransformer *)goodsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *goods, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[QGMallGoodsModell class] fromJSONArray:goods error:nil];
    } reverseBlock:^id(NSArray *goods, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:goods error:nil];
    }];
}


@end
