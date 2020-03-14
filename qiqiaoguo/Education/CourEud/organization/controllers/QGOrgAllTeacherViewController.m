//
//  QGOrgAllTeacherViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/2.
//
//

#import "QGOrgAllTeacherViewController.h"
#import "QGOrgTeacherTableViewCell.h"
#import "QGTeacherListModel.h"
#import "QGOrgTeacherHttpDownload.h"
#import "QGOrgTeacherTableViewCell.h"
#import "QGTeacherViewController.h"
#import "QGEduTeacherModel.h"
#import "QGTeacherListTableViewCell.h"
@interface QGOrgAllTeacherViewController ()

@property (nonatomic, strong) UIView *promptView;
/**总tableView*/
@property (nonatomic,strong)SASRefreshTableView *tableView;
/**老师总数据源*/
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) QGOrgTeacherListResultModel *result;
@end

@implementation QGOrgAllTeacherViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self createReturnButton];
    [self createNavTitle:@"全部老师"];
    [self p_createUI];
    [self p_requestMothod:SARefreshPullDownType];
    // Do any additional setup after loading the view.
}


/**
 *  创建UI
 */
- (void)p_createUI
{
    _dataArray = [[NSMutableArray alloc]init];
    
    _tableView = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0,  self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT- self.navImageView.maxY) style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = COLOR(241, 242, 243, 1);
    [self.view addSubview:_tableView];
    
    PL_CODE_WEAK(weakSelf);
    [_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
        [weakSelf p_requestMothod:SARefreshPullDownType];
    }];
    [_tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {
        [weakSelf p_requestMothod:SARefreshPullUpType];
    }];
}
/**
 *  网络请求
 *
 *  @param type 请求类型
 */
- (void)p_requestMothod:(SARefreshType)type
{

    [[SAProgressHud sharedInstance]showWaitWithWindow];
    QGOrgTeacherHttpDownload *download = [[QGOrgTeacherHttpDownload alloc]init];

     download.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    download.org_id = _org_id;

    if (type == SARefreshPullDownType)
        download.page = @"1";
    else
        download.page = [NSString stringWithFormat:@"%ld",(long)self.page];
[QGHttpManager courseTeatherInfoWithParam:download success:^(QGOrgTeacherListResultModel *result) {
        if (type == SARefreshPullDownType) {
            self.page = 1;
            self.page ++;
            [_dataArray removeAllObjects];
        }
        else
            self.page ++;
        // 数据加载完以藏加载
        if (self.page > [result.per_page  integerValue])
            [_tableView hiddenFooterView];
        else
            [_tableView showFooterView];
     
        NSArray *nn = [NSArray array];
        nn = result.items;
        [_dataArray addObjectsFromArray:nn];
    // 没有数据显示默认图
    if (_dataArray.count < 1) {
        _tableView.hidden = YES;
        if (self.promptView) {
            [self.view bringSubviewToFront:self.promptView];
        }else{
            _promptView = [UIView new];
            _promptView.backgroundColor = APPBackgroundColor;
            _promptView.frame = self.tableView.frame;
            UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search-notfind"]];
            UILabel *messageLabel = [UILabel makeThemeLabelWithType:BLULabelTypeBoldTitle];
            messageLabel.textColor = QGCellbottomLineColor;
            messageLabel.text = @"暂无数据~";
            [messageLabel sizeToFit];
            [_promptView addSubview:imageview];
            [_promptView addSubview:messageLabel];
            imageview.centerY = _promptView.centerY - imageview.height;
            imageview.centerX = _promptView.centerX;
            messageLabel.centerX = _promptView.centerX;
            messageLabel.Y = imageview.maxY + BLUThemeMargin * 3;
            
            [self.view addSubview:self.promptView];
            [self.view bringSubviewToFront:self.promptView];
        }
        
    }else{
        _tableView.hidden = NO;
        if (self.promptView) {
            [self.promptView removeFromSuperview];
        }
    }

        [_tableView reloadData];
        [_tableView endRrefresh];

    } failure:^(NSError *error) {
        [_tableView reloadData];
        [_tableView endRrefresh];
         [self showTopIndicatorWithError:error];
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
     return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    PL_CELL_NIB_CREATE(QGTeacherListTableViewCell)

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

- (void)dealloc
{
    [_tableView refreshFree];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
