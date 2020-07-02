//
//  MQTabBarViewController.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/23.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGTabBarViewController.h"
#import "QGHomeV2ViewController.h"
#import "QGEducationViewController.h"
#import "QGOptimalProductViewController.h"
#import "QGActivityHomeViewController.h"
#import "UIImage+MQimage.h"
#import "QGNavigationViewController.h"
#import "QGPersonalViewController.h"
#import "BLUCircleMainViewController.h"
#import "QGPayResultViewController.h"
#import "QGOrderPayViewController.h"
#import "QGFindController.h"//发现
#import "QGStudyController.h"//学习
@interface QGTabBarViewController ()

@end

@implementation QGTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    QGHomeV2ViewController *home = [[QGHomeV2ViewController alloc] init];
    [self addOneChildVc:home title:@"首页" imageName:[UIImage imageNamed:@"ic_首页"] SelectedImageName:[UIImage imageWithNamed:@"ic_首页_pr"]];
    
//    QGActivityHomeViewController *class = [[QGActivityHomeViewController alloc] init];
//    [self addOneChildVc:class title:@"发现" imageName:[UIImage imageNamed:@"ic_发现"] SelectedImageName:[UIImage imageWithNamed:@"ic_发现_pr"]];
    
	QGFindController *class = [[QGFindController alloc] init];
    [self addOneChildVc:class title:@"发现" imageName:[UIImage imageNamed:@"ic_发现"] SelectedImageName:[UIImage imageWithNamed:@"ic_发现_pr"]];
	
//    BLUCircleMainViewController *found = [[BLUCircleMainViewController alloc] init];
//    [self addOneChildVc:found title:@"学习" imageName:[UIImage imageWithNamed:@"ic_学习"] SelectedImageName:[UIImage imageWithNamed:@"ic_学习_pr"]];
    QGStudyController *found = [[QGStudyController alloc] init];
    [self addOneChildVc:found title:@"学习" imageName:[UIImage imageWithNamed:@"ic_学习"] SelectedImageName:[UIImage imageWithNamed:@"ic_学习_pr"]];

	
    QGPersonalViewController *me = [[QGPersonalViewController alloc] init];
    [self addOneChildVc:me title:@"我的" imageName:[UIImage imageNamed:@"ic_我的"] SelectedImageName:[UIImage imageWithNamed:@"ic_我的_pr"]];
}


- (void)addOneChildVc:(UIViewController *)ChildVc title:(NSString *)title imageName:(UIImage *)imageName SelectedImageName:(UIImage *)SelectedImageName {
    // ChildVc.view.backgroundColor = MQrandomColor;
    ChildVc.tabBarItem.title = title;
    // 设置图标
    ChildVc.tabBarItem.image = imageName;
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    // 声明这张图片用原图(别渲染)
    SelectedImageName = [SelectedImageName imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ChildVc.tabBarItem.selectedImage = SelectedImageName;
    
    UINavigationController *navVc = nil;
    navVc = [[QGNavigationViewController alloc] initWithRootViewController:ChildVc];

    [self addChildViewController: navVc];

}

- (void)selectedVCIndex:(NSInteger)index WithClassName:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([QGPayResultViewController class])] ||[className isEqualToString:NSStringFromClass([QGOrderPayViewController class])] ) {
        CATransition* animation = [CATransition animation];
        [animation setDuration:0.2f];
        [animation setType:kCATransitionMoveIn];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[self.view layer]addAnimation:animation forKey:@"switchView"];
    }
    
    self.selectedIndex = index;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end


