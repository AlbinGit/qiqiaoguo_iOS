//
//  QGGoodLogisticsViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/28.
//
//

#import "QGGoodLogisticsViewController.h"
#import "QGGoodLogisticsCell.h"
#import "QGGoodLogisticsHeaderview.h"
#import "QGHttpManager+Order.h"

@interface QGGoodLogisticsViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation QGGoodLogisticsViewController

- (instancetype)initWithOrderID:(NSNumber *)orderID {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(orderID, [NSNumber class]);
        _orderID = orderID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.infoView;
    
    @weakify(self);
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.title = NSLocalizedString(@"good-logistics.title", @"Logistics details");
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    [self reloadData];
}

- (QGTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [QGTableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[QGGoodLogisticsCell class]
           forCellReuseIdentifier:[QGGoodLogisticsCell defaultName]];
        _tableView.frame = self.view.bounds;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        
    }
    return _tableView;
}

- (QGGoodLogisticsInfoView *)infoView {
    if (_infoView == nil) {
        _infoView = [QGGoodLogisticsInfoView new];
        _infoView.frame = CGRectMake(0, 0, self.view.width,
                                     [QGGoodLogisticsInfoView requiredHeight]);
        _infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _infoView;
}

- (QGGoodLogisticsHeaderview *)headerView {
    if (_headerView == nil) {
        _headerView = [QGGoodLogisticsHeaderview new];
    }
    return _headerView;
}


- (void)reloadData {
    [self.view showIndicator];
    @weakify(self);
    [QGHttpManager getOrderLogisiticsDetailWithOrderID:self.orderID.integerValue Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.view hideIndicator];
        self.logistics = responseObject;
        [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
            self.infoView.logistics = self.logistics;
            [self.infoView setNeedsLayout];
            [self.infoView layoutIfNeeded];
        }];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"responseObject==%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.view hideIndicator];
        [self showTopIndicatorWithError:error];
    }];
    
    
//    [[self fetch] subscribeNext:^(BLULogistics *logistics) {
//        @strongify(self);
//        self.logistics = logistics;
//    } error:^(NSError *error) {
//        @strongify(self);
//        [self showAlertForError:error];
//    } completed:^{
//        @strongify(self);
//        
//        [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
//            self.infoView.logistics = self.logistics;
//            [self.infoView setNeedsLayout];
//            [self.infoView layoutIfNeeded];
//        }];
//        
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                      withRowAnimation:UITableViewRowAnimationFade];
//    }];
}

#pragma mark - UITabelVIewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logistics.details.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGGoodLogisticsCell *cell =
    (QGGoodLogisticsCell *)[tableView dequeueReusableCellWithIdentifier:[QGGoodLogisticsCell defaultName]
                                                            forIndexPath:indexPath];
    
    [cell setModel:self.logistics.details[indexPath.row]];
    
    if (indexPath.row == 0) {
        cell.emphasis = YES;
        cell.topLine.hidden = YES;
    } else {
        cell.emphasis = NO;
        cell.topLine.hidden = NO;
    }
    
    if (indexPath.row == self.logistics.details.count - 1) {
        cell.bottomLine.hidden = YES;
        cell.horizonSeparator.hidden = YES;
    } else {
        cell.bottomLine.hidden = NO;
        cell.horizonSeparator.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView sizeForCellWithCellClass:[QGGoodLogisticsCell class] cacheByIndexPath:indexPath width:self.tableView.width configuration:^(QGCell *cell) {
        QGGoodLogisticsCell *logisticsCell = (QGGoodLogisticsCell *)cell;
        [logisticsCell setModel:self.logistics.details[indexPath.row]];
    }].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [QGGoodLogisticsHeaderview requiredHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

@end
