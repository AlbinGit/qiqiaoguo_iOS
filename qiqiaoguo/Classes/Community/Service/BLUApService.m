//
//  BLUApService.m
//  Blue
//
//  Created by Bowen on 21/9/15.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUApService.h"
#import "JPUSHService.h"
#import "BLUApiManager+Others.h"
#import "BLURemoteNotification.h"
#import "QGHttpManager+User.h"

NSString * const BLUApServiceRemoteNotification = @"BLUApServiceRemoteNotification";
NSString * const BLUApServiceAPPKey = @"8ff7b0dfe3c14012bb2350d0";

@implementation BLUApService

+ (instancetype)sharedService {
    static BLUApService *sharedService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [self new];
    });
    return sharedService;
}

- (BOOL)setBadge:(NSInteger)value {
    return [JPUSHService setBadge:value];
}

- (void)resetBadge {
    [JPUSHService resetBadge];
}

- (void)configWithLaunchOptions:(NSDictionary *)launchOptions {
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#ifdef BLUDebug
    [APService setDebugMode];
    [APService setLogOFF];
#else
    [JPUSHService setLogOFF];
#endif

    // Required
//    [JPUSHService setupWithOption:launchOptions];
    [JPUSHService setupWithOption:launchOptions appKey:BLUApServiceAPPKey
                          channel:@"Publish channel"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

- (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    self.deviceToken = deviceToken;
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo showInfoDirectly:(BOOL)showInfoDirectly {
    [JPUSHService handleRemoteNotification:userInfo];
    NSError *error = nil;
    BLURemoteNotification *rn = [MTLJSONAdapter modelOfClass:[BLURemoteNotification class] fromJSONDictionary:userInfo error:&error];
    if (rn) {
        rn.showInfoDirectly = showInfoDirectly;
        [self postNotificationForRemoteNotification:rn];
    }
}

- (void)uploadRegistrationID {
    if ([JPUSHService registrationID].length) {
        //        [SAUserDefaults removeWithKey:USERDEFAULTS_registrationID];
        [SAUserDefaults saveValue:[JPUSHService registrationID] forKey:USERDEFAULTS_registrationID];
        if ([BLUAppManager sharedManager].currentUser) {
            [QGHttpManager updateDeviceToken:[SAUserDefaults getValueWithKey:USERDEFAULTS_registrationID] Success:^(NSURLSessionDataTask *task, id responseObject) {
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
    }
}

- (void)postNotificationForRemoteNotification:(BLURemoteNotification *)remoteNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:BLUApServiceRemoteNotification object:remoteNotification];
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    BLULogError(@"error = %@", error);
}

- (void)networkDidSetup:(NSNotification *)notification {
    BLULogInfo(@"did setup");
}

- (void)networkDidClose:(NSNotification *)notification {
    BLULogInfo(@"did close");
}

- (void)networkDidRegister:(NSNotification *)notification {
    BLULogInfo(@"%@", [notification userInfo]);
    BLULogInfo(@"did register");
}

- (void)networkDidLogin:(NSNotification *)notification {
    BLULogInfo(@"did login");
    if ([JPUSHService registrationID]) {
        BLULogInfo(@"RegistrationID = %@", [JPUSHService registrationID]);
        self.registrationID = [JPUSHService registrationID];
        [self uploadRegistrationID];
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"Did receive message:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    
    BLULogInfo(@"currentContent = %@", currentContent);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
