//
//  AppDelegate.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/23.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
typedef void(^AppDelegateBlock)();
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,copy)AppDelegateBlock weiXin_Pay_SuccessedBlock;
@property (nonatomic,copy)AppDelegateBlock weiXin_Pay_FailBlock;
@property (nonatomic, assign) BOOL didResignActive;
@property (nonatomic, assign) BOOL launchWithNotification;

@end

