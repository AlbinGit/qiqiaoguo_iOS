//
//  BLUApiManager+User.h
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager.h"

static NSString * const BLUUserApiKeyMobile        = @"mobile";
static NSString * const BLUUserApiKeyPassword      = @"password";
static NSString * const BLUUserApiKeyNickname      = @"nickname";
static NSString * const BLUUserApiKeyEmail         = @"email";
static NSString * const BLUUserApiKeyBirthday      = @"birthday";
static NSString * const BLUUserApiKeySignature     = @"signature";
static NSString * const BLUUserApiKeyAvatar        = @"avatar";
static NSString * const BLUUserApiKeyLocation      = @"location";
static NSString * const BLUUserApiKeyGender        = @"gender";
static NSString * const BLUUserApiKeyMarriage      = @"marriage";
static NSString * const BLUUserApiKeyUserID        = @"user_id";
static NSString * const BLUUserApiKeyCode          = @"security_code";
static NSString * const BLUUserApiKeyOpenID        = @"partner_id";
static NSString * const BLUUserApiKeyPlatform      = @"platform";
static NSString * const BLUUserApiKeySecurityCode  = @"type";
static NSString * const BLUUserPlatformID          = @"platform_id";

typedef NS_ENUM(NSInteger, BLUApiManagerUserSecurityCodeTypes) {
    BLUApiManagerUserSecurityCodeTypeReg = 1,
    BLUApiManagerUserSecurityCodeTypeResetPassword,
    BLUApiManagerUserSecurityCodeTypeBindMobile,
};

@class BLUAddress;

@interface BLUApiManager (User)

- (RACSignal *)loginWithMobile:(NSString *)mobile
                      password:(NSString *)password;

- (RACSignal *)loginWithNickname:(NSString *)nickname avatarURL:(NSURL *)avatarURL gender:(BLUUserGender)gender openID:(NSString *)openID platform:(BLUOpenPlatformTypes)type;

- (RACSignal *)logout;

- (RACSignal *)regWithMobile:(NSString *)mobile password:(NSString *)password nickname:(NSString *)nickname gender:(BLUUserGender)gender avatarImage:(UIImage *)avatarImage;

- (RACSignal *)fetchUserWithNickname:(NSString *)nickname;
- (RACSignal *)fetchUserWithUserID:(NSInteger)userID;
- (RACSignal *)updateUserWithUserInfo:(NSDictionary *)userInfo; // Cookie
- (RACSignal *)alterUserWithNicname:(NSString *)nickname signature:(NSString *)signature birthday:(NSDate *)birthday marriage:(BLUUserMarriage)marriage avatarImage:(UIImage *)avatarImage;

- (RACSignal *)followUserWithUserID:(NSInteger)userID;
- (RACSignal *)unfollowUserWithUserID:(NSInteger)userID;

- (RACSignal *)getSecurityCodeWithMobile:(NSString *)mobile;
- (RACSignal *)getSecurityCodeWithMobile:(NSString *)mobile type:(BLUApiManagerUserSecurityCodeTypes)type;
- (RACSignal *)validateSecurityCodeWithMobile:(NSString *)mobile code:(NSString *)code;
- (RACSignal *)resetPassword:(NSString *)password mobile:(NSString *)mobile code:(NSString *)code;
- (RACSignal *)bindMobile:(NSString *)mobile password:(NSString *)password code:(NSString *)code;

- (RACSignal *)fetchUsersFollowingCircle:(NSInteger)circleID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchUsersLikingPost:(NSInteger)postID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchUsersLikingComment:(NSInteger)commentID pagination:(BLUPagination *)pagination;

- (RACSignal *)fetchFollowingsForUserID:(NSInteger)userID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchFollowersForUserID:(NSInteger)userID pagination:(BLUPagination *)pagination;

- (RACSignal *)fetchCoinNewbieRulesWithPagination:(BLUPagination *)pagination;
- (RACSignal *)fetchCoinDailyRulesWithPagination:(BLUPagination *)pagination;
- (RACSignal *)fetchCoinLogsWithPagination:(BLUPagination *)pagination;

- (RACSignal *)fetchLevelRulesWithPagination:(BLUPagination *)pagination;
- (RACSignal *)fetchLevelLogsWithPagination:(BLUPagination *)pagination;
- (RACSignal *)fetchLevelSpecsWithPagination:(BLUPagination *)pagination;

- (RACSignal *)updateUserNickname:(NSString *)nickname;
- (RACSignal *)updateUserHeadimage:(UIImage *)avatarImage;

- (RACSignal *)checkout;

- (NSURL *)coinRulesURL;

- (RACSignal *)fetchUserAddress;
- (RACSignal *)postUserAddress:(BLUAddress *)address;

@end
