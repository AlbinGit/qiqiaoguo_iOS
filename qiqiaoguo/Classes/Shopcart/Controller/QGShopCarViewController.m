//
//  QGShopCarViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/23.
//
//

#import "QGShopCarViewController.h"
#import "QGGoodsMO.h"
#import "QGTableView.h"
#import "QGShopCarCellHeader.h"
#import "QGShopCarCell.h"
#import "QGHttpManager+ShopCar.h"
#import "QGShopCarModel.h"
#import "QGConfirmOrderViewController.h"
#import "QGShopCarAlertView.h"


@interface QGShopCarViewController () <UITableViewDelegate,UITableViewDataSource,QGShopCarCellDeletage>

@property (nonatomic, strong) QGTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *goodsIDArray;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic) NSFetchedResultsController *dataController;

@property (nonatomic) UIButton *settleButton;
@property (nonatomic) UIButton *selectAllButton;
@property (nonatomic) UILabel *totalPrompt;

@property (nonatomic, strong) UILabel *cannotFindLabel;
@property (nonatomic, strong) UIImageView *cannotFindImageView;
@property (nonatomic, strong) UIView *cannotFindView;
@property (nonatomic, assign) BOOL showNoContentPrompt;

@end

@implementation QGShopCarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我的购物车";
        _dataArr = [NSMutableArray array];
        _goodsIDArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // Table view
    _tableView = [[QGTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = APPBackgroundColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[QGShopCarCell class] forCellReuseIdentifier:NSStringFromClass([QGShopCarCell class])];
    [_tableView registerClass:[QGShopCarCellHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([QGShopCarCellHeader class])];
    
    [self constructToolbar];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self configData];
    [self updateToolbar];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
    }];
}

- (void)viewDidLayoutSubviews{
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0,98, 0);
}


- (void)constructToolbar {
    
    _toolbar = [UIToolbar new];
    _toolbar.backgroundColor = [UIColor whiteColor];
    _toolbar.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
    [self.view addSubview:_toolbar];
    [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    
    UIView *superview = self.toolbar;
    UILabel *titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
    titleLabel.textColor = QGMainContentColor;
    titleLabel.text = @"仅商品";
    
    [superview addSubview:self.selectAllButton];
    [superview addSubview:self.settleButton];
    [superview addSubview:self.totalPrompt];
    [superview addSubview:titleLabel];
    
    [self.selectAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview).offset(BLUThemeMargin * 2 + 1);
        make.centerY.equalTo(superview);
    }];
    
    [self.settleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(superview);
        make.width.equalTo(@(100));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview);
        make.right.equalTo(self.settleButton.mas_left).offset(-BLUThemeMargin * 2);
    }];
    
    [self.totalPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview);
        make.right.equalTo(titleLabel.mas_left).offset(-BLUThemeMargin * 2);
    }];
}


- (void)updateToolbar {
    NSArray *goodMOs = [self.dataController fetchedObjects];
    
    BOOL selectedAll = YES;
    CGFloat price = 0.0;
    NSInteger count = 0;
    
    for (QGGoodsMO *goodMO in goodMOs) {
        if (goodMO.selected.boolValue == NO) {
            selectedAll = NO;
        }
        if (goodMO.selected.boolValue == YES){
            price += goodMO.price.floatValue * goodMO.goodsCount.integerValue;
            count++;
        }
    }
    
    if (selectedAll) {
        self.selectAllButton.selected = YES;
    } else {
        self.selectAllButton.selected = NO;
    }
    
    self.totalPrompt.attributedText = [self attributedTotalText:@(price)];
    [self.settleButton setTitle:[self settleTextWithCount:@(count)]
                       forState:UIControlStateNormal];
}

- (UIButton *)settleButton {
    if (_settleButton == nil) {
        _settleButton = [UIButton new];
        _settleButton.backgroundColor = BLUThemeMainColor;
        _settleButton.showsTouchWhenHighlighted = YES;
        _settleButton.adjustsImageWhenDisabled = YES;
        _settleButton.adjustsImageWhenHighlighted = YES;
        _settleButton.reversesTitleShadowWhenHighlighted = YES;
        
        [_settleButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
        
        [_settleButton addTarget:self action:@selector(settleAction:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _settleButton;
}

- (UIButton *)selectAllButton {
    if (_selectAllButton == nil) {
        _selectAllButton = [UIButton new];
        
        [_selectAllButton setImage:[UIImage imageNamed:@"toy-deselected"]
                          forState:UIControlStateNormal];
        [_selectAllButton setImage:[UIImage imageNamed:@"toy-selected"]
                          forState:UIControlStateSelected];
        
        NSString *title =
        NSLocalizedString(@"shopping-cart-vc.select-all-button.title",
                          @"Select all");
        title = [NSString stringWithFormat:@"  %@", title];
        
        [_selectAllButton setTitle:title
                          forState:UIControlStateNormal];
        
        [_selectAllButton setTitleColor:[UIColor colorFromHexString:@"999999"]
                               forState:UIControlStateNormal];
        [_selectAllButton addTarget:self
                             action:@selector(selectAll:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAllButton;
}

- (UILabel *)totalPrompt {
    if (_totalPrompt == nil) {
        _totalPrompt = [UILabel new];
    }
    return _totalPrompt;
}

- (NSAttributedString *)attributedTotalText:(NSNumber *)amount {
    BLUAssertObjectIsKindOfClass(amount, [NSNumber class]);
    
    NSString *amountText = [NSString stringWithFormat:@"¥%0.2f", amount.floatValue];
    NSString *promptText =
    NSLocalizedString(@"shopping-cart-vc.toolbar.amount-prompt", @"Amount:");
    
    NSString *text = [NSString stringWithFormat:@"%@ %@", promptText, amountText];
    
    NSMutableAttributedString *attrText =
    [[NSMutableAttributedString alloc] initWithString:text];
    
    [attrText addAttribute:NSFontAttributeName
                     value:BLUThemeMainFontWithSize(17.0)
                     range:NSMakeRange(0, text.length)];
    
    [attrText addAttribute:NSForegroundColorAttributeName
                     value:BLUThemeMainColor
                     range:[text rangeOfString:amountText]];
    
    [attrText addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorFromHexString:@"666666"]
                     range:[text rangeOfString:promptText]];
    
    return attrText;
}

- (NSString *)settleTextWithCount:(NSNumber *)count {
    NSString *promptStr = NSLocalizedString(@"shopping-cart-vc.settle-button.settle", @"settle");
    NSString *text = [NSString stringWithFormat:@"%@(%@)", promptStr, count];
    return text;
}

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
        _cannotFindLabel.text = @"购物车空空如也~";
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
        make.centerX.centerY.equalTo(self.view);
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
        make.left.greaterThanOrEqualTo(superview);
        make.right.lessThanOrEqualTo(superview);
        make.bottom.equalTo(superview);
    }];
}

- (void)showCannotViewIfNeed {
    if (![self.view isDescendantOfView:self.cannotFindView]) {
        [self configCannotView];
    }
    
    NSInteger count = self.dataArr.count;
    
    self.cannotFindView.hidden = count <= 0 ? NO : YES;
    
    self.toolbar.hidden = !self.cannotFindView.hidden;
}

#pragma mark - Model

- (NSFetchedResultsController *)dataController {
    if (_dataController == nil) {
        _dataController =  [self shoppingCartFRC];
    }
    return _dataController;
}

- (void)configData {
    [_goodsIDArray removeAllObjects];
    NSArray *goodMOs = [self FindAllGoods];
    for (QGGoodsMO *goodsmo in goodMOs) {
        goodsmo.selected = @(NO);
        goodsmo.remark = @"";
        [_goodsIDArray addObject:goodsmo];
    }
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
    [_dataArr removeAllObjects];
    [_dataArr addObjectsFromArray:dataArr];
    [self.tableView reloadData];
    [self updateToolbar];
    [self showCannotViewIfNeed];
}

- (void)updateData{
    if (_goodsIDArray.count == 0) {
        return;
    }
    @weakify(self);
    [QGHttpManager checkInventoryWithGoodsIDs:self.goodsIDArray Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        NSArray *shopCarModelArray = responseObject;
        for (QGShopCarModel *model in shopCarModelArray) {
            QGGoodsMO *goodsmo = [self findGoodsMOWithGoodsID:model.goodsID];
            goodsmo.inventory = @(model.goodsInventory);
            goodsmo.price = @(model.goodsPrice);
            goodsmo.name = model.goodsName;
        }
        [self.tableView reloadData];
        [self updateToolbar];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showTopIndicatorWithError:error];
    }];

}

- (NSFetchedResultsController *)shoppingCartFRC {
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:
     @"goodsCount > 0 && isSeckilling == %@",@(NO)];

    return [QGGoodsMO MR_fetchAllSortedBy:nil
                                ascending:NO
                            withPredicate:predicate
                                  groupBy:nil
                                 delegate:nil];
}

- (NSArray *)FindAllSelectGoods {
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:
     @"selected == %@ && isSeckilling == %@",@(YES),@(NO)];
    NSArray *arr = [QGGoodsMO MR_findAllWithPredicate:predicate];
    return arr;
}

- (NSArray *)FindAllGoods {
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:
     @"isSeckilling == %@",@(NO)];
    NSArray *arr = [QGGoodsMO MR_findAllWithPredicate:predicate];
    return arr;
}


#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGShopCarCell *shopCarCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGShopCarCell class]) forIndexPath:indexPath];
    shopCarCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    QGGoodsMO *goods = self.dataArr[indexPath.section][indexPath.row];
    shopCarCell.goods = goods;
    shopCarCell.delegate = self;

    return shopCarCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 102;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    [self showCannotViewIfNeed];
    return [_dataArr[section] count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QGShopCarCellHeader *header =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:
     NSStringFromClass([QGShopCarCellHeader class])];
    
    NSArray *goodsArr = self.dataArr[section];
    header.goodsArray = goodsArr;
    header.Clickbutton.tag = section;
    [header.Clickbutton addTarget:self action:@selector(headerSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QGGoodsMO *goodMO = self.dataArr[indexPath.section][indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [goodMO MR_deleteEntity];
        NSMutableArray *goodsArr = self.dataArr[indexPath.section];
        [goodsArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        if (goodsArr.count == 0) {
            [self.dataArr removeObject:goodsArr];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                          withRowAnimation:UITableViewRowAnimationTop];
        }
        
    }
    [self showCannotViewIfNeed];
    [self updateToolbar];
}

#pragma mark - QGShopCarCellDeletage

- (void)selectButtonClick:(UIButton *)button{
    button.selected = !button.selected;
    NSInteger goodsID = button.tag;
    
    QGGoodsMO *goodsmo = [self findGoodsMOWithGoodsID:goodsID];
    
    if (goodsmo.goodsCount.integerValue > goodsmo.inventory.integerValue) {
        [self showTopIndicatorWithErrorMessage:@"该商品库存不足~"];
        button.selected = NO;
    }else{
        goodsmo.selected = @(button.selected);
    }
    
    [self.tableView reloadData];
    [self updateToolbar];
}

- (void)increaseButtonClick:(UIButton *)button{
    NSInteger goodsID = button.tag;
    
    QGGoodsMO *goodsmo = [self findGoodsMOWithGoodsID:goodsID];
    if (goodsmo.goodsCount.integerValue < goodsmo.inventory.integerValue) {
        goodsmo.goodsCount = @(goodsmo.goodsCount.integerValue + 1);
    } else {
        button.enabled = NO;
    }

    [self.tableView reloadData];
    [self updateToolbar];
}

- (void)ReductionButtonClick:(UIButton *)button{
    NSInteger goodsID = button.tag;
    
    QGGoodsMO *goodsmo = [self findGoodsMOWithGoodsID:goodsID];
    if (goodsmo.goodsCount.integerValue > 1) {
        goodsmo.goodsCount = @(goodsmo.goodsCount.integerValue - 1);
    }else{
    button.enabled = NO;
    }
    [self.tableView reloadData];
    [self updateToolbar];
}

#pragma mark - Action

- (void)headerSelectButtonClick:(UIButton *)button{
    
    button.selected = !button.selected;
    NSArray *goodsmoArr = _dataArr[button.tag];
    int count = 0;
    for (QGGoodsMO* goods in goodsmoArr) {
        if (goods.goodsCount.integerValue > goods.inventory.integerValue) {
            count++;
        }else{
            goods.selected = @(button.selected);
        }
    }
    
    if (count > 0) {
        [self showTopIndicatorWithErrorMessage:[NSString stringWithFormat:@"有%d件商品库存不足~",count]];
    }
    
    [self.tableView reloadData];
    [self updateToolbar];
}

- (void)selectAll:(UIButton *)button {
    button.selected = !button.selected;
    int count = 0;
    NSArray *goodMOs = self.dataArr;
    for (NSArray *goodMOArr in goodMOs) {
        for (QGGoodsMO *goodMO in goodMOArr) {
            if (goodMO.goodsCount.integerValue >
                goodMO.inventory.integerValue) {
                count += 1;
                goodMO.selected = @(NO);
                continue;
            }
            goodMO.selected = @(button.selected);
        }
    }
    if (count > 0) {
        button.selected = NO;
        [self showTopIndicatorWithWarningMessage:[NSString stringWithFormat:@"有%d件商品库存不足,请重新选择",count]];
    }
    
    [self.tableView reloadData];
    [self updateToolbar];
    
}

- (void)needUpdateDataWith:(int)index{
    QGConfirmOrderType type = QGConfirmOrderTypeOrdinary;
    NSArray *selectGoodsArr = [self FindAllSelectGoods];
    for (QGGoodsMO *goods in selectGoodsArr) {
        if (goods.deliveryType.integerValue == 3 && index == 1) {
            goods.selected = @(NO);
           
        }else if (goods.deliveryType.integerValue != 3 && index == 0){
            goods.selected = @(NO);
            type = QGConfirmOrderTypeGlobal;
        }
    }
    [self gotoReplaceWithGoodstype:type];
}

- (void)settleAction:(id)sender {
    
    if ([self loginIfNeeded]) {
        return;
    }
    
    // 判断是否有商品选中
    NSArray *selectGoodsArr = [self FindAllSelectGoods];
    if (selectGoodsArr.count == 0) {
        [self showTopIndicatorWithErrorMessage:@"您还没有选择商品哦！"];
        return;
    }
    
    // 判断是否包含普通及全球购两种类型的商品
    NSInteger ordinaryCount = 0;
    NSInteger GlobalCount = 0;
    for (QGGoodsMO *goods in selectGoodsArr) {
        if (goods.deliveryType.integerValue == 3) {
            GlobalCount ++;
        }else{
            ordinaryCount++;
        }
    }
    if (ordinaryCount > 0 && GlobalCount > 0) {
        @weakify(self);
        QGShopCarAlertView *alert = [[QGShopCarAlertView alloc]initWithTitle:@"请选择分开结算的商品" ordinaryCount:ordinaryCount GlobalCount:GlobalCount cancelButtonTitle:@"去结算" otherButtonTitle:@"返回购物车"];

        alert.cancelButtonAction = ^(int index){
            @strongify(self);
            [self needUpdateDataWith:index];
        };
        [alert show];
        
    }else if (GlobalCount > 0){
        [self gotoReplaceWithGoodstype:QGConfirmOrderTypeGlobal];
    }else{
         [self gotoReplaceWithGoodstype:QGConfirmOrderTypeOrdinary];
    }
   
}

- (void)gotoReplaceWithGoodstype:(QGConfirmOrderType)type{
    // 检查库存
    
    NSArray *selectGoodsArr = [self FindAllSelectGoods];
    if (selectGoodsArr.count == 0) {
        [self showTopIndicatorWithErrorMessage:@"你当前没有选中任何商品哦"];
        return;
    }
    
    @weakify(self);
    [QGHttpManager checkInventoryWithGoodsIDs:selectGoodsArr Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        int count = 0;
        NSArray *shopCarModelArray = responseObject;
        for (QGShopCarModel *model in shopCarModelArray) {
            QGGoodsMO *goodsmo = [self findGoodsMOWithGoodsID:model.goodsID];
            goodsmo.inventory = @(model.goodsInventory);
            goodsmo.price = @(model.goodsPrice);
            goodsmo.name = model.goodsName;
            if (goodsmo.goodsCount > goodsmo.inventory) {
                count ++;
                goodsmo.selected = @(NO);
            }
        }
        if (count > 0) {
            [self showTopIndicatorWithErrorMessage:
             [NSString stringWithFormat:@"当前有%d件商品库存不足~",count]];
            [self.tableView reloadData];
            [self updateToolbar];
            return ;
        }
        
        // 是否登录
        if ([self loginIfNeeded]) {
            return;
        }
        
        QGConfirmOrderViewController *vc = [QGConfirmOrderViewController new];
        vc.type = type;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showTopIndicatorWithError:error];
        return ;
    }];
    

    
}

- (QGGoodsMO *)findGoodsMOWithGoodsID:(NSInteger)goodsID{
    
    for (NSArray *goodsArray in self.dataArr) {
        for (QGGoodsMO *goods in goodsArray) {
            if (goods.goodID.integerValue == goodsID) {
                return goods;
            }
        }
    }
    return nil;
}

@end
