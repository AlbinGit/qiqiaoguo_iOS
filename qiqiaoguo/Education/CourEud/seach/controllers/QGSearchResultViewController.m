//
//  QGSearchResultViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.
//
//

#import "QGSearchResultViewController.h"
#import "QGCourseDetailViewController.h"
#import "QGTeacherViewController.h"
#import "QGOrgViewController.h"
#import "QGProductDetailsViewController.h"

#import "QGTeacherListTableViewCell.h"
#import "QGEduClassViewController.h"



#import "SASRefreshTableView.h"
#import "QGSearchCourseTableViewCell.h"
#import "QGSearchTeacherTableViewCell.h"

#import "QGSearchOrgModel.h"
#import "QGCourseInfoModel.h"
#import "QGEduTeacherModel.h"
#import "QGSortModel.h"
#import "QGCategoryModel.h"
#import "QGViewController+QGReturnToTheTop.h"
#import "QGSeacherCourseHttpDownload.h"
#import "QGSeacherOrgHttpDownload.h"
#import "QGSeacherTeacherHttpDownload.h"
#import "QGOrgTeacherTableViewCell.h"

#import "QGSearchView.h"
#import "QGSearchResultNavView.h"
#import "QGPOPView.h"
#import "QGMessageCenterViewController.h"
#import "QGSerachViewController.h"
#import "QGMillSingleStoreCell.h"
#import "QGStoreListViewController.h"
#import "QGShopCarViewController.h"
#import "QGSearchScreeningView.h"
#import "QGHttpManager+Search.h"
#import "QGSearchScreeningSelectView.h"
#import "GHBLocationManager.h"



@interface QGSearchResultViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,QGPOPViewDelegate,ScreeningViewDelegate,QGScreeningSelectViewDelegate>
/**搜索框*/
@property (nonatomic, strong) QGSearchResultNavView *searchBar;
@property (nonatomic, strong) SASRefreshTableView * tableView;
/**搜索结果数据源*/
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) QGSearchScreeningView *screeningView;
@property (nonatomic, strong) QGSearchScreeningSelectView *screeningSelectView;
@property (nonatomic, assign) QGScreeningSelectType selectType;
@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, assign) NSInteger firstLayerID;

@end

static const CGFloat ScreeningHeight = 50;

@implementation QGSearchResultViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectType = NSNotFound;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configNavUI];
    [self p_initData];
    [self p_createUI];
    [self request:SARefreshPullDownType];

    
    @weakify(self);
    [RACObserve(self, searchOptionType) subscribeNext:^(id x) {
        @strongify(self);
        
        if (self.searchOptionType == self.oldOptionType) return;

        if (self.searchOptionType == QGSearchOptionTypeGoods) {
            [UIView animateWithDuration:.2 animations:^{
                self.tableView.Y = self.searchBar.maxY;
                self.tableView.height = self.view.height - self.searchBar.maxY;
            }];
        }else{
            [UIView animateWithDuration:.2 animations:^{
                self.tableView.Y = self.searchBar.maxY + ScreeningHeight;
                self.tableView.height = self.view.height - self.screeningView.maxY;
            }];
        }
    }];
    
}

- (void)viewWillFirstAppear{
    [super viewWillFirstAppear];
    
    [QGHttpManager getScreeningDataWithSearchOptionType:QGSearchOptionTypeCourse Success:^(NSURLSessionDataTask *task, id responseObject) {
        
        _screeningSelectView.courseModel = responseObject;
        _screeningSelectView.leftTabselectedID = self.CateID;
        _screeningSelectView.type = self.searchOptionType;
        _screeningSelectView.areaSelectID = self.nearbyAreaID;
        _screeningView.nearButton.title = self.nearbyAreaID < 1 ?@"全部区域":@"附近";
        QGSearchScreeningModel *model =responseObject;
        [self configScreeningViewWithModelArr:model.courseCateList firstLayer:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showTopIndicatorWithError:error];
    }];
    
    [QGHttpManager getScreeningDataWithSearchOptionType:QGSearchOptionTypeInstitution Success:^(NSURLSessionDataTask *task, id responseObject) {
        
        _screeningSelectView.orgModel = responseObject;
        _screeningSelectView.type = self.searchOptionType;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showTopIndicatorWithError:error];
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
/**
 *  初始化数据
 */
- (void)p_initData {
    _dataArray = [[NSMutableArray alloc]init];
}

- (void)configNavUI{

    _searchBar = [QGSearchResultNavView new];
    _searchBar.searchTextField.delegate = self;
    self.searchBar.searchTextField.text = _keyWord;
    _searchBar.searchOptionType = self.searchOptionType;
    [self.view addSubview:_searchBar];
    
    _screeningView = [QGSearchScreeningView new];
    _screeningView.delegate = self;
    _screeningView.frame = CGRectMake(0, _searchBar.maxY, self.view.width, ScreeningHeight);
    [self.view addSubview:_screeningView];
    
    @weakify(self);
    [[self.searchBar.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        int index = self.navigationController.viewControllers.count;
        if ([self.navigationController.viewControllers[index-2] isKindOfClass:[UISearchController class]]) {
            UIViewController *vc = self.navigationController.viewControllers[index-3];
            [self.navigationController popToViewController:vc animated:YES];
            return ;
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [[self.searchBar.categoryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        QGPOPView *view = [QGPOPView new];
        view.delegate = self;
        [view showFrom:self.searchBar.categoryButton];
    }];
    
    [[self.searchBar.messageCenterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        QGMessageCenterViewController *MessageCenterVC = [QGMessageCenterViewController new];
        [self.navigationController pushViewController:MessageCenterVC animated:YES];
    }];
    
    [[self.searchBar.SearchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        QGSerachViewController *SerachVC = [QGSerachViewController new];
        SerachVC.searchOptionType = self.searchOptionType;
        SerachVC.keyword = self.keyWord;
        [self.navigationController pushViewController:SerachVC animated:NO];
    }];
    
}

- (void)setKeyWord:(NSString *)keyWord{
    
    _keyWord = keyWord;
    self.searchBar.searchTextField.text = keyWord;
    
}

- (void)setSearchOptionType:(QGSearchOptionType)searchOptionType{
    _oldOptionType = _searchOptionType;
    _searchOptionType = searchOptionType;
    self.searchBar.searchOptionType = _searchOptionType;
    self.screeningSelectView.type = _searchOptionType;
}


#pragma mark - QGPOPViewDelegate

- (void)popViewDidClickButton:(UIButton *)button{
    QGSearchOptionType type = self.searchOptionType;
    self.searchOptionType = button.tag;
    [self.screeningSelectView hidden];
    if (self.searchOptionType != type) {
        self.areaID = 0;
        self.CateID = 0;
        self.sortID = 0;
        [self.screeningView resetOptions];
        [self.screeningSelectView resetOptions];
        [self request:SARefreshPullDownType];
    }
}

- (void)p_createUI {
    
    PL_CODE_WEAK(ws)
    _tableView = [[SASRefreshTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.Y = _searchBar.maxY + ScreeningHeight;
    self.tableView.height = self.view.height - _screeningView.maxY;
    _tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = APPBackgroundColor;
    [self.view addSubview:_tableView];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    // 添加刷新和加载
    
    [_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
        [ws request:SARefreshPullDownType];
    }];
    [_tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {
        [ws request:SARefreshPullUpType];
    }];
    __weak typeof(self) weakSelf = self;
    [self addReturnToTheTopButtonFrame:CGRectMake(MQScreenW - 50, MQScreenH-120, 35, 35) WithBackgroundImage:[UIImage imageNamed:@"返回顶部"] CallBackblock:^{
        [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, MQScreenW, MQScreenH) animated:YES];
    }];
    
    _screeningSelectView = [QGSearchScreeningSelectView new];
    _screeningSelectView.leftTabselectedID = self.CateID;
    _screeningSelectView.hidden = YES;
    _screeningSelectView.type = self.searchOptionType;
    _screeningSelectView.delegate = self;
    [self.view addSubview:_screeningSelectView];
    [_screeningSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@114);
    }];
}



/**
 *  请求搜索结果数据
 *
 *  @param type 请求类型
 */

- (void)shouldUpdateData{
    [self request:SARefreshPullDownType];
}

- (void)request:(SARefreshType)type {

    QGHttpDownload * hd;
    // 机构
    if (_searchOptionType == QGSearchOptionTypeInstitution) {
        //         _searchBar.searchText.placeholder =@"搜索 机构";
        hd = [[QGSeacherOrgHttpDownload alloc]init];
        QGSeacherOrgHttpDownload * subHd = (QGSeacherOrgHttpDownload *)hd;
        subHd.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
        subHd.keyword = _keyWord;
        subHd.area_id = [@(_areaID) stringValue];
        subHd.sort_id = [@(_sortID) stringValue];
        subHd.category_id = [@(_CateID) stringValue];
        subHd.longitude = @(_longitude).stringValue;
        subHd.latitude = @(_latitude).stringValue;
        if (type == SARefreshPullDownType){
            subHd.page = @"1";
        }
        else{
            subHd.page = [NSString stringWithFormat:@"%ld",(long)self.page];
        }
    } // 课程
    else if (_searchOptionType == QGSearchOptionTypeCourse) {
        hd = [[QGSeacherCourseHttpDownload alloc]init];
        QGSeacherCourseHttpDownload * subHd = (QGSeacherCourseHttpDownload *)hd;
        subHd.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
//        subHd.category_id  = _catogoryId;
        subHd.keyword = _keyWord;
        subHd.area_id = [@(_areaID) stringValue];
        subHd.sort_id = [@(_sortID) stringValue];
        subHd.category_id = [@(_CateID) stringValue];
        subHd.longitude = @(_longitude).stringValue;
        subHd.latitude = @(_latitude).stringValue;
        if (type == SARefreshPullDownType){
            subHd.page = @"1";
        }
        else{
            subHd.page = [NSString stringWithFormat:@"%ld",(long)self.page];
        }
    }else if(_searchOptionType == QGSearchOptionTypeGoods){ //
      
        hd = [[QGSingleStoreDownload alloc]init];
        QGSingleStoreDownload *subHd = (QGSingleStoreDownload *)hd;
        subHd.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
        subHd.keyword = _keyWord;
        subHd.category_id  = _catogoryId;
        subHd.brand_id = _brand_id;
        if (type == SARefreshPullDownType)
            subHd.page = @"1";
        else
            subHd.page = [NSString stringWithFormat:@"%ld",(long)self.page];
    } else {
       
        hd = [[QGSeacherTeacherHttpDownload alloc]init];
        QGSeacherTeacherHttpDownload * subHd = (QGSeacherTeacherHttpDownload *)hd;
        subHd.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
        subHd.keyword = _keyWord;
        subHd.category_id  = _catogoryId;
        
        if (type == SARefreshPullDownType){
            subHd.page = @"1";
        }
        else{
            subHd.page = [NSString stringWithFormat:@"%ld",(long)self.page];
        }
        
    }
    
    [[SAProgressHud sharedInstance]showWaitWithWindow];
    
    [QGHttpManager courseInfoWithParam:hd success:^(QGCourseInfoResultModel *result) {
    
        NSArray * listArray; // 机构换成了老师
        if (_searchOptionType == QGSearchOptionTypeInstitution){
//            listArray = [QGSearchOrgModel mj_objectArrayWithKeyValuesArray:result.items];
            listArray = [QGEduTeacherModel mj_objectArrayWithKeyValuesArray:result.items];

        }
        else if (_searchOptionType == QGSearchOptionTypeCourse){
            //课程
            
            listArray = [QGCourseInfoModel mj_objectArrayWithKeyValuesArray:result.items];
        }
        else if(_searchOptionType == QGSearchOptionTypeGoods) {
            listArray = [QGSingleStoreModel  mj_objectArrayWithKeyValuesArray:result.items];
            
        }else {
            listArray = [QGEduTeacherModel mj_objectArrayWithKeyValuesArray:result.items];
        }
        
        [self tableViewEndRefreshing:self.tableView noMoreData:listArray.count < 1];
        
        if (type == SARefreshPullDownType) {
            self.page = 1;
            self.page ++;
            [_dataArray removeAllObjects];
        }
        else{
            self.page ++;
        }

        
        [_dataArray addObjectsFromArray:listArray];
        // 没有数据显示默认图
        if (_dataArray.count < 1) {
            _tableView.hidden = YES;
            BOOL flag = NO;
            if (self.promptView) {
                for (UIView *view in self.view.subviews) {
                    if (view == self.promptView) {
                        flag = YES;
                    }
                }
                if (!flag) {
                    [self.view addSubview:self.promptView];
                }
                [self.view bringSubviewToFront:self.promptView];
            }else{
                _promptView = [UIView new];
                _promptView.backgroundColor = APPBackgroundColor;
                _promptView.frame = self.tableView.frame;
                UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search-notfind"]];
                UILabel *messageLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
                messageLabel.textColor = QGCellbottomLineColor;
                messageLabel.text = @"没有找到呢，还是找点别的吧~";
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
        
        
        
    } failure:^(NSError *error) {
        [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
    }];
    
    [self viewDidLayoutSubviews];
 }


#pragma mark table - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_searchOptionType == QGSearchOptionTypeCourse) {
        PL_CELL_CREATEMETHOD(QGSearchCourseTableViewCell, @"searchCourse")
        cell.model = _dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_searchOptionType == QGSearchOptionTypeInstitution) { // 机构
//        PL_CELL_NIB_CREATE(QGOrgTeacherTableViewCell)
//        cell.model = _dataArray[indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
        PL_CELL_NIB_CREATE(QGTeacherListTableViewCell)//老师
        cell.model = _dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if (_searchOptionType == QGSearchOptionTypeGoods) { // 商品
        PL_CELL_CREATEMETHOD(QGMillSingleStoreCell, @"storecell")
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.singModel =  _dataArray[indexPath.row];
        [self addCarIconBtn];
        return cell;
        
    }else {
        PL_CELL_NIB_CREATE(QGTeacherListTableViewCell)//老师
        cell.model = _dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - ScreeningViewDelegate

- (void)configScreeningViewWithModelArr:(NSArray *)modelArr firstLayer:(BOOL)isFirstLayer{
    
    for (QGScreeningModel *Listmodel in modelArr) {
        if (isFirstLayer) {
            _firstLayerID = Listmodel.courseID;
        }
        if (Listmodel.courseID == self.CateID) {
            if (_firstLayerID != 0) {
                self.screeningView.selectModel = Listmodel;
            }
            self.screeningSelectView.cateID = Listmodel.courseID;
            self.screeningSelectView.leftTabselectedID = _firstLayerID;
            return;
        }
        [self configScreeningViewWithModelArr:Listmodel.subListArray firstLayer:NO];
    }
}

- (void)buttonShouldClick:(UIButton *)button{
    
    if (!self.screeningSelectView.orgModel || !self.screeningSelectView.courseModel) {
        button.selected = NO;
        self.selectType = NSNotFound;
        [_screeningSelectView hidden];
        return;
    }
    
    if (self.selectType == button.tag) {
        self.selectType = NSNotFound;
        button.selected = NO;
        [_screeningSelectView hidden];
    }else{
        self.selectType = button.tag;
        _screeningSelectView.selectType = self.selectType;
        [_screeningSelectView show];
        
        [self.view bringSubviewToFront:_screeningSelectView];
    }
    
}

- (void)shouldSelectedWithModel:(QGScreeningModel *)model selectType:(QGScreeningSelectType)type{
    
    [self.screeningSelectView hidden];
    self.screeningView.selectModel = model;
    self.selectType = NSNotFound;
    if (!model) {
        return;
    }
    
    
    switch (type) {
        case QGScreeningSelectTypeCourseCate: {
            _CateID = model.courseID;
            break;
        }
        case QGScreeningSelectTypeArea: {
            _areaID = model.courseID;
            break;
        }
        case QGScreeningSelectTypeSort: {
            _sortID = model.courseID;
            break;
        }
    }
    
    [self request:SARefreshPullDownType];
    
    
}


#pragma mark 添加侧面购物车

- (void)addCarIconBtn {
    
//    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    messageBtn.backgroundColor = [UIColor clearColor];
//    [messageBtn setBackgroundImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
//    messageBtn.enabled= YES;
//    [messageBtn addTarget:self action:@selector(btnCarClick) forControlEvents:UIControlEventTouchUpInside];
//    messageBtn.frame = CGRectMake(MQScreenW - 50, MQScreenH-180, 35, 35);
//    [self.view addSubview:messageBtn];
    
}

- (void)btnCarClick {
    
    QGShopCarViewController *vc = [QGShopCarViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_searchOptionType == QGSearchOptionTypeCourse)
    {
        return 245.7;
    }
    else if (_searchOptionType ==  QGSearchOptionTypeInstitution)
    {
        return 130;
    }else if (_searchOptionType ==  QGSearchOptionTypeGoods) {
        
        return 102;
    }
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击课程详情
    if (_searchOptionType == QGSearchOptionTypeCourse) {
        QGCourseInfoModel *model = _dataArray[indexPath.row];
        QGCourseDetailViewController *ctr = [[QGCourseDetailViewController alloc]init];
        
        ctr.course_id = model.id;
        [self.navigationController pushViewController:ctr animated:YES];
    } else if (_searchOptionType == QGSearchOptionTypeInstitution) {
        // 点击跳到机构主页
//        QGOrgViewController *orgCtl = [[QGOrgViewController alloc]init];
//        QGSearchOrgModel * model = _dataArray[indexPath.row];
//        orgCtl.org_id = model.org_id;
//        [self.navigationController pushViewController:orgCtl animated:YES];
		
        // 点击跳到老师主页
        QGTeacherViewController * ctr = [[QGTeacherViewController alloc]init];
        QGEduTeacherModel *model = _dataArray[indexPath.row];
        ctr.teacher_id = model.teacher_id;
        [self.navigationController pushViewController:ctr animated:YES];

    }else if(_searchOptionType == QGSearchOptionTypeGoods) {
        
        QGProductDetailsViewController *vc = [[QGProductDetailsViewController alloc] init];
        QGSingleStoreModel *model = _dataArray[indexPath.row];
        vc.goods_id =  model.id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        // 点击跳到老师主页
        QGTeacherViewController * ctr = [[QGTeacherViewController alloc]init];
        QGEduTeacherModel *model = _dataArray[indexPath.row];
        ctr.teacher_id = model.teacher_id;
        [self.navigationController pushViewController:ctr animated:YES];
    }
}


- (void)dealloc {
    [_tableView refreshFree];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
