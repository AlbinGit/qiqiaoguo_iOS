//
//  QGAnalyticsService.m
//  qiqiaoguo
//
//  Created by cws on 16/6/6.
//
//  友盟统计服务

#import "QGAnalyticsService.h"
#import "QGSocialService.h"
#import <UMMobClick/MobClick.h>

// TODO: 获取友盟的App key
static NSString *const kChanelID = @"Apple store";
static NSString *const kUMOnlineConfigDidFinishedNotification = @"OnlineConfigDidFinishedNotification";


@implementation QGAnalyticsService
+ (void)config {
#ifdef QGDEBUG
    // TODO: Need Yes
    [MobClick setLogEnabled:NO];
    
//    [MobClick startWithAppkey:kUmengAppKey reportPolicy:REALTIME channelId:kChanelID];
    UMConfigInstance.appKey = kUMSocialAppKey;
    UMConfigInstance.channelId = kChanelID;
    [MobClick startWithConfigure:UMConfigInstance];
#else
    [MobClick setLogEnabled:NO];
    [MobClick startWithAppkey:kUMSocialAppKey reportPolicy:BATCH channelId:kChanelID];
#endif
    //    [MobClick updateOnlineConfig];
    [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    //    [MobClick setEncryptEnabled:YES];
    [MobClick setCrashReportEnabled:YES];
    //    [MobClick checkUpdate];
    
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];

}

+ (void)beginLogPageViewWithClass:(Class)viewClass name:(NSString *)name {
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@.%@", viewClass, name]];
}

+ (void)endLogPageViewWithClass:(Class)viewClass name:(NSString *)name {
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@.%@", viewClass, name]];
}

+ (void)addOnlineConfigObserver:(id)observer selector:(SEL)aSelector {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:kUMOnlineConfigDidFinishedNotification object:nil];
}
@end
