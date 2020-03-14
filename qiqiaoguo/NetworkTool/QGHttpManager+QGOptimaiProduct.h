//
//  QGHttpManager+QGOptimaiProduct.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import "QGHttpManager.h"
#import "QGOptimalProductResultModel.h"
#import "QGGetSeckillGoodsListHttpDownload.h"
#import "QGSeckillResultModel.h"
#import "QGEudCategoryHttpDownload.h"
#import "QGGetGoodsListByCategoryIdHttpDownload.h"
#import "QGSingleStoreModel.h"
#import "QGStoreDetailModel.h"
#import "QGShopDetailsModel.h"
@interface QGHttpManager (QGOptimaiProduct)
+ (void)optimaiProducthomeDataSuccess:(void (^)(QGOptimalProductResultModel *result))success failure:(void (^)(NSError *error))failure;//商城首页
+ (void)optimaiProductSeckSkillSuccess:(void (^)(QGSeckillResultModel *result))success failure:(void (^)(NSError *error))failure;//秒杀
+ (void)mallDataSuccess:(void (^)(QGCategroyResultModel *result))success failure:(void (^)(NSError *error))failure;//商城分类首页
+ (void)mallListDataWithParam:(QGGetMallByCategoryIdHttpDownload *)param Success:(void (^)(QGCategroyGoodsListResultModel *result))success failure:(void (^)(NSError *error))failure;//商城分类列表

+ (void)mallSingStoreleListDataWithParam:(QGSingleStoreDownload *)param Success:(void (^)(QGSingleStoreResult *result))success failure:(void (^)(NSError *error))failure;//商品列表
+ (void)mallSingShopStoreleListDataWithParam:(QGSingleShopStoreDownload *)param Success:(void (^)(QGSingleStoreResult *result))success failure:(void (^)(NSError *error))failure;
+ (void)mallStoreDetailWithParam:(QGStoreDetailDownload *)param Success:(void (^)(QGStoreDetailModel *result))success failure:(void (^)(NSError *error))failure;//单店商品详情//QGSkillDetailDownload
+ (void)mallSkillStoreDetailWithParam:(QGSkillDetailDownload *)param Success:(void (^)(QGStoreDetailModel *result))success failure:(void (^)(NSError *error))failure;//秒杀商品详情/
+ (void)mallShopDetailsWithParam:(QGShopDetailsDownload *)param Success:(void (^)(QGShopDetailsModel *result))success failure:(void (^)(NSError *error))failure;//商品详情
@end
