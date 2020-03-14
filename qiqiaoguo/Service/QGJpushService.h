//
//  QGJpushService.h
//  qiqiaoguo
//
//  Created by cws on 16/6/6.
//
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString * const QGJpushServiceRemoteNotification;

@class QGRemoteNotiModel;

@interface QGJpushService : NSObject

@property (nonatomic, strong) NSString *registrationID;
@property (nonatomic, strong) NSData *deviceToken;

+ (instancetype)sharedService;

- (BOOL)setBadge:(NSInteger)value;

- (void)resetBadge;

- (void)uploadRegistrationID;

- (void)configWithLaunchOptions:(NSDictionary *)launchOptions;

- (void)registerDeviceToken:(NSData *)deviceToken;

- (void)handleRemoteNotification:(NSDictionary *)userInfo showInfoDirectly:(BOOL)showInfoDirectly;

- (void)postNotificationForRemoteNotification:(QGRemoteNotiModel *)remoteNotification;

@end
