//
//  QGHttpManager+Home.m
//  qiqiaoguo
//
//  Created by cws on 16/6/3.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGHttpManager+Home.h"
#import "QGHomeModel.h"

#define QGHome                   QGGetSkillInfoPath
#define BLUAdApiCircleAD         (BLUApiString(@"/ad/circle"))

@implementation QGHttpManager (Home)

+ (void)fetchHomeDataSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    NSDictionary *parameters = @{@"sid":GETSID};
    
    [self GET:QGHome params:parameters resultClass:[QGHomeModel class] objectKeyPath:QGApiObjectKeycontent success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
}

@end
