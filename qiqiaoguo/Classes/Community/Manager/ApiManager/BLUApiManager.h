//
//  BlUApiManager.h
//  Blue
//
//  Created by Bowen on 29/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "BLUServer.h"
#import "BLUPagination.h"
#import "BLUFormData.h"

#pragma mark Error Handle

#undef BLUApiManagerDebug
//#define BLUApiManagerDebug

// --- 请求成功

UIKIT_EXTERN NSInteger BLUApiRequestSuccess;

// --- 错误域 ---

UIKIT_EXTERN NSString * BLUApiErrorDomain;
UIKIT_EXTERN NSString * BLUApiErrorDomainClient;

// --- 客户端错误代码 ---

UIKIT_EXTERN NSInteger BLUApiErrorAuthenticationFailed; // 认证错误 403

UIKIT_EXTERN NSInteger BLUApiErrorRequestForbiddern; // 请求拒绝错误

UIKIT_EXTERN NSInteger BLUApiErrorBadRequest; // 错误的请求

UIKIT_EXTERN NSInteger BLUApiErrorServiceRequestFailed; // 服务端请求失败

UIKIT_EXTERN NSInteger BLUApiErrorConnectionFailed; // 链接失败

UIKIT_EXTERN NSInteger BLUApiErrorJSONParsingFailed; // JSON解码错误

UIKIT_EXTERN NSInteger BLUApiErrorWrongRequestFormate; // 错误的请求格式

UIKIT_EXTERN NSInteger BLUApiErrorNoCoinToChat; // 没有金币聊天了

// --- Base url ---

#define BLUApiString(relativeURLString) ([[[BLUServer sharedServer] baseURLString] stringByAppendingString:relativeURLString])

#define QQGApiString(relativeURLString) ([[[BLUServer sharedServer] QQGbaseURLString] stringByAppendingString:relativeURLString])

// --- Object key ---

UIKIT_EXTERN NSString * BLUApiObjectKeyMsg;
UIKIT_EXTERN NSString * BLUApiObjectKeyCode;
UIKIT_EXTERN NSString * BLUApiObjectKeyExtra;
UIKIT_EXTERN NSString * BLUApiObjectKeyItem;
UIKIT_EXTERN NSString * BLUApiObjectKeyItems;

// --- Http method ---

UIKIT_EXTERN NSString * BLUApiHttpMethodPost;
UIKIT_EXTERN NSString * BLUApiHttpMethodDelete;
UIKIT_EXTERN NSString * BLUApiHttpMethodPut;
UIKIT_EXTERN NSString * BLUApiHttpMethodGet;

// --- Mime Type ---
UIKIT_EXTERN NSString * BLUApiMimeTypeImageJPEG;
UIKIT_EXTERN NSString * BLUApiMimeTypeJSON;
UIKIT_EXTERN NSString * BLUApiMimeTypePlainText;

// --- Image ---
UIKIT_EXTERN  CGFloat BLUApiImageCompressionQuality;

// --- Notification ---
UIKIT_EXTERN NSString * BLUApiManagerLoginRequireNotification;
UIKIT_EXTERN NSString * BLUApiManagerUserProfitNotification;

#pragma mark Class

@interface BLUApiManager : AFHTTPSessionManager

// 使用默认的Server进行创建
+ (instancetype)sharedManager;

@property (nonatomic, copy, readonly) NSDictionary *clientApiVersion;

@end

@class BLUResponse;

@interface BLUApiManager (Request)

// Send Request
- (RACSignal *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters;
- (RACSignal *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters formDataArray:(NSArray *)formDataArray;

// Send ResponseObject
- (RACSignal *)enqueueRequest:(NSURLRequest *)request;

// Send BLUObject
- (RACSignal *)parsedResponseOfClass:(Class)resultClass fromJSON:(id)responseObject objectKeyPath:(NSString *)objectKeyPath;

// Send BLUResponse
- (RACSignal *)fetchWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath;

- (RACSignal *)fetchWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters formDataArray:(NSArray *)formDataArray resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath;

- (RACSignal *)fetchWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters pagination:(BLUPagination *)pagination resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath;

@end

@interface BLUApiManager (EULA)

+ (NSURL *)eulaURL;
+ (NSURL *)appURL;

@end

@interface BLUApiManager (CookieManager)

- (void)deleteCookieWithKey:(NSString *)key;
- (void)deleteAllCookie;

@end

@interface RACSignal (BLUApiManager)

- (RACSignal *)handleResponse;

@end
