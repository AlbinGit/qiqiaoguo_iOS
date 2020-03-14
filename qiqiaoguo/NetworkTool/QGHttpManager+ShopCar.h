//
//  QGHttpManager+ShopCar.h
//  qiqiaoguo
//
//  Created by cws on 16/7/25.
//
//

#import "QGHttpManager.h"
#import "QGAddressModel.h"

@interface QGHttpManager (ShopCar)

+ (void)checkInventoryWithGoodsIDs:(NSArray *)goodsIDArray Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;


+ (void)getAddressDetailsWithAddressID:(NSInteger)addressID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

// 获取默认地址
+ (void)getDefultAddressSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure;

// 保存地址
+ (void)saveAddressDetailsWithAddress:(QGAddressModel *)address Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

// 拉取运费
+ (void)fetchCountOrderFeeWithGoodsArray:(NSArray *)goodsArray Address:(QGAddressModel *)model Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

// 提交订单
+ (void)submitOrderWithGoodsArray:(NSArray *)goodsArray Address:(QGAddressModel *)model Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

@end
