//
//  BLUViewController.h
//  Blue
//
//  Created by Bowen on 30/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

//#undef BLUViewControllerVerboseLog
#define BLUViewControllerVerboseLog

UIKIT_EXTERN NSInteger BLUTabbarRedDotBaseTag;
UIKIT_EXTERN NSString * BLUMessageShowRedDotNotification;

@class BLUUserProfit;

@interface BLUViewController : UIViewController

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, readonly, assign) CGFloat statusBarHeight;
@property (nonatomic, readonly, assign) CGFloat navigationBarHeight;
@property (nonatomic, readonly, assign) CGFloat tabBarHeight;

- (void)addTiledLayoutConstrantForView:(UIView *)view;

- (void)loginRequired:(NSNotificationCenter *)userInfo;
- (BOOL)loginIfNeeded;

- (void)pushViewController:(UIViewController *)viewController;

- (void)viewWillFirstAppear;
- (void)viewDidFirstAppear;

- (void)showUserRewardPromptIndicatorWithUserProfit:(BLUUserProfit *)profit;

- (void)handleRemoteNotification:(NSNotification *)userInfo;
- (void)handleUserProfit:(NSNotification *)userInfo;

- (void)addRedDotAtTabBarItemIndex:(NSInteger)index;
- (void)removeRedDotAtTabBarItemIndex:(NSInteger)index;

- (void)showTopIndicatorWithSuccessMessage:(NSString *)message;
- (void)showTopIndicatorWithError:(NSError *)error;
- (void)showTopIndicatorWithMessage:(NSString *)message image:(UIImage *)image;
- (void)showTopIndicatorWithErrorMessage:(NSString *)errorMessage;


@end
