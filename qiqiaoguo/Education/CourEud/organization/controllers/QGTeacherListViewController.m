//
//  QGTeacherListViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/29.
//
//

#import "QGTeacherListViewController.h"
#import "QGTableView.h"
#import "QGOrgTeacherTableViewCell.h"
#import "QGTeacherViewController.h"

@interface QGTeacherListViewController ()<UITableViewDelegate,UITableViewDataSource>

/**总tableView*/
@property (nonatomic,strong)QGTableView *tableView;
/**老师总数据源*/
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) QGOrgTeacherListResultModel *result;

@end

@implementation QGTeacherListViewController

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
        [QGHttpManager getUserTeacherListWithURL:QGUserCollectionTeacher Page:self.page success:^(QGOrgTeacherListResultModel *result) {
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
        [QGHttpManager getUserTeacherListWithURL:QGUserCollectionTeacher Page:self.page success:^(QGOrgTeacherListResultModel *result) {
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
    self.page = 1;
    [QGHttpManager getUserTeacherListWithURL:QGUserCollectionTeacher Page:self.page success:^(QGOrgTeacherListResultModel *result) {
        [self.tableView.mj_header endRefreshing];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:result.items];
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
{
    self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
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
    QGTeacherViewController *teacher = [[QGTeacherViewController alloc]init];
    
    QGTeacherListModel *teacherModel = _dataArray[indexPath.row];
    teacher.teacher_id = teacherModel.teacher_id;
    
    [self.navigationController pushViewController:teacher animated:YES];
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
