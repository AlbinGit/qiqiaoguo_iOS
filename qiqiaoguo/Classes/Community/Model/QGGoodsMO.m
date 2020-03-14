//
//  QGGoodsMO.m
//  qiqiaoguo
//
//  Created by cws on 16/7/23.
//
//

#import "QGGoodsMO.h"

@implementation QGGoodsMO

// Insert code here to add functionality to your managed object subclass

- (void)configureWithGood:(QGShopCarModel *)CarModel {
    self.goodsCount     = @(CarModel.goodsCount);
    self.goodID         = @(CarModel.goodsID);
    self.goodsImage     = CarModel.goodsImage;
    self.name           = CarModel.goodsName;
    self.storeName      = CarModel.storeName;
    self.storeID        = @(CarModel.storeID);
    self.price          = @(CarModel.goodsPrice);
    self.inventory      = @(CarModel.goodsInventory);
    self.note           = CarModel.goodsNote;
    self.selected       = @(NO);
    self.deliveryType   = @(CarModel.DeliveryType);
    self.isSeckilling   = @(CarModel.isSeckilling);
    self.isBuyNow       = @(CarModel.isBuyNow);
    self.seckillingNO   = CarModel.seckillingNO;
}

@end
