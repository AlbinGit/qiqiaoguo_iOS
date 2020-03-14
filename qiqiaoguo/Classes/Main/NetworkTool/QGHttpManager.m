//
//  QGHttpManager.m
//  qiqiaoguo
//
//  Created by cws on 16/6/3.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGHttpManager.h"
#import "QGModel.h"

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
    });
    
    return _sharedClient;
}

+ (void)GET:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass objectKeyPath:(NSString *)objectKeyPath success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    QGHttpManager *manager = [QGHttpManager sharedManager];
    [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",url);
       responseObject = [manager parsedResponseOfClass:resultClass fromJSON:responseObject objectKeyPath:objectKeyPath];
        
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
    [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        responseObject = [manager parsedResponseOfClass:resultClass fromJSON:responseObject objectKeyPath:objectKeyPath];
        
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




- (id)parsedResponseOfClass:(Class)resultClass fromJSON:(id)responseObject objectKeyPath:(NSString *)objectKeyPath
{
//    NSParameterAssert(resultClass || [resultClass isSubclassOfClass:[MTLModel class]]);
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
            QGModel *parsedObject = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:JSONDictionary error:&error];
            if (parsedObject == nil) {
                if (![error.domain isEqual:MTLJSONAdapterErrorDomain] || error.code != MTLJSONAdapterErrorNoClassFound) {
                    return error;
                }
            }
            NSAssert([parsedObject isKindOfClass:[QGModel class]], @"Parsed model object is not an OCTObject: %@", parsedObject);
            [parsedResult addObject:parsedObject];
        }
        return parsedResult;
    }
    else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        QGModel *parsedObject = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:responseObject error:&error];
        if (parsedObject == nil) {
            if (![error.domain isEqual:MTLJSONAdapterErrorDomain] || error.code != MTLJSONAdapterErrorNoClassFound) {
                //                QGLogDebug(@"\nParse error = %@", error);
                return error;
            }
        }
        NSAssert([parsedObject isKindOfClass:[QGModel class]], @"Parsed model object is not an OCTObject: %@", parsedObject);
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

@end
@implementation QGHttpManager (Home)

+ (void)fetchHomeSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    
    NSDictionary *parameters = @{@"sid": GETSID,@"user_id":GETUID};
    
    [self GET:nil params:parameters resultClass:nil objectKeyPath:QGApiObjectKeyCode success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
}


@end
