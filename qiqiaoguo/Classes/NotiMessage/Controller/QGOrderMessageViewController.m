//
//  QGOrderMessageViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/5.
//
//

#import "QGOrderMessageViewController.h"
#import "QGTableView.h"
#import "QGMessageListCell.h"
#import "QGMessageListHeadView.h"
#import "QGHttpManager+Message.h"
#import "QGMessageListModel.h"
#import "QGActivityDetailViewController.h"
#import "QGMallOrderDetailViewController.h"

@interface QGOrderMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) QGTableView *tableView;
@property (nonatomic, copy) NSMutableArray *dataArr;

@end

@implementation QGOrderMessageViewController

-(instancetype)init
{
    if (self = [super init]) {
        self.title = @"商城消息";
        _dataArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad{
    
    self.view.backgroundColor = APPBackgroundColor;
    _tableView = [[QGTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = APPBackgroundColor;
    [_tableView registerClass:[QGMessageListCell class] forCellReuseIdentifier:NSStringFromClass([QGMessageListCell class])];
    [_tableView registerClass:[QGMessageListHeadView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([QGMessageListHeadView class])];
    [self.view addSubview:_tableView];
    self.tableView.mj_footer = [BLURefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchNextDate)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
}

- (void)fetchData{
    
    self.page = 1;
    [QGHttpManager getOrderMessageWithPage:@(self.page) Success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self showTopIndicatorWithError:error];
    }];
    
}

- (void)fetchNextDate{
    
    self.page ++;
    if (self.page < 1) {
        return;
    }
    [QGHttpManager getOrderMessageWithPage:@(self.page) Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject;
        if (arr.count) {
            [self tableViewEndRefreshing:self.tableView];
            [_dataArr addObjectsFromArray:responseObject];
            [self.tableView reloadData];
        }else
        {
            [self tableViewEndRefreshing:self.tableView noMoreData:YES];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self tableViewEndRefreshing:self.tableView];
        [self showTopIndicatorWithError:error];
    }];
    
}

#pragma mark - UITableView.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGMessageListCell *cell = (QGMessageListCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGMessageListCell class]) forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [self.tableView sizeForCellWithCellClass:[QGMessageListCell class] cacheByIndexPath:indexPath width:self.tableView.width configuration:^(QGCell *cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
    return size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    QGMessageListModel *model = _dataArr[section];
    
    QGMessageListHeadView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([QGMessageListHeadView class])];
    header.timeLabel.text = model.createDate.postTime;
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转订单详情
    QGMessageListModel *model = _dataArr[indexPath.section];
    QGMallOrderDetailViewController *vc = [QGMallOrderDetailViewController new];
    vc.orderID = model.messageID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    QGMessageListCell *messageListCell = (QGMessageListCell *)cell;
    messageListCell.messageListType = QGMessageListTypeOrder;
    [messageListCell setModel:_dataArr[indexPath.section]];
}

@end
