//
//  QGActivOrderListViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/19.
//
//

#import "QGActivOrderListViewController.h"
#import "QGTableView.h"
#import "QGorderListHeader.h"
#import "QGOrderListFooter.h"
#import "QGMallOrderCell.h"
#import "QGHttpManager+Order.h"
#import "VTMagic.h"
#import "QGActivOrderCell.h"
#import "QGSelectOrderCancelReasonViewController.h"
#import "QGActivOrderDetailViewController.h"
#import "QGAlertView.h"
#import "QGOrderPayViewController.h"
#import "QGActivityDetailViewController.h"
#import "QGStoreListViewController.h"

static void * const kOrderKey = "kOrderKey";
@interface QGActivOrderListViewController () <UITableViewDelegate,UITableViewDataSource,QGSelectOrderCancelReasonDelegate>

@property(nonatomic, strong)NSArray *pickViewDataArray;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) QGTableView *tableView;

@property (nonatomic, strong) QGMallOrderModel *selectOrder;

@property (nonatomic, strong) UILabel *cannotFindLabel;
@property (nonatomic, strong) UIImageView *cannotFindImageView;
@property (nonatomic, strong) UIView *cannotFindView;
@property (nonatomic, assign) BOOL showNoContentPrompt;

@end

@implementation QGActivOrderListViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Table view
    _tableView = [[QGTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorFromHexString:@"ececec"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[QGorderListHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([QGorderListHeader class])];
    [_tableView registerClass:[QGOrderListFooter class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([QGOrderListFooter class])];
    [_tableView registerClass:[QGActivOrderCell class] forCellReuseIdentifier:NSStringFromClass([QGActivOrderCell class])];
    
    @weakify(self);
    self.tableView.mj_header =
    [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [QGHttpManager getActivOrderListWithPage:self.page orderStatus:self.orderStatus Success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.view hideIndicator];
            [self tableViewEndRefreshing:self.tableView];
            [_dataArr removeAllObjects];
            [self configDataWith:responseObject];
            [self.tableView reloadData];
            self.page ++;
            [self showCannotViewIfNeed];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
        }];
        
    }];
    
    self.tableView.mj_footer =
    [BLURefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.view hideIndicator];
        if (self.page < 1) {
            return;
        }
        [QGHttpManager getActivOrderListWithPage:self.page orderStatus:self.orderStatus Success:^(NSURLSessionDataTask *task, id responseObject) {
            self.page ++;
            [self.view hideIndicator];
            [self configDataWith:responseObject];
            NSArray *arr = responseObject;
            [self tableViewEndRefreshing:self.tableView noMoreData:arr.count == 0];
            [self showCannotViewIfNeed];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
        }];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self.view showIndicator];
    self.page = 1;
    [QGHttpManager getActivOrderListWithPage:self.page orderStatus:self.orderStatus Success:^(NSURLSessionDataTask *task, id responseObject) {
        self.page ++;
        [self.view hideIndicator];
        [_dataArr removeAllObjects];
        [self configDataWith:responseObject];
        [self.tableView reloadData];
        [self showCannotViewIfNeed];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view hideIndicator];
        [self showTopIndicatorWithError:error];
    }];
}

- (void)viewWillFirstAppear{
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat bottomlength = 0.0;
    if ([self.parentViewController isKindOfClass:[VTMagicController class]]) {
        bottomlength = 108;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, bottomlength, 0);
}

- (void)configDataWith:(NSArray *)data{
    [self.dataArr addObjectsFromArray:data];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    [self showCannotViewIfNeed];
    QGMallOrderModel *order = self.dataArr[section];
    return order.goods.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGActivOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGActivOrderCell class]) forIndexPath:indexPath];
    QGMallOrderModel *model = self.dataArr[indexPath.section];
    orderCell.order = model.goods[indexPath.row];
    
    return orderCell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [_tableView sizeForCellWithCellClass:[QGActivOrderCell class] cacheByIndexPath:indexPath width:self.view.width configuration:^(QGCell *cell) {
        QGActivOrderCell *goodscell = (QGActivOrderCell *)cell;
        QGMallOrderModel *model = self.dataArr[indexPath.section];
       
        goodscell.order = model.goods[indexPath.row];
    }];
    return size.height;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    QGorderListHeader *header =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:
     NSStringFromClass([QGorderListHeader class])];
    
    QGMallOrderModel *order = self.dataArr[section];
    [header setOrder:order];
    
    [header.Clickbutton addTarget:self action:@selector(goToStore:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(header.Clickbutton,
                             @"headerKey",
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
    return header;
}

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section {
    QGOrderListFooter *footer =
    [tableView
     dequeueReusableHeaderFooterViewWithIdentifier:
     NSStringFromClass([QGOrderListFooter class])];
    
    footer.type = QGOrderFooterTypeActiv;
    
    QGMallOrderModel *order = self.dataArr[section];
    
    [footer setOrder:order];
    
    [footer.cancelButton addTarget:self
                            action:@selector(cancelAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(footer.cancelButton,
                             kOrderKey,
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [footer.deleteButton addTarget:self
                            action:@selector(deleteAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(footer.deleteButton,
                             kOrderKey,
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [footer.submitButton addTarget:self
                            action:@selector(submitAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(footer.submitButton,
                             kOrderKey,
                             order,
                             OBJC_ASSOCIATION_ASSIGN);
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return [QGorderListHeader userOrderHeaderHeight];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return [QGOrderListFooter userOrderFooterHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        QGActivOrderDetailViewController *vc = [QGActivOrderDetailViewController new];
        QGMallOrderModel *order = self.dataArr[indexPath.section];
        if (order) {
            vc.orderID = order.orderID;
        }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (void)goToStore:(UIButton *)button{
    QGMallOrderModel *order = objc_getAssociatedObject(button, @"headerKey");
    QGStoreListViewController *vc = [QGStoreListViewController new];
    vc.shop_id = [NSString stringWithFormat:@"%ld",(long)order.Sid];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)deleteAction:(UIButton *)button {
    
    
    QGAlertView *alt = [[QGAlertView alloc]initWithTitle:@"确定要删除该订单吗" message:@"删除过后订单消失，且不可恢复哦!" cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderKey);
    @weakify(self);
    alt.otherButtonAction = ^{
        if ([order isKindOfClass:[QGMallOrderModel class]]) {
            [QGHttpManager deleteOrderWithOrderID:order.orderID Success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(self);
                NSMutableArray *orders = [NSMutableArray arrayWithArray:self.dataArr];
                NSInteger index = [orders indexOfObject:order];
                [orders removeObject:order];
                self.dataArr = orders;
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index]
                              withRowAnimation:UITableViewRowAnimationFade];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self showTopIndicatorWithError:error];
            }];
        }
    };
    
    [alt show];
}

- (void)cancelAction:(UIButton *)button {
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderKey);
    if ([order isKindOfClass:[QGMallOrderModel class]]) {
        self.selectOrder = order;
        @weakify(self);
        [QGHttpManager getMallOrderCancelReasonWithOrdertype:20 Success:^(NSURLSessionDataTask *task, id responseObject) {
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
    
    QGMallOrderModel *order = objc_getAssociatedObject(button, kOrderKey);
        if ([order isKindOfClass:[QGMallOrderModel class]]) {
            QGOrderPayViewController *vc = [[QGOrderPayViewController alloc]init];
            vc.order_type = [@(order.orderType) stringValue];
            vc.order_id = [@(order.orderID) stringValue];
            vc.activity_id =  @"100";
            vc.pay_amount = [NSString stringWithFormat:@"%f",order.orderAmount];

            [self.navigationController pushViewController:vc animated:YES];
        }
}


#pragma mark -  PickerView
- (void)showPickViewWithType:(QGPickViewType)type{
    
    QGSelectOrderCancelReasonViewController *vc = [QGSelectOrderCancelReasonViewController new];
    //    vc.delegate = self;
    vc.view.backgroundColor = [UIColor colorFromHexString:@"999999" alpha:0.4];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0,-44, self.view.width, self.view.height+44);
    vc.delegate = self;
    vc.type = type;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    vc.view.alpha = 0.0;
    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        vc.view.alpha = 1.0;
    }];
    vc.pickViewDataArray = self.pickViewDataArray;
    
}

- (void)SelectOrderCancelReason:(NSString *)reason andType:(QGPickViewType)type{
    QGMallOrderModel *order = nil;
    for ( QGMallOrderModel * model in self.dataArr) {
        if (self.selectOrder.orderID == model.orderID) {
            order = model;
        }
    }
    if (type == QGPickViewTypeCannel) {
        QGMallOrderStatus oldStatus = order.orderStatus;
        order.orderStatus = QGMallOrderStatusCancel;
        [self.tableView reloadData];
        @weakify(self);
        [self.view showIndicator];
        [QGHttpManager cancelOrderWithOrderID:order.orderID Reason:reason Success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.view hideIndicator];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
            order.orderStatus = oldStatus;
            [self.tableView reloadData];
        }];
    }else{
        QGMallOrderStatus oldStatus = order.orderStatus;
        order.orderStatus = QGMallOrderStatusSystemGoodsBack;
        [self.tableView reloadData];
        @weakify(self);
        [self.view showIndicator];
        [QGHttpManager OrderAftersalesWithOrderID:order.orderID Reason:reason Success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.view hideIndicator];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
            order.orderStatus = oldStatus;
            [self.tableView reloadData];
        }];
        
    }
    
}


#pragma mark - showNODataView

- (UIImageView *)cannotFindImageView {
    if (_cannotFindImageView == nil) {
        _cannotFindImageView = [UIImageView new];
        _cannotFindImageView.image = [UIImage imageNamed:@"search-notfind"];
    }
    return _cannotFindImageView;
}

- (UILabel *)cannotFindLabel {
    if (_cannotFindLabel == nil) {
        _cannotFindLabel = [UILabel new];
        _cannotFindLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00];
         _cannotFindLabel.text = @"你还没有购买过呢~";
//        switch (self.orderStatus) {
//            case QGMallOrderStatusAll:
//            {
//               
//            }break;
//            case QGMallOrderStatusPayment:
//            {
//                _cannotFindLabel.text = @"当前没有未支付订单哦~";
//            }break;
//            case QGMallOrderStatusSend:
//            {
//                _cannotFindLabel.text = @"当前没有待发货订单哦~";
//            }break;
//            case QGMallOrderStatusDidSend:
//            {
//                _cannotFindLabel.text = @"当前没有待收货订单哦~";
//            }break;
//                
//                
//            default:
//                break;
//        }
        
    }
    return _cannotFindLabel;
}

- (UIView *)cannotFindView {
    if (_cannotFindView == nil) {
        _cannotFindView = [UIView new];
    }
    return _cannotFindView;
}

- (void)configCannotView {
    
    [self.view addSubview:self.cannotFindView];
    [self.cannotFindView addSubview:self.cannotFindImageView];
    [self.cannotFindView addSubview:self.cannotFindLabel];
    
    [self.cannotFindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(- 40);
    }];
    
    UIView *superview = self.cannotFindView;
    
    [self.cannotFindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview);
        make.left.greaterThanOrEqualTo(superview);
        make.right.lessThanOrEqualTo(superview);
        make.centerX.equalTo(superview);
    }];
    
    [self.cannotFindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cannotFindImageView.mas_bottom).offset(BLUThemeMargin * 2);
        make.centerX.equalTo(superview);
        make.left.greaterThanOrEqualTo(superview);
        make.right.lessThanOrEqualTo(superview);
        make.bottom.equalTo(superview);
    }];
}

- (void)showCannotViewIfNeed {
    if (![self.view isDescendantOfView:self.cannotFindView]) {
        [self configCannotView];
    }
    NSInteger count =  self.dataArr.count;
    self.cannotFindView.hidden = count <= 0 ? NO : YES;
}

@end
