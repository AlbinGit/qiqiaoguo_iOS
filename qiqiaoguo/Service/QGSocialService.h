//
//  QGSocialService.h
//  qiqiaoguo
//
//  Created by cws on 16/6/16.
//
//

#import <Foundation/Foundation.h>
#import "BLUShareObjectHeader.h"

UIKIT_EXTERN NSString * kUMSocialAppKey;
UIKIT_EXTERN NSString * kWechatAppID;

@class UMSocialAccountEntity;
@interface QGSocialService : NSObject

+ (void)config;

@property (nonatomic, strong, readonly) UMSocialAccountEntity *wechatSocialAccount;
@property (nonatomic, strong, readonly) UMSocialAccountEntity *qqSocialAccount;
@property (nonatomic, strong, readonly) UMSocialAccountEntity *sinaSocialAccount;

#pragma mark - Share

+ (RACSignal *)postShareContentWithType:(BLUShareType)shareType
title:(NSString *)title
content:(NSString *)content
image:(UIImage *)image
jumpsURL:(NSString *)jumpsURL
location:(CLLocation *)location
resourceURL:(NSURL *)URL
resourceType:(BLUShareResourceType)resourceType
presentedController:(UIViewController *)viewController;

+ (BOOL)handleOpenURL:(NSURL *)URL;

#pragma mark - Login

+ (void)thirdPartyLoginformType:(BLUOpenPlatformTypes)type inViewController:(UIViewController *)viewController;

+ (RACSignal *)authWithPlatformType:(BLUOpenPlatformTypes)type inViewController:(UIViewController *)viewController;

+ (RACSignal *)requestSnsInfomationWithPlatformType:(BLUOpenPlatformTypes)type;

+ (RACSignal *)loginWithPlatformType:(BLUOpenPlatformTypes)type inViewController:(UIViewController *)viewController;

+ (BOOL)isSupportWX;
+ (BOOL)isSupportQQ;
+ (BOOL)isSupportSina;


@end

