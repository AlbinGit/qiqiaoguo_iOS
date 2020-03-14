//
//  QGActivOrderDetailViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/21.
//
//

#import "QGEducationOrderDetailViewController.h"
#import "QGTableView.h"
#import "QGHttpManager+Order.h"
#import "QGMallOrderCell.h"
#import "QGEduOrderHeaderCell.h"
#import "QGActivOrderFooterCell.h"
#import "QGMallOrderDetailCell.h"
#import "QGOrderBottomTool.h"
#import "QGAlertView.h"
#import "QGSelectOrderCancelReasonViewController.h"
#import "QGActivOrderCell.h"
#import "QGActivOrderModel.h"
#import "QGEduOrderDetailCell.h"
#import "QGOrgViewController.h"

#import "QGOrderPayViewController.h"
#import "QGStoreListViewController.h"
#import "QGCourseDetailViewController.h"
static void * const kOrderBottomKey = "kActivOrderKey";
@interface QGEducationOrderDetailViewController () <UITableViewDataSource,UITableViewDelegate,QGSelectOrderCancelReasonDelegate>

@property (nonatomic ,strong)QGTableView *tableView;
@property (nonatomic ,strong)QGActivOrderModel *order;
@property (nonatomic ,strong)QGOrderBottomTool *tool;

@property (nonatomic ,strong)NSArray *pickViewDataArray;

@end


@implementation QGEducationOrderDetailViewController

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
    [_tableView registerClass:[QGEduOrderHeaderCell class] forCellReuseIdentifier:NSStringFromClass([QGEduOrderHeaderCell class])];
    [_tableView registerClass:[QGActivOrderFooterCell class] forCellReuseIdentifier:NSStringFromClass([QGActivOrderFooterCell class])];
    [_tableView registerClass:[QGEduOrderDetailCell class] forCellReuseIdentifier:NSStringFromClass([QGEduOrderDetailCell class])];
    [self.view addSubview:_tableView];
    
    _tool = [[QGOrderBottomTool alloc]init];
    [self.view addSubview:_tool];
    @weakify(self);
    self.tableView.mj_header =
    [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [QGHttpManager getEduOrderDetailWithOrderID:self.orderID Success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [QGHttpManager getEduOrderDetailWithOrderID:self.orderID Success:^(NSURLSessionDataTask *task, id responseObject) {
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
    self.tool.order = self.order.mallOrder;
    
    QGMallOrderModel *order = self.order.mallOrder;
    
    [_tool.refundButton addTarget:self
                           action:@selector(refundAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(_tool.refundButton,
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
    NSInteger count = self.order.mallOrder.goods.count;
    return count > 0 ? 3 : 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QGEduOrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGEduOrderHeaderCell class]) forIndexPath:indexPath];
        cell.order = self.order.mallOrder;
        [cell.logisticsButton addTarget:self action:@selector(goStoreVC) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1 ){
        QGActivOrderFooterCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGActivOrderFooterCell class]) forIndexPath:indexPath];
        cell.order = self.order.mallOrder;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        QGEduOrderDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGEduOrderDetailCell class]) forIndexPath:indexPath];
        cell.mallOrder = self.order.mallOrder;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGSize size = [_tableView sizeForCellWithCellClass:[QGEduOrderHeaderCell class] cacheByIndexPath:indexPath width:self.view.width configuration:^(QGCell *cell) {
            QGEduOrderHeaderCell *headcell = (QGEduOrderHeaderCell *)cell;
            headcell.order = self.order.mallOrder;
        }];
        return size.height;
    }else if (indexPath.row == 2){
        CGSize size = [_tableView sizeForCellWithCellClass:[QGActivOrderFooterCell class] cacheByIndexPath:indexPath width:self.view.width configuration:^(QGCell *cell) {
            QGActivOrderFooterCell *footcell = (QGActivOrderFooterCell *)cell;
            footcell.order = self.order.mallOrder;
        }];
        return size.height;
    }
    CGSize size = [_tableView sizeForCellWithCellClass:[QGEduOrderDetailCell class] cacheByIndexPath:indexPath width:self.view.width configuration:^(QGCell *cell) {
        QGEduOrderDetailCell *footcell = (QGEduOrderDetailCell *)cell;
        footcell.mallOrder = self.order.mallOrder;
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
    
    if (indexPath.row == 1) {
        QGMallOrderModel *order = self.order.mallOrder;;
        QGCourseDetailViewController *vc = [QGCourseDetailViewController new];
        
          for (QGMallGoodsModell *model in order.goods) {
               vc.course_id = [@(model.goodsID) stringValue];
              [self.navigationController pushViewController:vc animated:YES];}
    }

}


#pragma mark - Action

- (void)goStoreVC{
    QGOrgViewController *vc = [[QGOrgViewController alloc] init];
    vc.org_id =[NSString stringWithFormat:@"%ld",(long)self.order.mallOrder.Sid];
    [self.navigationController pushViewController:vc animated:YES];
//    QGStoreListViewController *vc = [QGStoreListViewController new];
//    vc.shop_id = [NSString stringWithFormat:@"%ld",(long)self.order.mallOrder.Sid];
//    [self.navigationController pushViewController:vc animated:YES];
    
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

- (void)refundAction:(UIButton *)button{
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderBottomKey);
    if ([order isKindOfClass:[QGMallOrderModel class]]) {
        
        [self.view showIndicator];
        @weakify(self);
        [QGHttpManager getMallOrderCancelReasonWithOrdertype:order.orderType Success:^(NSURLSessionDataTask *task, id responseObject) {
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

}

- (void)cancelAction:(UIButton *)button {
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderBottomKey);
    if ([order isKindOfClass:[QGMallOrderModel class]]) {
        
        [self.view showIndicator];
        @weakify(self);
        [QGHttpManager getMallOrderCancelReasonWithOrdertype:order.orderType Success:^(NSURLSessionDataTask *task, id responseObject) {
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
    QGActivOrderModel *Acitvorder = self.order;
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderBottomKey);
    if ([order isKindOfClass:[QGMallOrderModel class]]) {
        QGOrderPayViewController *vc = [[QGOrderPayViewController alloc]init];
        vc.order_type = [@(order.orderType) stringValue];
        vc.order_id = [@(order.orderID) stringValue];
        vc.pay_amount = [NSString stringWithFormat:@"%f",order.orderAmount];
        vc.edu_id =  [@(Acitvorder.activID) stringValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        QGMallOrderStatus oldStatus = self.order.mallOrder.orderStatus;
        self.order.mallOrder.orderStatus = QGMallOrderStatusCancel;
        [self.tableView reloadData];
        [self configBottomTool];
        @weakify(self);
        [self.view showIndicator];
        [QGHttpManager cancelOrderWithOrderID:self.order.mallOrder.orderID Reason:reason Success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.view hideIndicator];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
            self.order.mallOrder.orderStatus = oldStatus;
            [self.tableView reloadData];
            [self configBottomTool];
        }];
    }else{
        QGMallOrderStatus oldStatus = self.order.mallOrder.orderStatus;
        self.order.mallOrder.orderStatus = QGMallOrderStatusSystemRefund;
        [self.tableView reloadData];
        [self configBottomTool];
        @weakify(self);
        [self.view showIndicator];
        [QGHttpManager cancelOrderWithOrderID:self.order.mallOrder.orderID Reason:reason Success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.view hideIndicator];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
            self.order.mallOrder.orderStatus = oldStatus;
            [self.tableView reloadData];
            [self configBottomTool];
        }];
        
    }
    

}


@end
