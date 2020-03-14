//
//  QGHttpManager+Home.h
//  qiqiaoguo
//
//  Created by cws on 16/6/3.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGHttpManager.h"
#import "QGSkillHttpDownload.h"
#import "QGFirstPageDataModel.h"
#import "QGGetCityDownload.h"
#import "QGGetLocationCityModel.h"

@interface QGHttpManager (Home)
///Home/getLocationCity

+ (void)homeDataSuccess:(void (^)(QGFirstPageDataModel *result))success failure:(void (^)(NSError *error))failure;
//+ (void)homeInfoWithParam:(QGSkillHttpDownload *)param success:(void (^)(QGFirstPageDataModel *result))success failure:(void (^)(NSError *error))failure;

+ (void)homeGetCitySuccess:(void (^)(QGGetCityResultModel *result))success failure:(void (^)(NSError *error))failure;


+ (void)homeGetLocationCityWithParam:(QGGetLocationCityModel *)param success:(void (^)(QGGetCityResultModel *result))success failure:(void (^)(NSError *error))failure;

+ (void)getStartUpImageSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure;

@end
