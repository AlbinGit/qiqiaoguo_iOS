//
//  MQNavigationViewController.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/23.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGNavigationViewController.h"

@interface QGNavigationViewController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) id popDelegate;
@end

@implementation QGNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 恢复滑动返回功能:清空滑动手势代理
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    
    self.delegate = self;
}


- (void)navigationController:(nonnull UINavigationController *)navigationController didShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.childViewControllers[0]) {
        // 回到根控制器
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
    }else{ // 不是根控制器
        self.interactivePopGestureRecognizer.delegate = nil;
        
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)initialize {

    [self setupBarButtonItemTheme];
    [self setupNavigationBarTheme];

}
+(void)setupBarButtonItemTheme {


    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    NSMutableDictionary *nordict = [NSMutableDictionary dictionary];
    nordict[NSForegroundColorAttributeName] = [UIColor orangeColor];
    nordict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
     [appearance setTitleTextAttributes:nordict forState:(UIControlStateNormal)];


    NSMutableDictionary *heightdict = [NSMutableDictionary dictionary];
    heightdict[NSForegroundColorAttributeName] = [UIColor redColor];
    heightdict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [appearance setTitleTextAttributes:heightdict forState:(UIControlStateNormal)];
     NSMutableDictionary *disdict = [NSMutableDictionary dictionary];
     disdict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    disdict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [appearance setTitleTextAttributes:disdict forState:(UIControlStateDisabled)];
}
+ (void)setupNavigationBarTheme {

    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBarTintColor:PL_COLOR_255];
    NSMutableDictionary *navdict = [NSMutableDictionary dictionary];
    navdict[NSForegroundColorAttributeName] = [UIColor blackColor];
    navdict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [appearance setTitleTextAttributes:navdict];
}




- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count >0) {

        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithnorImage:[UIImage imageNamed:@"icon_classification_back"] heighImage:nil targer:self action:@selector(back)];
 }
    
    [super pushViewController:viewController animated:animated];
}



/**
 *  返回上一个控制器
 */
- (void)back {

    [self popViewControllerAnimated:YES];
}
/**
 *  返回目录
 */
- (void)more {
    [self popToRootViewControllerAnimated:YES];
}


@end
