//
//  MQShopViewController.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/23.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGOptimalProductViewController.h"
#import "SDCycleScrollView.h"
#import "QGSubjectView.h"
#import "QGOptimalProductSkillTableViewCell.h"
#import "QGOptimalProductCardCell.h"
#import "QGSecKillViewController.h"
#import "QGViewController+QGReturnToTheTop.h"
#import "QGOptimalClassController.h"
#import "QGSerachViewController.h"
#import "QGMessageCenterViewController.h"
#import "QGShopCarViewController.h"
#import "QGSearchResultViewController.h"
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
#import "QGTeacherViewController.h"
#import "QGOrgViewController.h"
#import "QGGoodsMO.h"

@interface QGOptimalProductViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)SASRefreshTableView*tableView;
@property (nonatomic,strong) UIView *navBGView;
@property (nonatomic,strong) NSMutableArray *bannerArray;//分类
@property (nonatomic,strong) UIImageView *searchBg;
@property (nonatomic,strong) UIButton *messageicon;
@property (nonatomic,strong) UIImageView *searchimg;
@property (nonatomic,strong) UIButton *ShopCarButton;
/**搜索框*/
@property(nonatomic,strong)UITextField *search;
@property (nonatomic,strong)UIButton *messeageLab;

@property (nonatomic,strong)UIButton *ShopCarCountButton;

@property (nonatomic,strong) UIButton *sortBtn;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) QGOptimalProductResultModel *result;
@property (nonatomic, strong) QGSubjectView * modelView;
  @property (nonatomic,strong) UIView *lineView;
@end

@implementation QGOptimalProductViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"优品";
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self getUserMessageCount];
    NSInteger count = [self getShopCarCount];
    _ShopCarCountButton.hidden = count > 0 ? NO : YES;
    _ShopCarCountButton.title = @(count).stringValue;
}
#pragma mark 懒加载
- (NSMutableArray *)bannerArray {
    
    if (!_bannerArray) {
        _bannerArray= [NSMutableArray array];
    }
    return _bannerArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseData];
    
    if (_tableView==nil) {
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = COLOR(242, 243, 244, 1);
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.tableHeaderView=[[UIView alloc]init];
        _tableView.tableFooterView=[[UIView alloc]init];
        
        
        PL_CODE_WEAK(weakSelf);
        [_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
            [weakSelf requestFirstDataMethod:SARefreshPullUpType];
        }];
        
    }else {
        
        [_tableView reloadData];
    }
    
    [self requestFirstDataMethod:SARefreshPullUpType];
    
}

/**
 *  请求数据
 *
 *  @param type 下拉刷新
 */
-(void)requestFirstDataMethod:(SARefreshType)type{
    [[SAProgressHud sharedInstance]showWaitWithWindow];
    [QGHttpManager optimaiProducthomeDataSuccess:^(QGOptimalProductResultModel *result) {
        [self.view addSubview:_tableView];
        _result = [[QGOptimalProductResultModel alloc] init];
        _result = result;
        [_listArray removeAllObjects];
        _listArray = [NSMutableArray array];
        _listArray = result.subjectList;
        
        [self createTableHeader];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.view addSubview:_tableView];
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

/**
 *  头部视图
 */
- (void)createTableHeader {
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
        make.top.equalTo(@32);
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
    
    _bannerArray = [NSMutableArray array];
    
    for ( QGOptimalProductBannerListModel *bannerModel in _result.bannerList) {
        [self.bannerArray  addObject:bannerModel.cover];
        
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH*0.625) imageURLStringsGroup:self.bannerArray];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlDotSize = CGSizeMake(5, 5);
    cycleScrollView.autoScrollTimeInterval = 5;
    [view addSubview:cycleScrollView];
    _modelView = [[QGSubjectView alloc]initWithFrame:CGRectMake(0, cycleScrollView.maxY, SCREEN_WIDTH, 85)];
    if (_result.cateList.count > 4) {
        _modelView.height = 165;
    }
    [_modelView addDataToImageArray:_result.cateList];
    
    [view addSubview:_modelView];
    [_modelView tapModel:^(QGEducateListtModel *model) {
        
        if ([model.id isEqualToString:@"0"]) {
            QGOptimalClassController *vc = [[QGOptimalClassController alloc] init];
            vc.id = model.id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            
            QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
            search.catogoryId = model.id;
            search.searchOptionType = QGSearchOptionTypeGoods;
            [self.navigationController pushViewController:search animated:YES];
            
        }
        
    }];

    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _modelView.maxY);
    self.tableView.tableHeaderView = view;

    
    
}




- (void)addMesseageBtnInTheView:(UIView *)view
{
    //消息
    UIView * bottomView = [[UIView alloc] init];
    bottomView.frame=CGRectMake(SCREEN_WIDTH-7-40, 26, 40, 40);
    bottomView.backgroundColor = [UIColor clearColor];
    
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [messageBtn setBackgroundImage:[UIImage imageNamed:@"background_home_classification"] forState:UIControlStateNormal];
    [messageBtn setImage:[UIImage imageNamed:@"message_image"] forState:UIControlStateNormal];
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
    [self addCarIconBtn];
}

#pragma mark 添加侧面购物车
- (void)addCarIconBtn {
    
    
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.backgroundColor = [UIColor clearColor];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"shopCar-icon"] forState:UIControlStateNormal];
    messageBtn.enabled= YES;
    [messageBtn addTarget:self action:@selector(btnCarClick) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.frame = CGRectMake(MQScreenW - 50, MQScreenH-120, 35, 35);
    _ShopCarButton = messageBtn;
    
    _ShopCarCountButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 17, 17)];
    _ShopCarCountButton.cornerRadius = _ShopCarCountButton.height/2;
    _ShopCarCountButton.backgroundColor = QGMainRedColor;
    _ShopCarCountButton.titleFont = [UIFont systemFontOfSize:10];
    
    [messageBtn addSubview:_ShopCarCountButton];
    
    NSInteger count = [self getShopCarCount];
    _ShopCarCountButton.hidden = count > 0 ? NO : YES;
    _ShopCarCountButton.title = @(count).stringValue;
    
    [self.view addSubview:messageBtn];

}

- (NSInteger)getShopCarCount{
    
    NSArray *arr = [self findAllShopCarGoods];
    return arr.count;
}


- (NSArray *)findAllShopCarGoods{
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:
     @"isSeckilling ==%@",@(NO)];
    NSArray *arr = [QGGoodsMO MR_findAllWithPredicate:predicate];
    return arr;
}

- (void)btnCarClick {
    
    QGShopCarViewController *vc = [QGShopCarViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void) btnClick{
    
    if ([self loginIfNeeded]) {
        return;
    };
    QGMessageCenterViewController *vc = [QGMessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    QGSerachViewController *cvc = [[QGSerachViewController alloc]init];
    cvc.searchOptionType = QGSearchOptionTypeGoods;
    _search.text = nil;
    [self.navigationController pushViewController:cvc animated:YES];
}
#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


        return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_result.seckillingList.items.count>0) {
    
        if (section==1){
            return _listArray.count ;
        }else{
            return 1;
        }
    }else {
        
        return _listArray.count;
    }
    
    
    
  
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==0){
            
            static NSString *skill=@"skillCell";
            QGOptimalProductSkillTableViewCell *skillCell=[tableView dequeueReusableCellWithIdentifier:skill];
            
            
            if (!skillCell)
            {
                skillCell=[[NSBundle mainBundle]loadNibNamed:@"QGOptimalProductSkillTableViewCell" owner:self options:nil][0];
            }
            
            if (_result.seckillingList.items.count>0) {
                skillCell.result= _result;
                skillCell.hidden = NO;
            }else{
                skillCell.hidden = YES;
            }
            
            return skillCell;
        }else {

       QGOptimalProductSubjrctListModel *SubjrctListModel =_listArray[indexPath.row] ;
 
        PL_CELL_CREATEMETHOD(QGOptimalProductCardCell, @"cell")
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.SubjrctListModel = SubjrctListModel;
        return cell;
    }
    
    }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==0) {
        QGSecKillViewController *vc =[[QGSecKillViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==0)
    {

        if (_result.seckillingList.items >0) {
          return 130;
        }else {

            return 0;
        }


    }
    else {
        return MQScreenW*0.5+54;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
          if (_result.seckillingList.items.count>0) {
              return 10;

          }else {
                  return 0.1;
    }
    }else
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        
        float Range = 150.0;
        float higth = scrollView.contentOffset.y;
        
        if (higth <0.0) {
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
            _searchBg.backgroundColor = COLOR(177, 177, 177, 0.5);
            _sortBtn.image = [UIImage imageNamed:@"icon_city_home"];
            [_messageicon setImage:[UIImage imageNamed:@"message_image"]];
            _messageicon.hidden = NO;
            _searchimg.image = [UIImage imageNamed:@"icon_search_home"];
            [_sortBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            _lineView.backgroundColor = RGBA(255, 255, 255 ,0);
        }else
        {
            UIColor *color = QGTitleColor;
            _search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索机构/课程" attributes:@{NSForegroundColorAttributeName: color}];
            _navBGView.backgroundColor = RGBA(253, 255, 255 ,1.0);
            //            _searchBg.backgroundColor =COLOR(243, 243, 243, 1);
            [_messageicon setImage:[UIImage imageNamed:@"message_icon"]];
            _messageicon.hidden = NO;

            [_sortBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            

            [_sortBtn setTitleColor:QGTitleColor forState:(UIControlStateNormal)];
            _lineView.backgroundColor = COLOR(222, 222, 222, 1);;

            _sortBtn.image = [UIImage imageNamed:@"城市-箭头"];
            _searchimg.image =[UIImage imageNamed:@"icon_classification_search"];
            _searchBg.backgroundColor = APPBackgroundColor;
        }
    }
    
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >MQScreenH) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.returnTopButton.hidden = NO;
            _ShopCarButton.frame =  CGRectMake(MQScreenW - 50, MQScreenH-180, 35, 35);
        }];
        
    }else {
        
        if (offsetY < MQScreenW) {
            
            
            [UIView animateWithDuration:0.2 animations:^{
                self.returnTopButton.hidden = YES;
                _ShopCarButton.frame =  CGRectMake(MQScreenW - 50, MQScreenH-120, 35, 35);
            }];
        }
        
    }
}
#pragma mark SDCycleScrollViewDelegate 代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    QGEduBannerListModel  *banner =_result.bannerList[index];
    
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
        [self goCourseDetailViewController:banner.activity_id];
    }else if ([banner.type integerValue]==20)
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
    }  else if ([banner.type integerValue]==18)
    {// 机构详情
        [self goNearOrgDetailViewC:banner.activity_id];
    }
    else if ([banner.type integerValue]==19)
    {// 老师详情
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
#pragma mark 活动

- (void)goActListVC
{
    
 self.tabBarController.selectedIndex=1;
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
