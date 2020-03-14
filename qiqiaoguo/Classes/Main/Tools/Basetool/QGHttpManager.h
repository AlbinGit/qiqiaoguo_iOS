//
//  QGHttpManager.h
//  qiqiaoguo
//
//  Created by cws on 16/6/3.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString * QGApiObjectKeyMsg;
UIKIT_EXTERN NSString * QGApiObjectKeyCode;
UIKIT_EXTERN NSString * QGApiObjectKeyExtra;
UIKIT_EXTERN NSString * QGApiObjectKeyItem;
UIKIT_EXTERN NSString * QGApiObjectKeyItems;
UIKIT_EXTERN NSString * QGApiObjectKeycontent;


typedef void (^QGResponseSuccess)(NSURLSessionDataTask * task,id responseObject);
typedef void (^QGResponseFail)(NSURLSessionDataTask * task, NSError * error);

@interface QGHttpManager : AFHTTPSessionManager
//+ (instancetype)sharedManager;
+ (void)GET:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)POST:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure;
@end
