//
//  QGStudyController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/15.
//

#import "QGStudyController.h"
#import "QGMessageCenterViewController.h"
#import "QGClassPoplView.h"
#import "QGClassModel.h"
#import "QGSwitchCityViewController.h"
#import "GHBLocationManager.h"
#import "QGstudyProgressView.h"
#import "HLSegementView.h"
//#import "QGNewClassCell.h"
#import "QGStudyCell.h"
#import "QGNewTeacherLessonModel.h"
#import "QGNewteacherBuyController.h"
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

@interface QGStudyController ()<HLSegementViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton *messageicon;
@property (nonatomic,strong)UIButton *messeageLab;
@property (nonatomic,strong) UIButton *sortBtn;
@property (nonatomic,copy) NSString *cityTitile;
@property (nonatomic,copy) UILabel *alreadyLabel;
@property (nonatomic,strong) QGstudyProgressView *studyProgress;
@property (nonatomic,strong) HLSegementView *segmentView;
@property (nonatomic, assign) NSInteger currentIndex;//当前选中tag
@property (nonatomic,strong)SASRefreshTableView*tableView;

/**城市数组*/
@property (nonatomic,strong)NSMutableArray *shopCityLists;
@property (nonatomic,strong) QGShopCityModel *result;
@property (nonatomic,strong) QGGetCityResultModel *item;

/**班级弹出视图*/
@property (nonatomic,strong) QGClassPoplView *classPopView;
@property (nonatomic,strong) NSIndexPath *myIndexPath;

//数据
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger  perPage;
@property (nonatomic,copy) NSString *category_id;

@end

@implementation QGStudyController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self p_creatNav];
	[self initData];
	[self add_viewUI];
	
	[self getShopCityListRequestMethod];
	[self p_loadAllStyudyData:0 andType:_currentIndex];
}
- (void)initData
{
	_category_id = @"0";
	_currentIndex = 0;
	_perPage = 1;
}

- (void)p_creatNav
{
//	PL_CODE_WEAK(ws);
	UIView * navView = [[UIView alloc]init];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
	navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, Height_TopBar+40);
	
	//分类按钮
	_sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[navView addSubview:_sortBtn];
	_sortBtn.titleFont = FONT_CUSTOM(14);
	_sortBtn.backgroundColor = [UIColor whiteColor];
	_sortBtn.frame = CGRectMake(15, 45, 60, 40);
	NSString * titleStr = [SAUserDefaults getValueWithKey:USERDEFAULTS_Class];
	if (titleStr.length<=0) {
		titleStr = @"全部";
	}
	[self updateCityBtnFrameWithTitle:titleStr];
	
	[_sortBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
	[_sortBtn addTarget:self action:@selector(CityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addMesseageBtnInTheView:navView];
	
	UILabel * alreadylabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50-83, 45, 83, 40)];
	alreadylabel.text = @"学习进度100%";
	alreadylabel.font = FONT_CUSTOM(12);
	alreadylabel.textAlignment = NSTextAlignmentLeft;
	alreadylabel.backgroundColor = [UIColor whiteColor];
	alreadylabel.textColor = [UIColor colorFromHexString:@"333333"];
	[navView addSubview:alreadylabel];
	_alreadyLabel = alreadylabel;
	
	_studyProgress = [[QGstudyProgressView alloc]initWithFrame:CGRectMake(alreadylabel.left-5-24, 45+8, 24, 24)];
//	_studyProgress.progress = 0.8;
	[navView addSubview:_studyProgress];
	
	NSArray * titlss = @[@"全部",@"公开课",@"精品课"];
	HLSegementView * segmentView = [[HLSegementView alloc] initWithFrame:CGRectMake(0, _alreadyLabel.bottom, SCREEN_WIDTH, 40) titles:titlss];
	segmentView.selectIndex = 0;
	segmentView.isShowUnderLine = YES;
	segmentView.delegate = self;
	_segmentView = segmentView;
	[navView addSubview:segmentView];

}
#pragma mark tag  didSelectWithIndex
- (void)hl_didSelectWithIndex:(NSInteger)index{
	NLog(@"代理实现的方法%ld",index);
//	_currentIndex = index;
	_perPage = 1;
	if (index == 0) {
		_currentIndex = 0;
	}else if (index == 1)
	{
		_currentIndex = 2;

	}else
	{
		_currentIndex = 1;
	}
	[self p_loadAllStyudyData:0 andType:_currentIndex];

}
- (void)CityBtnClick:(UIButton *)button
{
	PL_CODE_WEAK(weakSelf);
	[self.view addSubview:self.classPopView];
	[_classPopView cityBtnFrameWithTitle:_cityTitile];
	
	_classPopView.selectBlock = ^(QGClassListModel * _Nonnull model, NSIndexPath * _Nonnull indexPath) {
		
//		[weakSelf updateCityBtnFrameWithTitle:model.title];
//		[SAUserDefaults saveValue:model.title forKey:USERDEFAULTS_Class];
//		[SAUserDefaults saveValue:model.myID forKey:USERDEFAULTS_ClassID];
//		[SAUserDefaults saveValue:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.row,indexPath.section] forKey:USERDEFAULTS_IndexPath];
		
		if (model) {
			[weakSelf updateCityBtnFrameWithTitle:model.title];
			[SAUserDefaults saveValue:model.title forKey:USERDEFAULTS_Class];
			[SAUserDefaults saveValue:model.myID forKey:USERDEFAULTS_ClassID];
			[SAUserDefaults saveValue:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.row,(long)indexPath.section] forKey:USERDEFAULTS_IndexPath];
		}else
		{
			[weakSelf updateCityBtnFrameWithTitle:@"全部"];
			[SAUserDefaults removeWithKey:USERDEFAULTS_Class];
			[SAUserDefaults removeWithKey:USERDEFAULTS_ClassID];
			[SAUserDefaults removeWithKey:USERDEFAULTS_IndexPath];
			[weakSelf initData];
		}

		
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
		}];
	}];
	 
}
- (void)getShopCityListRequestMethod {
	[[SAProgressHud sharedInstance]showWaitWithWindow];
	[QGHttpManager homeGetCitySuccess:^(QGGetCityResultModel *result) {
		_shopCityLists = [NSMutableArray array];
		_shopCityLists = result.items;
		QGShopCityModel * shopCityModel = _shopCityLists[0];
		if ([shopCityModel.is_default integerValue]==1)
		{
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
		}
		[self getStudyLocation];
	} failure:^(NSError *error) {
		[SAUserDefaults saveValue:@"50" forKey:USERDEFAULTS_Platform_id];
		[self showTopIndicatorWithError:error];
	}];
}
	
- (void)updateCityBtnFrameWithTitle:(NSString *)title
{
    CGSize btntitleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_sortBtn.titleFont, NSFontAttributeName, nil]];
    float citybtnW = 18 + btntitleSize.width;
	_sortBtn.frame = CGRectMake(15, 45, citybtnW, 40);

	[_sortBtn setTitle:title forState:UIControlStateNormal];
	[_sortBtn setImage:[UIImage imageNamed:@"ic_选择学习阶段"] forState:UIControlStateNormal];
	
    [_sortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_sortBtn.imageView.image.size.width , 0, _sortBtn.imageView.image.size.width)];
    [_sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _sortBtn.titleLabel.width, 0, -_sortBtn.titleLabel.bounds.size.width)];
    
}
- (QGClassPoplView *)classPopView
{
	if (!_classPopView) {
		_classPopView = [[QGClassPoplView alloc]initWithFrame:self.view.bounds];
	}
	return _classPopView;
}

- (void)addMesseageBtnInTheView:(UIView *)view
{
    //消息
    UIView * bottomView = [[UIView alloc] init];
    bottomView.frame=CGRectMake(SCREEN_WIDTH-50, Height_TopBar-50-5, 50, 50);
    bottomView.backgroundColor = [UIColor clearColor];
	
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"ic_咨询"] forState:UIControlStateNormal];
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

-(void)add_viewUI {
    if (_tableView==nil) {
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,_segmentView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-Height_TapBar-_segmentView.bottom) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =COLOR(242, 243, 244, 1);
		_tableView.tableFooterView = [self p_footerView];
		_tableView.tableFooterView.hidden = YES;
		PL_CODE_WEAK(ws);
		[_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
			ws.perPage = 1;
			[ws p_loadAllStyudyData:0 andType:ws.currentIndex];
		}];
		[_tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {
			ws.perPage++;
			[ws p_loadAllStyudyData:1 andType:ws.currentIndex];
		}];
		
    }else {
        
        [_tableView reloadData];
    }
    [self.view addSubview:_tableView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	QGNewTeacherLessonModel * model = _dataArray[indexPath.section];
	PL_CELL_CREATEMETHOD(QGStudyCell,@"QGStudyCell") ;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.model = model;
	return cell;
}



#pragma make - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	  
	return 158;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    if ([self loginIfNeeded]) {
        return;
    }
	QGNewTeacherLessonModel * model = _dataArray[indexPath.section];
	QGNewteacherBuyController * vc = [[QGNewteacherBuyController alloc]init];
	vc.course_id = model.course_id;
	[self.navigationController pushViewController:vc animated:YES];
	
}
- (void)getStudyLocation
{
    PL_CODE_WEAK(weakSelf);
    if (IS_IOS8) {
        [[GHBLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            QGGetLocationCityModel *pa =[[QGGetLocationCityModel alloc] init];
            pa.latitude =  locationCorrrdinate.latitude;
            pa.longitude =  locationCorrrdinate.longitude;
            [QGHttpManager homeGetLocationCityWithParam:pa success:^(QGGetCityResultModel *item) {
                _item = item;
                [_shopCityLists enumerateObjectsUsingBlock:^(QGShopCityModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([item.item.name  isEqualToString: obj.name]&&[item.item.is_default integerValue]!=1) {
                        [[SAAlert sharedInstance] showAlertWithTitle:@"" message:[NSString stringWithFormat:@"系统定位您在%@，需要切换到%@吗？",item.item.name,item.item.name] cancelButtonTitle:@"取消" otherTitle:@"切换"];
                        [[SAAlert sharedInstance] confirmClick:^{
							_cityTitile = item.item.name;
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







#pragma mark 数据
- (void)p_loadAllStyudyData:(NSInteger)loadType andType:(NSInteger )type
{
	if (loadType == 0) {
		_dataArray = [NSMutableArray array];
	}
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSInteger userId = [BLUAppManager sharedManager].currentUser.userID;
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"user_id":@(userId),
		@"category_id":_category_id,
		@"page":@(_perPage),
		@"type":@(type),
		@"page_size":@"10",
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getCourseListByUserId",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		NSMutableArray * resultArr = [NSMutableArray array];
		
		_studyProgress.progress = [responseObj[@"extra"][@"already_study_rate"] floatValue]/100;
		_alreadyLabel.text = [NSString stringWithFormat:@"学习进度%@",responseObj[@"extra"][@"already_study_rate"]];
		resultArr = [QGNewTeacherLessonModel mj_objectArrayWithKeyValuesArray:responseObj[@"extra"][@"items"]];
		if (resultArr.count>0) {
			[_tableView showFooterView];
			for (QGNewTeacherLessonModel * model in resultArr) {
				[_dataArray addObject:model];
			}
			_tableView.tableFooterView.hidden = YES;

		}else
		{
			_tableView.tableFooterView.hidden = NO;

		}
		[_tableView endRrefresh];
		[_tableView reloadData];
		} failure:^(NSError *error) {
			NSLog(@"%@",error);
			[_tableView endRrefresh];
		}];
}
- (UIView *)p_footerView
{
	UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
	footView.backgroundColor = [UIColor clearColor];
	UILabel * myLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 60)];
	myLabel.text = @"学无止境，快去添加课程吧";
	myLabel.textAlignment = NSTextAlignmentCenter;
	myLabel.textColor = [UIColor colorFromHexString:@"999999"];
	myLabel.backgroundColor = [UIColor clearColor];
	[footView addSubview:myLabel];
	return footView;
}
@end
