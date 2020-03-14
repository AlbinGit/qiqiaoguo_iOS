//
//  QGHttpManager+ShopCar.m
//  qiqiaoguo
//
//  Created by cws on 16/7/25.
//
//

#import "QGHttpManager+ShopCar.h"
#import "QGShopCarModel.h"
#import "QGGoodsMO.h"
#import "QGAddressModel.h"

#define QGGoodsCheckInventory         (BLUApiString(@"/Phone/Order/checkOrder"))
#define QGDefaultAddress              (BLUApiString(@"/Phone/User/getDefaultAddress"))
#define QGSaveAddress                 (BLUApiString(@"/Phone/User/addAddress"))
#define QGUpdateAddress               (BLUApiString(@"/Phone/User/editAddress"))
#define QGGetcountOrderFee            (BLUApiString(@"/Phone/Order/countOrderFee"))
#define QGsubmitOrderFee              (BLUApiString(@"/Phone/Order/placeOrder"))

@implementation QGHttpManager (ShopCar)

+ (void)checkInventoryWithGoodsIDs:(NSArray *)goodsIDArray Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    NSMutableString *ids = [NSMutableString stringWithString:@"["];
    for (QGGoodsMO *goods in goodsIDArray) {
        [ids appendFormat:@"%@,",goods.goodID];
    }
    
    NSString *idStr = [NSString stringWithFormat:@"%@]",[ids substringWithRange:NSMakeRange(0, [ids length]-1)]];
    NSLog(@"idStr==%@",idStr);
    
    [self POST:QGGoodsCheckInventory params:@{@"platform_id":PLATFORMID,@"goodList":idStr} resultClass:[QGShopCarModel class] objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)getDefultAddressSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self GET:QGDefaultAddress params:nil resultClass:[QGAddressModel class] objectKeyPath:QGApiObjectKeyItem success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

+ (void)getAddressDetailsWithAddressID:(NSInteger)addressID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{

}

+ (void)saveAddressDetailsWithAddress:(QGAddressModel *)address Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSString *str = nil;
    if (address.addressID.integerValue > 0) {
        str = QGUpdateAddress;
    }else{
        str = QGSaveAddress;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:@{@"username":address.contact,@"tel":address.phone,@"address":address.details}];
    if (address.provinceDetail) {
        [dic setObject:address.provinceDetail forKey:@"province"];
    }else{
        [dic setObject:address.province forKey:@"province"];
    }
    
    if (address.cityDetail) {
        [dic setObject:address.cityDetail forKey:@"city"];
    }else{
        [dic setObject:address.city forKey:@"city"];
    }
    
    if (address.areaDetail) {
        [dic setObject:address.areaDetail forKey:@"area"];
    }else{
        [dic setObject:address.area forKey:@"area"];
    }
    
    if (address.addressID) {
        [dic setObject:address.addressID forKey:@"address_id"];
    }
    
    [self POST:str params:dic resultClass:nil objectKeyPath:QGApiObjectKeyItem success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)fetchCountOrderFeeWithGoodsArray:(NSArray *)goodsArray Address:(QGAddressModel *)model Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSArray *shopArr in goodsArray) {
        NSMutableDictionary *shopDic = [NSMutableDictionary dictionary];
        QGGoodsMO *good = shopArr.firstObject;
        [shopDic setObject:good.storeID forKey:@"sid"];
        if (good.remark) {
            [shopDic setObject:good.remark forKey:@"remark"];
        }
         NSMutableArray *goodsArr = [NSMutableArray array];
        for (QGGoodsMO *goodsmo in shopArr) {
            NSMutableDictionary *goodsDic = [[NSMutableDictionary alloc]initWithDictionary:
            @{@"id":goodsmo.goodID,@"quantity":goodsmo.goodsCount}];
            // TODO 这里需要添加秒杀商品的信息
            if(goodsmo.isSeckilling.boolValue == YES && goodsmo.seckillingNO){
                [goodsDic setObject:goodsmo.seckillingNO forKey:@"seckilling_no"];
            }
            [goodsArr addObject:goodsDic];
            
        }
        [shopDic setObject:goodsArr forKey:@"goodsList"];
        [arr addObject:shopDic];
    }
    
    
    [params setObject:model.addressID forKey:@"address_id"];
    [params setObject:PLATFORMID forKey:@"platform_id"];
    [params setObject:arr forKey:@"shoppingCart"];
    [[[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost
                                          URLString:QGGetcountOrderFee
                                         parameters:params
                                        resultClass:nil
                                     objectKeyPath:QGApiObjectKeyItem] handleResponse] subscribeNext:^(id x) {
        if (success) {
            success(nil,x);
        }
    } error:^(NSError *error) {
        if (failure) {
            failure(nil,error);
        }
    }];
//    [self POST:QGGetcountOrderFee params:params resultClass:nil objectKeyPath:QGApiObjectKeyItem success:^(NSURLSessionDataTask *task, id responseObject) {
//        if (success) {
//            success(task,responseObject);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (failure) {
//            failure(task,error);
//        }
//    }];
    
}

// 提交订单
+ (void)submitOrderWithGoodsArray:(NSArray *)goodsArray Address:(QGAddressModel *)model Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSArray *shopArr in goodsArray) {
        NSMutableDictionary *shopDic = [NSMutableDictionary dictionary];
        QGGoodsMO *good = shopArr.firstObject;
        [shopDic setObject:good.storeID forKey:@"sid"];
        if (good.remark) {
            [shopDic setObject:good.remark forKey:@"remark"];
        }
        NSMutableArray *goodsArr = [NSMutableArray array];
        for (QGGoodsMO *goodsmo in shopArr) {
            NSMutableDictionary *goodsDic = [[NSMutableDictionary alloc]initWithDictionary:
                                             @{@"id":goodsmo.goodID,@"quantity":goodsmo.goodsCount}];
            // TODO 这里需要添加秒杀商品的信息
            if(goodsmo.isSeckilling.boolValue == YES){
                [goodsDic setObject:goodsmo.seckillingNO forKey:@"seckilling_no"];
             }
            [goodsArr addObject:goodsDic];
            
        }
        [shopDic setObject:goodsArr forKey:@"goodsList"];
        [arr addObject:shopDic];
    }
    
    
    [params setObject:model.addressID forKey:@"address_id"];
    [params setObject:PLATFORMID forKey:@"platform_id"];
    [params setObject:arr forKey:@"shoppingCart"];
    if (model.idCard) {
        [params setObject:model.idCard forKey:@"id_card"];
    }
    
    [[[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost
                                           URLString:QGsubmitOrderFee
                                          parameters:params
                                         resultClass:nil
                                       objectKeyPath:QGApiObjectKeyItem] handleResponse] subscribeNext:^(id x) {
        if (success) {
            success(nil,x);
        }
    } error:^(NSError *error) {
        if (failure) {
            failure(nil,error);
        }
    }];
}

@end
