//
//  BLUSocialService.h
//  Blue
//
//  Created by Bowen on 20/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BLUService.h"
#import "BLUUser.h"
#import "BLUShareObjectHeader.h"

@class UMSocialAccountEntity;

@interface BLUSocialService : BLUService

+ (void)config;

//@property (nonatomic, strong, readonly) UMSocialAccountEntity *wechatSocialAccount;
//@property (nonatomic, strong, readonly) UMSocialAccountEntity *qqSocialAccount;
//@property (nonatomic, strong, readonly) UMSocialAccountEntity *sinaSocialAccount;

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

+ (RACSignal *)authWithPlatformType:(BLUOpenPlatformTypes)type inViewController:(UIViewController *)viewController;

+ (RACSignal *)requestSnsInfomationWithPlatformType:(BLUOpenPlatformTypes)type;

+ (RACSignal *)loginWithPlatformType:(BLUOpenPlatformTypes)type inViewController:(UIViewController *)viewController;

+ (BOOL)isSupportWX;
//+ (BOOL)isSupportQQ;
//+ (BOOL)isSupportSina;

@end
