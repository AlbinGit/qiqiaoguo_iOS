//
//  BLUApiManager+Others.m
//  Blue
//
//  Created by Bowen on 17/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager+Others.h"
#import "BLUVersion.h"
#import "BLUWechatUserInfo.h"
#import "BLUAPSetting.h"
#import "BLURecommend.h"
#import "BLUServerNotification.h"

#define BLUApiCheckoutVersion       (BLUApiString(@"/client"))
#define BLUApiWechatUserInfo        @"https://api.weixin.qq.com/sns/userinfo"
#define BLUApiPostRegistrationID    (BLUApiString(@"/device"))
#define BLUApiAPSetting             (BLUApiString(@"/user/push/setting")) // get post
#define BLUApiRecommended           (BLUApiString(@"/v2/recommended"))
#define BLUApiServerNotification    (BLUApiString(@"/Phone/Message/getNotificationList"))
#define BLUApiReport                (BLUApiString(@"/user/report"))
#define BLUApiUploadImage           (BLUApiString(@"/image"))
#define BLUApiCustomerService       (BLUApiString(@"/customer/id"))

@implementation BLUApiManager (Others)

- (RACSignal *)checkoutVersion {
    NSDictionary *parameters = @{BLUVersionKeyType: @"ios"};
   return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUApiCheckoutVersion parameters:parameters resultClass:[BLUVersion class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)fetchWechatUserInfoWithAccessToken:(NSString *)accessToken
                                           openID:(NSString *)openID {
    static NSString * const BLUWechatApiAccessTokenKey = @"access_token";
    static NSString * const BLUWechatApiOpenIDKey = @"openid";
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (accessToken) {
        parameters[BLUWechatApiAccessTokenKey] = accessToken;
    }
    if (openID) {
        parameters[BLUWechatApiOpenIDKey] = openID;
    }
    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodGet
             URLString:BLUApiWechatUserInfo
             parameters:parameters
             resultClass:[BLUWechatUserInfo class]
             objectKeyPath:nil]
            handleResponse];
}

- (RACSignal *)postRegistrationID:(NSString *)registrationID {
    static NSString * const BLUAPNRegistrationID = @"registration_id";
    NSDictionary *parameters = @{BLUAPNRegistrationID: registrationID};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUApiPostRegistrationID parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)fetchAPSetting {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUApiAPSetting parameters:nil resultClass:[BLUAPSetting class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)postAPSetting:(BLUAPSetting *)setting {
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:setting error:nil];
    BLULogDebug(@"parameters = %@", parameters);
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUApiAPSetting parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)fetchRecommended {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUApiRecommended parameters:nil resultClass:[BLURecommend class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchRecommendedWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUApiRecommended parameters:nil pagination:pagination resultClass:[BLURecommend class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchServerNoticationWithPagination:(BLUPagination *)pagination {
    
    NSMutableDictionary *paramers =nil;
    if (PLATFORMID) {
        [paramers setValue:PLATFORMID forKey:@"platform_id"];
    }
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUApiServerNotification parameters:paramers pagination:pagination resultClass:[BLUServerNotification class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)reportForObjectID:(NSInteger)objectID sourceType:(NSInteger)sourceType reasonType:(NSInteger)reasonType reason:(NSString *)reason {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUApiReport parameters:@{@"id": @(objectID), @"report_type": @(sourceType), @"reason_type": @(reasonType)} resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)uploadImageReses:(NSArray *)imageReses {
    NSParameterAssert(imageReses.count > 0);
    NSMutableArray *formDataArray = [NSMutableArray new];

    [imageReses enumerateObjectsUsingBlock:^(BLUImageRes *imageRes, NSUInteger idx, BOOL * _Nonnull stop) {
        NSParameterAssert([imageRes isKindOfClass:[BLUImageRes class]]);
        NSData *fileData = UIImageJPEGRepresentation(imageRes.image, BLUApiImageCompressionQuality);
        if (fileData) {
            NSString *name = imageRes.name;
            NSString *filename = [NSString stringWithFormat:@"%@.jpg", imageRes.name];
            BLUFormData *formData = [[BLUFormData alloc] initWithData:fileData
                                                                 name:name
                                                             filename:filename
                                                             mimeType:BLUApiMimeTypeImageJPEG];
            [formDataArray addObject:formData];
        }
    }];

    if (formDataArray.count > 0) {
        return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUApiUploadImage parameters:nil formDataArray:formDataArray resultClass:[BLUImageRes class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
    } else {
        return [RACSignal empty];
    }
}

- (RACSignal *)fetchCustomerService {
    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodGet
             URLString:BLUApiCustomerService
             parameters:nil
             resultClass:nil
             objectKeyPath:BLUApiObjectKeyItem]
            handleResponse];
}

@end
