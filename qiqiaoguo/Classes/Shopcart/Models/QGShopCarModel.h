//
//  QGShopCarModel.h
//  qiqiaoguo
//
//  Created by cws on 16/7/23.
//
//

#import "QGModel.h"

typedef NS_ENUM(NSUInteger, QGGoodsDeliveryType) {
    QGGoodsDeliveryTypeDomestic = 1, // 国内发货
    QGGoodsDeliveryTypeOverseas, // 境外发货
    QGGoodsDeliveryTypeBonded, // 全球购/保税区发货
};

@interface QGShopCarModel : QGModel

@property (nonatomic ,copy) NSString *storeName;
@property (nonatomic ,copy) NSString *goodsName;
@property (nonatomic ,copy) NSString *goodsNote;
@property (nonatomic ,assign) NSInteger goodsID;
@property (nonatomic ,assign) NSInteger storeID;
@property (nonatomic ,assign) CGFloat goodsPrice;
@property (nonatomic, assign) NSInteger goodsCount;
@property (nonatomic, assign) NSInteger goodsInventory;
@property (nonatomic, copy) NSString *goodsImage;
@property (nonatomic, assign) QGGoodsDeliveryType DeliveryType;
@property (nonatomic, assign) BOOL isBuyNow;
@property (nonatomic, assign) BOOL isSeckilling;
@property (nonatomic, copy) NSString *seckillingNO;
@end
