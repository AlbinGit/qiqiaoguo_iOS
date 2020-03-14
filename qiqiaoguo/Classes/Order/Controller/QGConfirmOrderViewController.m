//
//  QGConfirmOrderViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/25.
//
//

#import "QGConfirmOrderViewController.h"
#import "QGSelectAddressView.h"
#import "QGConfirmOrderGoodsCell.h"
#import "QGConfirmOrderHeader.h"
#import "QGGoodsMO.h"
#import "QGConfirmOrderFooter.h"
#import "QGOrderAddressViewController.h"
#import "QGHttpManager+ShopCar.h"
#import "QGHttpManager+Activity.h"
#import "QGOrderPayViewController.h"
#import "QGAlertView.h"

@interface QGConfirmOrderViewController () <UITableViewDelegate,UITableViewDataSource,QGLogisticsEditViewControllerDelegate>

@property (nonatomic, strong) QGSelectAddressView *selectAddView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) QGAddressModel *address;
@property (nonatomic, strong) NSArray * OrderFeeArray;
@property (nonatomic, copy) NSString *idCardStr;

@end

@implementation QGConfirmOrderViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"确认订单";
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = APPBackgroundColor;
    // Table view
    _tableView = [[QGTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = APPBackgroundColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = self.selectAddView;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[QGConfirmOrderGoodsCell class] forCellReuseIdentifier:NSStringFromClass([QGConfirmOrderGoodsCell class])];
        [_tableView registerClass:[QGConfirmOrderFooter class] forCellReuseIdentifier:NSStringFromClass([QGConfirmOrderFooter class])];
    [_tableView registerClass:[QGConfirmOrderHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([QGConfirmOrderHeader class])];
    
    
    
//    RAC(self.selectAddView.idCardTextButton,enabled) = [RACSignal
//                                     combineLatest:@[self.selectAddView.idCardTextField.rac_textSignal
//                                                     ]
//                                     reduce:^(NSString *idCard){
//                                         return @([idCard isIDCard]);
//                                     }];

    RAC(self, idCardStr) = self.selectAddView.idCardTextField.rac_textSignal;
    [self constructToolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    [self configData];
    [self loadAddress];
}

- (void)viewDidLayoutSubviews{
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0,98, 0);
}


- (void)configData {
    
    [_dataArray removeAllObjects];
    
    if (self.type == QGConfirmOrderTypeSecondkilling) {
        // 如果是秒杀商品就拉取秒杀的商品
        [_dataArray addObject:[self FindSendKillingGoods]];
        [self.tableView reloadData];
        return;
    }else if (self.type == QGConfirmOrderTypeBuyNow || self.type == QGConfirmOrderTypeGlobalAndBuyNow){
        // 拉取立即购买的商品
        [_dataArray addObject:[self FindBuyNowGoods]];
        [self.tableView reloadData];
        return;
    }
    NSArray *goodMOs = [self FindAllSelectGoods];

    NSMutableArray *mar = [NSMutableArray arrayWithArray:goodMOs];
    NSMutableArray *dataArr = [NSMutableArray array];
    while (mar.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        QGGoodsMO *goods = [mar firstObject];
        [arr addObject:goods];
        [mar removeObject:goods];
        if (mar.count == 0) {
            [dataArr addObject:arr];
            break;
        }
        NSArray *index = [NSArray arrayWithArray:mar];
        for (QGGoodsMO *good in index) {
            if (good.storeID == goods.storeID) {
                [arr addObject:good];
                [mar removeObject:good];
            }
        }
        [dataArr addObject:arr];
    }
    _dataArray = dataArr;
    [self.tableView reloadData];
}

- (NSArray *)FindAllSelectGoods {
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:
     @"selected == %@ && isSeckilling ==%@",@(YES),@(NO)];
    NSArray *arr = [QGGoodsMO MR_findAllWithPredicate:predicate];
    return arr;
}

- (NSArray *)FindSendKillingGoods {
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:
     @"isSeckilling ==%@",@(YES)];
    NSArray *arr = [QGGoodsMO MR_findAllWithPredicate:predicate];
    return arr;
}

- (NSArray *)FindBuyNowGoods {
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:
     @"isBuyNow ==%@",@(YES)];
    NSArray *arr = [QGGoodsMO MR_findAllWithPredicate:predicate];
    return arr;
}

#pragma mark - UI

- (void)constructToolbar {
    
    _toolbar = [UIToolbar new];

    _toolbar.backgroundColor = [UIColor whiteColor];
    
   
    
    [self.view addSubview:_toolbar];
    [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(68));
    }];
    _priceLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _priceLabel.textColor = QGMainRedColor;
    [self.toolbar addSubview:self.amountLabel];
    
    [self.toolbar addSubview:self.priceLabel];
    [self.view addSubview:self.submitButton];
    
    UIView *superview = self.toolbar;
    self.submitButton.frame = CGRectMake(self.view.width-140, self.view.height - 88-100, 140, 68);
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.right.equalTo(superview);
        make.bottom.equalTo(superview);
        make.width.equalTo(@(140));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.submitButton.mas_left).offset(-BLUThemeMargin * 2);
        make.centerY.equalTo(superview);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left).offset(-BLUThemeMargin);
        make.centerY.equalTo(superview);
    }];
    
    
}

- (void)updateToolbar{
    
    CGFloat price = 0.0;
    NSMutableArray *Marr = [NSMutableArray array];
    for (NSArray *arr in _dataArray) {
        for (QGGoodsMO *good in arr) {
            [Marr addObject:good];
        }
    }
    
    NSArray *goodMOs = Marr;
    for (QGGoodsMO *good in goodMOs) {
        price += good.goodsCount.integerValue * good.price.floatValue;
    }
    if (_OrderFeeArray) {
        for (NSDictionary *dic in _OrderFeeArray) {
            price += [dic[@"deliverFee"] floatValue];
        }
    }
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",price];
}


- (UIView *)selectAddView{
    if (_selectAddView == nil) {
        _selectAddView = [QGSelectAddressView new];
        @weakify(self);
        [[_selectAddView.SelectAddressButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
            QGOrderAddressViewController *vc = [QGOrderAddressViewController new];
            vc.delegate = self;
            QGAddressModel *model = self.address;
            vc.address = model;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
    }
    _selectAddView.type = self.type;
    _selectAddView.height = _selectAddView.headHeight;

    
    return _selectAddView;
}

- (void)setType:(QGConfirmOrderType)type{
    _type = type;
    self.selectAddView.type = type;
}



- (UILabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _amountLabel.text = @"合计:";
    }
    return _amountLabel;
}

- (UIButton *)submitButton {
    if (_submitButton == nil) {
        _submitButton = [UIButton new];
        _submitButton.backgroundColor = BLUThemeMainColor;
        [_submitButton setTitleColor:[UIColor blackColor]
                            forState:UIControlStateNormal];
        [_submitButton addTarget:self
                          action:@selector(submitAction:)
                forControlEvents:UIControlEventTouchUpInside];
        NSString *title = NSLocalizedString(@"confirm-order-vc.submit-button.title",
                                            @"Submit");
        
        [_submitButton setTitle:title forState:UIControlStateNormal];
    }
    return _submitButton;
}

- (void)loadAddress {

    @weakify(self);
    [QGHttpManager getDefultAddressSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        self.address = responseObject;
        self.selectAddView.address = self.address;
        if (![self.idCardStr isIDCard]) {
            self.idCardStr = self.address.idCard;
        }
        // 成功拉取到地址后在拉取运费
        [self getcountOrderFee];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self tableViewEndRefreshing:self.tableView];
        self.address = nil;
        self.selectAddView.address = nil;
    }];
}

- (void)getcountOrderFee{
    [self configData];
    if (_dataArray.count == 0) {
        return;
    }
    [self.view showIndicator];
    @weakify(self);
    [QGHttpManager fetchCountOrderFeeWithGoodsArray:self.dataArray Address:self.address Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self.view hideIndicator];
        _OrderFeeArray = responseObject;
        [self.tableView reloadData];
        [self updateToolbar];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self.view hideIndicator];
        [self showTopIndicatorWithError:error];
    }];
}

- (void)messageFieldValueChange:(UITextField *)field{
    
    NSArray *arr = _dataArray[field.tag];
    for (QGGoodsMO *goosmo in arr) {
        goosmo.remark = field.text;
    }
    
}

#pragma mark - Action

- (void)submitAction:(UIButton *)button{
    
    if (!self.address) {
        [self showTopIndicatorWithWarningMessage:@"请填写完整的收货地址"];
        return;
    }
    
    if (self.type == QGConfirmOrderTypeGlobal || self.type == QGConfirmOrderTypeGlobalAndBuyNow) {
        if (![self.idCardStr isIDCard]) {
            [self showTopIndicatorWithWarningMessage:@"请输入正确的身份证号码"];
            return;
        }

    if (self.address.cityDetail && self.address.city) {
        return;
    }
    self.address.idCard = self.idCardStr;
    
    QGAlertView *alert = [[QGAlertView alloc]initWithTitle:nil message:@"海关要求收件人姓名和身份证号必须匹配才能配送，你确认了吗?" cancelButtonTitle:@"确认并提交" otherButtonTitle:@"再想想"];
    
    alert.cancelButtonAction = ^{
        [self.view showIndicator];
        @weakify(self);
        [QGHttpManager submitOrderWithGoodsArray:self.dataArray Address:self.address Success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self.view hideIndicator];
            for (NSArray *arr  in self.dataArray) {
                for (QGGoodsMO *goods in arr) {
                    [goods MR_deleteEntity];
                    
                }
            }
            QGOrderPayViewController *vc = [[QGOrderPayViewController alloc]init];
            vc.order_id = responseObject[@"order_id"];
            vc.order_type =  responseObject[@"order_type"];
            vc.pay_amount = responseObject[@"pay_amount"];
            vc.ConfirmOrderType = self.type;
            if (responseObject[@"is_batch_pay"]) {
                vc.is_batch_pay = responseObject[@"is_batch_pay"];
            }
            
            [self.navigationController pushViewController:vc animated:YES];
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                
            }];
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
        }];

    };
    
    [alert show];
    
        
    }else{
        [self.view showIndicator];
        @weakify(self);
        [QGHttpManager submitOrderWithGoodsArray:self.dataArray Address:self.address Success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self.view hideIndicator];
            for (NSArray *arr  in self.dataArray) {
                for (QGGoodsMO *goods in arr) {
                    [goods MR_deleteEntity];
                    
                }
            }
            QGOrderPayViewController *vc = [[QGOrderPayViewController alloc]init];
            vc.order_id = responseObject[@"order_id"];
            vc.order_type =  responseObject[@"order_type"];
            vc.pay_amount =responseObject[@"pay_amount"];
            vc.ConfirmOrderType = self.type;
            if (responseObject[@"is_batch_pay"]) {
                vc.is_batch_pay = responseObject[@"is_batch_pay"];
            }
            
            [self.navigationController pushViewController:vc animated:YES];
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                
            }];
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self showTopIndicatorWithError:error];
        }];

    }
    
    
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _dataArray[section];
    return arr.count > 0 ? arr.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [_dataArray[indexPath.section] count])
    {
        QGConfirmOrderFooter *footCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGConfirmOrderFooter class]) forIndexPath:indexPath];
        footCell.selectionStyle = UITableViewCellSelectionStyleNone;
        footCell.goodsArray = _dataArray[indexPath.section];
        QGGoodsMO *good = [_dataArray[indexPath.section] firstObject];
        footCell.userMessageTextField.tag = indexPath.section;
        [footCell.userMessageTextField addTarget:self action:@selector(messageFieldValueChange:) forControlEvents:UIControlEventEditingDidEnd];
        if (_OrderFeeArray.count > 0) {
            for (NSDictionary *dic in _OrderFeeArray) {
                NSString *sid = dic[@"sid"];
                if (sid.integerValue == good.storeID.integerValue) {
                    footCell.dic = dic;
                }
            }
        }
        
        return footCell;
    }
    QGConfirmOrderGoodsCell *orderCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGConfirmOrderGoodsCell class]) forIndexPath:indexPath];
    orderCell.goods = _dataArray[indexPath.section][indexPath.row];
    orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return orderCell;
}


- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_dataArray[indexPath.section] count] ){
      return  [(QGTableView *)tableView sizeForCellWithCellClass:[QGConfirmOrderFooter class] cacheByIndexPath:indexPath width:self.view.width configuration:^(QGCell *cell) {
            
            QGConfirmOrderFooter *footCell = (QGConfirmOrderFooter *)cell;
            footCell.goodsArray = _dataArray[indexPath.section];
            
        }].height;

    }

    return 102;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    QGConfirmOrderHeader *header =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:
     NSStringFromClass([QGConfirmOrderHeader class])];
    QGGoodsMO *goods = [_dataArray[section] firstObject];
    header.storeNameLabel.text = goods.storeName;
    return header;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - Logistics edit

- (void)logisticsEditViewController:(QGOrderAddressViewController *)vc
               updateAddressSuccess:(QGAddressModel *)address {
    self.address = address;
    self.selectAddView.address = address;
    [self showTopIndicatorWithSuccessMessage:@"添加地址成功"];
    
    [self getcountOrderFee];// 更新完地址获取运费
    [self.tableView reloadData];
}

- (void)logisticsEditViewController:(QGOrderAddressViewController *)vc
                updateAddressFailed:(NSError *)error {
    [self showTopIndicatorWithError:error];
}


- (void)dealloc{
    
    // 在确认订单消失时将秒杀和立即购买的数据清空
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:[self FindBuyNowGoods]];
    [arr addObjectsFromArray:[self FindSendKillingGoods]];
    for (QGGoodsMO *mo in arr) {
        [mo MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
    }];
    
}

@end
