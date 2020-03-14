//
//  QGHttpManager+QGOptimaiProduct.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import "QGHttpManager+QGOptimaiProduct.h"

@implementation QGHttpManager (QGOptimaiProduct)
 + (void)optimaiProducthomeDataSuccess:(void (^)(QGOptimalProductResultModel *result))success failure:(void (^)(NSError *error))failure{
     QGOptimalProductHttpDownload *param = [[ QGOptimalProductHttpDownload alloc] init];
     param.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
     [self getWithUrl:param.path param:param resultClass:[QGOptimalProductResultModel  class] success:success failure:failure];
    
}
+ (void)optimaiProductSeckSkillSuccess:(void (^)(QGSeckillResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    QGGetSeckillGoodsListHttpDownload *ph = [[QGGetSeckillGoodsListHttpDownload alloc]init];
    
    ph.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    [self getWithUrl:ph.path param:ph  resultClass:[QGSeckillResultModel  class] success:success failure:failure];
}
+ (void)mallDataSuccess:(void (^)(QGCategroyResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    QGMallCategoryHttpDownload  *param = [[ QGMallCategoryHttpDownload  alloc] init];
    
    param.platform_id =[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    
    [self getWithUrl:param.path param:param resultClass:[QGCategroyResultModel class] success:success failure:failure];
    
}
+ (void)mallListDataWithParam:(QGGetMallByCategoryIdHttpDownload *)param Success:(void (^)(QGCategroyGoodsListResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    [self getWithUrl:param.path param:param resultClass:[QGCategroyGoodsListResultModel class] success:success failure:failure];
}
+ (void)mallSingStoreleListDataWithParam:(QGSingleStoreDownload *)param Success:(void (^)(QGSingleStoreResult *result))success failure:(void (^)(NSError *error))failure {
    
    [self getWithUrl:param.path param:param resultClass:[QGSingleStoreResult class] success:success failure:failure];
    
}

+ (void)mallSingShopStoreleListDataWithParam:(QGSingleShopStoreDownload *)param Success:(void (^)(QGSingleStoreResult *result))success failure:(void (^)(NSError *error))failure {
    
    [self getWithUrl:param.path param:param resultClass:[QGSingleStoreResult class] success:success failure:failure];
    
}
+ (void)mallStoreDetailWithParam:(QGStoreDetailDownload *)param Success:(void (^)(QGStoreDetailModel *result))success failure:(void (^)(NSError *error))failure{
    
    
    [self getWithUrl:param.path param:param resultClass:[QGStoreDetailModel class] success:success failure:failure];
}

+ (void)mallSkillStoreDetailWithParam:(QGSkillDetailDownload *)param Success:(void (^)(QGStoreDetailModel *result))success failure:(void (^)(NSError *error))failure{
    
    [self getWithUrl:param.path param:param resultClass:[QGStoreDetailModel class] success:success failure:failure];
    
}
+ (void)mallShopDetailsWithParam:(QGShopDetailsDownload *)param Success:(void (^)(QGShopDetailsModel *result))success failure:(void (^)(NSError *error))failure{
      [self getWithUrl:param.path param:param resultClass:[QGShopDetailsModel class] success:success failure:failure];
    
}

@end
