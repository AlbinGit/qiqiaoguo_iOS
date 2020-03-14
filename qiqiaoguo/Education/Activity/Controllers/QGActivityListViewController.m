//
//  QGActivityListViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/17.
//
//

#import "QGActivityListViewController.h"
#import "QGTableView.h"
#import "QGActivityHomeViewcell.h"
#import "QGActivityDetailViewController.h"


@interface QGActivityListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) QGTableView *tableView;
@property (nonatomic,strong) QGActHomeResultModel *result ;
@property (nonatomic,strong) QGActlistHomeResultModel *actListModel;
@property (nonatomic,strong) QGActlistHomeModel*actModel;

@end

@implementation QGActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Table view
    _tableView = [[QGTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.frame = self.view.frame;
    _tableView.backgroundColor = [UIColor colorFromHexString:@"ececec"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[QGActivityHomeViewcell class] forCellReuseIdentifier:NSStringFromClass([QGActivityHomeViewcell class])];
    self.automaticallyAdjustsScrollViewInsets = NO;
       if (@available(iOS 11.0, *)) {
             _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
         }
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        self.page = 1;
        QGHttpDownload *ph = [self getHttpDownload];
        [QGHttpManager UserActlistDataWithParam:ph Page:self.page success:^(QGActlistHomeResultModel *result) {
            [self.tableView.mj_header endRefreshing];
            _actListModel = result;
            [self.tableView reloadData];
            [self showCannotViewIfNeed:_actListModel.items.count > 0];
        } failure:^(NSError *error) {
            [self showTopIndicatorWithError:error];
        }];
    }];
    self.tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        self.page ++;
        QGHttpDownload *ph = [self getHttpDownload];
        [QGHttpManager UserActlistDataWithParam:ph Page:self.page success:^(QGActlistHomeResultModel *result) {
            [self tableViewEndRefreshing:self.tableView noMoreData:result.items.count < 1];
            [_actListModel.items addObjectsFromArray:result.items];
            [self.tableView reloadData];
            [self showCannotViewIfNeed:_actListModel.items.count > 0];
        } failure:^(NSError *error) {
            [self showTopIndicatorWithError:error];
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillFirstAppear{
    [super viewWillFirstAppear];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    QGHttpDownload *ph = [self getHttpDownload];
    self.page = 1;
    [QGHttpManager UserActlistDataWithParam:ph Page:self.page success:^(QGActlistHomeResultModel *result) {
        [self.tableView.mj_header endRefreshing];
        _actListModel = result;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self showTopIndicatorWithError:error];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets tableViewInsets = _tableView.contentInset;
    tableViewInsets.bottom = self.bottomLayoutGuide.length + 64;
    _tableView.contentInset = tableViewInsets;
}


- (QGHttpDownload *)getHttpDownload{
    
    switch (self.type) {
        case QGActivityTypeCollection: {
            return [[QGUserActivDownload alloc] init];
            break;
        }
        case QGActivityTypeParticipate: {
            return [[QGUserPartActivDownload alloc] init];
            break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self showCannotViewIfNeed:_actListModel.items.count > 0];
    return _actListModel.items.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PL_CELL_CREATE(QGActivityHomeViewcell);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _actModel = _actListModel.items[indexPath.row];
    cell.actModel = _actModel;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGActlistHomeModel*actModel = [[QGActlistHomeModel alloc] init];
    actModel = _actListModel.items[indexPath.row];
    QGActivityDetailViewController *vc = [[QGActivityDetailViewController alloc] init];
    vc.activity_id =actModel.id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (MQScreenW-20)*0.71+10;
}
@end
