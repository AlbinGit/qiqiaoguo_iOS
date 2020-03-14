//
//  SAProgressHud.h
//  SalesAssistant
//
//  Created by Albin on 14-12-12.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SAProgressHudCompleteBlock)(void);

@interface SAProgressHud : NSObject

+ (SAProgressHud *)sharedInstance;

// MBProgressHud
- (void)showFailWithView:(UIView *)view fail:(NSString *)fail;
- (void)showFailWithViewWindow:(NSString *)fail;
- (void)showWaitWithWindow;
- (void)showWaitWithView:(UIView *)view;
- (void)showFailWithWindow:(NSString *)fail complete:(SAProgressHudCompleteBlock)complete;
- (void)removeHudFromSuperView;
- (void)removeGifLoadingViewFromSuperView;

// 成功信息提示
- (void)showSuccessWithWindow:(NSString *)success;
- (void)showSuccessWithWindow:(NSString *)success complete:(SAProgressHudCompleteBlock)complete;

// 成功信息提示并pop
- (void)showSuccessWithWindowAndPop:(NSString *)success viewController:(UIViewController *)viewController;
- (void)showSuccessWithWindowAndPopToRoot:(NSString *)success viewController:(UIViewController *)viewController;
// 提示消息并退回主界面
- (void)showAlertWithWindowAndPopToRoot:(NSString *)message;
@end
