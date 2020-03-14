//
//  MQHomeViewController.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/25.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGHomeV2ViewController.h"
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
#import "QGHomeSubjectView.h"
#import "QGSearchCourseTableViewCell.h"
#import "QGEduClassViewController.h"
#import "QGHomevideoListCell.h"
#import "QGHomePostListV2TabCell.h"
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
typedef NS_ENUM(NSUInteger, QGHomeCellType) {
    QGHomeCellTypeEdu,
    QGHomeCellTypeVideo,
    QGHomeCellTypePost,
    QGHomeCellTypeCourse,
};


@interface QGHomeV2ViewController ()<UITextFieldDelegate,SDCycleScrollViewDelegate,CLLocationManagerDelegate,QGHomevideoListCellDelegate,QGHomePostListV2TabCellDelegate,QGCollectionFooterLineViewDelegate>
{
    CLLocationManager *locationManager;
}

@property (nonatomic,strong) QGFirstPageDataModel *dataModel;
@property (nonatomic,strong) NSMutableArray *postList;
@property (nonatomic,strong) UIView *navBGView;
@property (nonatomic,strong)SASRefreshTableView*tableView;
@property (nonatomic,strong) NSMutableArray *bannerArray;
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
@property (nonatomic, strong) QGHomeSubjectView * modelView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray   *firstRowCellCountArray;
@property (nonatomic, strong) NSMutableArray   *postfirstRowCellCountArray;
@property (nonatomic,assign) CGFloat postHeight;
@property (nonatomic,assign) CGFloat videoHeight;
@end
@implementation QGHomeV2ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self getUserMessageCount];
// self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
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
    _postList = [[NSMutableArray alloc] init];
    _firstRowCellCountArray = [NSMutableArray array];
    _postfirstRowCellCountArray = [NSMutableArray array];
  
    
  }

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)add_viewUI {
    if (_tableView==nil) {
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
   
        _tableView.backgroundColor =COLOR(242, 243, 244, 1);
        PL_CODE_WEAK(weakSelf);
        [_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
            [weakSelf requestFirstDataMethod:SARefreshPullUpType];
        }];
    }else {
        
        [_tableView reloadData];
    }
    [self.view addSubview:_tableView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    __weak typeof(self) weakSelf = self;
    [self addReturnToTheTopButtonFrame:CGRectMake(MQScreenW - 50, MQScreenH-120, 35, 35) WithBackgroundImage:[UIImage imageNamed:@"返回顶部"] CallBackblock:^{
        [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, MQScreenW, MQScreenH) animated:YES];
    }];
    self.navImageView.alpha=0;
    _navBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    _navBGView.backgroundColor = RGBA(255, 255, 255 ,0);
    [self.view addSubview:_navBGView];
    UIView *vc = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.width, 1)];
    vc.backgroundColor = RGBA(255, 255, 255 ,0);
    [_navBGView addSubview:vc];
    self.lineView = vc;
    //分类按钮
    _sortBtn = [UIButton new];
    [_navBGView addSubview:_sortBtn];
    _sortBtn.image = [UIImage imageNamed:@"icon_city_home"];
    _sortBtn.titleFont = FONT_CUSTOM(14);
    [_sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@38);
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
        make.top.equalTo(@38);
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
          self.automaticallyAdjustsScrollViewInsets =NO;
    
}
- (void)requestFirstDataMethod:(SARefreshType)type {
    [[SAProgressHud sharedInstance]showWaitWithWindow];
    [QGHttpManager homeDataSuccess:^(QGFirstPageDataModel *result) {
        _dataModel =result;
        _dataSource =_dataModel.videoList;
        [self createTableHeader];
        [self addpostHeghtCell];
        [self addvideoHeightCell];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    [self getUserMessageCount];
}
# pragma mark cell 的高度
- (void)addvideoHeightCell {
    CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
    CGFloat itemHeight = itemWidth*9/16;
    int totalCol = 2;
    int row = (_dataSource.count-1) / totalCol;
    CGFloat y = (itemHeight + 50) * row;
    _videoHeight = itemHeight +44 +y+50;
}
- (void)addpostHeghtCell {
    CGFloat itemWidth  = (MQScreenW-20)/2.0-15;
    CGFloat itemHeight = itemWidth*0.53+8;
    int totalCol = 2;
    int row = (_dataModel.postList.count-1) / totalCol;
    CGFloat y = (itemHeight) * row;
    _postHeight = y+44+itemHeight;
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
    [_sortBtn setTitle:title];
    [_sortBtn.titleLabel sizeToFit];
    [_sortBtn.imageView sizeToFit];
    [_sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _sortBtn.titleLabel.width+10, 0, -_sortBtn.titleLabel.width-5)];
    [_sortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_sortBtn.imageView.width-10 , 0, _sortBtn.imageView.width)];
    
}

#pragma mark 头部滚动视图banner
- (void)createTableHeader {
    UIView *view=[[UIView alloc]init];
    _bannerArray= [[NSMutableArray alloc] init];
    for (QGBannerModel *bannerModel11 in _dataModel.bannerList) {
        NSLog(@"ssss11 %@",bannerModel11.activity_id);
      // [self.bannerArray addObject:bannerModel.cover];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH*0.625) imageURLStringsGroup:self.bannerArray];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlDotSize = CGSizeMake(5, 5);
    cycleScrollView.autoScrollTimeInterval = 3;
    [view addSubview:cycleScrollView];
    _modelView = [[QGHomeSubjectView alloc]initWithFrame:CGRectMake(0, cycleScrollView.maxY, SCREEN_WIDTH, 85)];
    if (_dataModel.cateList.count > 4) {
        _modelView.height = 165;
    }
    
    NSLog(@"ssss %@",_dataModel.cateList);
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
          self.automaticallyAdjustsScrollViewInsets =NO;
    
    
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
    messageBtn.centerY = 33;
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

-(void) btnClick{
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
            QGGetLocationCityModel *pa =[[QGGetLocationCityModel alloc] init];
            pa.latitude =  locationCorrrdinate.latitude;
            pa.longitude =  locationCorrrdinate.longitude;
            _longitude = locationCorrrdinate.longitude;
            _latitude = locationCorrrdinate.latitude;
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


-(void)getLoaction
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
       count += _dataModel.postList.count > 0;
       count += _dataModel.courseList.count > 0;
       count += _dataModel.videoList.count > 0;
       count += _dataModel.bannerList.count>0;
       return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QGHomeCellType type = [self getCellTypeWithIndexPath:indexPath];
    
    if (type ==QGHomeCellTypeEdu)
    {
        PL_CELL_CREATE(QGHomeActivityListCell)
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        NSString *va = _dataModel.more[@"nearbyAreaId"];
        cell.nearbyAreaID = va.integerValue;
        cell.longitude =_longitude;
        cell.latitude = _latitude;
        return cell;
    }
    
    else if(type ==QGHomeCellTypeVideo){
        PL_CELL_CREATEMETHOD(QGHomevideoListCell,@"video") ;
        cell.delegate =self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.dataSource = _dataSource;
        NSDictionary *dic  = _dataModel.more;
        NSString *str = dic[@"videoCircleId"];
        cell.videoCircleId = str;
        [cell.collectionView reloadData];
        return cell;
    }
    
    else if(type ==QGHomeCellTypePost) {
        PL_CELL_CREATEMETHOD(QGHomePostListV2TabCell,@"post") ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.collectionView reloadData];
        cell.postList = _dataModel.postList;
        cell.delegate = self;
        return cell;
    }else {
        PL_CELL_CREATEMETHOD(QGSearchCourseTableViewCell, @"searchCourse")
        cell.model = _dataModel.courseList[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHomeCellType type = [self getCellTypeWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    
    if (type == QGHomeCellTypeCourse) {
        QGCourseInfoModel * model =  _dataModel.courseList[indexPath.row];
        
        QGCourseDetailViewController *vc =[[QGCourseDetailViewController alloc] init];
        vc.course_id =model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)QGHomevideoListCellMoreBtnClicked:(QGHomevideoListCell *)sender {
    PL_CODE_WEAK(ws)
    [UIView animateWithDuration:0.5f animations:^{
        [ws.firstRowCellCountArray addObject:_dataModel.postList];
        [sender.collectionView reloadData];
        [ws.tableView beginUpdates];
        [ws.tableView endUpdates];
    }];
    
}


- (void)QGHomePostListV2TabCellMoreBtnClicked:(QGHomePostListV2TabCell *)sender {
    
    PL_CODE_WEAK(ws)
    [UIView animateWithDuration:0.5f animations:^{
        [ws.postfirstRowCellCountArray addObject:_dataModel.postList];
        [sender.collectionView reloadData];
        [ws.tableView beginUpdates];
        [ws.tableView endUpdates];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{ QGHomeCellType type = [self getCellTypeWithIndexPath:indexPath];
    if (type == QGHomeCellTypeEdu)
    {   CGFloat width = MQScreenW/2-1;
        CGFloat height = width*0.38;
        return height;
    }else if(type == QGHomeCellTypeVideo)  {
        if (_firstRowCellCountArray.count>0 || _dataSource.count<3) {
            
            return _videoHeight;
        }else  {
            CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
            CGFloat itemHeight = itemWidth*9/16;
            return (itemHeight +50)*2+44;
        }
        
    } else if(type == QGHomeCellTypePost) {
        
        if (_postfirstRowCellCountArray.count>0 || _dataModel.postList.count<3) {
            return _postHeight;
        }else {
            CGFloat itemWidth  = (MQScreenW-20)/2.0-15;
            CGFloat itemHeight = itemWidth*0.53+8;
            return itemHeight*2+44;
        }
    }else {
        return 245.7;
    }
}
- (QGHomeCellType)getCellTypeWithIndexPath:(NSIndexPath *)indexPath{
    QGHomeCellType type = QGHomeCellTypeCourse;
    
    if (indexPath.section == 0) {
        type = QGHomeCellTypeEdu;
    }
    else
        if (indexPath.section == 1) {
            
            if (_dataModel.videoList.count > 0) {
                type = QGHomeCellTypeVideo;
            }else{
                
                type = _dataModel.postList.count> 0 ? QGHomeCellTypePost : QGHomeCellTypeCourse;
            }
        }else if(indexPath.section == 2){
            type = (_dataModel.videoList.count > 0 && _dataModel.postList.count>0) ? QGHomeCellTypePost : QGHomeCellTypeCourse;
        }
    return type;
}
#pragma mark 头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view= [[UIView alloc] init];
    QGHomeCellType type = [self getCellTypeWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    if (type == QGHomeCellTypeVideo) {
        view.backgroundColor = [UIColor whiteColor];
        view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
        UIImageView *nickImageView=[[UIImageView alloc]init];
        nickImageView.frame=CGRectMake(9, 12, 14, 14);
        nickImageView.backgroundColor =[UIColor colorFromHexString:@"ffafbc"];
        [view addSubview:nickImageView];
        UILabel *Lab=[[UILabel alloc]init];
        Lab.font=FONT_CUSTOM(16);
        Lab.text=@"名师风采";
        Lab.textColor =[UIColor colorFromHexString:@"666666"];
        [view addSubview:Lab];
        [nickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(10);
            make.centerY.equalTo(view.mas_centerY);
            make.width.equalTo(@4);
            make.height.equalTo(@17);
            
        }];
        [Lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nickImageView.mas_right).offset(6);
            make.centerY.equalTo(view.mas_centerY);
        }];
    }
    else if (type == QGHomeCellTypePost)
    {
        view =[self createSectionHeaderView:@"你可能感兴趣的帖子" ];
    }else if (type == QGHomeCellTypeCourse) {
        
        view =[self createSectionHeaderView:@"推荐课程" ];
    }
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    QGHomeCellType type = [self getCellTypeWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (type == QGHomeCellTypeEdu){
        
        return 10;
    }else
        return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}
#pragma  mark 头部视图
- (UIView *)createSectionHeaderView:(NSString *)sectionName
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
    UIImageView *nickImageView=[[UIImageView alloc]init];
    nickImageView.frame=CGRectMake(9, 12, 14, 14);
    nickImageView.backgroundColor =[UIColor colorFromHexString:@"ffafbc"];
    [view addSubview:nickImageView];
    UILabel *Lab=[[UILabel alloc]init];
    Lab.font=FONT_CUSTOM(16);
    Lab.text=sectionName;
    //    Lab.textColor=PL_COLOR_237;
    Lab.textColor =[UIColor colorFromHexString:@"666666"];
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(10, 44, self.view.width-20, QGOnePixelLineHeight);
    lineView.backgroundColor = QGlineBackgroundColor;
    [view addSubview:lineView];
    [view addSubview:Lab];
    [nickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(10);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@4);
        make.height.equalTo(@17);
        
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
            _search.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @"搜索机构/课程" attributes:@{NSForegroundColorAttributeName: color}];
            _sortBtn.image = [UIImage imageNamed:@"icon_city_home"];
            _messageicon.hidden = NO;
            [_messageicon setImage:[UIImage imageNamed:@"message_image"]];
            _searchimg.image = [UIImage imageNamed:@"icon_search_home"];
            _searchBg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
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
