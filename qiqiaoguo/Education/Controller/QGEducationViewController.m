//
//  MQHomeViewController.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/25.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGEducationViewController.h"
#import "SDCycleScrollView.h"
#import "QGEduFristActivityListCell.h"
#import "QGEducationMainHttpDownload.h"
#import "QGVerticalButton.h"
#import "QGEduClassViewController.h"
#import "SASRefreshTableView.h"
#import "QGSearchResultViewController.h"
#import "QGEduHomeResult.h"
#import "QGSubjectView.h"
#import "QGEduClassViewController.h"
#import "QGSearchResultViewController.h"
#import "QGQGEduFristVideoListCell.h"
#import "QGSearchCourseTableViewCell.h"
#import "QGSearchCourseTableViewCell.h"
#import "QGActivityHomeViewController.h"
#import "QGCourseDetailViewController.h"
#import "QGViewController+QGReturnToTheTop.h"
#import "QGMessageCenterViewController.h"
#import "QGSerachViewController.h"
#import "QGBannerWebViewController.h"
#import "QGProductDetailsViewController.h"
#import "QGSecKillViewController.h"
#import "QGOptimalClassController.h"
#import "QGActivityHomeViewController.h"
#import "QGActivityDetailViewController.h"
#import "QGCourseDetailViewController.h"
#import "BLUCircleDetailViewController.h"
#import "BLUPostTagDetailViewController.h"
#import "BLUCircleMainViewController.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "QGTeacherViewController.h"
#import "QGOrgViewController.h"



#define BUTTON_WIDTH 160
#define BUTTON_HEIGHT 80

typedef NS_ENUM(NSUInteger, QGEduHomeCellType) {
    QGEduHomeCellTypeActiv,
    QGEduHomeCellTypeVideo,
    QGEduHomeCellTypeCourse,
};



@interface QGEducationViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,SDCycleScrollViewDelegate>
@property (nonatomic,strong) QGEduHomeResult *dataModel;
/**推荐模块*/
@property (nonatomic, strong) QGSubjectView * modelView;
@property (nonatomic,strong) UIView *navBGView;
@property (nonatomic,strong)SASRefreshTableView*tableView;
@property (nonatomic,strong) NSMutableArray *bannerArray;
@property (nonatomic,strong) UIImageView *searchBg;
@property (nonatomic,strong) UIButton *messageicon;
@property (nonatomic,strong) UIImageView *searchimg;
/**搜索框*/
@property(nonatomic,strong)UITextField *search;
@property (nonatomic,strong)UIButton *messeageLab;

@property (nonatomic,strong) UIButton *sortBtn;
  @property (nonatomic,strong) UIView *lineView;
@property (nonatomic, assign) QGEduHomeCellType CellType;

@end

@implementation QGEducationViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"教育+";
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self getUserMessageCount];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initBaseData];
  
    if (_tableView==nil) {
        
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = COLOR(242, 243, 244, 1);
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.tableHeaderView=[[UIView alloc]init];
        _tableView.tableFooterView=[[UIView alloc]init];

        [self.view addSubview:_tableView];
        PL_CODE_WEAK(weakSelf);
        [_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
            [weakSelf requestFirstDataMethod:SARefreshPullUpType];
        }];
    }else {
        
        [_tableView reloadData];
    }
     [self requestFirstDataMethod:SARefreshPullUpType];

}
-(void)add_viewUI {

    
}


#pragma mark 请求数据
- (void)requestFirstDataMethod:(SARefreshType)type{
    [[SAProgressHud sharedInstance]showWaitWithWindow];
    [QGHttpManager eudhomeDataSuccess:^(QGEduHomeResult *result) {
        _dataModel= result;
        [self createTableHeader];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
     
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
         [self showTopIndicatorWithError:error];
           
    }];

    [self getUserMessageCount];
    
}

- (void)updateUserMessageCount{
    if (self.messageCount > 0) {
        _messeageLab.title = @(self.messageCount).stringValue;
    }
    _messeageLab.hidden = self.messageCount == 0;
}

#pragma mark 头部滚动视图banner
- (void)createTableHeader {
    
    self.navImageView.alpha=0;
    _navBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _navBGView.backgroundColor = RGBA(255, 255, 255 ,0);
    [self.view addSubview:_navBGView];
    //线
    UIView *vc = [[UIView alloc] initWithFrame:CGRectMake(0, 63, self.view.width, 1)];
    vc.backgroundColor = RGBA(255, 255, 255 ,0);
    [_navBGView addSubview:vc];
    self.lineView = vc;
      __weak typeof(self) weakSelf = self;
    [self addReturnToTheTopButtonFrame:CGRectMake(MQScreenW - 50, MQScreenH-120, 35, 35) WithBackgroundImage:[UIImage imageNamed:@"返回顶部"] CallBackblock:^{
        [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, MQScreenW, MQScreenH) animated:YES];
    }];

    //分类按钮
    _sortBtn = [UIButton new];
    [_navBGView addSubview:_sortBtn];
    _sortBtn.image = [UIImage imageNamed:@"icon_city_home"];
    _sortBtn.titleFont = FONT_CUSTOM(14);
    [_sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@26);
        make.left.equalTo(@7);
        make.height.equalTo(@32);
        make.width.equalTo(@0);
    }];

    //[self updateCityBtnFrameWithTitle:@"深圳"];
    //搜索
    //        UIView  *searchView = [[UIView alloc]initWithFrame:CGRectMake(_sortBtn.maxX+10, 26, SCREEN_WIDTH-_sortBtn.maxX-57, 44)];
    UIView *searchView = [[UIView alloc]init];
    
    kClearBackground(searchView);
    [_navBGView addSubview:searchView];
    UIImageView *searchBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, searchView.width, 30)];
    searchBg.backgroundColor = COLOR(177, 177, 177, 0.5);
    searchBg.layer.masksToBounds = YES;
    searchBg.layer.cornerRadius = 5;
    [searchView addSubview:searchBg];
    _searchBg = searchBg;
    //搜索图片
    UIImageView *serchImv = [[UIImageView alloc]initWithFrame:CGRectMake(7, 8, 15, 15)];
    serchImv.image = [UIImage imageNamed:@"icon_search_home"];
    [searchView addSubview:serchImv];//search-drop-down-icon
    _searchimg = serchImv;
    
    //搜索框
    _search = [[UITextField alloc]initWithFrame:CGRectMake(32, -6, searchView.width, 44)];
    _search.delegate = self;
    //        _search.textColor =PL_UTILS_COLORRGB(60, 60, 60);
    _search.returnKeyType = UIReturnKeySearch;
    _search.font = FONT_CUSTOM(14);
    UIColor *color = [UIColor whiteColor];
    _search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索机构/课程" attributes:@{NSForegroundColorAttributeName: color}];
    [searchView addSubview:_search];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sortBtn.mas_right).offset(10);
        make.top.equalTo(@26);
        make.height.equalTo(@44);
        make.right.equalTo(_navBGView).offset(-50);
    }];
    [searchBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(searchView);
        make.height.equalTo(@30);
    }];
    [serchImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@7);
        make.top.equalTo(@8);
        make.width.height.equalTo(@15);
    }];
    [_search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@32);
        make.top.equalTo(searchView).offset(6);
        make.width.equalTo(searchView).offset(-15);
    }];
    
    
    
    [self addMesseageBtnInTheView:_navBGView];
    
    UIView *view=[[UIView alloc]init];
    _bannerArray= [NSMutableArray array];
    for (QGEduBannerListModel   *bannerModel in _dataModel.bannerList) {
        [self.bannerArray  addObject:bannerModel.cover];
    }

    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH*0.625) imageURLStringsGroup:self.bannerArray];

  
    cycleScrollView.pageControlDotSize = CGSizeMake(5, 5);
    cycleScrollView.autoScrollTimeInterval = 5;
    cycleScrollView.delegate = self;
    [view addSubview:cycleScrollView];
    _modelView = [[QGSubjectView alloc]initWithFrame:CGRectMake(0, cycleScrollView.maxY, SCREEN_WIDTH, 85)];
    if (_dataModel.cateList.count > 4) {
        _modelView.height = 165;
    }

    [_modelView addDataToImageArray:_dataModel.cateList];
    [view addSubview:_modelView];
    [_modelView tapModel:^(QGEducateListtModel *model) {


        if ([model.id isEqualToString:@"0"]) {
            QGEduClassViewController *vc = [[QGEduClassViewController alloc] init];
            vc.id = model.id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{

            QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
            search.catogoryId = model.id;
            search.searchOptionType = QGSearchOptionTypeCourse;
            [self.navigationController pushViewController:search animated:YES];

        }
    }];

    UILabel *lba =[[UILabel alloc] initWithFrame:CGRectMake(0,_modelView.maxY , MQScreenW, 10)];

    lba.backgroundColor = COLOR(242, 243, 244, 1);
     view.frame = CGRectMake(0, 0, SCREEN_WIDTH, lba.maxY);;
    self.tableView.tableHeaderView = view;
    [view addSubview:lba];

}
- (void)addMesseageBtnInTheView:(UIView *)view
{
    //消息
    UIView * bottomView = [[UIView alloc] init];
    bottomView.frame=CGRectMake(SCREEN_WIDTH-7-40, 22, 40, 40);
    bottomView.backgroundColor = [UIColor clearColor];
    
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"icon_home_message"] forState:UIControlStateNormal];

    messageBtn.enabled= YES;
    [messageBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.frame = CGRectMake(6, 0, 20, 20);
    messageBtn.centerX = 20;
    messageBtn.centerY = 20;
    _messageicon = messageBtn;
    
    _messeageLab = [[UIButton alloc]initWithFrame:CGRectMake(11, -4, 15, 15)];
    _messeageLab.cornerRadius = _messeageLab.height/2;
    _messeageLab.backgroundColor = [UIColor redColor];
    _messeageLab.titleFont = [UIFont systemFontOfSize:10];
    _messeageLab.hidden = YES;
    [messageBtn addSubview:_messeageLab];
    [bottomView addSubview:messageBtn];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [bottomView addGestureRecognizer:tap];
    [view addSubview:bottomView];
}

-(void) btnClick{
    
    if ([self loginIfNeeded]) {
        return;
    };
    QGMessageCenterViewController *vc = [QGMessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)buttonClick:(UIButton *)button{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [self getDataCount];
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((section == [self getDataCount]-1) && (_dataModel.courseList.count > 0)) {
        return _dataModel.courseList.count;
    }else {
        
        return 1;
    }

}

- (NSInteger)getDataCount{
    NSInteger count = 0;
    count += _dataModel.courseList.count > 0;
    count += _dataModel.videoList.count > 0;
    count += _dataModel.activityList.count > 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QGEduHomeCellType type = [self getCellTypeWithIndexPath:indexPath];

    if (type == QGEduHomeCellTypeActiv)
    {
        PL_CELL_CREATEMETHOD(QGEduFristActivityListCell,@"activity") ;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.dataSource = _dataModel.activityList;
        [cell.collectionView reloadData];
        return cell;
    }

    else if (type == QGEduHomeCellTypeVideo)

    {
        PL_CELL_CREATEMETHOD(QGQGEduFristVideoListCell,@"video")
        cell.dataSource = _dataModel.videoList;
        [cell.collectionView reloadData];
        return cell;
    }else {
        PL_CELL_CREATEMETHOD(QGSearchCourseTableViewCell, @"searchCourse")
        cell.model = _dataModel.courseList[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QGEduHomeCellType type = [self getCellTypeWithIndexPath:indexPath];
    
    if (type == QGEduHomeCellTypeActiv)
    {
        return MQScreenW*0.23+20;
    }else if(type == QGEduHomeCellTypeVideo){

        return 140;
    }else {
        return 245.7;
    }

}
- (void) scrollButton:(UIButton *)bt {


    NSLog(@"sssss");
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view= [[UIView alloc] init];
    
    QGEduHomeCellType type = [self getCellTypeWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];

    if (type == QGEduHomeCellTypeActiv)
    {
        view=[self createSectionHeaderView:@"亲子活动" iconImageName:@"parent_child_ activities"];
    }else if (type == QGEduHomeCellTypeVideo) {

        view=[self createSectionHeaderView:@"名师风采" iconImageName:@"children_elegant_ demeanour"];

    }

    else if (type == QGEduHomeCellTypeCourse)
    {
        view =[self createSectionHeaderView:@"推荐课程" iconImageName:@"recommended_course" ];

    }
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view= [[UIView alloc] init];
    QGEduHomeCellType type = [self getCellTypeWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];

    if (type == QGEduHomeCellTypeActiv)
    {
     
        view = [self createSectionfooterView:@"更多活动" iconImageName:@"cell_right_arrow" moreBtnAction:^{
            QGActivityHomeViewController *Activity = [[QGActivityHomeViewController alloc] init];
          
         
            [self.navigationController pushViewController:Activity animated:YES];
        }];
    }else if (type == QGEduHomeCellTypeVideo) {

        view = [self createSectionfooterView:@"更多视频" iconImageName:@"cell_right_arrow" moreBtnAction:^{
            NSDictionary *dic  = _dataModel.more;
            NSString *str = dic[@"videoCircleId"];
            BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:str.integerValue];
            [self.navigationController pushViewController:vc animated:YES];
        }];

    }

    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( self.dataModel.courseList.count > 0 &&indexPath.section== ([self getDataCount] - 1) ) {
        
     QGCourseInfoModel * model =   _dataModel.courseList[indexPath.row];
      
        QGCourseDetailViewController *vc =[[QGCourseDetailViewController alloc] init];
        vc.course_id =model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self tableView:tableView numberOfRowsInSection:section]==0&&section==0)
    {
        return 10;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {


    if (section < ([self getDataCount] - 1)) {
        return 54;
    }else {
        
        return 0.01;
    }
}

- (QGEduHomeCellType)getCellTypeWithIndexPath:(NSIndexPath *)indexPath{
    QGEduHomeCellType type = QGEduHomeCellTypeCourse;
    if (indexPath.section == 0) {
        if (_dataModel.activityList.count > 0) {
            type = QGEduHomeCellTypeActiv;
        }else{
            type = _dataModel.videoList.count > 0 ? QGEduHomeCellTypeVideo : QGEduHomeCellTypeCourse;
        }
    }else if(indexPath.section == 1){
        
        type = (_dataModel.activityList.count > 0 && _dataModel.videoList.count > 0) ? QGEduHomeCellTypeVideo : QGEduHomeCellTypeCourse;
    }
    return type;
}

#pragma mark 尾部视图
- (UIView *)createSectionfooterView:(NSString *)sectionName iconImageName:(NSString *)imageName moreBtnAction:(void(^)())moreBtnBlock
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);

  

    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, self.view.width, 0.5);
    lineView.backgroundColor = QGlineBackgroundColor;
    [view addSubview:lineView];
  
    //更多
    UIButton* moreBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    
    [moreBtn setTitle:sectionName];
    [moreBtn setTitleFont:FONT_CUSTOM(16)];
    [moreBtn setTitleColor:[UIColor colorFromHexString:@"999999"]];
    [moreBtn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 0, -150);
    [view addSubview:moreBtn];
    [moreBtn addClick:^(UIButton *button) {
        if (moreBtnBlock)
        {
            moreBtnBlock();
        }
    }];
    UIView *lb =[[UIView alloc] initWithFrame:CGRectMake(0, moreBtn.maxY, self.view.width, 10)];
    
    lb.backgroundColor =COLOR(242, 243, 244, 1);
    
    [view addSubview:lb];
    return view;
}



#pragma  mark 头部视图
- (UIView *)createSectionHeaderView:(NSString *)sectionName iconImageName:(NSString *)imageName
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);

    UIImageView *nickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    nickImageView.frame=CGRectMake(9, 12, 14, 14);
    [view addSubview:nickImageView];
    UILabel *Lab=[[UILabel alloc]init];
    Lab.font=FONT_CUSTOM(16);
    Lab.text=sectionName;
    Lab.textColor = QGMainContentColor;
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(0, self.view.height - 1, self.view.width,1);
    lineView.backgroundColor = QGlineBackgroundColor;
    [view addSubview:lineView];
    [view addSubview:Lab];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(view);
        make.height.equalTo(@(1.0 / [UIScreen mainScreen].scale));
    }];

    [nickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(12);
        make.centerY.equalTo(view.mas_centerY);
    }];
    [Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickImageView.mas_right).offset(6);
        make.centerY.equalTo(view.mas_centerY);
    }];
    return view;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        
        float Range = 150.0;
        float higth = scrollView.contentOffset.y;
        if (higth < 0.0) {
            _navBGView.backgroundColor = RGBA(255, 255, 255 ,0);
            UIColor *color = RGBA(255, 255, 255 ,0);
            _search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索机构/课程" attributes:@{NSForegroundColorAttributeName: color}];
            [_messageicon setImage:[UIImage imageNamed:@""]];
            _messageicon.hidden = YES;
            _searchBg.backgroundColor = COLOR(177, 177, 177, 0);
            _searchimg.image = [UIImage imageNamed:@""];
            [_sortBtn setTitleColor:RGBA(255, 255, 255 ,0) forState:(UIControlStateNormal)];
            _sortBtn.image = [UIImage imageNamed:@""];
            _lineView.backgroundColor = RGBA(255, 255, 255 ,0);
        }
        else if ( higth >= 0.0 && higth < Range) {
            float alpha = 1.0 / Range * higth;
            _navBGView.backgroundColor = RGBA(253, 255, 255 ,alpha);
            UIColor *color = [UIColor whiteColor];
            _search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索机构/课程" attributes:@{NSForegroundColorAttributeName: color}];
            _sortBtn.image = [UIImage imageNamed:@"icon_city_home"];
            [_messageicon setImage:[UIImage imageNamed:@"message_image"]];
            _searchimg.image = [UIImage imageNamed:@"icon_search_home"];
            _messageicon.hidden = NO;
            _searchBg.backgroundColor = COLOR(177, 177, 177, 0.5);
            [_sortBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            _lineView.backgroundColor = RGBA(255, 255, 255 ,0);
        }else
        {
            UIColor *color = QGTitleColor;
            _search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索机构/课程" attributes:@{NSForegroundColorAttributeName: color}];
            _navBGView.backgroundColor = RGBA(253, 255, 255 ,1.0);_searchBg.backgroundColor = COLOR(177, 177, 177, 0.5);
            //            _searchBg.backgroundColor =COLOR(243, 243, 243, 1);
            [_messageicon setImage:[UIImage imageNamed:@"message_icon"]];
            _messageicon.hidden = NO;
            [_sortBtn setTitleColor:QGTitleColor forState:(UIControlStateNormal)];
            _searchimg.image =[UIImage imageNamed:@"icon_classification_search"];
            _searchBg.backgroundColor = APPBackgroundColor;
            _lineView.backgroundColor = COLOR(222, 222, 222, 1);
        }
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >MQScreenH) {
        
        self.returnTopButton.hidden = NO;
    }else {
        
        if (offsetY < MQScreenW) {
            
            self.returnTopButton.hidden = YES;
        }
        
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    QGSerachViewController *cvc = [[QGSerachViewController alloc]init];
    _search.text = nil;
    [self.navigationController pushViewController:cvc animated:YES];
}
#pragma mark SDCycleScrollViewDelegate 代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    QGBannerModel  *banner =_dataModel.bannerList[index];

    if ([banner.type integerValue]==1)
    {
        [self goSingleItemViewC:banner.activity_id];
    }else if([banner.type integerValue]==2)
    {
        [self goComboViewC:banner.activity_id];
    }else if([banner.type integerValue]==3)
    {
        [self goSubjectBrandViewC];
    }else if([banner.type integerValue]==4)
    {
        [self goClassViewC:banner.activity_id];
    }else if ([banner.type integerValue]==5)
    {
        QGBannerWebViewController *b=[[QGBannerWebViewController alloc]init];
        b.url = banner.url;
        [self.navigationController pushViewController:b animated:YES];
    }
    else if ([banner.type integerValue]==6)
    {
        [self goClassWithCategoryViewC:banner.activity_id];
    }else if ([banner.type integerValue]==7)
    {
        [self goEducationMainViewController];
    }else if ([banner.type integerValue]==8)
    {
        [self goOrgViewController:banner.activity_id];
    }else if ([banner.type integerValue]==9)
    {
        [self goTeacherViewController:banner.activity_id];
    }else if ([banner.type integerValue]==10)
    {
        [self goCourseListViewController];
    }else if ([banner.type integerValue]==11)
    {
        [self goCourseDetailViewController:banner.activity_id];
    }
    else if ([banner.type integerValue]==20)
    {
        [self goEduCourseSearchResultVC:banner.activity_id];
    }
    else if ([banner.type integerValue]==12)
    {// 活动列表
        [self goActListVC];
    }
    else if ([banner.type integerValue]==13)
    {// 活动详情
        [self goNearActDetailViewC:banner.activity_id];
    }
    else if ([banner.type integerValue]==18)
    {// 机构详情
        [self goNearOrgDetailViewC:banner.activity_id];
    }
    else if ([banner.type integerValue]==19)
    {// 活动详情
        [self goNearTheacherDetailViewC:banner.activity_id];
    }
    else if ([banner.type integerValue]==100)
    {// 巧妈帮首页
        BLUCircleMainViewController *Circle = [[BLUCircleMainViewController alloc]init];
        [self.navigationController pushViewController:Circle animated:YES];
    }
    else if ([banner.type integerValue]==101)
    {//帖子详情BLUPostDetailAsyncViewController
        BLUPostDetailAsyncViewController *Circle = [[BLUPostDetailAsyncViewController alloc]initWithPostID:banner.activity_id.integerValue];
        [self.navigationController pushViewController:Circle animated:YES];
    }
    else if ([banner.type integerValue]==102)
    {// 某一个圈子
        BLUCircleDetailMainViewController *Circle = [[BLUCircleDetailMainViewController alloc]initWithCircleID:banner.activity_id.integerValue];
        [self.navigationController pushViewController:Circle animated:YES];
    }
    else if ([banner.type integerValue]==111)
    {// 话题标签
        NSLog(@"ssssiiiiiiii %@",banner.activity_id );
        BLUPostTagDetailViewController *tagVC = [[BLUPostTagDetailViewController alloc] initWithTagID:banner.activity_id.integerValue];
        [self.navigationController pushViewController:tagVC animated:YES];
    }
    
    
}

/**
 *  单品
 *
 *  @param addonline_id 商品详情id
 */
- (void)goSingleItemViewC:(NSString *)addonline_id
{
    QGProductDetailsViewController *single=[QGProductDetailsViewController new];
    single.goods_id=addonline_id;
    [self.navigationController pushViewController:single animated:YES];
}
#pragma  mark 品牌特卖
/**
 *  品牌特卖
 *
 *  @param subjectid 品牌特卖id
 */
- (void)goSubjectBrandViewC
{
    QGSecKillViewController *subjectBrand=[QGSecKillViewController new];
    
    [self.navigationController pushViewController:subjectBrand animated:YES];
}
#pragma  mark 去套餐
/**
 *  套餐
 *
 *  @param combo_addonline_id 套餐id
 */
- (void)goComboViewC:(NSString *)combo_addonline_id
{
    
}
#pragma  mark 品牌
/**
 *  品牌
 *
 *  @param bannerId 品牌id
 */
- (void)goClassViewC:(NSString *)shopid
{
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId = shopid;
    search.brand_id = shopid;
    search.searchOptionType =  QGSearchOptionTypeGoods;
    [self.navigationController pushViewController:search animated:YES];
}
#pragma  mark 分类
/**
 *  分类
 *
 *  @param category_id 分类id
 */
- (void)goClassWithCategoryViewC:(NSString *)catogoryId
{
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId = catogoryId;
    search.searchOptionType =  QGSearchOptionTypeGoods;
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark 机构
/**
 *  机构
 *
 *  @param org_id 机构id
 */
- (void)goOrgViewController:(NSString *)org_id
{
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId = org_id;
    search.searchOptionType = QGSearchOptionTypeInstitution;
    [self.navigationController pushViewController:search animated:YES];
}
#pragma mark 教师
/**
 *  教师页
 *
 *  @param teacherId 教师id
 */
- (void)goTeacherViewController:(NSString *)teacherId
{
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId = teacherId;
    search.searchOptionType = QGSearchOptionTypeTeacher;
    [self.navigationController pushViewController:search animated:YES];
}
#pragma mark 班课
/**
 *  班课
 *
 *  @param course_id 班课id
 */
- (void)goCourseDetailViewController:(NSString *)course_id
{
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId = course_id;
    search.searchOptionType = QGSearchOptionTypeCourse;
    [self.navigationController pushViewController:search animated:YES];
}

- (void)goCourseListViewController {
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.searchOptionType = QGSearchOptionTypeCourse;
    [self.navigationController pushViewController:search animated:YES];
}
#pragma mark 活动

- (void)goActListVC
{
    
    QGActivityHomeViewController *ctl = [[QGActivityHomeViewController alloc] init];
    
    [self.navigationController pushViewController:ctl animated:YES];
}

/**
 *  教师详情
 *
 *  @param actid 活动id
 */
- (void)goNearTheacherDetailViewC:(NSString *)teacher_id
{
    QGTeacherViewController *ctl = [[QGTeacherViewController alloc] init];
    ctl.teacher_id = teacher_id;
    
    [self.navigationController pushViewController:ctl animated:YES];
}
/**
 *  活动详情
 *
 *  @param actid 活动id
 */
- (void)goNearActDetailViewC:(NSString *)actid
{
    QGActivityDetailViewController *ctl = [[QGActivityDetailViewController alloc] init];
    ctl.activity_id = actid;
    
    [self.navigationController pushViewController:ctl animated:YES];
}
#pragma mark 教育首页
/**
 *  教育首页
 */
- (void)goEducationMainViewController
{
    
    self.tabBarController.selectedIndex=1;
    
}
- (void)goEduCourseSearchResultVC:(NSString *)catogoryId
{
    QGCourseDetailViewController * ctr = [[QGCourseDetailViewController alloc]init];
    ctr.course_id = catogoryId;
    
    [self.navigationController pushViewController:ctr animated:YES];
}
/**
 *  机构详情
 *
 *  @param actid 活动id
 */
- (void)goNearOrgDetailViewC:(NSString *)org_id
{
    QGOrgViewController *ctl = [[QGOrgViewController alloc] init];
    ctl.org_id = org_id;
    
    [self.navigationController pushViewController:ctl animated:YES];
}
@end
