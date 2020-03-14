//
//  QGHttpManager+Activity.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/5.
//
//

#import "QGHttpManager+Activity.h"

#define QGActivCalendar       (BLUApiString(@"/Phone/Activity/getActivityCalendar"))
#define QGDailyActivList       (BLUApiString(@"/Phone/Activity/getDailyActivityList"))
#define QGNearActivList       (BLUApiString(@"/Phone/Activity/getNearbyActivityList"))

@implementation QGHttpManager (Activity)
+ (void)acthomeDataSuccess:(void (^)(QGActHomeResultModel *result))success failure:(void (^)(NSError *error))failure {
    
         QGActHomeHttpDownload  *param = [[ QGActHomeHttpDownload  alloc] init];
         param.platform_id =[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
        [self getWithUrl:param.path param:param resultClass:[QGActHomeResultModel class] success:success failure:failure];
    
}
+(void)actlisthomeDataWithParam:(QGActlistHomeDownload *)param success:(void (^)(QGActlistHomeResultModel *result))success failure:(void (^)(NSError *error))failure{
    
      param.platform_id =[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
     [self getWithUrl:param.path param:param resultClass:[QGActlistHomeResultModel class] success:success failure:failure];
    
}

+(void)UserActlistDataWithParam:(QGHttpDownload *)param Page:(NSInteger)page success:(void (^)(QGActlistHomeResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    [self getWithUrl:param.path param:@{@"page":@(page)} resultClass:[QGActlistHomeResultModel class] success:success failure:failure];
    
}

+(void)getActivNearListWithPage:(NSInteger)page Longitude:(CGFloat)longitude Latitude:(CGFloat)latitude success:(void (^)(QGActlistHomeResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    [self getWithUrl:QGNearActivList param:@{@"page":@(page),@"latitude":@(latitude),@"longitude":@(longitude)} resultClass:[QGActlistHomeResultModel class] success:success failure:failure];
    
}


+(void)actdetailWithParam:(QGActlistDetailDownload *)param success:(void (^)(QGActlistDetailResultModel *result))success failure:(void (^)(NSError *error))failure {
 
    [self getWithUrl:param.path param:param resultClass:[QGActlistDetailResultModel class] success:success failure:failure];
    
}
+(void)actlistOrderWithParam:(QGActOrderDownload *)param success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{

     NSDictionary *params = [param mj_keyValues];
 
    [[[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost
                                           URLString:QGActivityOrderDetailsPath
                                          parameters:params
                                         resultClass:nil
                                       objectKeyPath:QGApiObjectKeyItem] handleResponse] subscribeNext:^(id x) {
        if (success) {
           
            success(x );
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
      
    } error:^(NSError *error) {
        if (failure) {
            failure(error);
             [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
    }];
    
     }



+(void)edulistOrderWithParam:(QGEduOrderDownload *)param success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{
    NSDictionary *params = [param mj_keyValues];
    
    [[[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost
                                           URLString:QGEduSignOrderDetailsPath
                                          parameters:params
                                         resultClass:nil
                                       objectKeyPath:QGApiObjectKeyItem] handleResponse] subscribeNext:^(id x) {
        if (success) {
            
            success(x );
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
        
    } error:^(NSError *error) {
        if (failure) {
            failure(error);
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
    }];
    
}
+(void)actlistPayOrderWithParam:(QGWeiXInPayHttpDownload *)param success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{

    NSDictionary *params = [param mj_keyValues];

    [self get:param.path params:params success:^(id responseObj) {
        if (success) {

            success(responseObj);
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
      
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
    }];
}


+(void)actlistPaypalOrderWithParam:(QGPaypalHttpDownload *)param success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = [param mj_keyValues];
    
    [self get:param.path params:params success:^(id responseObj) {
        if (success) {
            
            success(responseObj);
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
    }];
    
}

// 获取活动日历场次数量
+ (void)getCalendarActSessionSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self GET:QGActivCalendar params:@{@"platform_id":PLATFORMID} resultClass:nil objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(task,error);
        }
    }];
    
}

/**获取某日活动列表*/
+ (void)getCalendarActListWithDate:(NSString *)dateStr Page:(NSInteger)page Success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{
    
    [self getWithUrl:QGDailyActivList param:@{@"platform_id":PLATFORMID,@"date":dateStr,@"page":@(page)} resultClass:[QGActlistHomeResultModel class] success:^(id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}



@end
