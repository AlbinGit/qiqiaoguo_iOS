//
//  BLUApService.h
//  Blue
//
//  Created by Bowen on 21/9/15.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString * const BLUApServiceRemoteNotification;

@class BLURemoteNotification;

@interface BLUApService : NSObject

@property (nonatomic, strong) NSString *registrationID;
@property (nonatomic, strong) NSData *deviceToken;

+ (instancetype)sharedService;

- (BOOL)setBadge:(NSInteger)value;

- (void)resetBadge;

- (void)uploadRegistrationID;

- (void)configWithLaunchOptions:(NSDictionary *)launchOptions;

- (void)registerDeviceToken:(NSData *)deviceToken;

- (void)handleRemoteNotification:(NSDictionary *)userInfo showInfoDirectly:(BOOL)showInfoDirectly;

- (void)postNotificationForRemoteNotification:(BLURemoteNotification *)remoteNotification;

@end
