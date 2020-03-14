//
//  QGMallOrderDetailViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/19.
//
//

#import "QGMallOrderDetailViewController.h"
#import "QGTableView.h"
#import "QGHttpManager+Order.h"
#import "QGMallOrderCell.h"
#import "QGMallOrderHeaderCell.h"
#import "QGMallOrderFooterCell.h"
#import "QGMallOrderDetailCell.h"
#import "QGOrderBottomTool.h"
#import "QGAlertView.h"
#import "QGSelectOrderCancelReasonViewController.h"
#import "QGGoodLogisticsViewController.h"
#import "QGOrderPayViewController.h"
#import "QGStoreListViewController.h"


static void * const kOrderBottomKey = "kOrderBottomKey";
@interface QGMallOrderDetailViewController () <UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,QGSelectOrderCancelReasonDelegate>

@property (nonatomic ,strong)QGTableView *tableView;
@property (nonatomic ,strong)QGMallOrderModel *order;
@property (nonatomic ,strong)QGOrderBottomTool *tool;

@property (nonatomic ,strong)NSArray *pickViewDataArray;

@end

@implementation QGMallOrderDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"订单详情";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Table view
    _tableView = [[QGTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = APPBackgroundColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[QGMallOrderHeaderCell class] forCellReuseIdentifier:NSStringFromClass([QGMallOrderHeaderCell class])];
    [_tableView registerClass:[QGMallOrderFooterCell class] forCellReuseIdentifier:NSStringFromClass([QGMallOrderFooterCell class])];
    [_tableView registerClass:[QGMallOrderDetailCell class] forCellReuseIdentifier:NSStringFromClass([QGMallOrderDetailCell class])];
    [self.view addSubview:_tableView];
    
    _tool = [[QGOrderBottomTool alloc]init];
    [self.view addSubview:_tool];
    @weakify(self);
    self.tableView.mj_header =
    [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [QGHttpManager getMallOrderDetailWithOrderID:self.orderID Success:^(NSURLSessionDataTask *task, id responseObject) {
            [self tableViewEndRefreshing:self.tableView];
            self.order = responseObject;
            [self.tableView reloadData];
            [self configBottomTool];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self tableViewEndRefreshing:self.tableView];
            [self showTopIndicatorWithError:error];
        }];
        
    }];
}

- (void)viewWillFirstAppear{
    
    [super viewWillFirstAppear];
    @weakify(self);
    [QGHttpManager getMallOrderDetailWithOrderID:self.orderID Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self tableViewEndRefreshing:self.tableView];
        self.order = responseObject;
        [self.tableView reloadData];
        [self configBottomTool];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self tableViewEndRefreshing:self.tableView];
        [self showTopIndicatorWithError:error];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithnorImage:[UIImage imageNamed:@"icon_classification_back"] heighImage:nil targer:self action:@selector(back)];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
    _tool.X = 0;
    _tool.Y = self.view.height - 44;
    [_tool layoutSubviews];
}

- (void)configBottomTool{
    self.tool.order = self.order;
    
    QGMallOrderModel *order = self.order;
    
    [_tool.refundButton addTarget:self
                           action:@selector(refundAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(_tool.refundButton,
                             kOrderBottomKey,
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [_tool.confirmGoodsButton addTarget:self
                            action:@selector(confirmGoods:)
                  forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(_tool.confirmGoodsButton,
                             kOrderBottomKey,
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [_tool.courierButton addTarget:self
                               action:@selector(courier:)
                     forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(_tool.courierButton,
                             kOrderBottomKey,
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [_tool.afterSalesButton addTarget:self
                           action:@selector(afterSales:)
                 forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(_tool.afterSalesButton,
                             kOrderBottomKey,
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [_tool.cancelButton addTarget:self
                            action:@selector(cancelAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(_tool.cancelButton,
                             kOrderBottomKey,
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [_tool.deleteButton addTarget:self
                            action:@selector(deleteAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(_tool.deleteButton,
                             kOrderBottomKey,
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [_tool.submitButton addTarget:self
                            action:@selector(submitAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(_tool.submitButton,
                             kOrderBottomKey,
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.order.goods.count;
    return count > 0 ? count + 2 : 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
       QGMallOrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGMallOrderHeaderCell class]) forIndexPath:indexPath];
        cell.order = self.order;
        [[cell.logisticsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            // 跳转物流详情
            QGGoodLogisticsViewController *vc = [[QGGoodLogisticsViewController alloc] initWithOrderID:@(self.order.orderID)];
            [self.navigationController pushViewController:vc animated:YES];
         }];
        [[cell.StoreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            // 跳转店铺详情
            QGStoreListViewController *vc = [[QGStoreListViewController alloc] init];
            vc.shop_id = @(self.order.Sid).stringValue;
            [self.navigationController pushViewController:vc animated:YES];
        }];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1 ){
        QGMallOrderFooterCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGMallOrderFooterCell class]) forIndexPath:indexPath];
        cell.order = self.order;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    QGMallOrderDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGMallOrderDetailCell class]) forIndexPath:indexPath];
        NSInteger index = indexPath.row - 1;
        QGMallGoodsModell *model = self.order.goods[index];
        cell.orderType = self.order.orderType;
        cell.order = model;
        cell.orderStatus = self.order.orderStatus;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
    CGSize size = [_tableView sizeForCellWithCellClass:[QGMallOrderHeaderCell class] cacheByIndexPath:indexPath width:self.view.width configuration:^(QGCell *cell) {
        QGMallOrderHeaderCell *headcell = (QGMallOrderHeaderCell *)cell;
        headcell.order = self.order;
    }];
        return size.height;
    }else if (indexPath.row == self.order.goods.count+1){
        CGSize size = [_tableView sizeForCellWithCellClass:[QGMallOrderFooterCell class] cacheByIndexPath:indexPath width:self.view.width configuration:^(QGCell *cell) {
            QGMallOrderFooterCell *footcell = (QGMallOrderFooterCell *)cell;
            footcell.order = self.order;
        }];
        return size.height;
    }
    CGSize size = [_tableView sizeForCellWithCellClass:[QGMallOrderDetailCell class] cacheByIndexPath:indexPath width:self.view.width configuration:^(QGCell *cell) {
        QGMallOrderDetailCell *footcell = (QGMallOrderDetailCell *)cell;
        QGMallGoodsModell *model = self.order.goods[indexPath.row - 1];
        footcell.order = model;
    }];
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Action

- (void)refundAction:(UIButton *)button{
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderBottomKey);
    if ([order isKindOfClass:[QGMallOrderModel class]]) {
        
        [self.view showIndicator];
        @weakify(self);
        [QGHttpManager getMallOrderCancelReasonWithOrdertype:0 Success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self.view hideIndicator];
            NSArray *arr = responseObject;
            NSMutableArray *marr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                NSString *str = dic[@"text"];
                [marr addObject:str];
            }
            self.pickViewDataArray = marr;
            
            [self showPickViewWithType:QGPickViewTypeGoodRefund];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
        }];
        
        
    }
    
}

- (void)deleteAction:(UIButton *)button {
    
    QGAlertView *alt = [[QGAlertView alloc]initWithTitle:@"确定要删除该订单吗" message:@"删除过后订单消失，且不可恢复哦!" cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderBottomKey);
    @weakify(self);
    alt.otherButtonAction = ^{
        if ([order isKindOfClass:[QGMallOrderModel class]]) {
            [QGHttpManager deleteOrderWithOrderID:order.orderID Success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self showTopIndicatorWithError:error];
            }];
        }
    };
    
    [alt show];

}

- (void)cancelAction:(UIButton *)button {
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderBottomKey);
    if ([order isKindOfClass:[QGMallOrderModel class]]) {
        
        [self.view showIndicator];
        @weakify(self);
        [QGHttpManager getMallOrderCancelReasonWithOrdertype:0 Success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
           [self.view hideIndicator];
            NSArray *arr = responseObject;
            NSMutableArray *marr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                NSString *str = dic[@"text"];
                [marr addObject:str];
            }
            self.pickViewDataArray = marr;
            
            [self showPickViewWithType:QGPickViewTypeCannel];
         
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
        }];

        
    }
}

- (void)submitAction:(UIButton *)button {
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderBottomKey);
    if ([order isKindOfClass:[QGMallOrderModel class]]) {
        QGOrderPayViewController *vc = [[QGOrderPayViewController alloc]init];
        vc.order_type = [@(order.orderType) stringValue];
        vc.order_id = [@(order.orderID) stringValue];
        vc.pay_amount = [NSString stringWithFormat:@"%f",order.orderAmount];
        if (order.orderType == 8) {
            vc.ConfirmOrderType = QGConfirmOrderTypeGlobal;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)confirmGoods:(UIButton *)button{
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderBottomKey);
    if ([order isKindOfClass:[QGMallOrderModel class]]) {
        
        [self.view showIndicator];
        @weakify(self);
        [QGHttpManager confirmOrderWithOrderID:order.orderID Success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self.view hideIndicator];
            self.order.orderStatus = QGMallOrderStatusComplete;
            [self.tableView reloadData];
            self.tool.order = self.order;
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
        }];
    }
}

- (void)courier:(UIButton *)button{

    QGGoodLogisticsViewController *vc = [[QGGoodLogisticsViewController alloc] initWithOrderID:@(self.order.orderID)];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)afterSales:(UIButton *)button{
    [self.view showIndicator];
    @weakify(self);
    [QGHttpManager getMallOrderAftersalesReasonWithOrdertype:0 Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self.view hideIndicator];
        NSArray *arr = responseObject;
        NSMutableArray *marr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            NSString *str = dic[@"text"];
            [marr addObject:str];
        }
        self.pickViewDataArray = marr;
        
        [self showPickViewWithType:QGPickViewTypeAfter];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self.view hideIndicator];
        [self showTopIndicatorWithError:error];
    }];

}

#pragma mark -  PickerView
- (void)showPickViewWithType:(QGPickViewType)type{
    
    QGSelectOrderCancelReasonViewController *vc = [QGSelectOrderCancelReasonViewController new];
    vc.view.backgroundColor = [UIColor colorFromHexString:@"999999" alpha:0.4];
    [self addChildViewController:vc];
    vc.view.frame = self.view.bounds;
    vc.delegate = self;
    vc.pickViewDataArray = self.pickViewDataArray;
    vc.type = type;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    vc.view.alpha = 0.0;
    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        vc.view.alpha = 1.0;
    }];

}


- (void)SelectOrderCancelReason:(NSString *)reason andType:(QGPickViewType)type{
    if (type == QGPickViewTypeCannel) {
        QGMallOrderStatus oldStatus = self.order.orderStatus;
        self.order.orderStatus = QGMallOrderStatusCancel;
        [self.tableView reloadData];
        [self configBottomTool];
        @weakify(self);
        [self.view showIndicator];
        [QGHttpManager cancelOrderWithOrderID:self.order.orderID Reason:reason Success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.view hideIndicator];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
            self.order.orderStatus = oldStatus;
            [self.tableView reloadData];
            [self configBottomTool];
        }];
    }else if (type == QGPickViewTypeAfter){
        QGMallOrderStatus oldStatus = self.order.orderStatus;
        self.order.orderStatus = QGMallOrderStatusSystemGoodsBack;
        [self.tableView reloadData];
        [self configBottomTool];
        @weakify(self);
        [self.view showIndicator];
        [QGHttpManager OrderAftersalesWithOrderID:self.order.orderID Reason:reason Success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.view hideIndicator];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
            self.order.orderStatus = oldStatus;
            [self.tableView reloadData];
            [self configBottomTool];
        }];
        
    }else{
        QGMallOrderStatus oldStatus = self.order.orderStatus;
        self.order.orderStatus = QGMallOrderStatusSystemRefunding;
        [self.tableView reloadData];
        [self configBottomTool];
        @weakify(self);
        [self.view showIndicator];
        [QGHttpManager cancelOrderWithOrderID:self.order.orderID Reason:reason Success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.view hideIndicator];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
            self.order.orderStatus = oldStatus;
            [self.tableView reloadData];
            [self configBottomTool];
        }];
    }

}




@end
