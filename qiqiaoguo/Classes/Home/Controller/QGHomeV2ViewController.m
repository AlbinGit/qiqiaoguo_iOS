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
#import "QGClassPoplView.h"
#import "QGClassModel.h"
#import "QQGCourseTableViewCell.h"
#import "QQGTeacherTableViewCell.h"
#import "QGHomeCourseModel.h"
#import "QGHomeTeacherModel.h"
#import "QGNewTeacherVideoCell.h"
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
typedef NS_ENUM(NSUInteger, QGHomeCellType) {
    QGHomeCellTypeEdu,//附近课程、附近机构
    QGHomeCellTypeVideo,//帖子
    QGHomeCellTypePost,//热门文章
    QGHomeCellTypeCourse,//精品课程
    QGHomeCellTypeTeacher,//名师风采
    QGHomeCellTypeTeacherVideo,//大家都在看
};


@interface QGHomeV2ViewController ()<UITextFieldDelegate,SDCycleScrollViewDelegate,CLLocationManagerDelegate,QGHomevideoListCellDelegate,QGHomePostListV2TabCellDelegate,QGCollectionFooterLineViewDelegate,QQGCourseTableViewCellDelegate,QGNewTeacherVideoCellDelegate>
{
    CLLocationManager *locationManager;
}

@property (nonatomic,strong) QGFirstPageDataModel *dataModel;
@property (nonatomic,strong) NSMutableArray *postList;
@property (nonatomic,strong) UIView *navBGView;
@property (nonatomic,strong)SASRefreshTableView*tableView;
@property (nonatomic,strong) NSMutableArray *bannerArray;
@property (nonatomic,strong) UIImageView *searchBg;

@property (nonatomic,strong) NSMutableArray *courseList;//课程列表
@property (nonatomic,strong) NSMutableArray *teacherList;//老师列表
@property (nonatomic,strong) NSMutableArray *momentList;//视频列表

@property (nonatomic,copy) NSString * category_id;//班级
@property (nonatomic,copy) NSString * subject_id;//科目
@property (nonatomic,assign) NSInteger firstpage;//课程
@property (nonatomic,assign) NSInteger teacherpage;//老师计数


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
@property (nonatomic, strong) NSMutableArray   *coursefirstRowCellCountArray;
@property (nonatomic,assign) CGFloat postHeight;
@property (nonatomic,assign) CGFloat videoHeight;
@property (nonatomic,assign) CGFloat courseHeight;
@property (nonatomic,assign) CGFloat teacherVideoHeight;

/**班级弹出视图*/
@property (nonatomic,strong) QGClassPoplView *classPopView;
@property (nonatomic,strong) NSIndexPath *myIndexPath;

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
	[self initData];
    [self getShopCityListRequestMethod];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self add_viewUI];
    _postList = [[NSMutableArray alloc] init];
    _firstRowCellCountArray = [NSMutableArray array];
    _postfirstRowCellCountArray = [NSMutableArray array];
    _coursefirstRowCellCountArray = [NSMutableArray array];
    

}
- (void)initData
{
	_subject_id = @"-1";
	_firstpage = 1;
	_teacherpage = 1;
	if ([SAUserDefaults getValueWithKey:USERDEFAULTS_ClassID]) {
		_category_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_ClassID];
	}else
	{
		_category_id = @"0";//精品
	}

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)add_viewUI {
    if (_tableView==nil) {
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-Height_TapBar) style:UITableViewStyleGrouped];
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
    _navBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 88)];
//    _navBGView.backgroundColor = RGBA(255, 255, 255 ,0);
    _navBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navBGView];
    UIView *vc = [[UIView alloc] initWithFrame:CGRectMake(0, 88, self.view.width, 1)];
    vc.backgroundColor = RGBA(255, 255, 255 ,0);
    [_navBGView addSubview:vc];
    self.lineView = vc;
    //分类按钮
    _sortBtn = [UIButton new];
    [_navBGView addSubview:_sortBtn];
//    _sortBtn.image = [UIImage imageNamed:@"ic_选择学习阶段"];
	[_sortBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    _sortBtn.titleFont = FONT_CUSTOM(14);
    [_sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@45);
        make.left.equalTo(@15);
        make.height.equalTo(@32);
        make.width.equalTo(@0);
    }];
    [_sortBtn addTarget:self action:@selector(CityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *searchView = [[UIView alloc]init];
    kClearBackground(searchView);
    [_navBGView addSubview:searchView];
    UIImageView *searchBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, searchView.width, 32)];
    searchBg.backgroundColor = PL_COLOR_230;
//    searchBg.backgroundColor = [UIColor colorFromHexString:@""];
    searchBg.layer.masksToBounds = YES;
    searchBg.layer.cornerRadius = 15;
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
        make.top.equalTo(@45);
        make.height.equalTo(@44);
        make.right.equalTo(_navBGView).offset(-20);
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
    
//	[self addMesseageBtnInTheView:_navBGView];
          
	self.automaticallyAdjustsScrollViewInsets =NO;
    
}
#pragma mark 请求首页数据
- (void)requestFirstDataMethod:(SARefreshType)type {
    [[SAProgressHud sharedInstance]showWaitWithWindow];
//	_firstpage = 1;
//	_teacherpage = 1;
	[self initData];
    [QGHttpManager homeDataSuccess:^(QGFirstPageDataModel *result) {
        _dataModel =result;
        _dataSource =_dataModel.videoList;
        [self createTableHeader];
        [self addpostHeghtCell];
        [self addvideoHeightCell];
//        [self addcourseHeghtCell];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    [self getUserMessageCount];	
	[self p_loadTeacherData:0];
	[self p_loadLessonData:0];
}

- (void)p_loadLessonData:(NSInteger)type
{
	if (type == 0) {
		_courseList = [NSMutableArray array];
	}
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"category_id":@([_category_id intValue]),
		@"subject_id":@([_subject_id intValue]),
//		@"subject_id":@(-1),
		@"page":@(_firstpage),
		@"page_size":@"4",
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Home/getTeacherCourseList",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		NSMutableArray * resultArr = [NSMutableArray array];
		resultArr = [QGHomeCourseModel mj_objectArrayWithKeyValuesArray:responseObj[@"extra"][@"items"]];

		if (resultArr.count>0) {
			[_tableView showFooterView];
			for (QGHomeCourseModel * model in resultArr) {
				[_courseList addObject:model];
			}
		}
        [self addcourseHeghtCell];
		[_tableView endRrefresh];
		[_tableView reloadData];
		} failure:^(NSError *error) {
			NSLog(@"%@",error);
			[_tableView endRrefresh];
		}];
}

- (void)p_loadTeacherData:(NSInteger)type
{
	if (type == 0) {
		_teacherList = [NSMutableArray array];
	}
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"category_id":@([_category_id intValue]),
		@"page":@(_teacherpage),
		@"page_size":@"4",
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Home/getTeacherMomentList",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		NSMutableArray * resultArr = [NSMutableArray array];
		resultArr = [QGHomeTeacherModel mj_objectArrayWithKeyValuesArray:responseObj[@"extra"][@"items"]];
		if (resultArr.count>0) {
			[_tableView showFooterView];
			for (QGHomeTeacherModel * model in resultArr) {
				[_teacherList addObject:model];
			}
		}else
		{
			[_tableView hiddenFooterView];
		}
		[self addTeacherVideoHeightCell];
		[_tableView endRrefresh];
		[_tableView reloadData];
		} failure:^(NSError *error) {
			NSLog(@"%@",error);
			[_tableView endRrefresh];
		}];
}
# pragma mark cell 的高度
- (void)addvideoHeightCell {
    CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
    CGFloat itemHeight = itemWidth*9/16;
    int totalCol = 2;
    int row = (_dataSource.count-1) / totalCol;
    CGFloat y = (itemHeight + 50) * row;
//    _videoHeight = itemHeight +44 +y+50;	
	if (_dataSource.count>0) {
		_videoHeight = itemHeight +44 +y+50;
	}else
	{
		_videoHeight = 0;
	}

}
- (void)addpostHeghtCell {
    CGFloat itemWidth  = (MQScreenW-20)/2.0-15;
    CGFloat itemHeight = itemWidth*0.53+8;
    int totalCol = 2;
    int row = (_dataModel.postList.count-1) / totalCol;
    CGFloat y = (itemHeight) * row;
    _postHeight = y+44+itemHeight;
}

- (void)addcourseHeghtCell {
    CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
    CGFloat itemHeight = itemWidth;
    int totalCol = 2;
    int row = (_courseList.count-1) / totalCol;
    CGFloat y = (itemHeight + 73) * row;
	if (_courseList.count>0) {
		_courseHeight = itemHeight +44 +y+73;
	}else
	{
		_courseHeight = 0;
	}
	
}

- (void)addTeacherVideoHeightCell {
    CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
    CGFloat itemHeight = itemWidth*4/3;
    int totalCol = 2;
    int row = (_teacherList.count-1) / totalCol;
    CGFloat y = (itemHeight + 50) * row;
    _teacherVideoHeight = itemHeight +44 +y+50;
}


- (void)updateUserMessageCount{
    if (self.messageCount > 0) {
        _messeageLab.title = @(self.messageCount).stringValue;
    }
    _messeageLab.hidden = self.messageCount == 0;
}

- (void)updateCityBtnFrameWithTitle:(NSString *)title
{
//    _cityTitile = title;
    CGSize btntitleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_sortBtn.titleFont, NSFontAttributeName, nil]];
    float citybtnW = 18 + btntitleSize.width;
    [_sortBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:citybtnW]);
    }];
//    [_sortBtn setTitle:title];
//    [_sortBtn.titleLabel sizeToFit];
//    [_sortBtn.imageView sizeToFit];
//    [_sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _sortBtn.titleLabel.width+10, 0, -_sortBtn.titleLabel.width-5)];
//    [_sortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_sortBtn.imageView.width-10 , 0, _sortBtn.imageView.width)];
	
	[_sortBtn setTitle:title forState:UIControlStateNormal];
	[_sortBtn setImage:[UIImage imageNamed:@"ic_选择学习阶段"] forState:UIControlStateNormal];
	
    [_sortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_sortBtn.imageView.image.size.width , 0, _sortBtn.imageView.image.size.width)];
    [_sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _sortBtn.titleLabel.width, 0, -_sortBtn.titleLabel.bounds.size.width)];
    
}

#pragma mark 头部滚动视图banner
- (void)createTableHeader {
    UIView *view=[[UIView alloc]init];
    _bannerArray= [NSMutableArray array];
    for (QGBannerModel *bannerModel in _dataModel.bannerList) {
        [self.bannerArray addObject:bannerModel.cover];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,_navBGView.bottom, SCREEN_WIDTH, SCREEN_WIDTH*0.625) imageURLStringsGroup:self.bannerArray];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlDotSize = CGSizeMake(5, 5);
    cycleScrollView.autoScrollTimeInterval = 3;
    [view addSubview:cycleScrollView];

    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, cycleScrollView.maxY);
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
//                            [weakSelf updateCityBtnFrameWithTitle:item.item.name];
							_cityTitile = item.item.name;
                            [SAUserDefaults saveValue:item.item.sid forKey:USERDEFAULTS_SID];
                            [SAUserDefaults saveValue:item.item.platform_id forKey:USERDEFAULTS_Platform_id];
//							[SAUserDefaults saveValue:_cityTitile forKey:USERDEFAULTS_City];
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
//        QGSwitchCityViewController *cityVC=[[QGSwitchCityViewController alloc]init];
//        cityVC.result = _item.item;
//        cityVC.cityNames = weakSelf.shopCityLists;
//        cityVC.cityTitle = _cityTitile;
//        __weak __typeof(UIButton *)btn = button;
//        [cityVC setCityBlock:^(QGShopCityModel *cityModel) {
//        [btn setTitle:cityModel.name forState:UIControlStateNormal];
//        [weakSelf updateCityBtnFrameWithTitle:cityModel.name];
//        [SAUserDefaults saveValue:cityModel.sid forKey:USERDEFAULTS_SID];
//        [SAUserDefaults saveValue:cityModel.platform_id forKey:USERDEFAULTS_Platform_id];
//        [weakSelf requestFirstDataMethod:SARefreshPullDownType];
//        }];
//        [weakSelf.navigationController pushViewController:cityVC animated:YES];
	
	[self.view addSubview:self.classPopView];
	
	[_classPopView cityBtnFrameWithTitle:_cityTitile];
	
	_classPopView.selectBlock = ^(QGClassListModel * _Nonnull model, NSIndexPath * _Nonnull indexPath) {
		if (model) {
			[weakSelf updateCityBtnFrameWithTitle:model.title];
			[SAUserDefaults saveValue:model.title forKey:USERDEFAULTS_Class];
			[SAUserDefaults saveValue:model.myID forKey:USERDEFAULTS_ClassID];
			[SAUserDefaults saveValue:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.row,indexPath.section] forKey:USERDEFAULTS_IndexPath];
		}else
		{
			[weakSelf updateCityBtnFrameWithTitle:@"全部"];
			[SAUserDefaults removeWithKey:USERDEFAULTS_Class];
			[SAUserDefaults removeWithKey:USERDEFAULTS_ClassID];
			[SAUserDefaults removeWithKey:USERDEFAULTS_IndexPath];
			[weakSelf initData];
		}
		[weakSelf requestFirstDataMethod:SARefreshPullDownType];
	};
	
	[_classPopView.localButton addClick:^(UIButton *button) {
		QGSwitchCityViewController *cityVC=[[QGSwitchCityViewController alloc]init];
		cityVC.result = weakSelf.item.item;
		cityVC.cityNames = weakSelf.shopCityLists;
		cityVC.cityTitle = weakSelf.cityTitile;
		[weakSelf.navigationController pushViewController:cityVC animated:YES];
		
		[cityVC setCityBlock:^(QGShopCityModel *cityModel) {
		[button setTitle:cityModel.name forState:UIControlStateNormal];
		[weakSelf.classPopView cityBtnFrameWithTitle:cityModel.name];
		_cityTitile = cityModel.name;
		[SAUserDefaults saveValue:cityModel.sid forKey:USERDEFAULTS_SID];
		[SAUserDefaults saveValue:cityModel.platform_id forKey:USERDEFAULTS_Platform_id];
//		[SAUserDefaults saveValue:cityModel.name forKey:USERDEFAULTS_City];
		[weakSelf requestFirstDataMethod:SARefreshPullDownType];
		}];
	}];
}
- (QGClassPoplView *)classPopView
{
	if (!_classPopView) {
		_classPopView = [[QGClassPoplView alloc]initWithFrame:self.view.bounds];
	}
	return _classPopView;
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
//        [_sortBtn setTitle:shopCityModel.name forState:UIControlStateNormal];
//        [self updateCityBtnFrameWithTitle:shopCityModel.name];
			_cityTitile = shopCityModel.name;
			NSString * className = [SAUserDefaults getValueWithKey:USERDEFAULTS_Class];
			if (className.length>0) {
				[self updateCityBtnFrameWithTitle:className];
			}else
			{
				[self updateCityBtnFrameWithTitle:@"全部"];
			}
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
//    if ((section == [self getDataCount]-1) && (_dataModel.courseList.count > 0)) {
//        return _dataModel.courseList.count;
//    }else {
        
        return 1;
//    }
}
- (NSInteger)getDataCount{
    NSInteger count = 0;
    count += _dataModel.postList.count > 0;
//    count += _dataModel.courseList.count > 0;
    count += _courseList.count > 0||_dataModel.cateList>0;
//    count += _dataModel.cateList>0;
    count += _teacherList.count > 0;
    count += _dataModel.videoList.count > 0;
    count += _dataModel.bannerList.count>0;
    count += _dataModel.teacherList.count>0;
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QGHomeCellType type = [self getCellTypeWithIndexPath:indexPath];
    
    if (type ==QGHomeCellTypeEdu)
    {
        PL_CELL_CREATEMETHOD(QGHomeActivityListCell,@"QGHomeActivityListCell");
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
    }
    else if (type == QGHomeCellTypeTeacher) {
        PL_CELL_CREATEMETHOD(QQGTeacherTableViewCell,@"teacher") ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataSource = _dataModel.teacherList;
        [cell.collectionView reloadData];
        return cell;
    }
    else if (type == QGHomeCellTypeTeacherVideo) {
        PL_CELL_CREATEMETHOD(QGNewTeacherVideoCell,@"QGNewTeacherVideoCell") ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataSource = _teacherList;
		cell.delegate = self;
        [cell.collectionView reloadData];
        return cell;
    }
    else {
        PL_CELL_CREATEMETHOD(QQGCourseTableViewCell,@"searchCourse") ;
        cell.delegate =self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        cell.dataSource = _dataModel.courseList;
        cell.dataSource = _courseList;
        [cell.collectionView reloadData];
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    QGHomeCellType type = [self getCellTypeWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    
//    if (type == QGHomeCellTypeCourse) {
//        QGCourseInfoModel * model =  _dataModel.courseList[indexPath.row];
//        
//        QGCourseDetailViewController *vc =[[QGCourseDetailViewController alloc] init];
//        vc.course_id =model.id;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
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

- (void)QQGCourseTableViewCellMoreBtnClicked:(QQGCourseTableViewCell *)sender {
    PL_CODE_WEAK(ws)
//    [UIView animateWithDuration:0.5f animations:^{
//        [ws.coursefirstRowCellCountArray addObject:_dataModel.courseList];
//        [sender.collectionView reloadData];
//        [ws.tableView beginUpdates];
//        [ws.tableView endUpdates];
//    }];
	_firstpage++;
    [UIView animateWithDuration:0.5f animations:^{	
		[ws p_loadLessonData:1];
        [sender.collectionView reloadData];
        [ws.tableView beginUpdates];
        [ws.tableView endUpdates];
    }];
}
#pragma mark 加载更多
- (void)QGNewTeacherVideoCellMoreBtnClicked:(QGNewTeacherVideoCell *)sender
{
    PL_CODE_WEAK(ws)
	_teacherpage++;
    [UIView animateWithDuration:0.5f animations:^{
		[ws p_loadTeacherData:1];
        [sender.collectionView reloadData];
        [ws.tableView beginUpdates];
        [ws.tableView endUpdates];
    }];
}

- (void)QQGCourseTableViewCellFoldBtnClicked:(QQGCourseTableViewCell *)sender {
    PL_CODE_WEAK(ws)
    [UIView animateWithDuration:0.5f animations:^{
        [ws.coursefirstRowCellCountArray removeAllObjects];
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
        if (_firstRowCellCountArray.count>0 || _dataModel.courseList.count<3) {
            
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
    } else if (type == QGHomeCellTypeTeacher) {
        CGFloat itemWidth  = (MQScreenW-4*10)/3.0;
        return itemWidth + 40;
    }
	else if (type == QGHomeCellTypeTeacherVideo) {
		   return _teacherVideoHeight;
	   }
    else {
//        if (_coursefirstRowCellCountArray.count>0 || _dataSource.count<3) {
//            return _courseHeight;
//        }else  {
//            CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
//            CGFloat itemHeight = itemWidth*9/16;
//            return (itemHeight +50)*2+44;
//        }
		return _courseHeight;
    }
}
- (QGHomeCellType)getCellTypeWithIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = [NSMutableArray array];
	
	if (_teacherList.count>0) {
		[array addObject:@(QGHomeCellTypeTeacherVideo)];
	}
    if (_dataModel.teacherList.count > 0) {
        [array addObject:@(QGHomeCellTypeTeacher)];
    }

//	if (_courseList.count > 0) {
//		[array addObject:@(QGHomeCellTypeCourse)];
//	}
	if (_courseList.count > 0||_dataModel.cateList.count>0) {
		[array addObject:@(QGHomeCellTypeCourse)];
	}

    if (_dataModel.postList.count > 0) {
        [array addObject:@(QGHomeCellTypePost)];
    }
    if (_dataModel.videoList.count > 0) {
        [array addObject:@(QGHomeCellTypeVideo)];
    }
    [array addObject:@(QGHomeCellTypeEdu)];

    return [array[indexPath.section] intValue];

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
        Lab.text=@"你可能感兴趣的帖子";
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
        view =[self createSectionHeaderView:@"热门文章"];
    }else if (type == QGHomeCellTypeCourse) {
		
		
		UIView * titleView = [self createSectionIconImgHeaderView:@"精品课程" andImgName:@"ic_课程"];
		titleView.backgroundColor = COLOR(242, 243, 244, 1);
		
		_modelView = [[QGHomeSubjectView alloc]initWithFrame:CGRectMake(0, titleView.maxY, SCREEN_WIDTH, 85)];
		_modelView.backgroundColor = COLOR(242, 243, 244, 1);
		NSLog(@"ssss %@",_dataModel.cateList);
		[_modelView addDataToImageArray:_dataModel.cateList];
		[_modelView tapModel:^(QGEducateListtModel *model) {
			if ([model.id isEqualToString:@"0"]) {//全部分类
				QGEduClassViewController *vc = [[QGEduClassViewController alloc] init];
				vc.id = model.id;
				[self.navigationController pushViewController:vc animated:YES];
			}else{
				
				_subject_id = model.id;
				_firstpage = 1;
				[self p_loadLessonData:0];
				
			}
		}];
		[view addSubview:titleView];
		[view addSubview:_modelView];
		view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _modelView.maxY+25);
    } else if (type == QGHomeCellTypeTeacher) {
		view = [self createSectionIconImgHeaderView:@"名师风采" andImgName:@"ic_老师"];
    }else if (type == QGHomeCellTypeTeacherVideo) {
		view = [self createSectionIconImgHeaderView:@"大家都在看" andImgName:@"ic_大家都在看"];
    }

    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    QGHomeCellType type = [self getCellTypeWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (type == QGHomeCellTypeEdu){
        return 10;
    }else if (type == QGHomeCellTypeCourse)
	{
		return 44+85+25;
	}
	else
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

- (UIView *)createSectionIconImgHeaderView:(NSString *)sectionName andImgName:(NSString *)imgName
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
    	
	UIImageView *nickImageView=[[UIImageView alloc]init];
//	nickImageView.frame=CGRectMake(9, 11, 22, 22);
	nickImageView.image = [UIImage imageNamed:imgName];
	[view addSubview:nickImageView];

	
    UILabel *Lab=[[UILabel alloc]init];
    Lab.font=FONT_CUSTOM(16);
    Lab.text=sectionName;
    Lab.textColor =[UIColor colorFromHexString:@"666666"];
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(10, 44, self.view.width-20, QGOnePixelLineHeight);
    lineView.backgroundColor = QGlineBackgroundColor;
    [view addSubview:lineView];
    [view addSubview:Lab];
    [nickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(10);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
        
    }];
    [Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickImageView.mas_right).offset(6);
        make.centerY.equalTo(view.mas_centerY);
    }];
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
