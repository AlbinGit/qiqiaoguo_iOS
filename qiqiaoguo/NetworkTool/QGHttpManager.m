//
//  QGHttpManager.m
//  qiqiaoguo
//
//  Created by cws on 16/6/3.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGHttpManager.h"

NSString * QGApiErrorDomain = @"QGApiErrorDomain";
NSString * QGApiErrorDomainClient = @"QGApiErrorDomainClient";

NSInteger QGApiRequestSuccess = 0;

NSInteger QGApiErrorBaseCode                 = 20000;
NSInteger QGApiErrorAuthenticationFailed     = 20001;
NSInteger QGApiErrorRequestForbiddern        = 20002;
NSInteger QGApiErrorBadRequest               = 20003;
NSInteger QGApiErrorServiceRequestFailed     = 20004;
NSInteger QGApiErrorConnectionFailed         = 20005;
NSInteger QGApiErrorJSONParsingFailed        = 20006;
NSInteger QGApiErrorWrongRequestFormate      = 20007;

NSString *  QGApiObjectKeyMsg         = @"msg";
NSString *  QGApiObjectKeyCode        = @"code";
NSString *  QGApiObjectKeyExtra       = @"extra";
NSString *  QGApiObjectKeyItem        = @"extra.item";
NSString *  QGApiObjectKeyItems       = @"extra.items";
NSString *  QGApiObjectKeyUserProfit  = @"extra.wealth";
NSString *  QGApiObjectKeyUserBalance = @"extra.balance";
NSString *  QGApiObjectKeyinfo        = @"extra.info";
NSString *  QGApiObjectKeycontent     = @"content";

@implementation QGHttpManager

+ (instancetype)sharedManager {
    static QGHttpManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sharedClient = [[QGHttpManager alloc] initWithSessionConfiguration:configuration];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        NSSet *contentTypeSet = _sharedClient.responseSerializer.acceptableContentTypes;
        NSMutableArray *contentTypes = [NSMutableArray arrayWithArray:contentTypeSet.allObjects];
        [contentTypes addObjectsFromArray:@[@"text/html", @"text/plain"]];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithArray:contentTypes];
//		_sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];

        // user agent调整
        NSString *userAgent = _sharedClient.requestSerializer.HTTPRequestHeaders[@"User-Agent"];
        NSArray *userAgentStrComponent = [userAgent componentsSeparatedByString:@"/"];
        __block NSString *fixedUserAgent = @"qiqiaoguo";
        [userAgentStrComponent enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
            if (idx != 0) {
                fixedUserAgent = [NSString stringWithFormat:@"%@/%@", fixedUserAgent, str];
            }
        }];
        [_sharedClient.requestSerializer setValue:fixedUserAgent forHTTPHeaderField:@"User-Agent"];
    });
    
    NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
                [_sharedClient.requestSerializer setHTTPShouldHandleCookies:YES];
                NSString *str = [NSString stringWithFormat:@"%@=%@", [cookie name], [cookie value]];
                [_sharedClient.requestSerializer setValue:str forHTTPHeaderField:@"Cookie"];
            }
            
        }
    }
    return _sharedClient;
}

+ (void)GET:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    QGHttpManager *manager = [QGHttpManager sharedManager];

    [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
       responseObject = [manager parsedResponseOfClass:resultClass fromJSON:responseObject objectKeyPath:objectKeyPath];
        NSLog(@"responseObject=== %@",responseObject);
        if ([responseObject isKindOfClass:[NSError class]] && failure) {
            failure(task,responseObject);
            return ;
        }
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

+ (void)POST:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    QGHttpManager *manager = [QGHttpManager sharedManager];
    
    [manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            responseObject = [manager parsedResponseOfClass:resultClass fromJSON:responseObject objectKeyPath:objectKeyPath];
            if ([responseObject isKindOfClass:[NSError class]] && failure) {
                failure(task,responseObject);
                return ;
            }
            if (success) {
                success(task,responseObject);
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)Delegate:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    QGHttpManager *manager = [QGHttpManager sharedManager];
    
    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [manager parsedResponseOfClass:resultClass fromJSON:responseObject objectKeyPath:objectKeyPath];
        if ([responseObject isKindOfClass:[NSError class]] && failure) {
            failure(task,responseObject);
            return ;
        }
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)POST:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    QGHttpManager *manager = [QGHttpManager sharedManager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
            NSData *fileData = UIImageJPEGRepresentation(image, BLUApiImageCompressionQuality);
            NSString *name = @"head";
            NSString *filename = @"image0.jpg";
            NSString *mimeType = @"image/jpeg";
            [formData appendPartWithFileData:fileData name:name fileName:filename mimeType:mimeType];
        }     
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        responseObject = [manager parsedResponseOfClass:resultClass fromJSON:responseObject objectKeyPath:objectKeyPath];
        if ([responseObject isKindOfClass:[NSError class]] && failure) {
            failure(task,responseObject);
            return ;
        }
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}
+ (void)POST:(NSString *)url params:(NSDictionary *)params video:(NSURL *)videoUrl success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    QGHttpManager *manager = [QGHttpManager sharedManager];
	[manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		NSData * fileData = [NSData dataWithContentsOfURL:videoUrl];
		[formData appendPartWithFileData:fileData name:@"video" fileName:@"video.mp4" mimeType:@"application/octet-stream"];
	} progress:^(NSProgress * _Nonnull uploadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject);
        }
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
        }

	}];
}




// 将数据转化成模型
- (id)parsedResponseOfClass:(Class)resultClass fromJSON:(id)responseObject objectKeyPath:(NSString *)objectKeyPath
{
//    NSParameterAssert(resultClass || [resultClass isSubclassOfClass:[MTLModel class]]);
    // code返回0表示成功
    if ([responseObject[@"code"] integerValue] == 2){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QGApiManagerLoginRequireNotification" object:self];
        [[BLUAppManager sharedManager] logOut];
        [SAUserDefaults removeWithKey:USERDEFAULTS_COOKIE];
        
        NSError *error = [NSError errorWithDomain:QGApiErrorDomain code:[responseObject[@"code"] integerValue] description:responseObject[@"msg"] reason:nil];
        return error;

    }else if ([responseObject[@"code"] integerValue] != 0) {
        
        NSError *error = [NSError errorWithDomain:QGApiErrorDomain code:[responseObject[@"code"] integerValue] description:responseObject[@"msg"] reason:nil];
        return error;
    }

    responseObject = objectKeyPath ? [responseObject valueForKeyPath:objectKeyPath] : responseObject;
    NSMutableArray *parsedResult = [NSMutableArray array];

    if (resultClass == nil) {
        return responseObject;
    }
    
    if ([responseObject isKindOfClass:[NSArray class]]) {
        for (NSDictionary *JSONDictionary in responseObject) {
            if (![JSONDictionary isKindOfClass:[NSDictionary class]]) {
                // TODO: Localize
                NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), JSONDictionary];
                return [self parsingErrorWithFailureReason:failureReason];
            }
            
            NSError *error = nil;
            MTLModel *parsedObject = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:JSONDictionary error:&error];
            if (parsedObject == nil) {
                if (![error.domain isEqual:MTLJSONAdapterErrorDomain] || error.code != MTLJSONAdapterErrorNoClassFound) {
                    return error;
                }
            }
            NSAssert([parsedObject isKindOfClass:[MTLModel class]], @"Parsed model object is not an OCTObject: %@", parsedObject);
            [parsedResult addObject:parsedObject];
        }
        return parsedResult;
    }
    else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        MTLModel *parsedObject = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:responseObject error:&error];
        if (parsedObject == nil) {
            if (![error.domain isEqual:MTLJSONAdapterErrorDomain] || error.code != MTLJSONAdapterErrorNoClassFound) {
                //                QGLogDebug(@"\nParse error = %@", error);
                return error;
            }
        }
        NSAssert([parsedObject isKindOfClass:[MTLModel class]], @"Parsed model object is not an OCTObject: %@", parsedObject);
        [parsedResult addObject:parsedObject];
        return parsedObject;
    }
    else if (responseObject == nil || responseObject == [NSNull null]) {
        return nil;
    }
    else {
        NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Response wasn't an array or dictionary (%@): %@", @""), [responseObject class], responseObject];
        return [self parsingErrorWithFailureReason:failureReason];
    }


    return nil;
}


- (NSError *)parsingErrorWithFailureReason:(NSString *)localizedFailureReason {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    // TODO: Localize
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Could not parse the service response", @"");
    
    if (localizedFailureReason != nil) {
        userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
    }

    NSError *error = [NSError errorWithDomain:QGApiErrorDomain code:QGApiErrorWrongRequestFormate userInfo:userInfo];
//    QGLogError(@"parse error = %@", error);
    return error;
}





#pragma mark 第二种
//第一层封装afnetworking
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    QGHttpManager *manager = [QGHttpManager sharedManager];
    [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
           NSLog(@"params = %@ ",params);

        
        if (success) {
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            if ([responseObject[@"code"] integerValue] == 2) {
                NSLog(@"responseObject = %@ ",responseObject);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QGApiManagerLoginRequireNotification" object:self];
                [[BLUAppManager sharedManager] logOut];
                [SAUserDefaults removeWithKey:USERDEFAULTS_COOKIE];
                failure([responseObject objectForKey:@"msg"]);
                     }
             if ([responseObject[@"code"] integerValue] !=0) {
                failure([responseObject objectForKey:@"msg"]);
             }
                success(responseObject);
            }else {
            
            if (failure) {
                
               failure([responseObject objectForKey:@"msg"]);
             }

            

        }
             [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        if (failure) {
          
            failure (error);
           }
    }];
    
}



+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    QGHttpManager *manager = [QGHttpManager sharedManager];
   
    [manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        
        NSLog(@"responseObject = %@ ",responseObject);
     
        
      //  if ([[responseObject objectForKey:@"msg"] isEqualToString:@"success"]) {
            
            if (success) {
                [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
                if ([responseObject[@"code"] integerValue] == 2) {
                    NSLog(@"responseObject = %@ ",responseObject);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"QGApiManagerLoginRequireNotification" object:self];
                    [[BLUAppManager sharedManager] logOut];
                    [SAUserDefaults removeWithKey:USERDEFAULTS_COOKIE];
                    failure([responseObject objectForKey:@"msg"]);
                }
                if ([responseObject[@"code"] integerValue] !=0) {
                    failure([responseObject objectForKey:@"msg"]);
                }
                success(responseObject);
            }else {
                
                if (failure) {
                    
                    failure([responseObject objectForKey:@"msg"]);
                }
                
                
            }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            failure(error);
          
        
        }
    }];
    
}


#pragma mark 封装MJExtension
+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *params = [param mj_keyValues];
    
    
    
    [self get:url params:params success:^(id responseObj) {
        if (success) {
            
            id result = [resultClass mj_objectWithKeyValues:responseObj[@"extra"]];
//           NSLog(@"result== %@   path==%@,",responseObj,url);
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
			
            success(result);
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
             [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
    }];
}




+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *params = [param mj_keyValues];
    
    [self post:url params:params success:^(id responseObj) {
        if (success) {
            id result = [resultClass mj_objectWithKeyValues:responseObj[@"extra"]];
            
//             NSLog(@"responseObj = %@  path= %@",responseObj,url);
            success(result);
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
           [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        }
    }];
}

//登录
// 登录成功后设置cookies
+ (void)setCookiesWithUrl:(NSString *)url
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [SAUserDefaults saveValue:data forKey:USERDEFAULTS_COOKIE];
}


@end

