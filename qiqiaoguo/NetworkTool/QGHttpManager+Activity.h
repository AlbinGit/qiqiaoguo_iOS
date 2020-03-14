//
//  QGHttpManager+Activity.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/5.
//
//

#import "QGHttpManager.h"
#import "QGActHomeModel.h"
#import "QGActlistHomeModel.h"
#import "QGWeiXInPayHttpDownload.h"
#import "QGActlistDetailModel.h"
#import "QGActOrderDownload.h"
#import "QGActOrderDetailResultModel.h"
#import "QGPaypalHttpDownload.h"
#import "QGEduOrderDownload.h"
@interface QGHttpManager (Activity)
+ (void)acthomeDataSuccess:(void (^)(QGActHomeResultModel *result))success failure:(void (^)(NSError *error))failure;//活动首页
+(void)actlisthomeDataWithParam:(QGActlistHomeDownload *)param success:(void (^)(QGActlistHomeResultModel *result))success failure:(void (^)(NSError *error))failure;//活动列表
+(void)actdetailWithParam:(QGActlistDetailDownload *)param success:(void (^)(QGActlistDetailResultModel *result))success failure:(void (^)(NSError *error))failure;//活动详情
+(void)UserActlistDataWithParam:(QGHttpDownload *)param Page:(NSInteger)page success:(void (^)(QGActlistHomeResultModel *result))success failure:(void (^)(NSError *error))failure; // 用户收藏或参与的活动列表
+(void)actlistOrderWithParam:(QGActOrderDownload *)param success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;//活动订单
+(void)edulistOrderWithParam:(QGEduOrderDownload *)param success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;//教育订单
+(void)actlistPayOrderWithParam:(QGWeiXInPayHttpDownload *)param success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;//微信支付
+(void)actlistPaypalOrderWithParam:(QGPaypalHttpDownload *)param success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;//支付宝支付

/**获取活动日历场次数量*/
+ (void)getCalendarActSessionSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**获取某日活动列表*/
+ (void)getCalendarActListWithDate:(NSString *)dateStr Page:(NSInteger)page Success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** 附近的活动 */
+(void)getActivNearListWithPage:(NSInteger)page Longitude:(CGFloat)longitude Latitude:(CGFloat)latitude success:(void (^)(QGActlistHomeResultModel *result))success failure:(void (^)(NSError *error))failure;

@end
