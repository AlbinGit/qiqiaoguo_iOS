//
//  QGOrgListViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/17.
//
//

#import "QGOrgCourseListViewController.h"
#import "QGTableView.h"
#import "QGSearchCourseTableViewCell.h"
#import "QGCourseDetailViewController.h"

@interface QGOrgCourseListViewController () <UITableViewDelegate,UITableViewDataSource>
/**总tableView*/
@property (nonatomic,strong)QGTableView *tableView;
/**课程总数据源*/
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation QGOrgCourseListViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[QGTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorFromHexString:@"ececec"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
       if (@available(iOS 11.0, *)) {
             _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
         }
    
  //  _tableView.backgroundColor = [UIColor redColor];
    [_tableView registerClass:[QGSearchCourseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QGSearchCourseTableViewCell class])];
    
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [QGHttpManager getUserCourseListWithURL:QGUserCollectionCourse Page:self.page success:^(QGOrgAllCourseModel *result) {
            [self.tableView.mj_header endRefreshing];
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:result.items];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self showTopIndicatorWithError:error];
        }];
    }];
    
    self.tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        self.page ++;
        [QGHttpManager getUserCourseListWithURL:QGUserCollectionCourse Page:self.page success:^(QGOrgAllCourseModel *result) {
            [self tableViewEndRefreshing:self.tableView noMoreData:result.items.count == 0];
            [_dataArray addObjectsFromArray:result.items];
            [self.tableView reloadData];
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
    self.page = 1;
    [QGHttpManager getUserCourseListWithURL:QGUserCollectionCourse Page:self.page success:^(QGOrgAllCourseModel *result) {
        [self.tableView.mj_header endRefreshing];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:result.items];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self showTopIndicatorWithError:error];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    _tableView.frame = self.view.frame;
//    UIEdgeInsets tableViewInsets = _tableView.contentInset;
//    tableViewInsets.bottom = self.bottomLayoutGuide.length;
//    _tableView.contentInset = tableViewInsets;
    _tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 108, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
    [self showCannotViewIfNeed:self.dataArray.count > 0];
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PL_CELL_CREATEMETHOD(QGSearchCourseTableViewCell, @"cell");
    
   QGCourseInfoModel *model = self.dataArray[indexPath.row];
    cell.model =  model;

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 245.7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000000000000000000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QGCourseInfoModel * model = _dataArray[indexPath.row];
    QGCourseDetailViewController *courseDetail = [[QGCourseDetailViewController alloc]init];
    courseDetail.course_id = model.id;
    [self.navigationController pushViewController:courseDetail animated:YES];
}

@end
