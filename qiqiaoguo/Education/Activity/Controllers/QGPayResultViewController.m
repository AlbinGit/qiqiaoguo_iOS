//
//  QGPayResultViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/8/3.
//
//

#import "QGPayResultViewController.h"
#import "QGActivOrderViewController.h"
#import "QGActivityDetailViewController.h"
#import "QGOptimalProductViewController.h"
#import "QGTabBarViewController.h"
#import "QGNavigationViewController.h"
#import "QGActivityHomeViewController.h"
#import "QGPersonalViewController.h"
#import "QGActivOrderDetailViewController.h"
#import "QGMallOrderDetailViewController.h"
#import "QGMallOrderViewController.h"
#import "QGEducationOrderDetailViewController.h"
#import "QGHomeV2ViewController.h"
#import "QGEducatiionOrderViewController.h"
@interface QGPayResultViewController ()

@end

@implementation QGPayResultViewController

-  (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self createNavTitle:@"支付结果"];
    [self createCustomReturnButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
}

- (void)navCustomLeftBtnClick
{
    [self backClick];
}


- (void)creatUI {
    NSString *signStr = nil;
    NSString *labStr = nil;
    NSString *btn1Title = nil;
    switch (_type) {
        case QGPayResultTypeActiv:
            signStr =  @"报名成功!";
            labStr  =  @"你已经成功报名，请按活动要求准时参加。如遇特殊情况，请与客服联系";
            btn1Title =  @"返回活动首页" ;
            break;
        case QGPayResultTypeEdu:
            signStr =  @"报名成功!";
            labStr  =  @"你已经成功报名，请按课程要求准时参加。如遇特殊情况，请与客服联系";
            btn1Title =  @"返回首页" ;;
            break;
            
        default:
            signStr =@"支付成功!";
            labStr =@"请放心,从七巧国商城所发出的每件商品,都会经过工作人员的精心打包,并力保产品完美的送达你的手中。";
            btn1Title = @"返回商城首页";
            break;
    }
    
//    NSString *signStr = self.type == QGPayResultTypeActiv ?  @"报名成功!" : @"支付成功!";
//    NSString *labStr  = self.type == QGPayResultTypeActiv ? @"你已经成功报名，请按活动要求准时参加。如遇特殊情况，请与客服联系" : @"请放心,从七巧国商城所发出的每件商品,都会经过工作人员的精心打包,并力保产品完美的送达你的手中。";
//    NSString *btn1Title    = self.type == QGPayResultTypeActiv ? @"返回活动首页" : @"返回商城首页";
    
    
    UIImageView *imabg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_bgimage"]];
    imabg.frame = CGRectMake(0, self.navImageView.maxY, MQScreenW, 200);
    [self.view addSubview:imabg];
    UIImageView *ima = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_success"]];
    ima.frame = CGRectMake(MQScreenW*0.5-100, 30, 100, 100);
    [imabg addSubview:ima];
    
    UILabel *sign = [[UILabel alloc] init];
    sign.text = signStr;
    sign.textColor = [UIColor colorFromHexString:@"666666"];
    sign.numberOfLines = 0;
    sign.font = [UIFont systemFontOfSize:17];
    CGRect rectsign = [QGCommon rectForString:sign.text withFont:17 WithWidth:MQScreenW];
    
    sign.frame = CGRectMake(ima.maxX+10,ima.maxY+15, MQScreenW-20, rectsign.size.height);
    
    [self.view addSubview:sign];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = labStr;
    lab.textColor = [UIColor lightGrayColor];
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:15];
    CGRect rect = [QGCommon rectForString:lab.text withFont:15 WithWidth:MQScreenW];
    
    lab.frame = CGRectMake(10, imabg.maxY, MQScreenW-20, rect.size.height);
    
    [self.view addSubview:lab];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(30, lab.maxY+30, (MQScreenW-80)*0.5, 30)];
    [btn1 setTitle:btn1Title];
    [btn1 setTitleColor:[UIColor colorFromHexString:@"666666"] forState:(UIControlStateNormal)];
    [btn1 setTitleFont:[UIFont systemFontOfSize:15]];
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 5;
    btn1.layer.borderWidth = 2;
    btn1.layer.borderColor = [UIColor colorFromHexString:@"333333"].CGColor;
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btn1.maxX +20, lab.maxY+30,(MQScreenW-80)*0.5, 30)];
    [btn2 setTitleColor:[UIColor colorFromHexString:@"999999"] forState:(UIControlStateNormal)];
    [btn2 setTitle:@"查看订单"];
    [btn2 setTitleFont:[UIFont systemFontOfSize:15]];
    btn2.layer.masksToBounds = YES;
    btn2.layer.cornerRadius = 5;
    btn2.layer.borderWidth = 2;
    btn2.layer.borderColor = [UIColor colorFromHexString:@"999999"].CGColor;
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backClick{
    
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
    QGTabBarViewController *tabvc = (QGTabBarViewController *)window.rootViewController;

    if (self.type == QGPayResultTypeActiv) {
        // 返回活动详情
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QGActivityHomeViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        // 不是从活动详情页支付的
          [tabvc selectedVCIndex:1 WithClassName:NSStringFromClass([self class])];
        
        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[QGPersonalViewController class]]) {
            QGPersonalViewController *vc = self.navigationController.viewControllers.firstObject;
            vc.isPush = NO;
        }
        [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
        
        
    }else if(self.type == QGPayResultTypeEdu) {
    
        // 返回商城首页
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QGHomeV2ViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        // 不是从商城首页支付时返回商城首页
        
        [tabvc selectedVCIndex:0 WithClassName:NSStringFromClass([self class])];
        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[QGPersonalViewController class]]) {
            QGPersonalViewController *vc = self.navigationController.viewControllers.firstObject;
            vc.isPush = NO;
        }
        [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
        
    
    
    
    
    }
        
    else{
        // 返回商城首页
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QGOptimalProductViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        // 不是从商城首页支付时返回商城首页
        
        [tabvc selectedVCIndex:3 WithClassName:NSStringFromClass([self class])];
        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[QGPersonalViewController class]]) {
            QGPersonalViewController *vc = self.navigationController.viewControllers.firstObject;
            vc.isPush = NO;
        }
        [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
        
    }

}

- (void)orderClick{
    
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
    QGTabBarViewController *tabvc = (QGTabBarViewController *)window.rootViewController;
    
    if (self.type == QGPayResultTypeActiv) {
        // 返回活动订单详情
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QGActivOrderDetailViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        // 不是从活动订单支付的
        
        QGNavigationViewController *nav = tabvc.viewControllers[4];
        
        NSMutableArray *marr = [[NSMutableArray alloc]init];
        [marr addObject:nav.viewControllers.firstObject];
        
        QGActivOrderViewController *ActivorderVC = [QGActivOrderViewController new];
        ActivorderVC.hidesBottomBarWhenPushed = YES;

        
        [marr addObject:ActivorderVC];
        
        QGActivOrderDetailViewController *vc = [QGActivOrderDetailViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.orderID = self.orderID;
        [marr addObject:vc];
        
        
        nav.viewControllers = marr;
        
        [tabvc selectedVCIndex:4 WithClassName:NSStringFromClass([self class])];
        
        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[QGPersonalViewController class]]) {
            QGPersonalViewController *vc = self.navigationController.viewControllers.firstObject;
            vc.isPush = NO;
        }else{
            [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
        }

        
    }else   if (self.type == QGPayResultTypeEdu) {
        
            
        // 返回教育订单详情
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QGEducationOrderDetailViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        // 不是从教育订单支付的
        
        QGNavigationViewController *nav = tabvc.viewControllers[4];
        
        NSMutableArray *marr = [[NSMutableArray alloc]init];
        [marr addObject:nav.viewControllers.firstObject];
        
        QGEducatiionOrderViewController *ActivorderVC = [QGEducatiionOrderViewController new];
        ActivorderVC.hidesBottomBarWhenPushed = YES;
        
        
        [marr addObject:ActivorderVC];
        
        QGEducationOrderDetailViewController *vc = [QGEducationOrderDetailViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.orderID = self.orderID;
        [marr addObject:vc];
        
        
        nav.viewControllers = marr;
        
        [tabvc selectedVCIndex:4 WithClassName:NSStringFromClass([self class])];
        
        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[QGPersonalViewController class]]) {
            QGPersonalViewController *vc = self.navigationController.viewControllers.firstObject;
            vc.isPush = NO;
        }else{
            [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
        }
    
            
    }else {
        // 返回商城订单详情
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QGMallOrderDetailViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        // 不是从商城订单支付时返回商城订单详情
        QGNavigationViewController *nav = tabvc.viewControllers[4];
        
        NSMutableArray *marr = [[NSMutableArray alloc]init];
        [marr addObject:nav.viewControllers.firstObject];
        
        QGMallOrderViewController *ActivorderVC = [QGMallOrderViewController new];
        ActivorderVC.hidesBottomBarWhenPushed = YES;
        
        [marr addObject:ActivorderVC];
        
        QGMallOrderDetailViewController *vc = [QGMallOrderDetailViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.orderID = self.orderID;
        [marr addObject:vc];
        
        
        nav.viewControllers = marr;
        
        [tabvc selectedVCIndex:4 WithClassName:NSStringFromClass([self class])];
        
        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[QGPersonalViewController class]]) {
            QGPersonalViewController *vc = self.navigationController.viewControllers.firstObject;
            vc.isPush = NO;
        }else{
            [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
