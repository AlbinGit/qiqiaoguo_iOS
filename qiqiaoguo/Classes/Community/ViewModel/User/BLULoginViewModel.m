//
//  BLULoginViewModel.m
//  Blue
//
//  Created by Bowen on 24/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLULoginViewModel.h"
#import "BLUApiManager+User.h"
#import "BLUApiManager+Others.h"
#import "BLUAppManager.h"
#import "BLUWechatUserInfo.h"
#import "BLUApService.h"
#import "QGSocialService.h"

@implementation BLULoginViewModel

- (RACCommand *)login {
    return [[RACCommand alloc] initWithEnabled:[self _validate] signalBlock:^RACSignal *(id input) {
        return [[[BLUApiManager sharedManager] loginWithMobile:self.mobile password:self.password] doNext:^(BLUUser *user) {
            BLUAppManager *appManager = [BLUAppManager sharedManager];
            appManager.currentUser = user;
            [[BLUApService sharedService] uploadRegistrationID];
        }];
    }];
}

- (RACCommand *)wechatLogin {
    return [self makeThirdPartyLoginCommand:BLUOpenPlatformTypeWechat];
}

//- (RACCommand *)qqLogin {
//    return [self makeThirdPartyLoginCommand:BLUOpenPlatformTypeQQ];
//}
//
//- (RACCommand *)sinaLogin {
//    return [self makeThirdPartyLoginCommand:BLUOpenPlatformTypeSina];
//}

- (RACSignal *)validateThirdPartyLogin {
    return [RACSignal return:@(YES)];
}

- (RACCommand *)makeThirdPartyLoginCommand:(BLUOpenPlatformTypes)type {
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:[self validateThirdPartyLogin] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self makeThirdPartyLoginSignalWithPlatformType:type] doNext:^(BLUUser *user) {
            BLUAppManager *appManager = [BLUAppManager sharedManager];
            appManager.currentUser = user;
            [[BLUApService sharedService] uploadRegistrationID];
            BLULogDebug(@"user = %@", user);
        }];
    }];
}

- (RACSignal *)makeThirdPartyLoginSignalWithPlatformType:(BLUOpenPlatformTypes)type {
    return [[QGSocialService loginWithPlatformType:type inViewController:nil] flattenMap:^RACStream *(BLUUser *user) {
        if (type == BLUOpenPlatformTypeWechat) {
            return [[[BLUApiManager sharedManager] fetchWechatUserInfoWithAccessToken:user.accessToken openID:user.openID] flattenMap:^RACStream *(BLUWechatUserInfo *userInfo) {
                BLUUserGender gender = userInfo.sex == 1 ? BLUUserGenderMale : BLUUserGenderFemale;
                return [[BLUApiManager sharedManager]
                        loginWithNickname:userInfo.nickname
                        avatarURL:[NSURL URLWithString:userInfo.avatarURLString]
                        gender:gender
                        openID:userInfo.unionID
                        platform:BLUOpenPlatformTypeWechat];
            }];
        } else {
            return [[BLUApiManager sharedManager]
                    loginWithNickname:user.nickname
                    avatarURL:user.avatar.originURL
                    gender:user.gender
                    openID:user.openID
                    platform:user.openPlatformType];
        }
    }];
}

- (RACSignal *)_validate {
    return [[RACSignal combineLatest:@[[BLUUser validateMobile:RACObserve(self, mobile)], [BLUUser validatePassword:RACObserve(self, password)]]] reduceEach:^id(NSNumber *isUser, NSNumber *isPassword) {
        return @(isUser.boolValue && isPassword.boolValue);
    }];
}

@end
