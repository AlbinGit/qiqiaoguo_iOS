//
//  QGNewCourseDetailController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/4.
//

#import "QGNewCourseDetailController.h"
#import "QGNewTeacherHtmlCell.h"
#import "QGNewTeacherIntroCell.h"
#import "QGNewteacherLessonsCell.h"
#import "QGNewTeacherCommentCell.h"
#import "QGNewTeacherLiveLessonsCell.h"
#import "QGNewCatalogModel.h"
#import "QGNewCommentModel.h"
#import "QGNewStarCell.h"
#import "QGShareViewController.h"
#import "QGNewShareModel.h"
#import "QGNewBottomView.h"
#import "QGHttpManager+User.h"
#import "QGEduOrderViewController.h"

#import <TTTClassKit/TTTClassKit.h>
#import "QGRecordVideoController.h"
@interface QGNewCourseDetailController ()<UITableViewDelegate,UITableViewDataSource,TTTClassManagerDelegate>
@property (nonatomic,strong) SASRefreshTableView *tableView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *coverImgView;
@property (nonatomic,strong) UILabel *titLab;
@property (nonatomic,strong) UILabel *teachLab;
@property (nonatomic,strong) UILabel *lessonsLab;
@property (nonatomic,strong) UILabel *studyPersonLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) QGNewBottomView *bottomView;
@property (nonatomic,strong) QGCourseDetaiResultModel *result;//支付相关
@property (nonatomic,copy) NSString *teacherID;


@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int webViewheight;

//data
@property (nonatomic,copy) NSString *htmlString;
@property (nonatomic,strong) NSMutableAttributedString *htmlAttribute;

@property (nonatomic,copy) NSString *starString;
@property (nonatomic,copy) NSString *courseID;
@property (nonatomic,strong) QGNewShareModel *shareModel;

@property (nonatomic,strong) NSDictionary *teacherDict;//老师信息
@property (nonatomic,strong) NSMutableArray *commentArray;
@property (nonatomic,assign) NSInteger  myPage;

@property (nonatomic,copy) NSString *teacherName;
@property (nonatomic,copy) NSString *teacher_headImg;

@end

@implementation QGNewCourseDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	_myPage = 1;
	[self p_creatNav];
	
	[self.view addSubview:self.bottomView];

	[self p_loadCourseData];
	
	[self add_viewUI];
	
}
- (void)p_creatNav
{
    [self createNavImageView];
    [self initBaseData];
    [self createReturnButton];
	[self createNavTitle:@"课程介绍"];
	UIButton * shareBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
	shareBtn.frame = CGRectMake(SCREEN_WIDTH-16-20, kTopEdgeHeight+(64-32)/2+5, 32, 32);
	[shareBtn setImage:[UIImage imageNamed:@"ic_分享"]];
	[self.navImageView addSubview:shareBtn];
	[shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)shareClick:(UIButton *)btn
{
    if ([self loginIfNeeded]) {
        return;
    }
     QGShareViewController *vc = [QGShareViewController new];
    vc.shareObject = _shareModel;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)add_viewUI {
    if (_tableView==nil) {
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,Height_TopBar, SCREEN_WIDTH, SCREEN_HEIGHT-Height_TopBar-54-Height_BottomSafe) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =COLOR(242, 243, 244, 1);
		_tableView.tableHeaderView = [self tableViewHeaderView];
        PL_CODE_WEAK(weakSelf);
//        [_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
//			[weakSelf.tableView endRrefresh];
//        }];
//		[_tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {
//			[weakSelf loadMoreData];
//		}];
    }
	else {
        [_tableView reloadData];
    }
    [self.view addSubview:_tableView];

}
#pragma mark 头视图
- (UIView *)tableViewHeaderView
{
	UIView * headView = [[UIView alloc]init];
	headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 326);
	headView.backgroundColor = [UIColor whiteColor];
	_headView = headView;
	
	UIImageView * coverImg = [[UIImageView alloc]init];
	coverImg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 210);
	[headView addSubview:coverImg];
	coverImg.backgroundColor = [UIColor whiteColor];
	_coverImgView = coverImg;
	
	UIView * blackView = [[UIView alloc]initWithFrame:CGRectMake(_coverImgView.width-5-83, coverImg.height-5-18, 83, 18)];
	blackView.backgroundColor = [UIColor blackColor];
	blackView.alpha = 0.5;
	blackView.layer.cornerRadius = 9;
	[self.coverImgView addSubview:blackView];
	
	UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 7, 8)];
	img.userInteractionEnabled = YES;
	img.image = [UIImage imageNamed:@"ic_视频学习"];
	[blackView addSubview:img];

	self.studyPersonLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(img.right+3,0, 63,18)];
		label.font = FONT_SYSTEM(11);
		label.textColor = [UIColor whiteColor];
		label.textAlignment = NSTextAlignmentLeft;
		[blackView addSubview:label];
		label;
	});

	UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake(15, coverImg.bottom+15, SCREEN_WIDTH-30, 56)];
//	titLab.text = @"就啊看了时代峰峻嗷嗷待食会计法减肥拉开解放东路";
	titLab.numberOfLines = 0;
	titLab.textAlignment = NSTextAlignmentLeft;
	titLab.font = [UIFont boldSystemFontOfSize:20];
	titLab.textColor = [UIColor blackColor];
	[headView addSubview:titLab];
	_titLab = titLab;
	
	UILabel * teachLab = [[UILabel alloc]initWithFrame:CGRectMake(15, titLab.bottom+10, 100, 20)];
	teachLab.text = @"授课地点:线上";
	teachLab.textAlignment = NSTextAlignmentLeft;
	teachLab.font = FONT_CUSTOM(14);
	teachLab.textColor = [UIColor colorFromHexString:@"666666"];
	[headView addSubview:teachLab];
	_teachLab = teachLab;

	UILabel * lessonsLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100-15, titLab.bottom+10, 100, 20)];
	lessonsLab.text = @"10节";
	lessonsLab.textAlignment = NSTextAlignmentRight;
	lessonsLab.font = FONT_CUSTOM(14);
	lessonsLab.textColor = [UIColor colorFromHexString:@"666666"];
	[headView addSubview:lessonsLab];
	_lessonsLab = lessonsLab;
	
	UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, headView.height-10, SCREEN_WIDTH, 10)];
	lineView.backgroundColor = [UIColor colorFromHexString:@"F7F7F7"];
	[headView addSubview:lineView];
	_lineView = lineView;
	
	return headView;
}
#pragma mark 底部视图
- (QGNewBottomView *)bottomView
{
	if (!_bottomView) {
		_bottomView = [[QGNewBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-54-Height_BottomSafe, SCREEN_WIDTH, 54+Height_BottomSafe)];
		_bottomView.backgroundColor = [UIColor whiteColor];
		
		PL_CODE_WEAK(ws);
		
		__weak __typeof(&*_bottomView)weakBottom = _bottomView;

		_bottomView.collectionBlock = ^(BOOL isSel) {
			[QGHttpManager CollectionWithCollectType:UserCollectionTypeCourse objectID:[ws.courseID integerValue] isCollection:!isSel Success:^(NSURLSessionDataTask *task, id responseObject) {
				
				NSLog(@"%@",responseObject);
				if (isSel) {
					weakBottom.isFollowed = NO;
				}else
				{
					weakBottom.isFollowed = YES;
				}
			   } failure:^(NSURLSessionDataTask *task, NSError *error) {
				   NSLog(@"%@",error);
			   }];
		};
		
		_bottomView.payForLessonsBlock = ^{
			[ws payLessons];
		};
	}
	return _bottomView;
}
#pragma mark 报名支付
- (void)payLessons
{
	if ([self loginIfNeeded]) {
		return;
	};
	QGEduOrderViewController *vc =[[QGEduOrderViewController alloc] init];
	vc.max_student_number = _result.item.max_student_number;
	vc.apply_student_number = _result.item.apply_student_number;
	vc.avilibale_student_number = _result.item.avilibale_student_number;
	vc.cover_path = _result.item.cover_path;
	vc.org_name = _result.item.org_name;
	vc.sign = _result.item.category_name;
	vc.class_price = _result.item.class_price;
	vc.name= _result.item.title;
	vc.eduId = _result.item.id;
	vc.eduSid = _result.item.sid;
	vc.type = _result.item.type;
	[self.navigationController pushViewController:vc animated:YES];

}
#pragma mark 看录播
- (void)gotoRecordRoomWithModel:(QGNewCatalogModel *)model
{
	QGRecordVideoController * vc = [[QGRecordVideoController alloc]init];
	vc.model = model;
	vc.teacherName = _teacherName;
	vc.teacherImgUrl = _teacher_headImg;
	vc.course_id =[_courseID intValue];
	[self.navigationController pushViewController:vc animated:NO];
}

#pragma mark 听直播
- (void)gotoLiveRoomWithFileId:(NSString *)file_id
{
	
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"section_id":@([file_id intValue]),//课节id
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Live/joinRoom",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		
		NSDictionary * resultDic = responseObj[@"extra"];
		// TODO: 进入房间具体调用及实现.
		// 1. 检查当前设备网络是否可用.(这一步根据自己本地的代码库进行判断, demo省略)
		// 2. 进房间参数准备需要服务端配合, 具体联系服务端同事进行相关对接后, 获取对应的参数数据;
//		NSString *roomId = @"100676";
//		NSString *userId = @"100841";
//		NSString *safeKey = @"6e5cea08a56f9dc945a5454109b77d47";
//		NSString *timeStamp = @"1592639780";
//		NSString *baseUrl = @"http://yunapi.qiqiaoguo.com";
		
		NSString *roomId = resultDic[@"classId"];
		NSString *userId = resultDic[@"UID"];
		NSString *safeKey = resultDic[@"safeKey"];
		NSString *timeStamp = resultDic[@"timeStamp"];
		NSString *baseUrl = resultDic[@"baseUrl"];

		// Progress page logo.
		UIImage *loadingImage = [UIImage imageNamed:@""];
		[[TTTClassManager sharedInstance] ttt_enterLiveRoomWithRoomId:roomId userId:userId safeKey:safeKey timeStamp:timeStamp baseUrl:baseUrl loadingImage:loadingImage];
		[TTTClassManager sharedInstance].delegate = self;

	}
		failure:^(NSError *error) {
		NSLog(@"%@",error);
	}];

}
#pragma mark - TTTClassManager Delegate
- (void)ttt_enterRoomSuccessCallBack {
    NSLog(@"ttt___:进入房间成功!");
}
- (void)ttt_enterRoomFailureCallback:(NSString *)errorInfo {
    NSLog(@"ttt___:进入房间错误信息打印:--%@", errorInfo);
	[self showTopIndicatorWithSuccessMessage:@"暂无课程，请稍后~"];
}
- (void)ttt_exitRoomSuccessCallBack {
    NSLog(@"ttt___:退出房间成功!");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==2)
	{
		return _dataArray.count;
		
	}
	else if (section == 3)
	{
		return _commentArray.count+1;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PL_CODE_WEAK(ws);

	if (indexPath.section == 0) {
		PL_CELL_CREATEMETHOD(QGNewTeacherHtmlCell,@"QGNewTeacherHtmlCell") ;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.urlString = _htmlString;
		cell.attribute = _htmlAttribute;
//		cell.webViewHeightChanged = ^(int height) {
//			ws.webViewheight = height;
//			[ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
//		};
		return cell;
	}
	else if (indexPath.section == 1)
	{
		PL_CELL_CREATEMETHOD(QGNewTeacherIntroCell,@"QGNewTeacherIntroCell") ;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell loadDict:_teacherDict];
		return cell;
	}
	else if (indexPath.section == 2)
	{
		
		QGNewCatalogModel * model = _dataArray[indexPath.row];
		if ([model.is_free intValue]==1) {
			QGNewCatalogModel * model = _dataArray[indexPath.row];
			PL_CELL_CREATEMETHOD(QGNewteacherLessonsCell,@"QGNewteacherLessonsCell") ;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.model = model;
			cell.freeVideoBlock = ^(QGNewCatalogModel *model) {
				if ([model.video_type intValue]==0) {
					//录播课
					[self gotoRecordRoomWithModel:model];
				}else if ([model.video_type intValue]==1)
				{
					//直播课
					if ([model.live_status intValue]==0) {
						//未开始
						[ws showTopIndicatorWithSuccessMessage:@"直播未开始~"];
						
					}else if ([model.live_status intValue]==1)
					{
						[ws gotoLiveRoomWithFileId:model.myID];
					}else
					{
						//2 已结束
						[ws showTopIndicatorWithSuccessMessage:@"直播已结束~"];
					}
				}else
				{
					//回放课
					[self gotoRecordRoomWithModel:model];
				}
			};

			return cell;
		}else
		{
			PL_CELL_CREATEMETHOD(QGNewTeacherLiveLessonsCell,@"QGNewTeacherLiveLessonsCell") ;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.model = model;
			cell.liveVideoBlock = ^(QGNewCatalogModel *model) {
//				NSArray * arr = [QGfileListModel mj_objectArrayWithKeyValuesArray:model.fileList];
//				NSLog(@"%@",arr);
//				QGfileListModel * amodel = arr[0];
				if ([model.video_type intValue]==0) {
					//录播课
					[self gotoRecordRoomWithModel:model];
				}else if ([model.video_type intValue]==1)
				{
					//直播课
					if ([model.live_status intValue]==0) {
						//未开始
						[ws showTopIndicatorWithSuccessMessage:@"直播未开始~"];
						
					}else if ([model.live_status intValue]==1)
					{
						[ws gotoLiveRoomWithFileId:model.myID];
					}else
					{
						//2 已结束
						[ws showTopIndicatorWithSuccessMessage:@"直播已结束~"];
					}
				}else
				{
					//回放课
					[self gotoRecordRoomWithModel:model];
				}
				
//				[ws gotoLiveRoomWithFileId:model.myID];

			};
			return cell;
		}
	}
	else if (indexPath.section == 3)
	{
		if (indexPath.row == 0) {
			PL_CELL_CREATEMETHOD(QGNewStarCell,@"QGNewStarCell") ;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.starStr = _starString;
			return cell;
		}
		else
		{
			QGNewCommentModel * model = _commentArray[indexPath.row-1];
			PL_CELL_CREATEMETHOD(QGNewTeacherCommentCell,@"QGNewTeacherCommentCell") ;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.model = model;
			return cell;

		}
	}

	PL_CELL_CREATEMETHOD(QGNewTeacherIntroCell,@"QGNewTeacherIntroCell") ;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
//	PL_CODE_WEAK(ws);
	[cell loadDict:_teacherDict];
	return cell;
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{	
	UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
	bgView.backgroundColor = [UIColor whiteColor];
	NSArray * sectionArr = @[@"课程介绍",@"课程老师",@"课程目录",@"课程评价"];
	UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, (50-22)/2, SCREEN_WIDTH-30, 22)];
	titleLab.font = [UIFont boldSystemFontOfSize:16];
	titleLab.textColor = [UIColor colorFromHexString:@"333333"];
	titleLab.textAlignment = NSTextAlignmentLeft;
	titleLab.text = sectionArr[section];
	[bgView addSubview:titleLab];
	return bgView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
	bgView.backgroundColor = [UIColor colorFromHexString:@"f7f7f7"];
	return bgView;
}
#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
//		return self.webViewheight;
//		return 144;
		UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
		return cell.frame.size.height;
	}
	else if (indexPath.section == 1)
	{
		return 60;
	}
	else if (indexPath.section == 2)
	{
//		return 60;
		
		UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
		return cell.frame.size.height;

	}
	else if (indexPath.section == 3)
	{
		if (indexPath.row == 0) {
			return 67;
		}else
		{
			UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
			return cell.frame.size.height;
		}
	}

	return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 10;
}
- (void)p_loadCourseData
{
	[[SAProgressHud sharedInstance]showWaitWithWindow];

	_dataArray = [NSMutableArray array];
	_commentArray = [NSMutableArray array];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"course_id":_course_id,
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getCourseInfo",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		//		NSLog(@"%@",responseObj);
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		_result = [QGCourseDetaiResultModel mj_objectWithKeyValues:responseObj[@"extra"]];
		NSDictionary * resultDic = responseObj[@"extra"][@"item"];
		_result.item.sid = resultDic[@"teacher_id"];

		//课程封面
		[_coverImgView sd_setImageWithURL:[NSURL URLWithString:resultDic[@"cover_path"]] placeholderImage:nil];
		_titLab.text = resultDic[@"title"];
		_teachLab.text = [NSString stringWithFormat:@"授课地点:%@",resultDic[@"address"]];
		_lessonsLab.text = [NSString stringWithFormat:@"%@节",resultDic[@"section_count"]];
		_studyPersonLabel.text =[NSString stringWithFormat:@"%@人学习",resultDic[@"sign_count"]];
		CGRect rect =  [QGCommon rectForString:_titLab.text withBoldFont:_titLab.font WithWidth:SCREEN_WIDTH-30];
		_titLab.frame = CGRectMake(15, _coverImgView.bottom+15, SCREEN_WIDTH-30, rect.size.height+1);
		_teachLab.frame = CGRectMake(15, _titLab.bottom+10, SCREEN_WIDTH-100-15, 20);
		_lessonsLab.frame = CGRectMake(SCREEN_WIDTH-100-15, _titLab.bottom+10, 100, 20);
		_headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 326-56+_titLab.height);
		_lineView.frame = CGRectMake(0, _headView.height-10, SCREEN_WIDTH, 10);

//		_shareString = resultDic[@"share_url"];
		_courseID = resultDic[@"id"];
		_shareModel = [[QGNewShareModel alloc]init];
		_shareModel.title = resultDic[@"title"];
		_shareModel.content = resultDic[@"title"];
		_shareModel.shareImg = resultDic[@"cover_path"];
		_shareModel.sharUrl = resultDic[@"share_url"];

		_bottomView.service_id = resultDic[@"service_id"];
		if ([resultDic[@"is_followed"] intValue]==0) {
			_bottomView.isFollowed = NO;
		}else
		{
			_bottomView.isFollowed = YES;
		}
		//1.cell
		_htmlString = resultDic[@"course_desc"];
		
		NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
								   NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
		// htmlString 为需加载的HTML代码
		NSData *htmlData = [resultDic[@"course_desc"] dataUsingEncoding:NSUTF8StringEncoding];
		_htmlAttribute = [[NSMutableAttributedString alloc] initWithData:htmlData options:options documentAttributes:nil error:nil];

//		NSLog(@"%@",_htmlString);
		//2.cell 教师信息
		_teacherDict = @{
			@"teacher_name":resultDic[@"teacher_name"],
			@"teacher_experience":resultDic[@"teacher_experience"],
			@"teacher_fans_num":resultDic[@"teacher_fans_num"],
			@"teacher_head_img":resultDic[@"teacher_head_img"],
			@"teacher_id":resultDic[@"teacher_id"],
		};
		_teacherName = resultDic[@"teacher_name"];
		_teacher_headImg = resultDic[@"teacher_head_img"];
		//3.cell
		_dataArray = [QGNewCatalogModel mj_objectArrayWithKeyValuesArray:resultDic[@"sectionList"]];
	
		//4.cell 评论
		_starString = resultDic[@"comment_info"][@"comment_avg"];
		_commentArray = [QGNewCommentModel mj_objectArrayWithKeyValuesArray:resultDic[@"comment_info"][@"list"]];
		
		
		[[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

		[_tableView reloadData];
		[_tableView endRrefresh];
	} failure:^(NSError *error) {
			NSLog(@"%@",error);
		
	}];
}
- (void)loadMoreData
{
	_myPage++;
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"course_id":_course_id,
		@"page":@(_myPage),
		@"page_size":@"10",
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getCourseCommentList",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		
		NSMutableArray * resultArr = [NSMutableArray array];
		NSDictionary * resultDic = responseObj[@"extra"][@"item"];

		resultArr = [QGNewCommentModel mj_objectArrayWithKeyValuesArray:resultDic[@"comment_info"][@"list"]];
		
		if (resultArr.count>0) {
			for (QGNewCommentModel * model in resultArr) {
				[_commentArray addObject:model];
			}
		}
		[_tableView reloadData];
		[_tableView endRrefresh];
	}
		failure:^(NSError *error) {
		NSLog(@"%@",error);
		[_tableView endRrefresh];
	}];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = 10;//设置你footer高度
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

@end
