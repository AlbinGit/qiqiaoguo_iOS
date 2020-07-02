//
//  MQHomeViewController.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/25.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGHomeViewController.h"
#import "SDCycleScrollView.h"
#import "QGSkillHttpDownload.h"
#import "QGFirstPageDataModel.h"
#import "QGHomeActivityListCell.h"
#import "QGEduFristActivityListCell.h"
#import "QGHttpManager+Home.h"
#import "QGOptimalProductSkillTableViewCell.h"
#import "QGHomePostListCell.h"
#import "QGPostListFrameModel.h"
#import "SAUserDefaults.h"
#import "QGActivityHomeViewController.h"
#import "QGViewController+QGReturnToTheTop.h"
#import "QGSearchResultNavView.h"
#import "QGSwitchCityViewController.h"
#import "QGMessageCenterViewController.h"
#import "QGSerachViewController.h"
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
#import "QGTeacherViewController.h"
#import "QGOrgViewController.h"
#import "QGSubjectView.h"
#import "QGEduClassViewController.h"


#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

typedef NS_ENUM(NSUInteger, QGHomeCellType) {
    QGHomeCellTypeEdu,
    QGHomeCellTypeActivty,
    QGHomeCellTypeSkill,
    QGHomeCellTypePost,
};


@interface QGHomeViewController ()<UITextFieldDelegate,SDCycleScrollViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (nonatomic,strong) QGFirstPageDataModel *dataModel;
@property (nonatomic,strong) NSMutableArray *postList;
@property (nonatomic,strong) UIView *navBGView;
@property (nonatomic,strong)SASRefreshTableView*tableView;
@property (nonatomic,strong) NSMutableArray *bannerArray;
@property (nonatomic,strong) NSMutableArray *skillArray;
@property (nonatomic,strong) UIImageView *searchBg;
/**城市数组*/
@property (nonatomic,strong)NSMutableArray *shopCityLists;
@property (nonatomic,strong) QGShopCityModel *result;
@property (nonatomic,strong) QGGetCityResultModel *item;
@property (nonatomic,strong) UIButton *messageicon;
@property (nonatomic,strong) UIImageView *searchimg;
/**搜索框*/
@property(nonatomic,strong)UITextField *search;
@property (nonatomic,strong)UIButton *messeageLab;
@property (nonatomic) CLLocationDegrees longitude ;
@property (nonatomic)CLLocationDegrees latitude;
@property (nonatomic,strong) UIButton *sortBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,copy) NSString *cityTitile;
@property (nonatomic, strong) QGSubjectView * modelView;
@end

@implementation QGHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
   // [self getUserMessageCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationManager = [[CLLocationManager alloc]init];
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        locationManager.delegate = self;
    }
    [self getShopCityListRequestMethod];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self add_viewUI];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSMutableArray *)postList {
    
    if (_postList == nil) {
        _postList = [[NSMutableArray alloc] init];
    }
    return _postList;
    
}


-(void)add_viewUI {
    if (_tableView==nil) {
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
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
    [self.view addSubview:_tableView];
    __weak typeof(self) weakSelf = self;
    [self addReturnToTheTopButtonFrame:CGRectMake(MQScreenW - 50, MQScreenH-120, 35, 35) WithBackgroundImage:[UIImage imageNamed:@"返回顶部"] CallBackblock:^{
        [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, MQScreenW, MQScreenH) animated:YES];
    }];
    self.navImageView.alpha=0;
    _navBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _navBGView.backgroundColor = RGBA(255, 255, 255 ,0);
    [self.view addSubview:_navBGView];
    UIView *vc = [[UIView alloc] initWithFrame:CGRectMake(0, 63, self.view.width, 1)];
    vc.backgroundColor = RGBA(255, 255, 255 ,0);
    [_navBGView addSubview:vc];
    self.lineView = vc;
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
    [_sortBtn addTarget:self action:@selector(CityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
        make.left.equalTo(_sortBtn.mas_right).offset(15);
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
    
}



- (void)requestFirstDataMethod:(SARefreshType)type {
    
    
    [[SAProgressHud sharedInstance]showWaitWithWindow];
    [QGHttpManager homeDataSuccess:^(QGFirstPageDataModel *result) {
        _skillArray = [NSMutableArray array];
       _dataModel =result;

        if (_dataModel.seckillingList.items.count>0) {
            [_skillArray addObject:_dataModel.seckillingList];

        }
        [_postList removeAllObjects];
        [self createTableHeader];
        NSMutableArray *frames = [NSMutableArray array];
        //模型数组转为frame数组
        for (QGPostListModel *model in result.postList) {
            QGPostListFrameModel *frame  =[[QGPostListFrameModel alloc] init];
            frame.post = model;
            [frames addObject:frame];
        }
        [self.postList addObjectsFromArray:frames];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];        
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

        
    }];
    
   [self getUserMessageCount];

    
}

- (void)updateUserMessageCount{
    if (self.messageCount > 0) {
        _messeageLab.title = @(self.messageCount).stringValue;
    }
    _messeageLab.hidden = self.messageCount == 0;
}

- (void)updateCityBtnFrameWithTitle:(NSString *)title
{
    _cityTitile = title;
    CGSize btntitleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_sortBtn.titleFont, NSFontAttributeName, nil]];
    float citybtnW = 18 + btntitleSize.width;
    [_sortBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:citybtnW]);
    }];
    [_sortBtn setTitle:title forState:UIControlStateNormal];
    [_sortBtn.titleLabel sizeToFit];
    [_sortBtn.imageView sizeToFit];
    [_sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _sortBtn.titleLabel.width+5, 0, -_sortBtn.titleLabel.width-5)];
    [_sortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_sortBtn.imageView.width , 0, _sortBtn.imageView.width)];
    
}

#pragma mark 头部滚动视图banner
- (void)createTableHeader {
    
    UIView *view=[[UIView alloc]init];
    
    _bannerArray= [NSMutableArray array];
    for (QGBannerModel *bannerModel in _dataModel.bannerList) {
        [self.bannerArray addObject:bannerModel.cover];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH*0.625) imageURLStringsGroup:self.bannerArray];
    cycleScrollView.delegate = self;
 
    cycleScrollView.pageControlDotSize = CGSizeMake(5, 5);
    cycleScrollView.autoScrollTimeInterval = 3;
    [view addSubview:cycleScrollView];

    _modelView = [[QGSubjectView alloc]initWithFrame:CGRectMake(0, cycleScrollView.maxY, SCREEN_WIDTH, 85)];
    if (_dataModel.cateList.count > 4) {
        _modelView.height = 165;
    }
    [_modelView addDataToImageArray:_dataModel.cateList];
    [_modelView tapModel:^(QGEducateListtModel *model) {
        
        
        if ([model.id isEqualToString:@"0"]) {
            QGEduClassViewController *vc = [[QGEduClassViewController alloc] init];
            vc.id = model.id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
            search.catogoryId = model.id;
            search.CateID = model.id.integerValue;
            search.searchOptionType = QGSearchOptionTypeCourse;
            [self.navigationController pushViewController:search animated:YES];
            
        }
    }];
    [view addSubview:_modelView];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _modelView.maxY);
    _tableView.tableHeaderView = view;

}

- (void)addMesseageBtnInTheView:(UIView *)view
{
    //消息
    UIView * bottomView = [[UIView alloc] init];
    bottomView.frame=CGRectMake(SCREEN_WIDTH-50, 20, 50, 50);
    bottomView.backgroundColor = [UIColor clearColor];
    
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"message_image"] forState:UIControlStateNormal];
    messageBtn.enabled= YES;
    [messageBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn sizeToFit];
    messageBtn.centerX = 25;
    messageBtn.centerY = 20;
    _messageicon = messageBtn;
    
    _messeageLab = [[UIButton alloc]initWithFrame:CGRectMake(11, -4, 15, 15)];
    _messeageLab.cornerRadius = _messeageLab.height/2;
    _messeageLab.backgroundColor = [UIColor redColor];
    _messeageLab.titleFont = [UIFont systemFontOfSize:10];
    _messeageLab.hidden = YES;
    [_messageicon addSubview:_messeageLab];
    [bottomView addSubview:_messageicon];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [bottomView addGestureRecognizer:tap];
    [view addSubview:bottomView];
}


-(void)btnClick{
    
    if ([self loginIfNeeded]) {
        return;
    };
    QGMessageCenterViewController *vc = [QGMessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



- (void)CityBtn:(UIButton *)button
{
    PL_CODE_WEAK(weakSelf);
    if (IS_IOS8) {
    [[GHBLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
      
        NSLog(@"当前位置:%f,%f",locationCorrrdinate.longitude,locationCorrrdinate.latitude);

        QGGetLocationCityModel *pa =[[QGGetLocationCityModel alloc] init];
        pa.latitude =  locationCorrrdinate.latitude;
        pa.longitude =  locationCorrrdinate.longitude;
        [QGHttpManager homeGetLocationCityWithParam:pa success:^(QGGetCityResultModel *item) {
      
               _item = item;
            [_shopCityLists enumerateObjectsUsingBlock:^(QGShopCityModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([item.item.name  isEqualToString: obj.name]&&[item.item.is_default integerValue]!=1) {
                    [[SAAlert sharedInstance] showAlertWithTitle:@"" message:[NSString stringWithFormat:@"系统定位您在%@，需要切换到%@吗？",item.item.name,item.item.name] cancelButtonTitle:@"取消" otherTitle:@"切换"];
                    
                    [[SAAlert sharedInstance] confirmClick:^{
                        __weak __typeof(UIButton *)btn = button;
                        [btn setTitle:item.item.name forState:UIControlStateNormal];
                        [weakSelf updateCityBtnFrameWithTitle:item.item.name];
                        
                        [SAUserDefaults saveValue:item.item.sid forKey:USERDEFAULTS_SID];
                        [SAUserDefaults saveValue:item.item.platform_id forKey:USERDEFAULTS_Platform_id];
                    }];
                
                    *stop = YES;
                }
            }];
         } failure:^(NSError *error) {
             [self showTopIndicatorWithError:error];
        }];
        
    }];
    }
}
- (void)CityBtnClick:(UIButton *)button
{
      PL_CODE_WEAK(weakSelf);
     QGSwitchCityViewController *cityVC=[[QGSwitchCityViewController alloc]init];
       cityVC.result = _item.item;
       cityVC.cityNames = weakSelf.shopCityLists;
       cityVC.cityTitle = _cityTitile;
        __weak __typeof(UIButton *)btn = button;
       [cityVC setCityBlock:^(QGShopCityModel *cityModel) {
        [btn setTitle:cityModel.name forState:UIControlStateNormal];
        [weakSelf updateCityBtnFrameWithTitle:cityModel.name];
        [SAUserDefaults saveValue:cityModel.sid forKey:USERDEFAULTS_SID];
        [SAUserDefaults saveValue:cityModel.platform_id forKey:USERDEFAULTS_Platform_id];
        [weakSelf requestFirstDataMethod:SARefreshPullDownType];
        
    }];
    [weakSelf.navigationController pushViewController:cityVC animated:YES];
    
    

    
}


- (void)getLoaction
{
    
}

- (void)getShopCityListRequestMethod {
    [[SAProgressHud sharedInstance]showWaitWithWindow];
    [QGHttpManager homeGetCitySuccess:^(QGGetCityResultModel *result) {
        _shopCityLists = [NSMutableArray array];
        _shopCityLists = result.items;
        QGShopCityModel * shopCityModel = _shopCityLists[0];
        if ([shopCityModel.is_default integerValue]==1)
        {
            [_sortBtn setTitle:shopCityModel.name forState:UIControlStateNormal];
            [self updateCityBtnFrameWithTitle:shopCityModel.name];
            [SAUserDefaults saveValue:shopCityModel.sid forKey:USERDEFAULTS_SID];
            [SAUserDefaults saveValue:shopCityModel.platform_id forKey:USERDEFAULTS_Platform_id];
            [self requestFirstDataMethod:SARefreshPullUpType];
        }
        
         [self CityBtn:_sortBtn];
    } failure:^(NSError *error) {
        [SAUserDefaults saveValue:@"50" forKey:USERDEFAULTS_Platform_id];
        [self showTopIndicatorWithError:error];
    }];
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    NSInteger count = [self getDataCount];

    return count;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((section == [self getDataCount]-1) && (_dataModel.postList.count > 0)) {
        return _dataModel.postList.count;
    }else {

        return 1;
    }
}
- (NSInteger)getDataCount{
    NSInteger count = 0;
    count += _dataModel.postList.count > 0;
      count += _skillArray.count > 0;
    count += _dataModel.activityList.count > 0;
    count += 1;

    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        QGHomeCellType type = [self getCellTypeWithIndexPath:indexPath];

    if (type == QGHomeCellTypeEdu)
    {
        PL_CELL_CREATE(QGHomeActivityListCell)
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        NSString *va = _dataModel.more[@"nearbyAreaId"];
        cell.nearbyAreaID = va.integerValue;
        return cell;
    }
    else if(type ==QGHomeCellTypeActivty){
        PL_CELL_CREATEMETHOD(QGEduFristActivityListCell,@"activity");
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.dataSource = _dataModel.activityList;
        [cell.collectionView reloadData];
        return cell;
    }
        else if(type ==QGHomeCellTypeSkill) {
         static NSString *skill=@"skillCell";
        QGOptimalProductSkillTableViewCell *skillCell=[tableView dequeueReusableCellWithIdentifier:skill];
        if (!skillCell)
        {
            skillCell=[[NSBundle mainBundle]loadNibNamed:@"QGOptimalProductSkillTableViewCell" owner:self options:nil][0];
        }
        skillCell.dataModel= _dataModel;
        return skillCell;
    }else {
        PL_CELL_CREATEMETHOD(QGHomePostListCell,@"PostList")
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.postframe = self.postList[indexPath.row];
        [cell.collectionView reloadData];
        @weakify(self);
        cell.block = ^{
            @strongify(self);
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
        };
        return cell;
        
    }
   

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    QGHomeCellType type = [self getCellTypeWithIndexPath:indexPath];

    if (type ==QGHomeCellTypeSkill) {
          QGSecKillViewController *vc = [[QGSecKillViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
    }else if (type==QGHomeCellTypePost){
        QGPostListModel *model = _dataModel.postList[indexPath.row];
        BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc]initWithPostID:model.id.integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{ QGHomeCellType type = [self getCellTypeWithIndexPath:indexPath];
    if (type == QGHomeCellTypeEdu)
    {
        return MQScreenW *0.18+20;
    }else if(type == QGHomeCellTypeActivty)  {
        
        return MQScreenW*0.23+20;
    } else if(type == QGHomeCellTypeSkill) {
        return 130;
    }else {
        QGPostListFrameModel *frame  = self.postList[indexPath.row];
        return frame.cellHeight;
    }
}
- (QGHomeCellType)getCellTypeWithIndexPath:(NSIndexPath *)indexPath{
    QGHomeCellType type = QGHomeCellTypePost;
    if (indexPath.section == 0) {
     type = QGHomeCellTypeEdu;
    }
else
    if (indexPath.section == 1) {
        if (_dataModel.activityList.count > 0) {
            type = QGHomeCellTypeActivty;
        }else{
            type = _skillArray.count> 0 ? QGHomeCellTypeSkill : QGHomeCellTypePost;
        }
    }else if(indexPath.section == 2){
        type = (_dataModel.activityList.count > 0 && _skillArray.count>0) ? QGHomeCellTypeSkill : QGHomeCellTypePost;
    }
    return type;
}
#pragma mark 头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view= [[UIView alloc] init];
    QGHomeCellType type = [self getCellTypeWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (type == QGHomeCellTypeEdu)
    {
        view=[self createSectionHeaderView:@"星级教育" iconImageName:@"星级教育"];
    }else if (type == QGHomeCellTypeActivty) {
        view=[self createSectionHeaderView:@"亲子活动" iconImageName:@"亲子活动"];
        
    }
    
    else if (type == QGHomeCellTypeSkill)
    {
        view =[self createSectionHeaderView:@"限时秒杀" iconImageName:@"限时秒杀" ];
        
    }else if (type == QGHomeCellTypePost) {
        view =[self createSectionHeaderView:@"你可能感兴趣的帖子" iconImageName:@"帖子" ];
    
    }
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view= [[UIView alloc] init];
    QGHomeCellType type = [self getCellTypeWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (type == QGHomeCellTypeActivty)
    {
        
        view = [self createSectionfooterView:@"更多活动" iconImageName:@"cell_right_arrow" moreBtnAction:^{
            
            QGActivityHomeViewController *vc =[[QGActivityHomeViewController alloc] init];
           
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
    }else if (type == QGHomeCellTypeSkill) {
        
        view = [self createSectionfooterView:@"更多优惠" iconImageName:@"cell_right_arrow" moreBtnAction:^{
            
            QGSecKillViewController *vc = [[QGSecKillViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    }
    
    return view;
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
    if (section == 1||section==2) {
        return 54;
    }else if (section ==0){
        return 10;
    }else {
        return 0.1;
    }
    if (section < ([self getDataCount] - 1)) {
        return 54;
    }else {

        return 0.1;
    }
    
}

#pragma mark 尾部视图
- (UIView *)createSectionfooterView:(NSString *)sectionName iconImageName:(NSString *)imageName moreBtnAction:(void(^)())moreBtnBlock
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
     UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(0, 1, self.view.width, 0.5);
    lineView.backgroundColor =  QGlineBackgroundColor;
    [view addSubview:lineView];
    //更多
    UIButton* moreBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    
    [moreBtn setTitle:sectionName forState:UIControlStateNormal];
    [moreBtn setTitleFont:FONT_CUSTOM(16)];
    [moreBtn setTitleColor:[UIColor colorFromHexString:@"999999"]];
    [moreBtn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, -135);
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
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
    //    Lab.textColor=PL_COLOR_237;
    Lab.textColor =[UIColor colorFromHexString:@"666666"];
 
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(0, 44, self.view.width, 0.5);
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
        
        if (higth <0.0) {
            _navBGView.backgroundColor = RGBA(255, 255, 255 ,0);
            UIColor *color = RGBA(255, 255, 255 ,0);
            _search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索机构/课程" attributes:@{NSForegroundColorAttributeName: color}];
            [_messageicon setImage:[UIImage imageNamed:@""]];
            _messageicon.hidden = YES;
            _searchimg.image = [UIImage imageNamed:@""];
            [_sortBtn setTitleColor:RGBA(255, 255, 255 ,0) forState:(UIControlStateNormal)];
            _sortBtn.image = [UIImage imageNamed:@""];
            _searchBg.backgroundColor = COLOR(177, 177, 177, 0);
             _lineView.backgroundColor = RGBA(255, 255, 255 ,0);
           
        }
        else if ( higth >= 0.0 && higth < Range) {
            float alpha = 1.0 / Range * higth;
            _navBGView.backgroundColor = RGBA(253, 255, 255 ,alpha);
            UIColor *color = [UIColor whiteColor];
            _search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索机构/课程" attributes:@{NSForegroundColorAttributeName: color}];
            _sortBtn.image = [UIImage imageNamed:@"icon_city_home"];
            _messageicon.hidden = NO;
            [_messageicon setImage:[UIImage imageNamed:@"message_image"]];
            _searchimg.image = [UIImage imageNamed:@"icon_search_home"];
            _searchBg.backgroundColor = COLOR(177, 177, 177, 0.5);
            [_sortBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            _lineView.backgroundColor = RGBA(255, 255, 255 ,0);
        }else
        {
            UIColor *color = QGTitleColor;
            _search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索机构/课程" attributes:@{NSForegroundColorAttributeName: color}];
            _navBGView.backgroundColor = RGBA(253, 255, 255 ,1.0);
            _searchBg.backgroundColor = COLOR(177, 177, 177, 0.5);
            //            _searchBg.backgroundColor =COLOR(243, 243, 243, 1);
            [_messageicon setImage:[UIImage imageNamed:@"message_icon"]];
            _messageicon.hidden = NO;
            [_sortBtn setTitleColor:QGTitleColor forState:(UIControlStateNormal)];
            
            _sortBtn.image = [UIImage imageNamed:@"search-drop-down-icon"];
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
    else if ([banner.type integerValue]==20)
    {
        [self goEduCourseSearchResultVC:banner.activity_id];
    }
    else if ([banner.type integerValue]==12)
    {// 活动列表
        [self goActListVC];
    }else if ([banner.type integerValue]==18)
    {// 机构详情
        [self goNearOrgDetailViewC:banner.activity_id];
    }
    else if ([banner.type integerValue]==13)
    {// 活动详情
        [self goNearActDetailViewC:banner.activity_id];
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
