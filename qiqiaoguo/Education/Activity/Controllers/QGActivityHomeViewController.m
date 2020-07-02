//
//  QGActivityHomeViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/5.
//
//

#import "QGActivityHomeViewController.h"
#import "SDCycleScrollView.h"
#import "QGActivityHomeViewcell.h"
#import "QGActivityDetailViewController.h"
#import "QGMessageCenterViewController.h"
#import "QGActivityDetailViewController.h"
#import "GHBLocationManager.h"
#import "QGSecKillViewController.h"
#import "QGSearchResultViewController.h"
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
#import "QGEducationViewController.h"
#import "QGViewController+QGReturnToTheTop.h"
#import "QGTeacherViewController.h"
#import "QGOrgViewController.h"
#import "QGActivityCalendarCell.h"

@interface QGActivityHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic,strong)SASRefreshTableView*tableView;
@property (nonatomic,strong) NSMutableArray *bannerArray;
@property (nonatomic,strong) QGActHomeResultModel *result ;
@property (nonatomic,strong) QGActlistHomeResultModel *actListModel;
@property (nonatomic,strong)  QGActlistHomeModel*actModel;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *navBGView;
@property (nonatomic,strong) UIButton *messageicon;
@property (nonatomic,strong)  SAButton * returnBtn;
@property (nonatomic,strong)UIButton *messeageLab;
@end

@implementation QGActivityHomeViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"活动";
        
    }
    return self;
}
-  (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self getUserMessageCount];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];

    [self addTabView_UI];
    [self createNavInfo];
    [self getUserMessageCount];
    //[self createActListInfo:SARefreshPullDownType];
    [self requestFirstDataMethod:SARefreshPullUpType];
}

- (void)createNavInfo {
    
    _navBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64+Height_StatusBar)];
    _navBGView.backgroundColor = RGBA(255, 255, 255 ,0);
//    _navBGView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_navBGView];
    //返回按钮
//    SAButton * returnBtn = [SAButton buttonWithType:UIButtonTypeCustom];
//    returnBtn.frame = CGRectMake(0, self.navImageView.height - 34, 50, 49);
//    [returnBtn setNormalImage:@"round-back-icon"];
//	PL_CODE_WEAK(ws);
//    [returnBtn addClick:^(SAButton *button) {
//        [ws.navigationController popViewControllerAnimated:YES];
//    }];
//    _returnBtn = returnBtn;

	UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, self.navImageView.height - 34, 50, 49);
    [returnBtn setImage:[UIImage imageNamed:@"round-back-icon"] forState:UIControlStateNormal];
	[returnBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_navBGView addSubview:returnBtn];
    [self addMesseageBtnInTheView:_navBGView];
}
- (void)backClick
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)addMesseageBtnInTheView:(UIView *)view
{
    //消息
    UIView * bottomView = [[UIView alloc] init];
    bottomView.frame=CGRectMake(SCREEN_WIDTH-50,  self.navImageView.height - 30, 35, 35);
    bottomView.backgroundColor = [UIColor clearColor];
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [messageBtn setBackgroundImage:[UIImage imageNamed:@"background_home_classification"] forState:UIControlStateNormal];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"actmess-icon"] forState:UIControlStateNormal];
    messageBtn.enabled= YES;
    [messageBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//    messageBtn.frame = CGRectMake(0, 0, 35, 35);
    [messageBtn sizeToFit];
    messageBtn.centerX = 25;
    messageBtn.centerY = 20;
    _messeageLab = [[UIButton alloc]initWithFrame:CGRectMake(18, 3, 15, 15)];
    [_messeageLab addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    _messeageLab.cornerRadius = _messeageLab.height/2;
    _messeageLab.backgroundColor = [UIColor redColor];
    _messeageLab.titleFont = [UIFont systemFontOfSize:10];
    _messeageLab.hidden = YES;
    [messageBtn addSubview:_messeageLab];

    [bottomView addSubview:messageBtn];
    _messageicon = messageBtn;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [bottomView addGestureRecognizer:tap];
    [view addSubview:bottomView];
}

- (void)updateUserMessageCount{
    if (self.messageCount > 0) {
        _messeageLab.title = @(self.messageCount).stringValue;
    }
    _messeageLab.hidden = self.messageCount == 0;
}

-(void) btnClick{
    
    if ([self loginIfNeeded]) {
        return;
    };
    QGMessageCenterViewController *vc = [QGMessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 创建ui
- (void)addTabView_UI {
    
    _dataArray = [[NSMutableArray alloc]init];
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
            [weakSelf requestFirstDataMethod:SARefreshPullDownType];
        }];
        [_tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {

            [weakSelf requestFirstDataMethod:SARefreshPullUpType];
        }];
        [_tableView reloadData];
    }else {
        
        [_tableView reloadData];
    }
    __weak typeof(self) weakSelf = self;
    [self addReturnToTheTopButtonFrame:CGRectMake(MQScreenW - 50, MQScreenH-120, 35, 35) WithBackgroundImage:[UIImage imageNamed:@"返回顶部"] CallBackblock:^{
        [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, MQScreenW, MQScreenH) animated:YES];
    }];
    
    if (@available(iOS 11.0, *)) {
         _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     }
    
}


#pragma mark 活动banner请求
- (void)requestFirstDataMethod:(SARefreshType )type{
    [[SAProgressHud sharedInstance]showWaitWithWindow];
    [QGHttpManager acthomeDataSuccess:^(QGActHomeResultModel *result) {
        
        _result = result;
        
        [self addHeaderView];
        
        [self createActListInfo:type];
    } failure:^(NSError *error) {
         [self showTopIndicatorWithError:error];
    }];
    
}

#pragma 活动列表请求
- (void)createActListInfo:(SARefreshType )type{
    QGActlistHomeDownload *ph =[[QGActlistHomeDownload alloc] init];
    if (type == SARefreshPullDownType)
        ph.page = @"1";
    else
        ph.page = [NSString stringWithFormat:@"%ld",(long)self.page];
    NSLog(@"sssssssrrr  %ld",(long)self.page);
    [QGHttpManager actlisthomeDataWithParam:ph success:^(QGActlistHomeResultModel *result) {
        _actListModel = result;
        NSLog(@"dmokkmklmp %@ %@ %@ %@ %@", result.items,result.per_page,result.current_page,result.total_page,result.total_page);
        
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
        NSLog(@"sssssssrrr  %ld",(long)self.page);
        NSArray *nn = [NSArray array];
        nn = result.items;
        [_dataArray addObjectsFromArray:nn];
        [self.tableView reloadData];
        [_tableView endRrefresh];
    } failure:^(NSError *error) {
         [self showTopIndicatorWithError:error];
    }];
}
- (void)addHeaderView{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH*0.62)];
    _bannerArray= [NSMutableArray array];
    for (QGActHomeModel *model in _result.items) {
        [self.bannerArray addObject:model.cover];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH*5/8) imageURLStringsGroup:self.bannerArray];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlDotSize = CGSizeMake(5, 5);
    cycleScrollView.autoScrollTimeInterval = 3;
    [view addSubview:cycleScrollView];
    self.tableView.tableHeaderView = view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 + (_dataArray.count>0);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
    
    return  section == 0 ? 1 : _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
        
        PL_CELL_CREATEMETHOD(QGActivityCalendarCell,@"QGActivityCalendarCell");
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
    PL_CELL_CREATE(QGActivityHomeViewcell);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _actModel = _dataArray[indexPath.row];
    cell.actModel = _actModel;
    return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGActlistHomeModel *actModel = [[QGActlistHomeModel alloc] init];
    actModel = _dataArray[indexPath.row];
    QGActivityDetailViewController *vc = [[QGActivityDetailViewController alloc] init];
    vc.activity_id =actModel.id;
    vc.sign_tips = actModel.sign_tips;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 17;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return MQScreenW *0.18;
    }
    
    return (MQScreenW-20)*5/9 +65;
    
}

#pragma mark SDCycleScrollViewDelegate 代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

    QGActHomeModel  *banner =_result.items[index];
    NSLog(@"ssssmkkmk %@",banner.activity_id);
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
    else if ([banner.type integerValue]==18)
    {// 机构详情
        [self goNearOrgDetailViewC:banner.activity_id];
    }
    else if ([banner.type integerValue]==20)
    {
        [self goEduCourseSearchResultVC:banner.activity_id];
    }
    else if ([banner.type integerValue]==12)
    {// 活动列表
        [self goActListVC];
    }else if ([banner.type integerValue]==19)
    {//教师
        [self goNearTheacherDetailViewC:banner.activity_id];
    }

    else if ([banner.type integerValue]==13)
    {// 活动详情
        [self goNearActDetailViewC:banner.activity_id];
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
- (void)goClassWithCategoryViewC:(NSString *)CategoryId
{
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId = CategoryId;
    search.searchOptionType =QGSearchOptionTypeGoods;
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
- (void)goCourseListViewController {
    
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];

    search.searchOptionType = QGSearchOptionTypeCourse;
    [self.navigationController pushViewController:search animated:YES];
    
}


- (void)goCourseDetailViewController:(NSString *)course_id
{
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId = course_id;
    search.searchOptionType = QGSearchOptionTypeCourse;
    [self.navigationController pushViewController:search animated:YES];
}
#pragma mark 活动

- (void)goActListVC
{
   // QGActivityHomeViewController *ctl = [[QGActivityHomeViewController alloc] init];
    self.tabBarController.selectedIndex=1;
    //[self.navigationController pushViewController:ctl animated:YES];
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
    QGEducationViewController *vc = [[QGEducationViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)goEduCourseSearchResultVC:(NSString *)catogoryId
{
    QGCourseDetailViewController * ctr = [[QGCourseDetailViewController alloc]init];
    ctr.course_id = catogoryId;
    
    [self.navigationController pushViewController:ctr animated:YES];
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
