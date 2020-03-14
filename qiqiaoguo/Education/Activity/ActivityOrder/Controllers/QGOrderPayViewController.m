 //
//  QGOrderPayViewController.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/28.
//
//

#import "QGOrderPayViewController.h"
#import "QGOrderPayTableViewCell.h"
#import "QGPayTool.h"
#import "QGOrderPayModel.h"
#import "QGActivOrderViewController.h"
#import "QGMallOrderViewController.h"
#import "QGAlertView.h"
#import "QGConfirmOrderViewController.h"
#import "QGPayResultViewController.h"
#import "QGActivOrderDetailViewController.h"
#import "QGNavigationViewController.h"
#import "QGTabBarViewController.h"
#import "QGMallOrderDetailViewController.h"
#import "QGPersonalViewController.h"
#import "QGEducationOrderDetailViewController.h"
#import "QGEducatiionOrderViewController.h"
#import "QGEducationOrderDetailViewController.h"
@interface QGOrderPayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic ,assign)NSInteger indexRow;

@end

@implementation QGOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self createNavTitle:@"支付订单"];
    [self createCustomReturnButton];
    _tableView =[[SATableView  alloc]initWithFrame:CGRectMake(0,self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.bouncesZoom=YES;
    _tableView.rowHeight=54;
    _tableView.backgroundColor=PL_COLOR_240;
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.indexRow inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    [self addHeaderView];
    [self addFooterView];
    

}

- (void)navCustomLeftBtnClick{
    // 点击返回
    QGAlertView *alert = [[QGAlertView alloc]initWithTitle:@"确定要放弃付款吗" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
    @weakify(self);
    alert.otherButtonAction = ^{
        @strongify(self);
        [self goToOrderDetail];
    };
    
    [alert show];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    switch (self.ConfirmOrderType) {
        case QGConfirmOrderTypeGlobal :
        case QGConfirmOrderTypeGlobalAndBuyNow:
        {
            QGAlertView *alert = [[QGAlertView alloc]initWithTitle:@"购买全球购商品须知" message:@"由于全球购商品的特殊性,若商品无质量问题,付款后即不提供退货/退款服务" cancelButtonTitle:@"知道了" otherButtonTitle:nil];
            [alert show];
        }break;
            
        default:
            break;
    }
    
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[QGConfirmOrderViewController class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)addHeaderView {
    UIView *labview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 105)];
    labview.backgroundColor =[UIColor whiteColor];
    _tableView.tableHeaderView = labview;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MQScreenW*0.5, 50)];
    lab.textColor = [UIColor blackColor];
    lab.text = @"订单总额";
    lab.font = [UIFont systemFontOfSize:16];
    [labview addSubview:lab];
    
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.textColor = QGMainRedColor;
    lab1.text = [NSString stringWithFormat:@"￥%.2f",_pay_amount.floatValue];
    lab1.font = [UIFont boldSystemFontOfSize:16];
    [labview addSubview:lab1];
    
    UIView *LineView = [UIView new];
    LineView.backgroundColor = APPBackgroundColor;
    [labview addSubview:LineView];
    
    UILabel *CooseLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    CooseLabel.text = @"请选择支付方式";
    CooseLabel.textColor = QGMainContentColor;
    [labview addSubview:CooseLabel];
    
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab);
        make.right.equalTo(labview.mas_right).offset(-14);
    }];
    
    UILabel * line = [[UILabel alloc]init];
    line.backgroundColor = APPBackgroundColor;
    [labview addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labview.mas_top);
        make.size.mas_equalTo(CGSizeMake(MQScreenW, 1));
    }];
    
    [LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labview).offset(50);
        make.left.right.equalTo(labview);
        make.height.equalTo(@(10));
    }];
    
    [CooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LineView.mas_bottom).offset(BLUThemeMargin * 3);
        make.left.equalTo(LineView).offset(BLUThemeMargin * 3);
    }];
    
    
}
- (void)addFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 64)];

    _tableView.tableFooterView = view;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 0, SCREEN_WIDTH-40, 54);
    btn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    [btn setTitle:@"确认支付"];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btn.backgroundColor = QGMainRedColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.right.equalTo(view.mas_right).offset(-14);
        make.left.equalTo(view.mas_left).offset(14);
    }];

    PL_CODE_WEAK(weakSelf)
    [btn addClick:^(UIButton *button) {
        [weakSelf addpayType];

  

    }];

}
- (void)addpayType {
    if (self.indexRow  ==0 ) {
        //微信支付
        [self addPayWeiXType];
    }else {
        //支付宝支付
        [self addPaypalWayType];

    }
//     [self addPaypalWayType];

}
- (void)addPaypalWayType {
    QGPaypalHttpDownload *param = [[QGPaypalHttpDownload alloc] init];
    param.platform_id =[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    param.order_id = _order_id;
    param.batch_pay = _is_batch_pay;
    
    [QGHttpManager actlistPaypalOrderWithParam:param success:^(id responseObj) {
        QGPaypalPayModel *model = [QGPaypalPayModel mj_objectWithKeyValues:responseObj[@"extra"][@"item"]];
        QGOrderPayModel *order=[QGOrderPayModel new];
        order.sign = model.sign;
        order.order_info = model.order_info;
        order.sign_type = model.sign_type;
        order.out_trade_no = model.out_trade_no;
        [[QGPayTool shareInstance] commitPaiPayRequest:order withSign:model.sign paySuccess:^(BOOL isSuccess) {
           [self weiXinPaySuccess];
            
        } payFail:^(BOOL isSuccess) {
             [self weiXinPayFail];
        }];
  
    
    } failure:^(NSError *error) {
          [self showTopIndicatorWithError:error];
    }];
    
    
}
- (void)weiXinPaySuccess
{             
    // 成功后跳转到支付成功页
    QGPayResultViewController*order=[QGPayResultViewController  new];
    if (_activity_id.integerValue > 0) {
        order.activity_id = _activity_id;
        order.type = QGPayResultTypeActiv;
    }else if (_edu_id.integerValue >0){
          order.type =  QGPayResultTypeEdu;
         order.activity_id = _edu_id;
    } else {
          order.type = QGPayResultTypeMall;
        
    }
     order.orderID = _order_id.integerValue;
    
    [self.navigationController pushViewController:order animated:NO];
    
}
- (void)weiXinPayFail
{
    [[SAAlert sharedInstance]showAlertWithTitle:@"提示" message:@"订单支付失败"cancelButtonTitle:@"确定" otherTitle:nil];
    [[SAAlert sharedInstance]cancelClick:^{
        [self goToOrderDetail];
    }];
}

- (void)goToOrderDetail{
        
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
        
        if (_activity_id.integerValue > 0) {
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
            vc.orderID = self.order_id.integerValue;
            [marr addObject:vc];
            
            
            nav.viewControllers = marr;
            
            [tabvc selectedVCIndex:4 WithClassName:NSStringFromClass([self class])];
            
            if ([self.navigationController.viewControllers.firstObject isKindOfClass:[QGPersonalViewController class]]) {
                QGPersonalViewController *vc = self.navigationController.viewControllers.firstObject;
                vc.isPush = NO;
            }else{
                [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
            }
            
            
        }else  if (_edu_id.integerValue > 0) {
        
        
            // 返回教育订单详情
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[QGActivOrderDetailViewController class]]) {
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
            vc.orderID = self.order_id.integerValue;
            [marr addObject:vc];
            

            
            nav.viewControllers = marr;
            nav.viewControllers = marr;
            
            [tabvc selectedVCIndex:4 WithClassName:NSStringFromClass([self class])];
            
            if ([self.navigationController.viewControllers.firstObject isKindOfClass:[QGPersonalViewController class]]) {
                QGPersonalViewController *vc = self.navigationController.viewControllers.firstObject;
                vc.isPush = NO;
            }else{
                [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
            }
        
        
        
        }
    
    
    else{
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
            vc.orderID = self.order_id.integerValue;
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

- (void)addPayWeiXType {
    
    if (!([WXApi isWXAppInstalled] ||
          [WXApi isWXAppSupportApi])) {
        NSString *message = @"你没有安装微信哦~";
        [self showTopIndicatorWithErrorMessage:message];
        return ;
    }
    
    QGWeiXInPayHttpDownload *param = [[QGWeiXInPayHttpDownload alloc] init];
    param.platform_id =[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    param.order_id = _order_id;
     param.batch_pay = _is_batch_pay;
    [ QGHttpManager actlistPayOrderWithParam:param success:^(id responseObj) {
    PayReq *request = [[PayReq alloc] init];
    QGWeiXInPayModel  *model =   [QGWeiXInPayModel mj_objectWithKeyValues:responseObj[@"extra"][@"item"]];
        request.openID = model.appid;
        request.partnerId = model.partnerid;
        request.prepayId= model. prepayid;
        request.package = model.wxpackage;
        request.nonceStr= model.noncestr;
        request.timeStamp= [model.timestamp intValue];
        request.sign= model.sign;
      //  _pay_order_type=model.pay_order_type;

        [[QGPayTool shareInstance]commitWeiXinRequest:request paySuccess:^(BOOL isSuccess) {
        [self weiXinPaySuccess];
        } payFail:^(BOOL isSuccess) {
            [self weiXinPayFail];
            
        }];
    } failure:^(NSError *error) {
     [self showTopIndicatorWithError:error];
    }];

}

//- (void)navCustomLeftBtnClick
//{
//    [super navCustomLeftBtnClick];
//    [[SAAlert sharedInstance] showAlertWithTitle:@"" message:@"您确定要放弃支付吗" cancelButtonTitle:@"取消" otherTitle:@"确定"];
//    PL_CODE_WEAK(ws);
//    [[SAAlert sharedInstance] confirmClick:^{
//
//        //去活动
//        if ([_order_type isEqualToString:@"20"]) {
//            QGActivOrderViewController *order=[QGActivOrderViewController new];
//            
//            
//            [ws.navigationController pushViewController:order animated:NO];
//        }else {
//            QGMallOrderViewController *order = [QGMallOrderViewController new];
//            [ws.navigationController pushViewController:order animated:NO];
//        }
//    }];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sign=@"cell";
    PL_CELL_CREATEMETHOD(QGOrderPayTableViewCell, sign);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==0)
    {
        cell.picImageView.image=[UIImage imageNamed:@"icon_weixin"];
        cell.name.text=@"微信支付";

    }else if (indexPath.row==1)
    {
        cell.picImageView.image=[UIImage imageNamed:@"icon_zhifubao"];
        cell.name.text=@"支付宝支付";

    }
     cell.Triangle.tag=indexPath.row;
    cell.backgroundColor = [UIColor whiteColor];
    [cell.Triangle addTarget:self action:@selector(choosePressed:) forControlEvents:UIControlEventTouchUpInside];
    if (self.indexRow == indexPath.row) {
        [cell.Triangle setImage:[UIImage imageNamed:@"shoppingSelected"] forState:UIControlStateNormal];
    }else{
        [cell.Triangle setImage:[UIImage imageNamed:@"shoppingnormal"] forState:UIControlStateNormal];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {



    return 30;

}
-(void)choosePressed:(UIButton *)sender{

    self.indexRow=sender.tag;
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.indexRow = indexPath.row;
    [self.tableView reloadData];


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
