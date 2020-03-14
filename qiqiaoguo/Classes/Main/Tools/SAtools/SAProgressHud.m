//
//  SAProgressHud.m
//  SalesAssistant
//
//  Created by Albin on 14-12-12.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SAProgressHud.h"
#import "MBProgressHUD.h"
//#import "QGGifLoadingView.h"

@interface SAProgressHud ()
//@property (nonatomic,strong)MBProgressHUD *hud;
//@property (nonatomic,strong)QGGifLoadingView *gifLoadingView;


@end

@implementation SAProgressHud

static SAProgressHud *_shareInstance = nil;
+ (SAProgressHud *)sharedInstance
{
    @synchronized(self)
    {
        if (!_shareInstance){
            _shareInstance = [[SAProgressHud alloc]init];
        }
    }
    return _shareInstance;
}

#pragma mark MBProgressHud Method
//- (void)showFailWithView:(UIView *)view fail:(NSString *)fail
//{
//    if (!_hud)
//    {
//        _hud = [[MBProgressHUD alloc]initWithView:view];
//        [view addSubview:_hud];
//        _hud.labelText = fail;
//        _hud.mode = MBProgressHUDModeText;
//        [_hud showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            PL_CODE_SAFEREMOVEW(_hud)
//        }];
//        
//    }
//}

//- (void)showFailWithViewWindow:(NSString *)fail
//{
//    if (!_hud) {
//        _hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
//        [[UIApplication sharedApplication].keyWindow addSubview:_hud];
//        _hud.detailsLabelText = fail;
//        _hud.detailsLabelFont = [UIFont boldSystemFontOfSize:17.0f];
//        _hud.mode = MBProgressHUDModeText;
//        [_hud showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            PL_CODE_SAFEREMOVEW(_hud)
//        }];
//        
//    }
//}

//- (void)showFailWithWindow:(NSString *)fail complete:(SAProgressHudCompleteBlock)complete
//{
//    if(!_hud)
//    {
//        _hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
//        [[UIApplication sharedApplication].keyWindow addSubview:_hud];
//        _hud.labelText = fail;
//        _hud.mode = MBProgressHUDModeText;
//        [_hud showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            [_hud removeFromSuperview];
//            _hud = nil;
//            complete();
//        }];
//    }
//}



- (void)showWaitWithWindow
{
    // 获取当前显示的控制器
    UIViewController *currentVC = [self getCurrentVC];
    
    [currentVC.view showIndicator];
    
 
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    if ([window subviews].count == 0)
        return window.rootViewController;
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}


- (void)removeGifLoadingViewFromSuperView
{
    
    // 获取当前显示的控制器
    UIViewController *currentVC = [self getCurrentVC];
    
    [currentVC.view hideIndicator];
    //    PL_CODE_SAFEREMOVEW(_gifLoadingView)
}

- (void)showWaitWithView:(UIView *)view
{
    
    // 获取当前显示的控制器
    UIViewController *currentVC = [self getCurrentVC];
    
    [currentVC.view showIndicator];

}

//- (void)removeHudFromSuperView
//{
//    PL_CODE_SAFEREMOVEW(_hud)
//}
//
//// 成功信息提示
//- (void)showSuccessWithWindow:(NSString *)success;
//{
//    if(!_hud)
//    {
//        _hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
//        [[UIApplication sharedApplication].keyWindow addSubview:_hud];
//        _hud.labelText = success;
//        _hud.mode = MBProgressHUDModeCustomView;
//        _hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark.png"]] ;
//        [_hud showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            [_hud removeFromSuperview];
//            _hud = nil;
//        }];
//    }
//}

//- (void)showSuccessWithWindow:(NSString *)success complete:(SAProgressHudCompleteBlock)complete
//{
//    if(!_hud)
//    {
//        _hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
//        [[UIApplication sharedApplication].keyWindow addSubview:_hud];
//        _hud.labelText = success;
//        _hud.mode = MBProgressHUDModeCustomView;
//        _hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark.png"]] ;
//        [_hud showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            [_hud removeFromSuperview];
//            _hud = nil;
//            complete();
//        }];
//    }
//}

//// 成功信息提示并pop
//- (void)showSuccessWithWindowAndPop:(NSString *)success viewController:(UIViewController *)viewController
//{
//    if(!_hud)
//    {
//        _hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
//        [[UIApplication sharedApplication].keyWindow addSubview:_hud];
//        _hud.labelText = success;
//        _hud.mode = MBProgressHUDModeCustomView;
//        _hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark.png"]] ;
//        [_hud showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            [_hud removeFromSuperview];
//            _hud = nil;
//            [viewController.navigationController popViewControllerAnimated:YES];
//        }];
//    }
//}

//// 成功信息提示并pop
//- (void)showSuccessWithWindowAndPopToRoot:(NSString *)success viewController:(UIViewController *)viewController
//{
//    if(!_hud)
//    {
//        _hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
//        [[UIApplication sharedApplication].keyWindow addSubview:_hud];
//        _hud.labelText = success;
//        _hud.mode = MBProgressHUDModeCustomView;
//        _hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark.png"]] ;
//        [_hud showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            [_hud removeFromSuperview];
//            _hud = nil;
//            [viewController.navigationController popToRootViewControllerAnimated:YES];
//        }];
//    }
//}

//// 提示消息并退回主界面
//- (void)showAlertWithWindowAndPopToRoot:(NSString *)message
//{
//    if(!_hud)
//    {
//        _hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
//        [[UIApplication sharedApplication].keyWindow addSubview:_hud];
//        _hud.labelText = message;
//        _hud.mode = MBProgressHUDModeCustomView;
//        [_hud showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            [_hud removeFromSuperview];
//            _hud = nil;
//            UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            [nav popToRootViewControllerAnimated:YES];
//        }];
//    }
//}

@end
