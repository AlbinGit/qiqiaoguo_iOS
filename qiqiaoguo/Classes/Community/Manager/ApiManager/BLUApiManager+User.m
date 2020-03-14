//
//  BLUApiManager+User.m
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager+User.h"
#import "BLUApiManager+Circle.h"
#import "BLUApiManager+Post.h"
#import "BLUCoinLog.h"
#import "BLUCoinDailyRule.h"
#import "BLUCoinNewBieRule.h"
#import "BLULevelLog.h"
#import "BLULevelSpec.h"
#import "BLULevelRule.h"
#import "BLUAddress.h"

#define BLUUserApiLogin             (BLUApiString(@"/user/login"))
#define BLUUserApiLogout            (BLUApiString(@"/user/logout"))
#define BLUUserApiReg               (BLUApiString(@"/user/reg"))
#define BLUUserApiUser              (BLUApiString(@"/user/detail"))

#define BLUUserApiFollowing         (BLUApiString(@"/user/followings"))
#define BLUUserApiFollower          (BLUApiString(@"/user/followers"))
#define BLUUserApiFollow            (BLUApiString(@"/user/follow"))

#define BLUUserApiResetPassword     (BLUApiString(@"/user/resetpassword"))
#define BLUUserApiBindMobile        (BLUApiString(@"/user/bound/mobile"))
#define BLUUserApiGetSecurityCode   (BLUApiString(@"/security"))

#define BLUUserApiResetPassword     (BLUApiString(@"/user/resetpassword"))
#define BLUUserApiCircleFollowers   (BLUApiString(@"/circle/followers"))

#define BLUUserApiLikedPostUsers    (BLUApiString(@"/post/likedusers"))

#define BLUUserApiLikedCommentUsers (BLUApiString(@"/post/comment/liked/users"))

#define BLUUserApiThirdPartyLogin   (BLUApiString(@"/partner/login"))

#define BLUUserApiCoinNewBieRules   (BLUApiString(@"/user/get/coin/newhand/rules"))
#define BLUUserApiCoinDailyRules    (BLUApiString(@"/user/get/coin/daily/rules"))
#define BLUUserApiCoinLogs          (BLUApiString(@"/user/get/coin/log"))
#define BLUUserApiExpSpecs          (BLUApiString(@"/user/get/rank/experience"))
#define BLUUserApiExpLogs           (BLUApiString(@"/user/get/experience/log"))
#define BLUUserApiExpRules          (BLUApiString(@"/user/get/experience/rules"))
#define BLUUserApiCheckout          (BLUApiString(@"/user/check"))
#define BLUUserApiAddress           (BLUApiString(@"/user/address"))

#define QGUpdateUserNiackname       (BLUApiString(@"/Phone/User/updateUserName"))
#define QGUpdateUserHeadImage       (BLUApiString(@"/Phone/User/updateUserhead"))

@implementation BLUApiManager (User)

- (RACSignal *)loginWithMobile:(NSString *)mobile password:(NSString *)password {
    NSParameterAssert(mobile);
    NSParameterAssert(password);
    NSDictionary *parameters = @{BLUUserApiKeyMobile: mobile, BLUUserApiKeyPassword: password};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUUserApiLogin parameters:parameters resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)loginWithNickname:(NSString *)nickname avatarURL:(NSURL *)avatarURL gender:(BLUUserGender)gender openID:(NSString *)openID platform:(BLUOpenPlatformTypes)type {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (nickname) {
        parameters[BLUUserApiKeyNickname] = nickname;
    }
    if (avatarURL) {
        parameters[BLUUserApiKeyAvatar] = avatarURL.absoluteString;
    }
    parameters[BLUUserApiKeyGender] = @(gender);
    if (openID) {
        parameters[BLUUserApiKeyOpenID] = openID;
    }
    parameters[BLUUserApiKeyPlatform] = @(type);
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUUserApiThirdPartyLogin parameters:parameters resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)logout {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiLogout parameters:nil resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)fetchUserWithNickname:(NSString *)nickname {
    NSParameterAssert(nickname);
    NSDictionary *parameters = @{BLUUserApiKeyNickname: nickname};
    return [[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiUser parameters:parameters resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItem];
}

- (RACSignal *)fetchUserWithUserID:(NSInteger)userID {
    NSDictionary *parameters = @{BLUUserApiKeyUserID: @(userID),BLUUserPlatformID:[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id]};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiUser parameters:parameters resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)updateUserWithUserInfo:(NSDictionary *)userInfo {
    NSParameterAssert(userInfo);
    NSDictionary *parameters = userInfo;
    return [[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPut URLString:BLUUserApiUser parameters:parameters resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItem];
}

- (RACSignal *)alterUserWithNicname:(NSString *)nickname signature:(NSString *)signature birthday:(NSDate *)birthday marriage:(BLUUserMarriage)marriage avatarImage:(UIImage *)avatarImage {
    NSParameterAssert(nickname || signature || birthday || avatarImage);
    
    BLULogInfo(@"\nNickname ==> %@\nSignature ==> %@\nBirthday ==> %@\nMarriage ==> %@\nAvatarImage ==> %@\n", nickname, signature, birthday, @(marriage), avatarImage);
    
    NSMutableArray *formDataArray = [NSMutableArray new];
   
    if (nickname) {
        BLUFormData *formData = [[BLUFormData alloc] initWithData:[nickname dataUsingEncoding:NSUTF8StringEncoding] name:BLUUserApiKeyNickname filename:nil mimeType:BLUApiMimeTypePlainText];
        [formDataArray addObject:formData];
    }
    
    if (signature) {
        BLUFormData *formData = [[BLUFormData alloc] initWithData:[signature dataUsingEncoding:NSUTF8StringEncoding] name:BLUUserApiKeySignature filename:nil mimeType:BLUApiMimeTypePlainText];
        [formDataArray addObject:formData];
    }
    
    if (birthday) {
        NSString *birthdayStr = [[NSDateFormatter sharedBirthdayDateFormater] stringFromDate:birthday];
        BLUFormData *formData = [[BLUFormData alloc] initWithData:[birthdayStr dataUsingEncoding:NSUTF8StringEncoding] name:BLUUserApiKeyBirthday filename:nil mimeType:BLUApiMimeTypePlainText];
        [formDataArray addObject:formData];
    }
    
    if (avatarImage) {
        NSData *imageData = UIImageJPEGRepresentation(avatarImage, BLUApiImageCompressionQuality);
        NSString *name = @"image0";
        NSString *filename = @"image0.jpg";
        BLUFormData *formData = [[BLUFormData alloc] initWithData:imageData name:name filename:filename mimeType:BLUApiMimeTypeImageJPEG];
        [formDataArray addObject:formData];
    }
    
    NSString *marriageStr = @(marriage).stringValue;
    if (marriageStr) {
        BLUFormData *formData = [[BLUFormData alloc] initWithData:[marriageStr dataUsingEncoding:NSUTF8StringEncoding] name:BLUUserApiKeyMarriage filename:nil mimeType:BLUApiMimeTypePlainText];
        [formDataArray addObject:formData];
    }
    
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUUserApiUser parameters:nil formDataArray:formDataArray resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)updateUserNickname:(NSString *)nickname{
    
    NSMutableArray *formDataArray = [NSMutableArray new];
    
    if (nickname) {
        BLUFormData *formData = [[BLUFormData alloc] initWithData:[nickname dataUsingEncoding:NSUTF8StringEncoding] name:@"uname" filename:nil mimeType:BLUApiMimeTypePlainText];
        [formDataArray addObject:formData];
    }
    BLUUser *user = [BLUAppManager sharedManager].currentUser;
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:QGUpdateUserNiackname parameters:@{@"uid":@(user.userID)} formDataArray:formDataArray resultClass:nil objectKeyPath:nil] handleResponse];
    
}
- (RACSignal *)updateUserHeadimage:(UIImage *)avatarImage{
     NSMutableArray *formDataArray = [NSMutableArray new];
    if (avatarImage) {
        NSData *imageData = UIImageJPEGRepresentation(avatarImage, BLUApiImageCompressionQuality);
        NSString *name = @"image0";
        NSString *filename = @"image0.jpg";
        BLUFormData *formData = [[BLUFormData alloc] initWithData:imageData name:name filename:filename mimeType:BLUApiMimeTypeImageJPEG];
        [formDataArray addObject:formData];
    }
    BLUUser *user = [BLUAppManager sharedManager].currentUser;
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:QGUpdateUserHeadImage parameters:@{@"uid":@(user.userID)} formDataArray:formDataArray resultClass:nil objectKeyPath:BLUApiObjectKeyExtra] handleResponse];
}

- (RACSignal *)followUserWithUserID:(NSInteger)userID {
    NSDictionary *parameters = @{BLUUserApiKeyUserID: @(userID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUUserApiFollow parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)unfollowUserWithUserID:(NSInteger)userID {
    NSDictionary *parameters = @{BLUUserApiKeyUserID: @(userID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodDelete URLString:BLUUserApiFollow parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)regWithMobile:(NSString *)mobile password:(NSString *)password nickname:(NSString *)nickname gender:(BLUUserGender)gender avatarImage:(UIImage *)avatarImage {
    NSParameterAssert(mobile);
    NSParameterAssert(password);
    NSParameterAssert(nickname);
    BLULogInfo(@"\nMobile ==> %@\nPassword ==> %@\nNickname ==> %@\n", mobile, password, nickname);
   
    NSMutableArray *formDatas = [NSMutableArray new];
   
    if (avatarImage) {
        NSData *fileData = UIImageJPEGRepresentation(avatarImage, BLUApiImageCompressionQuality);
        NSString *name = @"image0";
        NSString *filename = @"image0.jpg";
        BLUFormData *formData = [[BLUFormData alloc] initWithData:fileData name:name filename:filename mimeType:BLUApiMimeTypeImageJPEG];
        [formDatas addObject:formData];
    }
    
    NSDictionary *parameters = @{BLUUserApiKeyMobile: mobile, BLUUserApiKeyPassword: password, BLUUserApiKeyNickname: nickname, BLUUserApiKeyGender: @(gender)};
    NSData *JSON = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    BLUFormData *parameterFormData = [[BLUFormData alloc] initWithData:JSON name:@"data" filename:nil mimeType:BLUApiMimeTypeJSON];
    [formDatas addObject:parameterFormData];
    
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUUserApiReg parameters:nil formDataArray:formDatas resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)getSecurityCodeWithMobile:(NSString *)mobile {
    NSParameterAssert(mobile);
    NSDictionary *parameters = @{BLUUserApiKeyMobile: mobile};
    
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiGetSecurityCode parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)getSecurityCodeWithMobile:(NSString *)mobile type:(BLUApiManagerUserSecurityCodeTypes)type {
    NSParameterAssert(mobile);
    NSDictionary *parameters = @{BLUUserApiKeyMobile: mobile, BLUUserApiKeySecurityCode: @(type)};
    
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiGetSecurityCode parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)validateSecurityCodeWithMobile:(NSString *)mobile code:(NSString *)code {
    NSParameterAssert(mobile && code);
    NSDictionary *parameters = @{BLUUserApiKeyMobile: mobile, BLUUserApiKeyCode: code};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUUserApiGetSecurityCode parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)resetPassword:(NSString *)password mobile:(NSString *)mobile code:(NSString *)code {
    NSParameterAssert(mobile);
    NSParameterAssert(password);
    NSParameterAssert(code);
    
    NSDictionary *parameters = @{BLUUserApiKeyMobile: mobile, BLUUserApiKeyPassword: password, BLUUserApiKeyCode: code};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUUserApiResetPassword parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)bindMobile:(NSString *)mobile password:(NSString *)password code:(NSString *)code {
    NSParameterAssert(mobile && password && code);
    NSDictionary *parameters = @{BLUUserApiKeyMobile: mobile, BLUUserApiKeyPassword: password, BLUUserApiKeyCode: code};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUUserApiBindMobile parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)fetchUsersFollowingCircle:(NSInteger)circleID pagination:(BLUPagination *)pagination {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (pagination) {
        [pagination configMutableDictionary:parameters];
    }
    
    [parameters setObject:@(circleID) forKey:BLUCircleApiKeyCircleID];
    
    return [[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiCircleFollowers parameters:parameters resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItems];
}

- (RACSignal *)fetchUsersLikingPost:(NSInteger)postID pagination:(BLUPagination *)pagination {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (pagination) {
        [pagination configMutableDictionary:parameters];
    }
    
    [parameters setObject:@(postID) forKey:BLUPostApiKeyPostID];
    
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiLikedPostUsers parameters:parameters pagination:pagination resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchUsersLikingComment:(NSInteger)commentID pagination:(BLUPagination *)pagination {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (pagination) {
        [pagination configMutableDictionary:parameters];
    }
    
    [parameters setObject:@(commentID) forKey:BLUPostApiKeyPostID];
    
    return [[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUUserApiLikedPostUsers parameters:parameters resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItems];
}

- (RACSignal *)fetchFollowingsForUserID:(NSInteger)userID pagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiFollowing parameters:@{BLUUserApiKeyUserID: @(userID)} pagination:pagination resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchFollowersForUserID:(NSInteger)userID pagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiFollower parameters:@{BLUUserApiKeyUserID: @(userID)} pagination:pagination resultClass:[BLUUser class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchCoinNewbieRulesWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiCoinNewBieRules parameters:nil pagination:pagination resultClass:[BLUCoinNewBieRule class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchCoinDailyRulesWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiCoinDailyRules parameters:nil pagination:pagination resultClass:[BLUCoinDailyRule class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchCoinLogsWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiCoinLogs parameters:nil pagination:pagination resultClass:[BLUCoinLog class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchLevelRulesWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiExpRules parameters:nil pagination:pagination resultClass:[BLULevelRule class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchLevelLogsWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiExpLogs parameters:nil pagination:pagination resultClass:[BLULevelLog class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchLevelSpecsWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUUserApiExpSpecs parameters:nil pagination:pagination resultClass:[BLULevelSpec class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (NSURL *)coinRulesURL {
    return [NSURL URLWithString:@"http://www.blue69.cn/wealth_coin.html"];
}

- (RACSignal *)checkout {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUUserApiCheckout parameters:nil resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)fetchUserAddress {
    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodGet
             URLString:BLUUserApiAddress
             parameters:nil
             resultClass:[BLUAddress class]
             objectKeyPath:BLUApiObjectKeyItem]
            handleResponse];
}

- (RACSignal *)postUserAddress:(BLUAddress *)address {
    NSMutableDictionary *parameters = [NSMutableDictionary new];

    BLUParameterAssert(address.phone);
    BLUParameterAssert(address.contact);
    BLUParameterAssert(address.details);

    NSNumber *emptyDistrict = @(-1);

    parameters[@"province"] = address.provinceID ? address.provinceID : emptyDistrict;
    parameters[@"city"] = address.cityID ? address.cityID : emptyDistrict;
    parameters[@"county"] = address.countyID ? address.countyID : emptyDistrict;

    parameters[@"name"] = address.contact;
    parameters[@"phone"] = address.phone;
    parameters[@"detail"] = address.details;

    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodPost
             URLString:BLUUserApiAddress
             parameters:parameters
             resultClass:nil
             objectKeyPath:nil]
            handleResponse];
}

@end
