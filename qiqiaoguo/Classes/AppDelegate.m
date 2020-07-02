//
//  AppDelegate.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/23.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "AppDelegate.h"
#import "QGTabBarViewController.h"
#import "QGAnalyticsService.h"
#import "QGJpushService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "QGSocialService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JPUSHService.h"
#import "QGNewFeatureViewController.h"
#import "QGSaveService.h"
#import "QGHttpManager+User.h"
#import "BLUAppManager.h"
#import "QGAdvertisingView.h"
#import "QGVideoChatViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()

@property (nonatomic, strong)QGAdvertisingView *adView;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    [NSThread sleepForTimeInterval:1.0];
    application.statusBarHidden = NO;
    NSString *curVersion =  [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *oldVersion = [QGSaveService objectForKey:USERDEFAULTS_Version];
    if ([curVersion isEqualToString:oldVersion] == NO) {
        [QGSaveService setObject:curVersion forKey:USERDEFAULTS_Version];
        
         self.window.rootViewController =[[QGNewFeatureViewController alloc] init];
        
    }else{ // 没有最新的版本号
        // 进入主框架界面
        self.window.rootViewController =[[QGTabBarViewController alloc] init];
        
    }
	//直接进入视频
//	QGVideoChatViewController * videoVC = [[QGVideoChatViewController alloc]init];
//	UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:videoVC];
//	self.window.rootViewController = nav;

//    [self showAdvertisingPage];

    
	
	if (@available(iOS 11.0, *)) {
		UITableView.appearance.estimatedRowHeight = 0;
		UITableView.appearance.estimatedSectionFooterHeight = 0;
		UITableView.appearance.estimatedSectionHeaderHeight = 0;
	}
	
    //向微信注册
    [WXApi registerApp:kWXAppId withDescription:@"qiqiaoguo"];
  //  [self OpenNetworkMonitored];// 开启网络监控
    [[QGJpushService sharedService] configWithLaunchOptions:launchOptions]; // 极光推送
    [self configCircle];        // 设置社区的一些东西
    [self configSocialService]; // 友盟设置
    [QGAnalyticsService config];// 开启友盟统计
    [self setIQKeyBoard];
    self.didResignActive = NO;
    NSDictionary *userInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    self.launchWithNotification = NO;
    if (userInfo) {
        self.launchWithNotification = YES;
    } else {
        self.launchWithNotification = NO;
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[QGJpushService sharedService] registerDeviceToken:deviceToken];
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    self.didResignActive = YES;
    [self handleNotificationWithUserInfo:userInfo];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    self.didResignActive = YES;
    [self handleNotificationWithUserInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    self.didResignActive = YES;
    [self handleNotificationWithUserInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    self.didResignActive = NO;
    [self handleNotificationWithUserInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)handleNotificationWithUserInfo:(NSDictionary *)userInfo {
    if (self.didResignActive) {
        [[QGJpushService sharedService] handleRemoteNotification:userInfo showInfoDirectly:YES];
        self.didResignActive = NO;
        self.launchWithNotification = NO;
    } else if (self.launchWithNotification){
        self.didResignActive = NO;
        self.launchWithNotification = NO;
        [self performSelector:@selector(delayPostNotification:) withObject:userInfo afterDelay:2];
    }else {
        [[QGJpushService sharedService] handleRemoteNotification:userInfo showInfoDirectly:NO];
    }
}

- (void)delayPostNotification:(id)userInfo {
//    [[QGJpushService sharedService] handleRemoteNotification:userInfo showInfoDirectly:YES];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.didResignActive = YES;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
            BLULogInfo(@"MOC Save success!");
        } else {
            BLULogError(@"MOC save failed, error = %@", error);
        }
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[QGJpushService sharedService] resetBadge];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}


-(void)setIQKeyBoard
{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

}

//- (void)OpenNetworkMonitored
//{
//    //监控网络
//    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
//    // 当网络状态改变了，就会调用
//    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown: // 未知网络
//                break;
//            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
//                [[SAProgressHud sharedInstance] showFailWithViewWindow:@"网络异常，请检查网络设置！"];
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
//                break;
//        }
//    }];
//    // 开始监控
//    [mgr startMonitoring];
//}

- (void)configCircle
{
    // Theme 设置社区导航栏
    [BLUCurrentTheme customizeAppAppearance];
    // 设置数据库
    [self configCoreData];
}

- (void)configSocialService
{
    [QGSocialService config];
}

#pragma mark - 广告页

- (void)showAdvertisingPage{
    
    UIImage *image = [self getADImage];
    if (image) {
        
        _adView = [[QGAdvertisingView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _adView.adImage = image;
        [_adView.cannelButton addTarget:self action:@selector(hideAdView) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:_adView]; 
        [self performSelector:@selector(hideAdView) withObject:nil afterDelay:3];
    }
    
    
    [QGHttpManager getStartUpImageSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *dic1 = [NSDictionary dictionary];
        NSString *str = nil;
        if ([dic allValues].count > 0) {
            dic1 = dic[@"item"];
            if (![dic1 isEqual:[NSNull null]]) {
                str = dic1[@"cover"];
            }
        }
        else{
            str = @"";
        }

        UIImage *image1 = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:str]]];
        NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imageName = @"ADImage";
        NSString *filePath = [[documentDirectory stringByAppendingPathComponent:@"ADImages"] stringByAppendingString:imageName];
        NSData *data = UIImageJPEGRepresentation(image1, 0.1);
        if (!data) {
            data = [NSData data];
        }
        if ([data writeToFile:filePath atomically:YES]) {
            NSLog(@"写入成功");
        };
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)hideAdView{
    [UIView animateWithDuration:1 animations:^{
        _adView.alpha = 0;
        _adView.transform=CGAffineTransformScale(_adView.transform, 2, 2);
        
    } completion:^(BOOL finished) {
        [_adView removeFromSuperview];
    }];
}

// 获取本地广告图片
- (UIImage *)getADImage{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imageName = @"ADImage";
    NSString *filePath = [[documentDirectory stringByAppendingPathComponent:@"ADImages"] stringByAppendingString:imageName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:data];
        return image;
    }
    return nil;
}


#pragma mark - Core data

- (void)configCoreData {
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[self dbStore]];
#ifdef QGDEBUG
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
#endif
}

- (NSString *)dbStore {
    NSString *dbName = @"blue_model";
    dbName = [NSString stringWithFormat:@"%@_%@", dbName, @(1)];
    return [NSString stringWithFormat:@"%@.sqlite", dbName];
}



- (void)cleanAndResetupDB {
    NSString *dbStore = [self dbStore];
    
    NSError *error1 = nil;
    NSError *error2 = nil;
    NSError *error3 = nil;
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:dbStore];
    NSURL *walURL = [[storeURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-wal"];
    NSURL *shmURL = [[storeURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-shm"];
    
    if([[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error1] &&
       [[NSFileManager defaultManager] removeItemAtURL:walURL error:&error2] &&
       [[NSFileManager defaultManager] removeItemAtURL:shmURL error:&error3]){
        [self configCoreData];
    }
    else{
        NSLog(@"An error has occurred while deleting %@", dbStore);
        NSLog(@"Error1 description: %@", error1.description);
        NSLog(@"Error2 description: %@", error2.description);
        NSLog(@"Error3 description: %@", error3.description);
    }
}
/**
 *  设置微信的回调

 *  @return
 */



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"sssssiiii %@",url.host);
   
    if ([url.host isEqualToString:@"platformId=wechat"])
    {
        return  [UMSocialSnsService handleOpenURL:url];
    }else if ([url.host isEqualToString:@"pay"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

            NSInteger status=[resultDic[@"resultStatus"] integerValue];
            switch (status) {
                case 6001:
                    if (self.weiXin_Pay_FailBlock)
                    {
                        self.weiXin_Pay_FailBlock();
                    }

                    NSLog(@"支付失败，retcode=%d");
                    break;
                case 9000:
                    if (self.weiXin_Pay_SuccessedBlock)
                    {
                        self.weiXin_Pay_SuccessedBlock();
                    }
                    //服务器端查询支付通知或查询API返回的结果再提示成功

                    NSLog(@"支付成功");
                    break;
                case 6002:

                    if (self.weiXin_Pay_FailBlock)
                    {
                        self.weiXin_Pay_FailBlock();
                    }

                    NSLog(@"支付失败，retcode=%d");
                    break;
                case 4000:

                    if (self.weiXin_Pay_FailBlock)
                    {
                        self.weiXin_Pay_FailBlock();
                    }

                    NSLog(@"支付失败，retcode=%d");
                case 8000:

                    if (self.weiXin_Pay_FailBlock)
                    {
                        self.weiXin_Pay_FailBlock();
                    }

                    NSLog(@"支付失败，retcode=%d");
                default:
                    break;
            }
            NSLog(@"result = %@",resultDic);
        }];
    }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        }];
    }else{
        return  [UMSocialSnsService handleOpenURL:url];
    }
    
    
    return NO;
}
#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp*)resp{

    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case 0:
                if (self.weiXin_Pay_SuccessedBlock)
                {
                    self.weiXin_Pay_SuccessedBlock();
                }
                //服务器端查询支付通知或查询API返回的结果再提示成功

                NSLog(@"支付成功");
                break;

            case -2:
                if (self.weiXin_Pay_FailBlock)
                {
                    self.weiXin_Pay_FailBlock();
                }

                NSLog(@"支付失败，retcode=%d",resp.errCode);

            default:
                break;
        }

    }
}
//- (UITextView *)debugTextView {
//    if (_debugTextView == nil) {
//        _debugTextView = [[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        _debugTextView.backgroundColor = [UIColor randomColor];
//    }
//    return _debugTextView;
//}


@end
