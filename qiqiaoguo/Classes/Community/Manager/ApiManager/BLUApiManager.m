//
//  BLUClient.m
//  Blue
//
//  Created by Bowen on 29/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager.h"
#import "BLUObject.h"
#import "BLUResponse.h"
#import "BLUServer.h"
#import "BLUPagination.h"
#import "BLUUserProfit.h"
#import "BLUUserBalance.h"

NSString * BLUApiErrorDomain = @"BLUApiErrorDomain";
NSString * BLUApiErrorDomainClient = @"BLUApiErrorDomainClient";

NSInteger BLUApiRequestSuccess = 0;

NSInteger BLUApiErrorBaseCode                 = 20000;
NSInteger BLUApiErrorAuthenticationFailed     = 20001;
NSInteger BLUApiErrorRequestForbiddern        = 20002;
NSInteger BLUApiErrorBadRequest               = 20003;
NSInteger BLUApiErrorServiceRequestFailed     = 20004;
NSInteger BLUApiErrorConnectionFailed         = 20005;
NSInteger BLUApiErrorJSONParsingFailed        = 20006;
NSInteger BLUApiErrorWrongRequestFormate      = 20007;



NSInteger BLUApiErrorLoginRequired            = 2;

NSString * BLUApiObjectKeyMsg         = @"msg";
NSString * BLUApiObjectKeyCode        = @"code";
NSString * BLUApiObjectKeyExtra       = @"extra";
NSString * BLUApiObjectKeyItem        = @"extra.item";
NSString * BLUApiObjectKeyItems       = @"extra.items";
NSString * BLUApiObjectKeyUserProfit  = @"extra.wealth";
NSString * BLUApiObjectKeyUserBalance = @"extra.balance";

NSString * BLUApiHttpMethodPost       = @"POST";
NSString * BLUApiHttpMethodDelete     = @"DELETE";
NSString * BLUApiHttpMethodPut        = @"PUT";
NSString * BLUApiHttpMethodGet        = @"GET";

NSString * BLUApiMimeTypeImageJPEG    = @"image/jpeg";
NSString * BLUApiMimeTypeJSON         = @"application/json";
NSString * BLUApiMimeTypePlainText    = @"text/plain";

NSString * BLUApiManagerLoginRequireNotification = @"BLUApiManagerLoginRequireNotification";
NSString * BLUApiManagerUserProfitNotification = @"BLUApiManagerUserProfitNotification";

CGFloat BLUApiImageCompressionQuality = 0.9;

NSInteger BLUApiManagerRequestForbbien = 403;

@interface BLUApiManager ()

@end

@implementation BLUApiManager

#pragma mark - Life Circle

+ (instancetype)sharedManager {
    static BLUApiManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sharedClient = [[BLUApiManager alloc] initWithSessionConfiguration:configuration];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        NSSet *contentTypeSet = _sharedClient.responseSerializer.acceptableContentTypes;
        NSMutableArray *contentTypes = [NSMutableArray arrayWithArray:contentTypeSet.allObjects];
        [contentTypes addObjectsFromArray:@[@"text/html", @"text/plain"]];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithArray:contentTypes];
    });
    
    return _sharedClient;
}

#pragma mark - Request Creation

- (RACSignal *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [self requestWithMethod:method URLString:URLString parameters:parameters formDataArray:nil];
}

- (RACSignal *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters formDataArray:(NSArray *)formDataArray {
    NSParameterAssert(method && URLString);
   
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        
        NSError *error = nil;
        NSMutableURLRequest *request = nil;
        
        
        if (formDataArray.count > 0) {
            
            request = [self.requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                [formDataArray enumerateObjectsUsingBlock:^(BLUFormData *data, NSUInteger idx, BOOL *stop) {
                    if (data.filename) {
                        [formData appendPartWithFileData:data.data name:data.name fileName:data.filename mimeType:data.mimeType];
                    } else {
                        [formData appendPartWithFormData:data.data name:data.name];
                    }
                }];
                
            } error:&error];
            
            if (error) {
                [subscriber sendError:error];
            }

        } else {
            // Post, put需要用Body, JSON格式上传参数
            if ([method isEqualToString:BLUApiHttpMethodPost] || [method isEqualToString:BLUApiHttpMethodPut]) {
                request = [self.requestSerializer requestWithMethod:method URLString:URLString parameters:nil error:&error];
                
                if (error) {
                    [subscriber sendError:error];
                }
                
                if (parameters) {
                    NSData *JSON = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
                    if (error) {
                        [subscriber sendError:error];
                    }
                    request.HTTPBody = JSON;
                }
                
            } else if ([method isEqualToString:BLUApiHttpMethodGet] || [method isEqualToString:BLUApiHttpMethodDelete]) { // 其他的HTTP方法暂时通过这个配置参数
                request = [self.requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:&error];
                
                if (error) {
                    [subscriber sendError:error];
                }
            } else {
                NSError *e = [NSError errorWithDomain:BLUApiErrorDomain code:BLUApiErrorWrongRequestFormate description:@"Wrong request formate" reason:[NSString stringWithFormat:@"Wrong http method = %@", method]];
                [subscriber sendError:e];
            }
        }
//        NSLog(@"request==%@  method ==%@",request,method);
        NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
        if([cookiesdata length]) {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            NSHTTPCookie *cookie;
            for (cookie in cookies) {
                if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
                    [request setHTTPShouldHandleCookies:YES];
                    [request setValue:[NSString stringWithFormat:@"%@=%@", [cookie name], [cookie value]] forHTTPHeaderField:@"Cookie"];
                }
                
            }
        }
        
        
        request.HTTPShouldUsePipelining = YES;
        
        // BAD:糟糕的user agent调整方法
        NSString *userAgent = request.allHTTPHeaderFields[@"User-Agent"];
        NSArray *userAgentStrComponent = [userAgent componentsSeparatedByString:@"/"];
        
        __block NSString *fixedUserAgent = @"qiqiaoguo";
        [userAgentStrComponent enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
            if (idx != 0) {
                fixedUserAgent = [NSString stringWithFormat:@"%@/%@", fixedUserAgent, str];
            }
        }];
        [request setValue:fixedUserAgent forHTTPHeaderField:@"User-Agent"];
//        NSLog(@"%@",request.HTTPBody);
#ifdef BLUApiManagerDebug
        BLULogInfo(@"\nHttp Method ==> %@\nURL ==> %@\nParameters ==> %@\nformDataArray == %@\nheader ==> %@\nbody ==> %@\n", method, URLString, parameters, formDataArray.description, request.allHTTPHeaderFields, [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
#endif
//        NSLog(@"allHTTPHeaderFields==%@",request.allHTTPHeaderFields);
        [subscriber sendNext:request];
        [subscriber sendCompleted];
        
        return nil;
    }];
}

#pragma mark - Request Enqueuing

- (RACSignal *)enqueueRequest:(NSURLRequest *)request {
  
    NSURLRequest *originalRequest = [request copy];
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self dataTaskWithRequest:originalRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            
            if (error) {
                BLULogError(@"\nResponse ==> FAILED WITH %@\nObject ==> %@\nError ==> %@\n",response, responseObject, error);
               
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    if (httpResponse.statusCode == BLUApiManagerRequestForbbien) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:BLUApiManagerLoginRequireNotification object:self];
                        [[BLUAppManager sharedManager] logOut];
                    }
                }
                
                [subscriber sendError:error];
            }


            NSNumber *code;
            NSString *message;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                code = responseObject[BLUApiObjectKeyCode];
                message = responseObject[BLUApiObjectKeyMsg];
            }
#ifdef BLUApiManagerDebug
            BLULogInfo(@"\nresponseObject ==> %@\nResponse => %@\nObject.exist ==> %@\n", responseObject, response, @(responseObject ? YES : NO));
#endif

            [subscriber sendNext:RACTuplePack(response, responseObject, code, message)];
            [subscriber sendCompleted];
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
#ifdef BLUApiManagerDebug
            BLULogInfo(@"disposed");
#endif
            [task cancel];
        }];
        
    }];
  
    return [[signal replayLazily] setNameWithFormat:@"-enqueueRequest: %@", request];
}

#pragma mark - Parsing

- (NSError *)parsingErrorWithFailureReason:(NSString *)localizedFailureReason {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    // TODO: Localize
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Could not parse the service response", @"");
    
    if (localizedFailureReason != nil) {
        userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
    }
    
    NSError *error = [NSError errorWithDomain:BLUApiErrorDomain code:BLUApiErrorWrongRequestFormate userInfo:userInfo];
    BLULogError(@"parse error = %@", error);
    return error;
}

- (RACSignal *)parsedResponseOfClass:(Class)resultClass fromJSON:(id)responseObject objectKeyPath:(NSString *)objectKeyPath {
    
    NSParameterAssert(resultClass || [resultClass isSubclassOfClass:[MTLModel class]]);
    
    responseObject = objectKeyPath ? [responseObject valueForKeyPath:objectKeyPath] : responseObject;
    
    NSMutableArray *parsedResult = [NSMutableArray array];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
#ifdef BLUApiManagerDebug
        BLULogInfo(@"\nParse responseObject.class = %@\nObject key path = %@\n", [responseObject class], objectKeyPath);
#endif

        void (^pareseJSONDictionary)(NSDictionary *) = ^(NSDictionary *JSONDictionary) {
            if (resultClass == nil) {
                [subscriber sendNext:JSONDictionary];
                return;
            }
            
            NSError *error = nil;
            BLUObject *parsedObject = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:JSONDictionary error:&error];
            if (parsedObject == nil) {
                if (![error.domain isEqual:MTLJSONAdapterErrorDomain] || error.code != MTLJSONAdapterErrorNoClassFound) {
                    BLULogDebug(@"\nParse error = %@", error);
                    [subscriber sendError:error];
                }
                
                return;
            }

            NSAssert([parsedObject isKindOfClass:[BLUObject class]], @"Parsed model object is not an OCTObject: %@", parsedObject);
        
            [parsedResult addObject:parsedObject];
        };
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *JSONDictionary in responseObject) {
                if (![JSONDictionary isKindOfClass:[NSDictionary class]]) {
                    // TODO: Localize
                    NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), JSONDictionary];
                    [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
                    return nil;
                }
                pareseJSONDictionary(JSONDictionary);
            }
            [subscriber sendNext:parsedResult];
            
            [subscriber sendCompleted];
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            pareseJSONDictionary(responseObject);
            [subscriber sendNext:parsedResult.lastObject];
            [subscriber sendCompleted];
        } else if (responseObject == nil || responseObject == [NSNull null]) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } else {
            NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Response wasn't an array or dictionary (%@): %@", @""), [responseObject class], responseObject];
            [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
        }
        
        return nil;
        
    }];
}

#pragma mark - Fetch

- (RACSignal *)fetchWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath {
    return [self fetchWithMethod:method URLString:URLString parameters:parameters formDataArray:nil resultClass:resultClass objectKeyPath:objectKeyPath];
}

- (RACSignal *)fetchWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters pagination:(BLUPagination *)pagination resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath {
    NSMutableDictionary *paramDict = [NSMutableDictionary new];
    
    if (parameters) {
        [paramDict addEntriesFromDictionary:parameters];
    }
    
    if (pagination) {
        [pagination configMutableDictionary:paramDict];
    }
    
    if (paramDict.count == 0) {
        paramDict = nil;
    }
    
    return [self fetchWithMethod:method URLString:URLString parameters:paramDict formDataArray:nil resultClass:resultClass objectKeyPath:objectKeyPath];
}

- (RACSignal *)fetchWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters formDataArray:(NSArray *)formDataArray resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath {
    
    RACSignal *fetchSignal = nil;
    RACSignal *requestSignal = nil;
    RACSignal *responseSignal = nil;
    if (formDataArray.count > 0) {
        requestSignal = [self requestWithMethod:method URLString:URLString parameters:parameters formDataArray:formDataArray];
    } else {
        requestSignal = [self requestWithMethod:method URLString:URLString parameters:parameters];
    }
    
    responseSignal = [requestSignal flattenMap:^RACStream *(NSURLRequest *request) {
        return [self enqueueRequest:request];
    }];
    
    __block NSURLResponse *URLResponse = nil;
    __block NSNumber *code = nil;
    __block NSString *message = nil;
    __block NSDictionary *responseObject = nil;
    RACSignal *parsedSignal = nil;
    
    if (resultClass && [resultClass isSubclassOfClass:[MTLModel class]]) {
        parsedSignal = [responseSignal flattenMap:^id(RACTuple *responsePack) {
            RACTupleUnpack(NSURLResponse *response, NSDictionary *paramResponseObject, NSNumber *paramCode, NSString *paramMessage) = responsePack;
            
            URLResponse = response;
            code = paramCode;
            message = paramMessage;
          
            responseObject = paramResponseObject;
            
            return [self parsedResponseOfClass:resultClass fromJSON:responseObject objectKeyPath:objectKeyPath];
        }];
    }
    
    if (parsedSignal) {
        fetchSignal = [parsedSignal map:^id(id object) {
            BLUResponse *response = [BLUResponse new];
            response.object = object;
            response.URLResponse = URLResponse;
            response.JSONDictionary = responseObject;

            if (code) {
                response.code = code.integerValue;
            }
            
            if (message) {
                response.message = message;
            }
            
            return response;
        }];
    } else {
        fetchSignal = [responseSignal map:^id(RACTuple *responsePack) {
            RACTupleUnpack(NSURLResponse *paramResponse, NSDictionary *paramResponseObject, NSNumber *paramCode, NSString *paramMessage) = responsePack;
            BLUResponse *response = [BLUResponse new];
            response.URLResponse = paramResponse;
            response.JSONDictionary = paramResponseObject;

            if (objectKeyPath) {
                response.object = [response.JSONDictionary valueForKeyPath:objectKeyPath];
            } else {
                response.object = nil;
            }

            if (paramCode) {
                response.code = paramCode.integerValue;
            }
            
            if (paramMessage) {
                response.message = paramMessage;
            }
            
            return response;
        }];
    }
    
    return fetchSignal;
}

#pragma mark - Cookie manager

- (void)deleteCookieWithKey:(NSString *)key {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    if (cookieJar != nil) {
        NSArray *cookies = [cookieJar cookies];

        for (NSHTTPCookie *cookie in cookies) {
            if ([[cookie name] isEqualToString:key]) {
                [cookieJar deleteCookie:cookie];
            }
        }
        BLULogInfo(@"Did delete cookie for key = %@", key);
    }
}

- (void)deleteAllCookie {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [cookieJar cookies];
    
    for (NSHTTPCookie *cookie in cookies) {
        [cookieJar deleteCookie:cookie];
    }
    
    BLULogInfo(@"Did delete all cookie");
}

@end

@implementation RACSignal (BLUApiManager)

- (RACSignal *)_handleResponse:(BLUResponse *)response {
    NSParameterAssert(response);

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (response.code != BLUApiRequestSuccess) {
            if (response.code == BLUApiErrorLoginRequired) {
                [[NSNotificationCenter defaultCenter] postNotificationName:BLUApiManagerLoginRequireNotification object:self];
                [[BLUAppManager sharedManager] logOut];
                [subscriber sendCompleted];
            } else {
                NSError *error = [NSError errorWithDomain:BLUApiErrorDomainClient code:response.code description:response.message reason:nil];
                BLULogError(@"Handle response error  = %@", error);
                [subscriber sendError:error];
            }
        } else {
#ifdef BLUApiManagerDebug
            BLULogInfo(@"\nBLUResponse code = %@, message = %@\n", @(response.code), response.message);
            if ([response.object isKindOfClass:[NSArray class]]) {
                NSArray *objects = response.object;
                for (id obj in objects) {
                    BLULogInfo(@"\nobj ==> %@\n", obj);
                }
            } else {
                BLULogInfo(@"\nObject ==> %@\n", response.object);
            }
#endif
//            NSLog(@"JSONDictionary===%@",response.JSONDictionary);
            NSDictionary *profitDict = [response.JSONDictionary valueForKeyPath:BLUApiObjectKeyUserProfit];
           
            if ([profitDict isKindOfClass:[NSDictionary class]]) {
                BLUUserProfit *profit = [MTLJSONAdapter modelOfClass:[BLUUserProfit class] fromJSONDictionary:profitDict error:nil];
                if (profit) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BLUApiManagerUserProfitNotification object:profit];
                }
            }

            NSDictionary *userBalance = [response.JSONDictionary valueForKeyPath:BLUApiObjectKeyUserBalance];
            if ([userBalance isKindOfClass:[NSDictionary class]]) {
                BLUUserBalance *balance = [MTLJSONAdapter modelOfClass:[BLUUserBalance class] fromJSONDictionary:userBalance error:nil];
                if (balance) {
                    [balance checkCoin];
                }
            }
            

            [subscriber sendNext:response.object];
            [subscriber sendCompleted];
        }
        return nil;
    }];

}

- (RACSignal *)handleResponse {
    return [self flattenMap:^RACStream *(BLUResponse *response) {
        return [self _handleResponse:response];
    }];
}

@end

@implementation BLUApiManager (EULA)

+ (NSURL *)eulaURL {
    return [NSURL URLWithString:@"http://www.qiqiaoguo.com/eula.html"];
}

+ (NSURL *)appURL {
//    return [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1039248750"];
    return nil;
}

@end

