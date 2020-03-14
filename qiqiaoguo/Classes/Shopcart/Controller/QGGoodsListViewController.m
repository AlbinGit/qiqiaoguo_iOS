//
//  QGGoodsListViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/29.
//
//

#import "QGGoodsListViewController.h"
#import "QGTableView.h"
#import "QGHttpManager+User.h"
#import "QGGoodsListCell.h"
#import "QGProductDetailsViewController.h"

@interface QGGoodsListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) QGTableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation QGGoodsListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
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
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[QGGoodsListCell class] forCellReuseIdentifier:NSStringFromClass([QGGoodsListCell class])];
    
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        self.page = 1;
        @weakify(self);
        [QGHttpManager getUserCollectionGoodsWithPage:self.page Success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:responseObject];
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self showTopIndicatorWithError:error];
        }];
    }];
    
    self.tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        self.page ++;
        @weakify(self);
        [QGHttpManager getUserCollectionGoodsWithPage:self.page Success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            NSArray *arr = responseObject;
            [self tableViewEndRefreshing:self.tableView noMoreData:arr.count == 0];
            [self.dataArray addObjectsFromArray:responseObject];
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self showTopIndicatorWithError:error];
        }];
    }];
    
}

-(void)viewWillFirstAppear{
    [super viewWillFirstAppear];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    @weakify(self);
    [QGHttpManager getUserCollectionGoodsWithPage:self.page Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showTopIndicatorWithError:error];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 108, 0);
}

#pragma mark -  UITabelViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self showCannotViewIfNeed:_dataArray.count > 0];
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGGoodsListCell class]) forIndexPath:indexPath];
    cell.goods = _dataArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QGSearchResultGoodsModel *model =_dataArray[indexPath.row];
    QGProductDetailsViewController *vc = [QGProductDetailsViewController new];
    vc.goods_id = [NSString stringWithFormat:@"%ld",model.goodsID];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

@end
