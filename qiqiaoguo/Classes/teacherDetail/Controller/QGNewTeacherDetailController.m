//
//  QGNewTeacherDetailController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/28.
//

#import "QGNewTeacherDetailController.h"
#import "HLSegementView.h"
#import "QGNewTeacherTextCell.h"
#import "QGNewTeacherBigImgCell.h"
#import "QGNewTeacherMulImgCell.h"
#import "QGNewClassCell.h"
#import "QGNewTeacherInfoCell.h"
#import "QGNewTeacherInteligenceCell.h"
#import "QGNewTeacherOrganizationCell.h"
#import "QGNewTeacherInfoCell.h"
#import "QGNewTeacherInteligenceCell.h"
#import "QGNewTeacherOrganizationCell.h"
#import "QGNewTeacherStateModel.h"
#import "QGNewTeacherLessonModel.h"
#import "QGNewteacherInfoModel.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "BLUChatViewController.h"
#import "QGHttpManager+User.h"
#import "QGNewCourseDetailController.h"
#import "BLUPostDetailAsyncViewController.h"
#import "CRIKeyboardView.h"
#import "QGShareViewController.h"
#import "QGNewShareModel.h"
#import "QGFilePath.h"
#import "QGBrocastController.h"
#import "QGNewteacherBuyController.h"

@interface QGNewTeacherDetailController ()<UITableViewDelegate,UITableViewDataSource,HLSegementViewDelegate,QGNewTeacherTextCellDelegate,QGNewTeacherBigImgCellDelegate,QGNewTeacherMulImgCellDelegate,keyboardInputViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) SASRefreshTableView *tableView;
@property (nonatomic,strong) HLSegementView *segmentView;
@property (nonatomic,strong) UIView *navView;

@property (nonatomic,strong) UIImageView *coverImg;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UIImageView *portraitImg;
@property (nonatomic,strong) UIImageView *sexImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *fansLab;
@property (nonatomic,strong) UILabel *ageLab;
@property (nonatomic,strong) UILabel *stateLab;
@property (nonatomic,strong) UIButton *concernBtn;
@property (nonatomic,copy) NSString *service_id;
@property (nonatomic,assign) BOOL  is_followed;
@property (nonatomic,copy) NSString *moment_id;
@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic,assign) NSInteger is_self;//是否是自己 1自己

@property (nonatomic,strong) QGNewShareModel *shareModel;

@property (nonatomic, assign) NSInteger currentIndex;//当前选中tag
@property (nonatomic,strong) NSMutableArray *courseList;
@property (nonatomic,strong) NSMutableArray *orgizationList;
@property (nonatomic, assign) NSInteger mypage;
@property (nonatomic,strong) NSMutableArray *teacherList;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray *urls;

@end

@implementation QGNewTeacherDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	_mypage = 0;
	[self add_viewUI];
	[self p_navView];
	[self initPlayer];
	[self p_loadOrgnizationData:0];//老师信息
	[self p_loadTeacherListData:0];

}
- (void)p_navView
{
	_navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_TopBar)];
	_navView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:_navView];
	PL_CODE_WEAK(weakSelf);
	UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBtn setImage:[UIImage imageNamed:@"icon_classification_back"]];
	backBtn.frame = CGRectMake(20, (Height_TopBar-54)/2+12, 32, 54);
	[backBtn addClick:^(UIButton *button) {
		[weakSelf.navigationController popViewControllerAnimated:NO];
	}];
	_navView.alpha  = 0;
	[_navView addSubview:backBtn];
}
- (void)initPlayer
{
		/// playerManager
		ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
		/// player的tag值必须在cell里设置
		self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
		self.player.controlView = self.controlView;
//		self.player.assetURLs = self.urls;
		self.player.shouldAutoPlay = NO;
		/// 1.0是完全消失的时候
		self.player.playerDisapperaPercent = 1.0;
		
		@weakify(self)
		self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
			@strongify(self)
			[self setNeedsStatusBarAppearanceUpdate];
			[UIViewController attemptRotationToDeviceOrientation];
			self.tableView.scrollsToTop = !isFullScreen;
		};
		
		self.player.playerDidToEnd = ^(id  _Nonnull asset) {
			@strongify(self)
				[self.player stopCurrentPlayingCell];
		};

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.player.viewControllerDisappear = YES;
}
-(void)add_viewUI {
    if (_tableView==nil) {
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =COLOR(242, 243, 244, 1);
		_tableView.tableHeaderView = [self tableViewHeaderView];
        PL_CODE_WEAK(weakSelf);
//        [_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
//			[weakSelf.tableView endRrefresh];
//        }];

		[_tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {
			[weakSelf loadMoreData];
		}];
    }else {
        
        [_tableView reloadData];
    }
    [self.view addSubview:_tableView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
- (void)loadMoreData
{
	_mypage++;
	if (_currentIndex == 0) {
		[self p_loadTeacherListData:1];
	}else if (_currentIndex == 1)
	{
		[self p_loadLessonData:1];
	}
	else
	{
		[_tableView endRrefresh];
	}
}
#pragma mark 头视图
- (UIView *)tableViewHeaderView
{
	_currentIndex = 0;
	UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*210/375 *2-26)];
	bgView.backgroundColor = [UIColor whiteColor];
	
	

	UIImageView * coverImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*210/375)];
	coverImg.image = [UIImage imageNamed:@"店铺主页-背景"];
	coverImg.userInteractionEnabled = YES;
	coverImg.contentMode = UIViewContentModeScaleAspectFill;
	[bgView addSubview:coverImg];
	_coverImg = coverImg;
	
	self.playBtn = ({
		UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		playBtn.backgroundColor = [UIColor clearColor];
		playBtn.frame = CGRectMake((SCREEN_WIDTH-48)/2, (SCREEN_WIDTH*210/375-48)/2, 48, 48);
		[playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
//		[playBtn setImage:[UIImage imageNamed:@"ic_播放"]];
		[playBtn setBackgroundImage:[UIImage imageNamed:@"ic_播放"]];
		[coverImg addSubview:playBtn];
		playBtn;
	});
	
	// 长按
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
	[coverImg addGestureRecognizer:longPress];
	
	UIImageView * portraitImg = [[UIImageView alloc]initWithFrame:CGRectMake(18, SCREEN_WIDTH*178/375, 84, 84)];
//	portraitImg.image = [UIImage imageNamed:@"ic_潜能开发_pr"];
	portraitImg.layer.masksToBounds = YES;
	portraitImg.layer.cornerRadius = 84/2;
	[bgView addSubview:portraitImg];
	_portraitImg = portraitImg;
	
	UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	messageBtn.layer.masksToBounds = YES;
	messageBtn.layer.cornerRadius = 15;
	messageBtn.borderWidth = 1.;
	messageBtn.borderColor = [UIColor colorFromHexString:@"333333"];
	messageBtn.backgroundColor = [UIColor whiteColor];
	messageBtn.frame = CGRectMake(SCREEN_WIDTH*189/375, coverImg.bottom +16, 78, 32);
	[messageBtn setTitle:@"消息" forState:UIControlStateNormal];
	[messageBtn addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
	[messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[bgView addSubview:messageBtn];
	
	UIButton * concerndBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	concerndBtn.layer.masksToBounds = YES;
	concerndBtn.layer.cornerRadius = 15;
	concerndBtn.backgroundColor = [UIColor colorFromHexString:@"EE3634"];
	concerndBtn.frame = CGRectMake(messageBtn.right+10, messageBtn.y, 78, 32);
	[concerndBtn setTitle:@"关注" forState:UIControlStateNormal];
	[concerndBtn addTarget:self action:@selector(concernClick:) forControlEvents:UIControlEventTouchUpInside];
	[bgView addSubview:concerndBtn];
	_concernBtn = concerndBtn;
	
	UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(18, portraitImg.bottom+18, 100, 33)];
	nameLab.text = @"Lisa1209";
	nameLab.adjustsFontSizeToFitWidth = YES;
	nameLab.textAlignment = NSTextAlignmentLeft;
	nameLab.font = FONT_CUSTOM(24);
	nameLab.textColor = [UIColor blackColor];
	[bgView addSubview:nameLab];
	_nameLab = nameLab;
	
	UIImageView * sexImg = [[UIImageView alloc]init];
	sexImg.frame = CGRectMake(nameLab.right+5, portraitImg.bottom+18+8, 18, 18);
//	sexImg.backgroundColor = [UIColor redColor];
	sexImg.userInteractionEnabled = YES;
//	sexImg.image = [UIImage imageNamed:@"ic_女"];
	[bgView addSubview:sexImg];
	_sexImg = sexImg;
	
	UILabel * fansLab = [[UILabel alloc]initWithFrame:CGRectMake(18, nameLab.bottom+20, (SCREEN_WIDTH-36)/3, 33)];
	NSMutableAttributedString * Str1 = [self attributedStringWithString:[NSString stringWithFormat:@"%@ %@",@"3309",@"粉丝"]];
    fansLab.attributedText = Str1;
	fansLab.textAlignment = NSTextAlignmentCenter;
	[bgView addSubview:fansLab];
	_fansLab = fansLab;
	
	UILabel * ageLab = [[UILabel alloc]initWithFrame:CGRectMake(fansLab.right, nameLab.bottom+20, (SCREEN_WIDTH-36)/3, 33)];
	NSMutableAttributedString * Str2 = [self attributedStringWithString:[NSString stringWithFormat:@"%@ %@",@"5年",@"年龄"]];
	ageLab.attributedText = Str2;
	ageLab.textAlignment = NSTextAlignmentCenter;
	[bgView addSubview:ageLab];
	_ageLab = ageLab;
	
	UILabel * stateLab = [[UILabel alloc]initWithFrame:CGRectMake(ageLab.right, nameLab.bottom+20, (SCREEN_WIDTH-36)/3, 33)];
	NSMutableAttributedString * Str3 = [self attributedStringWithString:[NSString stringWithFormat:@"%@ %@",@"206",@"动态"]];
	stateLab.attributedText = Str3;
	stateLab.textAlignment = NSTextAlignmentCenter;
	[bgView addSubview:stateLab];
	_stateLab = stateLab;
	
	UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, stateLab.bottom+18, SCREEN_WIDTH, 10)];
	lineV.backgroundColor = [UIColor colorFromHexString:@"F7F7F7"];
	[bgView addSubview:lineV];

	return bgView;
}

#pragma mark 长按操作
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
	if (_is_self==1) {
		
		PL_CODE_WEAK(ws);
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
		
		UIAlertAction *action = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[ws addCamera];
		}];
		[alert addAction:action];

		UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[ws addPhoto];
		}];
		
		[alert addAction:action2];
		
		UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[ws addVideo];

		}];
		[alert addAction:action3];
		
		UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
		[alert addAction:cancleAction];
		
		[self presentViewController:alert animated:YES completion:^{
			
		}];
	}
	
	
}
- (void)playClick
{
	
	QGBrocastController * mvc = [[QGBrocastController alloc]init];
	mvc.videoStr = _videoUrl;
	[self.navigationController pushViewController:mvc animated:NO];
}

- (void)messageClick
{
	BLUChatViewController *vc = [[BLUChatViewController alloc]
									 initWithUserID:_service_id.integerValue];
	[self.navigationController pushViewController:vc animated:YES];
}
- (void)concernClick:(UIButton *)btn
{
//	@weakify(self);
	[QGHttpManager CollectionWithCollectType:UserCollectionTypeTeacher objectID:[self.teacher_id integerValue] isCollection:_is_followed Success:^(NSURLSessionDataTask *task, id responseObject) {
		_is_followed = !_is_followed;
		if (_is_followed) {
			[btn setTitle:@"关注" forState:UIControlStateNormal];
		}else
		{
			[btn setTitle:@"已关注" forState:UIControlStateNormal];
		}
	   } failure:^(NSURLSessionDataTask *task, NSError *error) {

	   }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_currentIndex == 0) {
		return _teacherList.count;
	}else if (_currentIndex == 1)
	{
		return _courseList.count;
	}else
	{
		return _orgizationList.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_currentIndex == 0) {
		QGNewTeacherStateModel * model = _teacherList[indexPath.row];
		if ([model.resource_type intValue]==1) {
			if (model.resources.count<1) {
				PL_CELL_CREATEMETHOD(QGNewTeacherTextCell,@"QGNewTeacherTextCell") ;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.myIndexpath = indexPath;
				cell.delegate = self;
				cell.model = model;
				return cell;
			}else
			{
				PL_CELL_CREATEMETHOD(QGNewTeacherMulImgCell,@"QGNewTeacherMulImgCell") ;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.myIndexpath = indexPath;
				cell.model = model;
				cell.delegate = self;
				return cell;
			}
		}else
		{
			PL_CELL_CREATEMETHOD(QGNewTeacherBigImgCell,@"QGNewTeacherBigImgCell") ;

			cell.myIndexpath = indexPath;
			cell.delegate = self;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.model = model;
			PL_CODE_WEAK(weakSelf);
				cell.playOriginalVideoBlock = ^(NSIndexPath *myIndexpath) {
					[weakSelf playTheVideoAtIndexPath:myIndexpath scrollToTop:NO];
				};
			return cell;
		}
	}
	else if (_currentIndex == 1)
	{
		QGNewTeacherLessonModel * model = _courseList[indexPath.row];
		static NSString *CellIdentifier = @"QGNewClassCell";
		QGNewClassCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell) {
			cell = [[QGNewClassCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.model = model;
		return cell;
	}else
	{
		QGNewteacherInfoModel * model = _orgizationList[indexPath.row];
		static NSString *CellIdentifier1 = @"QGNewTeacherOrganizationCell1";
		static NSString *CellIdentifier2 = @"QGNewTeacherOrganizationCell2";
		static NSString *CellIdentifier3 = @"QGNewTeacherOrganizationCell3";

		if ([model.introType isEqualToString:@"1"]) {
			
			QGNewTeacherInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
			if (!cell) {
				cell = [[QGNewTeacherInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
			}
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.model = model;
			return cell;
		}else if ([model.introType isEqualToString:@"2"])
		{
			QGNewTeacherInteligenceCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
			if (!cell) {
				cell = [[QGNewTeacherInteligenceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
			}
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.model = model;
			return cell;
		}else
		{
			QGNewTeacherOrganizationCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
			if (!cell) {
				cell = [[QGNewTeacherOrganizationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
			}
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.model = model;
			return cell;
		}

	}
	
//	PL_CELL_CREATE(QGNewClassCell)
//	cell.selectionStyle = UITableViewCellSelectionStyleNone;
//	return cell;
	return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
	UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
	bgView.backgroundColor = [UIColor whiteColor];
	NSArray * titlss = @[@"老师动态",@"全部课程",@"老师信息"];
		
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
#pragma mark tag  didSelectWithIndex
- (void)hl_didSelectWithIndex:(NSInteger)index{
	NLog(@"代理实现的方法%ld",index);
	_mypage = 0;
	_currentIndex = index;
	if (index == 0) {
		[self p_loadTeacherListData:0];
	}else if (index == 1)
	{
		[_teacherList removeAllObjects];
		[self p_loadLessonData:0];
	}else
	{
		[self p_loadOrgnizationData:0];
	}

}



#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_currentIndex == 0) {
		QGNewTeacherStateModel * model = _teacherList[indexPath.row];
		if ([model.resource_type intValue]==1) {
			if (model.resources.count<1) {
				return 156;
			}
			else
			{
				return model.cellHeight;
			}
		}else
		{
			return 371;
		}

	}else if (_currentIndex == 1)
	{
		return 159;
	}else
	{
		QGNewteacherInfoModel * model = _orgizationList[indexPath.row];
		UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
		if ([model.introType intValue]==1) {
			return cell.frame.size.height;
		}else if ([model.introType intValue] == 2)
		{
			return 80+22+10+10+10;
		}else
		{
			return 22+10+10+10+64+53;
		}
	}
	
	return 159;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	NLog(@"点击--%ld",indexPath.row);
	
	if (_currentIndex == 0) {
		NLog(@"00000");
	}else if (_currentIndex == 1)
	{
		NLog(@"11111");
		QGNewTeacherLessonModel * model = _courseList[indexPath.row];
		if ([model.is_buy intValue]==1) {
			QGNewteacherBuyController * vc = [[QGNewteacherBuyController alloc]init];
			vc.course_id = model.course_id;
			[self.navigationController pushViewController:vc animated:NO];

		}else
		{
			QGNewCourseDetailController * vc = [[QGNewCourseDetailController alloc]init];
			vc.course_id = model.course_id;
			[self.navigationController pushViewController:vc animated:NO];
		}
		
	}else
	{
		NLog(@"22222");
	}
}
#pragma mark QGNewTeacherTextCellDelegate
- (void)textCell:(QGNewTeacherTextCell *)textCell praiseBtnIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"praiseBtnIndexPath");
	QGNewTeacherStateModel * model = _teacherList[indexPath.row];
	if ([model.is_liked isEqualToString:@"0"]) {
		[textCell.praiseBtn setImage:[UIImage imageNamed:@"ic_点赞_pr"] forState:UIControlStateNormal];
		textCell.priseNum.text = [NSString stringWithFormat:@"%d",[model.likes_num intValue]+1];
	}else
	{
		[textCell.praiseBtn setImage:[UIImage imageNamed:@"ic_点赞"] forState:UIControlStateNormal];
		textCell.priseNum.text = [NSString stringWithFormat:@"%d",[model.likes_num intValue]-1];
	}
	[self requestLikeDataWithTeacher:model];

}
- (void)textCell:(QGNewTeacherTextCell *)textCell commentBtnIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"commentBtnIndexPath");
	QGNewTeacherStateModel * model = _teacherList[indexPath.row];
	_moment_id = model.myID;
	[self keyboardShow];
}
- (void)textCell:(QGNewTeacherTextCell *)textCell shareBtnIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"shareBtnIndexPath");
	
	if ([self loginIfNeeded]) {
		   return;
	   }

//	QGNewTeacherStateModel * model = _teacherList[indexPath.row];
//	_shareModel = [[QGNewShareModel alloc]init];
//	_shareModel.title = model.title;
//	_shareModel.content = model.title;
//	_shareModel.shareImg = model.cover_img;
//
//		QGShareViewController *vc = [QGShareViewController new];
//	   vc.shareObject = _shareModel;
//	   [self presentViewController:vc animated:YES completion:nil];
}
- (void)bigImgCell:(QGNewTeacherBigImgCell *)bigImgCell praiseBtnIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"praiseBtnIndexPath");
	QGNewTeacherStateModel * model = _teacherList[indexPath.row];
	if ([model.is_liked isEqualToString:@"0"]) {
		[bigImgCell.praiseBtn setImage:[UIImage imageNamed:@"ic_点赞_pr"] forState:UIControlStateNormal];
		bigImgCell.priseNum.text = [NSString stringWithFormat:@"%d",[model.likes_num intValue]+1];
	}else
	{
		[bigImgCell.praiseBtn setImage:[UIImage imageNamed:@"ic_点赞"] forState:UIControlStateNormal];
		bigImgCell.priseNum.text = [NSString stringWithFormat:@"%d",[model.likes_num intValue]-1];
	}
	[self requestLikeDataWithTeacher:model];

}
- (void)bigImgCell:(QGNewTeacherBigImgCell *)bigImgCell commentBtnIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"commentBtnIndexPath");
	QGNewTeacherStateModel * model = _teacherList[indexPath.row];
	_moment_id = model.myID;
	[self keyboardShow];
}
- (void)bigImgCell:(QGNewTeacherBigImgCell *)bigImgCell shareBtnIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"shareBtnIndexPath");
}
- (void)mulImgCell:(QGNewTeacherMulImgCell *)bigImgCell praiseBtnIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"praiseBtnIndexPath");
	
	QGNewTeacherStateModel * model = _teacherList[indexPath.row];
	if ([model.is_liked isEqualToString:@"0"]) {
		[bigImgCell.praiseBtn setImage:[UIImage imageNamed:@"ic_点赞_pr"] forState:UIControlStateNormal];
		bigImgCell.priseNum.text = [NSString stringWithFormat:@"%d",[model.likes_num intValue]+1];
	}else
	{
		[bigImgCell.praiseBtn setImage:[UIImage imageNamed:@"ic_点赞"] forState:UIControlStateNormal];
		bigImgCell.priseNum.text = [NSString stringWithFormat:@"%d",[model.likes_num intValue]-1];
	}
	[self requestLikeDataWithTeacher:model];

}
- (void)mulImgCell:(QGNewTeacherMulImgCell *)bigImgCell commentBtnIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"commentBtnIndexPath");
	QGNewTeacherStateModel * model = _teacherList[indexPath.row];
	_moment_id = model.myID;
	[self keyboardShow];
}
- (void)mulImgCell:(QGNewTeacherMulImgCell *)bigImgCell shareBtnIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"shareBtnIndexPath");
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat tableHeaderViewHeight = CGRectGetHeight(self.tableView.tableHeaderView.bounds);
//    // 修改导航栏透明度
    self.navView.alpha = offsetY / tableHeaderViewHeight;
    // 修改组头悬停位置
    if (offsetY >= tableHeaderViewHeight) {
        // 留出导航栏的位置
        self.tableView.contentInset = UIEdgeInsetsMake(Height_TapBar, 0, 0, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
	
    [scrollView zf_scrollViewDidScroll];

}


#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
	QGNewTeacherStateModel * model = _teacherList[indexPath.row];
//	[self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/27089192_abcedcf00b503195b7d09f2c91814ef2_3.mp4"] scrollToTop:scrollToTop];
	if (model.resources.count>0) {
		[self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:model.resources[0]] scrollToTop:scrollToTop];
	}
    [self.controlView showTitle:model.title
                 coverURLString:model.cover_img
                 fullScreenMode:ZFFullScreenModePortrait];
}

- (BOOL)shouldAutorotate {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate 列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [scrollView zf_scrollViewDidScroll];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.prepareShowLoading = YES;
    }
    return _controlView;
}



#pragma mark getData
- (void)p_loadTeacherListData:(NSInteger)type
{
	if (type == 0) {
		_teacherList = [NSMutableArray array];
	}else
	{
		
	}
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"page_size":@"10",
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"teacher_id":_teacher_id,
		@"page":@(_mypage),
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"]
	};
	
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getMomentListByTeacherId",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
	//		NSLog(@"%@",responseObj);
			NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
			NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
			NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
			NSLog(@"%@",strda);
		NSMutableArray * resultArr = [NSMutableArray array];
		resultArr = [QGNewTeacherStateModel mj_objectArrayWithKeyValuesArray:responseObj[@"extra"][@"items"]];
	
		if (resultArr.count>0) {
			[_tableView showFooterView];
			
			for (QGNewTeacherStateModel * model in resultArr) {
				if ([model.resource_type intValue]==1) {

					if (model.resources.count<4&&model.resources.count>0) {
						model.cellHeight = 282;
						model.collectionHeight = 111;

					}else if (model.resources.count<7)
					{
						model.cellHeight = 282+10+111;
						model.collectionHeight = 111*2+20;

					}else
					{
						model.cellHeight = 282+(10+111)*2;
						model.collectionHeight = 111*3+30;
					}
				}else
				{
					
				}
				
				[_teacherList addObject:model];
			}
		}else
		{
//			[_tableView hiddenFooterView];
		}
		[_tableView endRrefresh];
		[_tableView reloadData];
		} failure:^(NSError *error) {
			NSLog(@"%@",error);
		}];
}

- (void)p_loadLessonData:(NSInteger)type
{
	if (type == 0) {
		_courseList = [NSMutableArray array];
	}else
	{
		
	}
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"page_size":@"10",
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"teacher_id":_teacher_id,
		@"page":@(_mypage),
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"]
	};
	
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getCourseListByTeacherId",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
	//		NSLog(@"%@",responseObj);
			NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
			NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
			NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
			NSLog(@"%@",strda);
		NSMutableArray * resultArr = [NSMutableArray array];
		resultArr = [QGNewTeacherLessonModel mj_objectArrayWithKeyValuesArray:responseObj[@"extra"][@"items"]];
			
		if (resultArr.count>0) {
			[_tableView showFooterView];
			for (QGNewTeacherLessonModel * model in resultArr) {
				[_courseList addObject:model];
			}
		}
		[_tableView endRrefresh];
		[_tableView reloadData];
		} failure:^(NSError *error) {
			NSLog(@"%@",error);
			[_tableView endRrefresh];
		}];
}

- (void)p_loadOrgnizationData:(NSInteger)type
{
	_orgizationList = [NSMutableArray array];

	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"teacher_id":_teacher_id,
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"]
	};
	
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getTeacherInfo",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		//		NSLog(@"%@",responseObj);
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		
		NSMutableArray * resultArr = [NSMutableArray array];
		NSDictionary * resultDic = responseObj[@"extra"];
		[self p_headViewDataWithDict:resultDic];
		NSDictionary * dict1 = @{
			@"iconImgName":@"ic_简介",
			@"title":@"简介",
			@"content":resultDic[@"signature"],
			@"intelegencyImg":@"",
			@"orgImg":@"ios",
			@"orgName":@"ios",
			@"orgLocation":@"ios",
			@"orgLangauage":@"ios",
			@"introType":@"1",
		};

		NSDictionary * dict2 = @{
			@"iconImgName":@"ic_教育",
			@"title":@"教学资质",
			@"content":resultDic[@"signature"],
			@"intelegencyImg":resultDic[@"org_head_img"],
			@"orgImg":@"ios",
			@"orgName":@"ios",
			@"orgLocation":@"ios",
			@"orgLangauage":@"ios",
			@"introType":@"2",
		};
		NSDictionary * dict3 = @{
			@"iconImgName":@"ic_个人简介",
			@"title":@"个人介绍",
			@"content":resultDic[@"intro"],
			@"intelegencyImg":@"",
			@"orgImg":@"ios",
			@"orgName":@"ios",
			@"orgLocation":@"ios",
			@"orgLangauage":@"ios",
			@"introType":@"1",
		};
//		NSArray * shareArr = resultDic[@"share"];
//		if (shareArr.count>0) {
//			for (NSDictionary * dic in shareArr) {
//				shareStr = [NSString stringWithFormat:@"%@\n",dic[@"content"]];
//			}
//		}
//		if (shareStr.length>1==NO) {
//			shareStr = @"暂无分享~";
//		}
		NSString * shareStr ;
		shareStr = resultDic[@"share"];
		if (shareStr.length<=0) {
			shareStr = @"这个人很懒，暂未填写分享~";
		}

		NSDictionary * dict4 = @{
			@"iconImgName":@"ic_简介",
			@"title":@"成果分享",
			@"content":shareStr,
			@"intelegencyImg":@"",
			@"orgImg":@"ios",
			@"orgName":@"ios",
			@"orgLocation":@"ios",
			@"orgLangauage":@"ios",
			@"introType":@"1",
		};
		NSDictionary * dict5 = @{
			@"iconImgName":@"ic_机构",
			@"title":@"所属机构",
			@"content":resultDic[@"signature"],
			@"intelegencyImg":@"",
			@"orgImg":resultDic[@"org_head_img"],
			@"orgName":resultDic[@"org_name"],
			@"orgLocation":[NSString stringWithFormat:@"%@%@",resultDic[@"org_provice"],resultDic[@"org_city"]],
			@"orgLangauage":resultDic[@"org_signature"],
			@"introType":@"3",
		};
		[resultArr addObject:dict1];
		[resultArr addObject:dict2];
		[resultArr addObject:dict3];
		[resultArr addObject:dict4];
		[resultArr addObject:dict5];
		_orgizationList = [QGNewteacherInfoModel mj_objectArrayWithKeyValuesArray:resultArr];
			
		[_tableView reloadData];
		[_tableView endRrefresh];
	} failure:^(NSError *error) {
			NSLog(@"%@",error);
		
	}];
}
- (void)p_headViewDataWithDict:(NSDictionary *)dict
{
	_service_id = dict[@"service_id"];
	_is_self = [dict[@"is_self"] integerValue];
	[_coverImg sd_setImageWithURL:[NSURL URLWithString:dict[@"bg_img"]] placeholderImage:[UIImage imageNamed:@""]];
	[_portraitImg sd_setImageWithURL:[NSURL URLWithString:dict[@"head_img"]] placeholderImage:[UIImage imageNamed:@""]];
	
	_videoUrl = dict[@"video"];
	if (_videoUrl.length>0) {
		_playBtn.hidden = NO;
		
	}else
	{
		_playBtn.hidden = YES;
	}
	if ([dict[@"sex"] intValue]==1) {//女
		_sexImg.image = [UIImage imageNamed:@"ic_女"];
	}else
	{
		_sexImg.image = [UIImage imageNamed:@"ic_男"];
	}
	_nameLab.text = dict[@"name"];
	if ([dict[@"is_followed"] intValue]==1) {
		[_concernBtn setTitle:@"已关注" forState:UIControlStateNormal];
		_is_followed = NO;
	}else
	{
		[_concernBtn setTitle:@"关注" forState:UIControlStateNormal];
		_is_followed = YES;
	}
	
	NSMutableAttributedString * Str1 = [self attributedStringWithString:[NSString stringWithFormat:@"%@ %@",dict[@"fans_num"],@"粉丝"]];
    _fansLab.attributedText = Str1;
	
	NSMutableAttributedString * Str2 = [self attributedStringWithString:[NSString stringWithFormat:@"%@ %@",dict[@"teacher_experience"],@"年龄"]];
	_ageLab.attributedText = Str2;

	NSMutableAttributedString * Str3 = [self attributedStringWithString:[NSString stringWithFormat:@"%@ %@",dict[@"moment_num"],@"动态"]];
	_stateLab.attributedText = Str3;

}
- (void)requestLikeDataWithTeacher:(QGNewTeacherStateModel *)model
{
	NSInteger like = 0;
	if ([model.is_liked isEqualToString:@"1"]) {
		like = 0;
	}else
	{
		like = 1;
	}
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"moment_id":@([model.myID intValue]),
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"is_like":@(like),
	};
	[QGHttpManager post: [NSString stringWithFormat:@"%@/Phone/Edu/setMomentLike",QQG_BASE_APIURLString]params:param success:^(id responseObj) {
		NLog(@"%@",responseObj);
		if ([model.is_liked isEqualToString:@"0"]) {
			model.is_liked = @"1";
			model.likes_num = [NSString stringWithFormat:@"%d",[model.likes_num intValue]+1];
		}else
		{
			model.is_liked = @"0";
			model.likes_num = [NSString stringWithFormat:@"%d",[model.likes_num intValue]-1];
		}
	} failure:^(NSError *error) {
		NLog(@"%@",error);

	}];
}
- (void)sendCommentDataWithString:(NSString *)commentStr
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"moment_id":@([_moment_id intValue]),
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"content":commentStr,
	};
	[QGHttpManager post: [NSString stringWithFormat:@"%@/Phone/Edu/addMomentComment",QQG_BASE_APIURLString]params:param success:^(id responseObj) {
		NLog(@"%@",responseObj);
		
//    [[SAProgressHud sharedInstance] showSuccessWithWindow:@"发送成功"];
		[self showTopIndicatorWithSuccessMessage:@"发送成功"];
	} failure:^(NSError *error) {
		NLog(@"%@",error);
	}];
}

#pragma mark 上传视频照片
- (void)uploadAlbumWithImage:(UIImage *)image
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"teacher_id":_teacher_id,
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
	};
    [[QGHttpManager sharedManager] POST:[NSString stringWithFormat:@"%@/Phone/Edu/updateTeacherCover",QQG_BASE_APIURLString] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
            NSData *fileData = UIImageJPEGRepresentation(image, BLUApiImageCompressionQuality);
            NSString *name = @"bg_img";
            NSString *filename = @"image0.jpg";
            NSString *mimeType = @"image/jpeg";
            [formData appendPartWithFileData:fileData name:name fileName:filename mimeType:mimeType];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
		[self p_loadOrgnizationData:0];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"%@",error);

	}];
}

- (void)uploadVideoWithVideoUrl:(NSURL *)videoUrl
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"teacher_id":_teacher_id,
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
	};

	[QGHttpManager POST:[NSString stringWithFormat:@"%@/Phone/Edu/updateTeacherCover",QQG_BASE_APIURLString] params:param video:videoUrl success:^(NSURLSessionDataTask *task, id responseObject) {
		[self showTopIndicatorWithSuccessMessage:@"请选择一张图片作为封面上传!"];

		[self addCoverImg];
//		[self p_loadOrgnizationData:0];
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		NSLog(@"%@",error);

	}];
}

/*
 *  @param aString aString description
 *
 *  @return return value description
 */
- (NSMutableAttributedString *)attributedStringWithString:(NSString *)aString
{
    //数字放大处理
    NSArray * arr = [aString componentsSeparatedByString:@" "];
    NSString * aString1 = arr[0];
    NSString * aString2 = arr[1];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: aString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, aString1.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"666666"] range:NSMakeRange(aString1.length, aString2.length+1)];
    [attributedString addAttribute:NSFontAttributeName value:FONT_CUSTOM(18) range:NSMakeRange(0, aString1.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(aString1.length, aString2.length+1)];
    return attributedString;
}

- (void)keyboardShow
{
	[self showXHInputViewWithStyle:InputViewStyleLarge];//显示样式二
}
-(void)showXHInputViewWithStyle:(InputViewStyle)style{
	
	PL_CODE_WEAK(weakSelf);
	
	[CRIKeyboardView showWithStyle:style configurationBlock:^(CRIKeyboardView *inputView) {
		/** 代理 */
		inputView.delegate = self;
		inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
	} sendBlock:^BOOL(NSString *text) {
		if(text.length){
			NSLog(@"输入的信息为:%@",text);
			[weakSelf sendCommentDataWithString:text];
			return YES;//return YES,收起键盘
		}else{
			NSLog(@"显示提示框-请输入要评论的的内容");
			return NO;//return NO,不收键盘
		}
		
	} cancleBlock:^BOOL{
		return YES;
	}];
}


#pragma mark 相机
//触发事件：拍照
- (void)addCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //可编辑
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //摄像头
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum:相机胶卷
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else { //否则打开照片库
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备不支持相机功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

    }
    [self presentViewController:picker animated:YES completion:nil];
}
//触发事件：相册
- (void)addPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //可编辑
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //摄像头
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum:相机胶卷
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie,nil];

    } else { //否则打开照片库
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备不支持相机功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    [self presentViewController:picker animated:YES completion:nil];
}

//触发事件：录像
- (void)addVideo
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium; //录像质量
        picker.videoMaximumDuration = 60.0f; //录像最长时间
        picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备不支持录像功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    //跳转到拍摄页面
    [self presentViewController:picker animated:YES completion:nil];
}

//触发事件：相册
- (void)addCoverImg
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //可编辑
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else { //否则打开照片库
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备不支持相机功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

 //拍摄完成后要执行的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([mediaType isEqualToString:@"public.image"]) {
        //得到照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //图片存入相册
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
		[self uploadAlbumWithImage:image];
    } else if ([mediaType isEqualToString:@"public.movie"]) {
        NSString *videoPath = [QGFilePath getSavePathWithFileSuffix:@"mov"];
        success = [fileManager fileExistsAtPath:videoPath];
        if (success) {
            [fileManager removeItemAtPath:videoPath error:nil];
        }
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
		NSLog(@"media 写入成功,video路径:%@",videoURL);
		[self uploadVideoWithVideoUrl:videoURL];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
