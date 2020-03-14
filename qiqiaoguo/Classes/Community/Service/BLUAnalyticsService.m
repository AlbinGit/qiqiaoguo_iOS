////
////  BLUAnalyticsService.m
////  Blue
////
////  Created by Bowen on 20/7/15.
////  Copyright (c) 2015 com.blue. All rights reserved.
////
//
#import "BLUAnalyticsService.h"
//#import "MobClick.h"
//
//// TODO: 获取友盟的App key
//static NSString *const kUmengAppKey = kUMSocialKey;
//static NSString *const kChanelID = @"Apple store";
//static NSString *const kUMOnlineConfigDidFinishedNotification = @"OnlineConfigDidFinishedNotification";
//
@implementation BLUAnalyticsService
//
//+ (void)config {
//#ifdef BLUDebug
//    // TODO: Need Yes
//    [MobClick setLogEnabled:NO];
//    [MobClick startWithAppkey:kUmengAppKey reportPolicy:REALTIME channelId:kChanelID];
//#else
//    [MobClick setLogEnabled:NO];
//    [MobClick startWithAppkey:kUmengAppKey reportPolicy:BATCH channelId:kChanelID];
//#endif
////    [MobClick updateOnlineConfig];
//    [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
////    [MobClick setEncryptEnabled:YES];
//    [MobClick setCrashReportEnabled:YES];
////    [MobClick checkUpdate];
//
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//
////    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
//}
//
//+ (void)beginLogPageViewWithClass:(Class)viewClass name:(NSString *)name {
//    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@.%@", viewClass, name]];
//}
//
//+ (void)endLogPageViewWithClass:(Class)viewClass name:(NSString *)name {
//    [MobClick endLogPageView:[NSString stringWithFormat:@"%@.%@", viewClass, name]];
//}
//
//+ (void)addOnlineConfigObserver:(id)observer selector:(SEL)aSelector {
//    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:kUMOnlineConfigDidFinishedNotification object:nil];
//}
//
@end
