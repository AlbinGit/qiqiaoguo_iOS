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
UIKIT_EXTERN NSString * QGApiObjectKeyinfo;
UIKIT_EXTERN NSString * QGApiObjectKeyUserProfit;


typedef void (^QGResponseSuccess)(NSURLSessionDataTask * task,id responseObject);
typedef void (^QGResponseFail)(NSURLSessionDataTask * task, NSError * error);

@interface QGHttpManager : AFHTTPSessionManager

+ (instancetype)sharedManager;
//+ (instancetype)sharedManager;
+ (void)GET:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)POST:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)Delegate:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

// 上传图片的请求
+ (void)POST:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure;


// 上传视频的请求
+ (void)POST:(NSString *)url params:(NSDictionary *)params video:(NSURL *)videoUrl success:(QGResponseSuccess)success failure:(QGResponseFail)failure;




#pragma mark 第二种
//第一层封装AFNetworking
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;


//第二层封装MJExtension
+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)setCookiesWithUrl:(NSString *)url;
@end
