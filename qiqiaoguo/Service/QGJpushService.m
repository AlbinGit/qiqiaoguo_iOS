//
//  QGJpushService.m
//  qiqiaoguo
//
//  Created by cws on 16/6/6.
//
//

#import "QGJpushService.h"
#import "QGRemoteNotiModel.h"
#import "JPUSHService.h"
#import "QGHttpManager+User.h"

NSString * const QGJpushServiceRemoteNotification = @"QGApServiceRemoteNotification";
NSString * const QGJpushServiceAPPKey = @"8ff7b0dfe3c14012bb2350d0";

@implementation QGJpushService
+ (instancetype)sharedService {
    static QGJpushService *sharedService;
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
#ifdef QGDEBUG
    [JPUSHService setDebugMode];
    [JPUSHService setLogOFF];
#else
    [JPUSHService setLogOFF];
#endif
    
    // Required
    [JPUSHService setupWithOption:launchOptions appKey:QGJpushServiceAPPKey
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
    NSDictionary *dic = userInfo[@"pushExtra"];
    NSString *IDStr = [NSString stringWithFormat:@"%@",dic[@"id"]];
    NSString *ModuleStr = [NSString stringWithFormat:@"%@",dic[@"module"]];
    NSNumber *ID = [IDStr stringToNSNumber];
    NSNumber *Module = [ModuleStr stringToNSNumber];
    NSDictionary *dic1 =nil;
    if (ID && Module) {
       dic1 = @{@"id":ID,@"module":Module};
    }
    
    QGRemoteNotiModel *rn = [MTLJSONAdapter modelOfClass:[QGRemoteNotiModel class] fromJSONDictionary:dic1 error:&error];
    if (rn) {
        rn.showInfoDirectly = showInfoDirectly;
        [self postNotificationForRemoteNotification:rn];
    }else if(error){
        NSLog(@"%@",error);
    }
}

- (void)postNotificationForRemoteNotification:(QGRemoteNotiModel *)remoteNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:QGJpushServiceRemoteNotification object:remoteNotification];
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
}

- (void)networkDidSetup:(NSNotification *)notification {
}

- (void)networkDidClose:(NSNotification *)notification {
}

- (void)networkDidRegister:(NSNotification *)notification {

}

- (void)networkDidLogin:(NSNotification *)notification {
    if ([JPUSHService registrationID]) {
        self.registrationID = [JPUSHService registrationID];
        [self uploadRegistrationID];
    }
}

- (void)uploadRegistrationID {
    if ([JPUSHService registrationID].length) {
        [SAUserDefaults saveValue:[JPUSHService registrationID] forKey:USERDEFAULTS_registrationID];
        if ([BLUAppManager sharedManager].currentUser) {
            [QGHttpManager updateDeviceToken:[SAUserDefaults getValueWithKey:USERDEFAULTS_registrationID] Success:^(NSURLSessionDataTask *task, id responseObject) {
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
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
