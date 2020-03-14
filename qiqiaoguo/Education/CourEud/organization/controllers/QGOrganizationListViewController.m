//
//  QGOrganizationListViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/29.
//
//

#import "QGOrganizationListViewController.h"
#import "QGTableView.h"
#import "QGSearchOrgModel.h"
#import "QGOrgTeacherTableViewCell.h"
#import "QGOrgViewController.h"

@interface QGOrganizationListViewController () <UITableViewDataSource,UITableViewDelegate>

/**总tableView*/
@property (nonatomic,strong)QGTableView *tableView;
/**老师总数据源*/
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) QGSearchOrgModel *result;

@end

@implementation QGOrganizationListViewController
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
    
    [self p_createUI];
}
/**
 *  创建UI
 */
- (void)p_createUI
{
    _dataArray = [[NSMutableArray alloc]init];
    
    _tableView = [[QGTableView alloc]initWithFrame:self.view.bounds style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = APPBackgroundColor;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[QGOrgTeacherTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QGOrgTeacherTableViewCell class])];
    
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [QGHttpManager getUserOrganizaListWithURL:QGUserCollectionOrg Page:self.page success:^(NSDictionary *result) {
            [self.tableView.mj_header endRefreshing];
            NSArray *dicArr = result[@"extra"][@"items"];
            NSArray *listArray = [QGSearchOrgModel mj_objectArrayWithKeyValuesArray:dicArr];
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:listArray];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            [self showTopIndicatorWithError:error];
        }];
    }];
    
    self.tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        self.page ++;
        [QGHttpManager getUserOrganizaListWithURL:QGUserCollectionOrg Page:self.page success:^(NSDictionary *result) {
            NSArray *dicArr = result[@"extra"][@"items"];
            [self tableViewEndRefreshing:self.tableView noMoreData:dicArr.count == 0];
            NSArray *listArray = [QGSearchOrgModel mj_objectArrayWithKeyValuesArray:dicArr];
            [_dataArray addObjectsFromArray:listArray];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self showTopIndicatorWithError:error];
        }];
    }];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length+98, 0);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.page = 1;
    [QGHttpManager getUserOrganizaListWithURL:QGUserCollectionOrg Page:self.page success:^(NSDictionary *result) {
        [self.tableView.mj_header endRefreshing];
        NSArray *dicArr = result[@"extra"][@"items"];
        NSArray *listArray = [QGSearchOrgModel mj_objectArrayWithKeyValuesArray:dicArr];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:listArray];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self showTopIndicatorWithError:error];
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
    [self showCannotViewIfNeed:self.dataArray.count > 0];
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PL_CELL_NIB_CREATE(QGOrgTeacherTableViewCell)
    QGTeacherListModel *model = self.dataArray[indexPath.row];
    cell.teacherModel =  model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QGOrgViewController *orgCtl = [[QGOrgViewController alloc]init];
    QGSearchOrgModel * model = _dataArray[indexPath.row];
    orgCtl.org_id = model.org_id;
    [self.navigationController pushViewController:orgCtl animated:YES];
    
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
//    return 0.5;
//}

- (void)dealloc
{
    //    [_tableView refreshFree];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
