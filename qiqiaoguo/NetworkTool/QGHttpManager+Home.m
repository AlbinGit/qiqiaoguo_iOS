//
//  QGHttpManager+Home.m
//  qiqiaoguo
//
//  Created by cws on 16/6/3.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGHttpManager+Home.h"


#define QGHome                   QGGetSkillInfoPath
#define QGStartUpImage          (BLUApiString(@"/Phone/Home/getStartUpImage"))

@implementation QGHttpManager (Home)



+ (void)homeDataSuccess:(void (^)(QGFirstPageDataModel *result))success failure:(void (^)(NSError *error))failure; {
    
    QGSkillHttpDownload *param = [[QGSkillHttpDownload alloc] init];
    param.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    [self getWithUrl:param.path param:param resultClass:[QGFirstPageDataModel class] success:success failure:failure];
}


+ (void)homeGetCitySuccess:(void (^)(QGGetCityResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    QGGetCityDownload  *param = [[QGGetCityDownload  alloc] init];
    param.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
     [self getWithUrl:param.path param:param resultClass:[QGGetCityResultModel class] success:success failure:failure];
}
+ (void)homeGetLocationCityWithParam:(QGGetLocationCityModel *)param success:(void (^)(QGGetCityResultModel *result))success failure:(void (^)(NSError *error))failure {


    param.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    [self getWithUrl:param.path param:param resultClass:[QGGetCityResultModel class] success:success failure:failure];

}

+ (void)getStartUpImageSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    [self GET:QGStartUpImage params:nil resultClass:nil objectKeyPath:QGApiObjectKeyExtra success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}


@end
