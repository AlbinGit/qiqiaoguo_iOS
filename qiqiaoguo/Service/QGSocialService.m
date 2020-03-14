//
//  QGSocialService.m
//  qiqiaoguo
//
//  Created by cws on 16/6/16.
//
//

#import "QGSocialService.h"
#import "UMSocial.h"
#import "UMSocialData.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialConfig.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "BLUWXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "QGLoginUser.h"
#import "BLUUser.h"
#import "QGLoginViewController.h"

// TODO: 设置各类ID
NSString * kUMSocialAppKey = @"5729a4bc67e58eed120007fa";  // 正式的友盟ID

NSString * kWechatAppID = @"wx4663f0a434546015";
static NSString * const kWechatAppSecret = @"42f3ab04c89c670f540680bb89f4ba07";
static NSString * const kWechatRedirectURL = @"http://www.umeng.com/social";

static NSString * const kSinaAppKey = @"1796865126";
static NSString * const kSinaAppSecret = @"6a9a5812fc040b58185310ab5c32b207";
static NSString * const kSinaRedirectURL = @"https://api.weibo.com/oauth2/default.html";

//static NSString * const kOfficeSinalWeibo = @"http://weibo.com/p/1006065646806927";

static NSString * const kQQAppID = @"1105068412";
static NSString * const kQQAppKey = @"jltetc46MchvuQ28";
static NSString * const kQQRedirectURL = @"http://www.umeng.com/social";

@implementation QGSocialService

+ (void)config {
    // 设置友盟社会化组件appkey
    [UMSocialData setAppKey:kUMSocialAppKey];
    
    // TODO: 需要配置微信，新浪，QQ的URL scheme
    
    // 设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kWechatAppID appSecret:kWechatAppSecret url:kWechatRedirectURL];
    
    // 设置新浪RedirectURL
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppKey secret:kSinaAppSecret RedirectURL:kSinaRedirectURL];
    
    // 设置关注官方微博
//    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina: kOfficeSinalWeibo}];
    
    // 设置QQ App id，app key，url
    [UMSocialQQHandler setQQWithAppId:kQQAppID appKey:kQQAppKey url:kQQRedirectURL];
    
#ifdef QGDEBUG
    [UMSocialData openLog:YES];
#endif
}


+ (BOOL)handleOpenURL:(NSURL *)URL {
    
    NSString *host = [URL host];
    NSString *scheme = [URL scheme];
    
    if ([scheme hasPrefix:@"wx"] && [host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:URL
                           delegate:[BLUWXApiManager sharedManager]];
    } else if ([host isEqualToString:@"safepay"]){
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:URL
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@",resultDic);
         }];
        return YES;
    } else {
        return [UMSocialSnsService handleOpenURL:URL];
    }
    
}

// 第三方分享
+ (RACSignal *)postShareContentWithType:(BLUShareType)shareType
                                  title:(NSString *)title
                                content:(NSString *)content
                                  image:(UIImage *)image
                               jumpsURL:(NSString *)jumpsURL
                               location:(CLLocation *)location
                            resourceURL:(NSURL *)URL
                           resourceType:(BLUShareResourceType)resourceType
                    presentedController:(UIViewController *)viewController {
    
    // 不能没有Content
    NSParameterAssert(content);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *snsType = nil;
        
        UMSocialUrlResourceType type = UMSocialUrlResourceTypeDefault;
        
        switch (resourceType) {
            case BLUShareResourceTypeImage: {
                type = UMSocialUrlResourceTypeImage;
            } break;
            case BLUShareResourceTypeVideo: {
                type = UMSocialUrlResourceTypeVideo;
            } break;
            case BLUShareResourceTypeMusic: {
                type = UMSocialUrlResourceTypeMusic;
            } break;
            default: {
                type = UMSocialUrlResourceTypeDefault;
            } break;
        }
        
        switch (shareType) {
            case BLUShareTypeSina: {
                snsType = UMShareToSina;
            } break;
            case BLUShareTypeWechatSession: {
                snsType = UMShareToWechatSession;
            } break;
            case BLUShareTypeWechatFavorite: {
                snsType = UMShareToWechatFavorite;
            } break;
            case BLUShareTypeWechatTimeline: {
                snsType = UMShareToWechatTimeline;
            } break;
            case BLUShareTypeQQSession: {
                snsType = UMShareToQQ;
            } break;
            case BLUShareTypeQZone: {
                snsType = UMShareToQzone;
            } break;
            default: {
                snsType = nil;
            } break;
        }
        
        if (title) {
            [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
            [UMSocialData defaultData].extConfig.qqData.title = title;
            [UMSocialData defaultData].extConfig.qzoneData.title = title;
            [UMSocialData defaultData].extConfig.sinaData.shareText =
            [NSString stringWithFormat:@"%@%@", title, jumpsURL];
        }
        
        if (jumpsURL) {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = jumpsURL;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = jumpsURL;
            [UMSocialData defaultData].extConfig.qqData.url = jumpsURL;
            [UMSocialData defaultData].extConfig.qzoneData.url = jumpsURL;
        }
        
        if (URL) {
            [UMSocialData defaultData].urlResource =
            [[UMSocialUrlResource alloc] initWithSnsResourceType:type
                                                             url:URL.absoluteString];
        }
        
        [[UMSocialDataService defaultDataService]
         postSNSWithTypes:@[snsType]
         content:content
         image:image
         location:location
         urlResource:nil
         presentedController:viewController
         completion:^(UMSocialResponseEntity *response) {
             if (response.responseCode == UMSResponseCodeSuccess) {
                 BLULogInfo(@"share success response = %@", response);
                 [subscriber sendCompleted];
             } else if (response.responseCode != UMSResponseCodeCancel){
                 BLULogInfo(@"share failed response = %@", response);
                 [subscriber sendError:response.error];
             }
         }];
        
        return nil;
    }];
}

// 第三方登录
+ (void)thirdPartyLoginformType:(BLUOpenPlatformTypes)type inViewController:(UIViewController *)viewController{
    UMSocialSnsPlatform *snsPlatform = nil;
    switch (type) {
        case BLUOpenPlatformTypeWechat: {
            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        } break;
        case BLUOpenPlatformTypeQQ: {
            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        } break;
        case BLUOpenPlatformTypeSina: {
            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        } break;
        default: {
            snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        } break;
    }
    snsPlatform.loginClickHandler(viewController ,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSDictionary *dic =@{@"data":response.data,@"thirdPlatformUserProfile":response.thirdPlatformUserProfile};
            BLUUser *user = [[BLUUser alloc]initWithSnsInfo:dic platformType:type];
            [BLUAppManager sharedManager].currentUser = user;
        } else {
            
        }
        if (response.responseCode == UMSResponseCodeSuccess){
            QGLoginViewController *loginVC = (QGLoginViewController *)viewController;
            [loginVC thirdPartyLogin];
        }
        
    });
}

+ (BOOL)isSupportWX {
    return [WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled];
}

+ (BOOL)isSupportQQ {
    return [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi];
}

+ (BOOL)isSupportSina {
    return [WeiboSDK isCanSSOInWeiboApp] && [WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP];
}

@end

