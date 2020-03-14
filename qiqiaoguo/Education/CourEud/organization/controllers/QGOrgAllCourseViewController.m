//
//  QGOrgAllCourseViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/2.
//
//

#import "QGOrgAllCourseViewController.h"

#import "QGOrgAllCourseModel.h"
#import "QGOrgCourseHttpDownload.h"
#import "QGCourseDetailViewController.h"
#import "QGSearchCourseTableViewCell.h"
@interface QGOrgAllCourseViewController ()

/**总tableView*/
@property (nonatomic,strong)SASRefreshTableView *tableView;
/**课程总数据源*/
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *promptView;
@end

@implementation QGOrgAllCourseViewController
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
    _dataArray = [[NSMutableArray alloc]init];
    [self createReturnButton];
    [self createNavTitle:@"全部课程"];
    [self p_createUI];
    [self p_requestMothod:SARefreshPullDownType];
    // Do any additional setup after loading the view.
}

/**
 *  创建UI
 */
- (void)p_createUI
{
    _tableView = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0, self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - self.navImageView.maxY) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR(242, 243, 244, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    PL_CODE_WEAK(weakSelf);
    [_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
        [weakSelf p_requestMothod:SARefreshPullDownType];
    }];
    [_tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {
        [weakSelf p_requestMothod:SARefreshPullUpType];
    }];
}
- (NSMutableArray *)dataArray {
    
    if (_dataArray  == nil) {
        _dataArray  = [[NSMutableArray alloc] init];
    }
    return _dataArray ;
    
}

/**
 *  网络请求
 *
 *  @param type 请求类型
 */
- (void)p_requestMothod:(SARefreshType)type
{
    QGOrgCourseHttpDownload *download = [[QGOrgCourseHttpDownload alloc]init];

    download.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    
    download.org_id = _org_id;
    if (type == SARefreshPullDownType)
        download.page = @"1";
    else
        download.page = [NSString stringWithFormat:@"%ld",(long)self.page];
    [[SAProgressHud sharedInstance]showWaitWithWindow];
    [QGHttpManager courseAllCourseInfoWithParam:download success:^(QGOrgAllCourseModel *result) {
 

        
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
         [self showTopIndicatorWithError:error];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
     return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   PL_CELL_CREATEMETHOD(QGSearchCourseTableViewCell, @"cell2");


        QGCourseInfoModel *model =_dataArray[indexPath.row];
        
        cell.model = model;

   
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
  
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  245.7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
        return 1;

 
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QGCourseInfoModel * model = _dataArray[indexPath.row];
    QGCourseDetailViewController *courseDetail = [[QGCourseDetailViewController alloc]init];
    courseDetail.course_id = model.id;
    [self.navigationController pushViewController:courseDetail animated:YES];
}

- (void)dealloc
{
    [_tableView refreshFree];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
