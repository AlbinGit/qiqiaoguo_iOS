//
//  QGNewteacherBuyRecordedController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/11.
//

#import "QGNewteacherBuyController.h"
#import "QGNewteacherLessonsCell.h"
#import "QGNewTeacherHtmlCell.h"
#import "QGNewTeacherLiveLessonsCell.h"
#import "QGNewCatalogModel.h"
#import "QGShareViewController.h"
#import "QGNewShareModel.h"
#import "QGHttpManager+User.h"
#import <TTTClassKit/TTTClassKit.h>
#import "HLSegementView.h"
#import "QGRecordVideoController.h"

@interface QGNewteacherBuyController ()<UITableViewDelegate,UITableViewDataSource,TTTClassManagerDelegate,HLSegementViewDelegate>
@property (nonatomic,strong) SASRefreshTableView *tableView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *coverImgView;
@property (nonatomic,strong) UILabel *titLab;
@property (nonatomic,strong) UILabel *teachLab;
@property (nonatomic,strong) UILabel *lessonsLab;
@property (nonatomic,strong) UILabel *studyPersonLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,copy) NSString *teacherID;

@property (nonatomic,strong) NSMutableArray *dataArray;
//data
@property (nonatomic,copy) NSString *htmlString;
@property (nonatomic,strong) NSMutableAttributedString *htmlAttribute;
@property (nonatomic,copy) NSString *courseID;

@property (nonatomic,strong) QGNewShareModel *shareModel;
@property (nonatomic,strong) NSDictionary *teacherDict;//老师信息
@property (nonatomic,assign) NSInteger  myPage;
@property (nonatomic,strong) HLSegementView *segmentView;
@property (nonatomic, assign) NSInteger currentIndex;//当前选中tag

@property (nonatomic,copy) NSString *teacherName;
@property (nonatomic,copy) NSString *teacher_headImg;

@end

@implementation QGNewteacherBuyController
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
	
	_myPage = 1;
	[self p_creatNav];
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
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,Height_TopBar, SCREEN_WIDTH, SCREEN_HEIGHT-Height_TopBar) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =COLOR(242, 243, 244, 1);
		_tableView.tableHeaderView = [self tableViewHeaderView];
        PL_CODE_WEAK(weakSelf);
//        [_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
//			[weakSelf.tableView endRrefresh];
//        }];		
    }
	else {
        [_tableView reloadData];
    }
    [self.view addSubview:_tableView];

}
#pragma mark 头视图
- (UIView *)tableViewHeaderView
{
	_currentIndex = 0;

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_currentIndex==0) {
		return _dataArray.count;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_currentIndex == 1) {
		PL_CELL_CREATEMETHOD(QGNewTeacherHtmlCell,@"QGNewTeacherHtmlCell") ;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.urlString = _htmlString;
		cell.attribute = _htmlAttribute;
		return cell;
	}
	
	QGNewCatalogModel * model = _dataArray[indexPath.row];
	PL_CODE_WEAK(ws);
	PL_CELL_CREATEMETHOD(QGNewTeacherLiveLessonsCell,@"QGNewTeacherLiveLessonsCell") ;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.model = model;
	cell.liveVideoBlock = ^(QGNewCatalogModel *model) {
		if ([model.video_type intValue]==0) {
			//录播
			[ws gotoRecordRoomWithModel:model];
		}else if ([model.video_type intValue]==1)
		{
			[ws gotoLiveRoomWithFileId:model.myID];//直播
		}else
		{
			//回放
			[ws gotoRecordRoomWithModel:model];
		}
	};
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
	bgView.backgroundColor = [UIColor whiteColor];
	NSArray * titlss = @[@"课程目录",@"课程介绍"];
		
	HLSegementView * segmentView = [[HLSegementView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40) titles:titlss];
	segmentView.selectIndex = _currentIndex;
	segmentView.isShowUnderLine = YES;
	segmentView.delegate = self;
	_segmentView = segmentView;
	
	[bgView addSubview:segmentView];
	UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60-4, SCREEN_WIDTH, 4)];
	[bgView addSubview:lineView];
	lineView.backgroundColor = [UIColor colorFromHexString:@"F8F8F8"];
	return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 60;
}
#pragma mark tag  didSelectWithIndex
- (void)hl_didSelectWithIndex:(NSInteger)index{
	NLog(@"代理实现的方法%ld",index);
	_currentIndex = index;
	
	[self.tableView reloadData];

//	if (index == 0) {
//	}
//	else
//	{
//
//	}
}

#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}
- (void)p_loadCourseData
{
	_dataArray = [NSMutableArray array];
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
		
		NSDictionary * resultDic = responseObj[@"extra"][@"item"];

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

		_courseID = resultDic[@"id"];
		_shareModel = [[QGNewShareModel alloc]init];
		_shareModel.title = resultDic[@"title"];
		_shareModel.content = resultDic[@"title"];
		_shareModel.shareImg = resultDic[@"cover_path"];
		_shareModel.sharUrl = resultDic[@"share_url"];

		//1.cell
		_htmlString = resultDic[@"course_desc"];
		NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
								   NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
		// htmlString 为需加载的HTML代码
		NSData *htmlData = [resultDic[@"course_desc"] dataUsingEncoding:NSUTF8StringEncoding];
		_htmlAttribute = [[NSMutableAttributedString alloc] initWithData:htmlData options:options documentAttributes:nil error:nil];

//		_htmlString =  @"<!DOCTYPE html>\r\n    <html lang=\"zh-CN\">\r\n    <head>\r\n    <meta http-equiv=\"Content-Type\" content=\"text\/html; charset=UTF-8\"\/>\r\n    <meta name=\"viewport\" content=\"initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\">\r\n    <\/head>\r\n    <body><div style=\"font-size:14px; line-height:25px;\"><p style=\"padding:0px; margin:0px; border:0px;\">好小子机器人教育 I Diy Robotec Corp 系由台湾、日本、美国机器人学者、专家共同创立于台湾。<br\/>于2009年正式进入中国大陆，并在上海、香港成立事业总部，在上海、北京、武汉、宜昌、长沙、福州、深圳、沈阳、南京、无锡、成都、湾、日本、美国机器人学者、专家共同创立于台湾。<br\/>于2009年正式进入中国大陆，并在上海、香港成立事业总部，在上海、北京、武汉、宜昌、长沙、福州、深圳、沈阳、南京、无锡、成都、抚顺、广州等地成立机器人科学教育学校，创办了机器人科学实验室。<br\/>在透过机器人DIY（Do It Yourself）的过程中提升青少年学生在机械学、工程学、电学、电路学、电子学、程式设计、自动控湾、日本、美国机器人学者、专家共同创立于台湾。<br\/>于2009年正式进入中国大陆，并在上海、香港成立事业总部，在上海、北京、武汉、宜昌、长沙、福州、深圳、沈阳、南京、无锡、成都 抚顺、广州等地成立机器人科学教育学校，创办了机器人科学实验室。<br\/>在透过机器人DIY（Do It Yourself）的过程中提升青少年学生在机械学、工程学、电学、电路学、电子学、程式设计、自动控制等领域的科普知识。<br\/>可说是一家拥有创新技术与创意科学教育的先进机构，也是中国第一家专业的机器人教育学校。<br\/>在课程设置上，学校充分考虑了科学分级、循序渐进的原则，根据湾、日本、美国机器人学者、专家共同创立于台湾。<br\/>于2009年正式进入中国大陆，并在上海、香港成立事业总部，在上海、北京、武汉、宜昌、长沙、福州、深圳、沈阳、南京、无锡、成都、抚顺、广州等地成立机器人科学教育学校，创办了机器人科学实验室。<br\/>在透过机器人DIY（Do It Yourself）的过程中提升青少年学生在机械学、工程学、电学、电路学、电子学、程式设计、自动控制等领域的科普知识。<br\/>可说是一家拥有创新技术与创意科学教育的先进机构，也是中国第一家专业的机器人教育学校。<br\/>在课程设置上，学校充分考虑了科学分级、循序渐进的原则，根据青少年身心发展的特点，独创了好小子（轻松学）学程计划，让学生在做中学Learning by doing、玩中学Learning by playing、错中学Learning by trying的方式启发孩子的智能与潜能。<\/p><p style=\"padding:0px; margin:0px; border:0px;\"><img src=\"http:\/\/www.qiqiaoguo.com\/Public\/Uploads\/User\/534\/2016\/1019\/58072401bcdc6_1080x1080.png\" style=\"      width:100%;      margin:0px; padding:0px; border:0px;\"\/><\/p><p style=\"padding:0px; margin:0px; border:0px;\"><img src=\"http:\/\/www.qiqiaoguo.com\/Public\/Uploads\/User\/534\/2016\/1019\/5807240226980_1080x1080.png\" style=\"      width:100%;      margin:0px; padding:0px; border:0px;\"\/><\/p><p style=\"padding:0px; margin:0px; border:0px;\"><img src=\"http:\/\/www.qiqiaoguo.com\/Public\/Uploads\/User\/534\/2016\/1019\/580724023f9ce_1080x1080.png\" style=\"      width:100%;      margin:0px; padding:0px; border:0px;\"\/><\/p><p style=\"padding:0px; margin:0px; border:0px;\"><img src=\"http:\/\/www.qiqiaoguo.com\/Public\/Uploads\/User\/534\/2016\/1019\/5807240256c6d_1080x1080.png\" style=\"      width:100%;      margin:0px; padding:0px; border:0px;\"\/><\/p><p style=\"padding:0px; margin:0px; border:0px;\"><img src=\"http:\/\/www.qiqiaoguo.com\/Public\/Uploads\/User\/534\/2016\/1019\/5807240273b80_1080x1080.png\" style=\"      width:100%;      margin:0px; padding:0px; border:0px;\"\/><\/p><p style=\"padding:0px; margin:0px; border:0px;\"><img src=\"http:\/\/www.qiqiaoguo.com\/Public\/Uploads\/User\/534\/2016\/1019\/580724029a8f2_1080x1080.png\" style=\"      width:100%;      margin:0px; padding:0px; border:0px;\"\/><\/p><p style=\"padding:0px; margin:0px; border:0px;\"><br\/><\/p><\/div>\r\n    <\/body>\r\n    <\/html>";
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
		
		[_tableView reloadData];
		[_tableView endRrefresh];
	} failure:^(NSError *error) {
			NSLog(@"%@",error);
		
	}];
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

//- (void)gotoLiveRoom
//{
//	// TODO: 进入房间具体调用及实现.
//	// 1. 检查当前设备网络是否可用.(这一步根据自己本地的代码库进行判断, demo省略)
//	// 2. 进房间参数准备需要服务端配合, 具体联系服务端同事进行相关对接后, 获取对应的参数数据;
//	NSString *roomId = @"100615";
//	NSString *userId = @"100793";
//	NSString *safeKey = @"fbbdd528776033a754f95049f132ae44";
//	NSString *timeStamp = @"1591684641";
//	NSString *baseUrl = @"http://yunapi.qiqiaoguo.com/";
//	// Progress page logo.
//	UIImage *loadingImage = [UIImage imageNamed:@""];
//	[[TTTClassManager sharedInstance] ttt_enterLiveRoomWithRoomId:roomId userId:userId safeKey:safeKey timeStamp:timeStamp baseUrl:baseUrl loadingImage:loadingImage];
//	[TTTClassManager sharedInstance].delegate = self;
//}
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
//		NSString *roomId = @"100677";
//		NSString *userId = @"100842";
//		NSString *safeKey = @"9a756e9983cfd3c389db8b34334a7791";
//		NSString *timeStamp = @"1592649398";
//		NSString *baseUrl = @"http://yunapi.qiqiaoguo.com/";
		
		NSString *roomId = resultDic[@"classId"];
		NSString *userId = resultDic[@"UID"];
		NSString *safeKey = resultDic[@"safeKey"];
		NSString *timeStamp = [NSString stringWithFormat:@"%@",resultDic[@"timeStamp"]];
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

@end
