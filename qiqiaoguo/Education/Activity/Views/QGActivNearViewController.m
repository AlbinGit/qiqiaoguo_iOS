//
//  QGActivNearViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/8/23.
//
//

#import "QGActivNearViewController.h"
#import "QGActivityHomeViewcell.h"
#import "QGActivityDetailViewController.h"
#import "QGHttpManager+Activity.h"
#import "GHBLocationManager.h"

@interface QGActivNearViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) QGTableView *tableView;
@property (nonatomic,strong) QGActHomeResultModel *result ;
@property (nonatomic,strong) QGActlistHomeResultModel *actListModel;
@property (nonatomic,strong) QGActlistHomeModel *actModel;
@property (nonatomic,assign) CGFloat longitude;
@property (nonatomic,assign) CGFloat latitude;
@end

@implementation QGActivNearViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"附近活动";
    }
    return self;
}

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

    
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [QGHttpManager getActivNearListWithPage:self.page Longitude:_longitude Latitude:_latitude success:^(QGActlistHomeResultModel *result) {
            [self tableViewEndRefreshing:self.tableView];
            _actListModel = result;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self tableViewEndRefreshing:self.tableView];
            [self showTopIndicatorWithError:error];
        }];

    }];
    
    self.tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        self.page ++;
        [QGHttpManager getActivNearListWithPage:self.page Longitude:_longitude Latitude:_latitude success:^(QGActlistHomeResultModel *result) {
            [self tableViewEndRefreshing:self.tableView noMoreData:result.items.count < 1];
            [_actListModel.items addObjectsFromArray:result.items];
            [self.tableView reloadData];
            [self showCannotViewIfNeed:_actListModel.items.count > 0];
        } failure:^(NSError *error) {
            [self tableViewEndRefreshing:self.tableView];
            [self showTopIndicatorWithError:error];
        }];
    }];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillFirstAppear{
    [super viewWillFirstAppear];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.page = 1;
    [[GHBLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        _longitude = locationCorrrdinate.longitude;
        _latitude = locationCorrrdinate.latitude;
        NSLog(@"当前位置:%f,%f",locationCorrrdinate.longitude,locationCorrrdinate.latitude);
        [QGHttpManager getActivNearListWithPage:self.page Longitude:locationCorrrdinate.longitude Latitude:locationCorrrdinate.latitude success:^(QGActlistHomeResultModel *result) {
            _actListModel = result;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self showTopIndicatorWithError:error];
        }];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets tableViewInsets = _tableView.contentInset;
    tableViewInsets.bottom = self.bottomLayoutGuide.length + 20;
    _tableView.contentInset = tableViewInsets;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self showCannotViewIfNeed:_actListModel.items.count > 0];
    return _actListModel.items.count;
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
    
    return (MQScreenW-20)*0.71+30;
}


@end
