//
//  QGTeacherWaitController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/19.
//

#import "QGTeacherWaitController.h"
#import "BLUChatViewController.h"
#import "QGNewTeacherStateModel.h"
#import "QGNewTeacherTextCell.h"
#import "QGNewTeacherMulImgCell.h"
#import "QGNewTeacherBigImgCell.h"
#import "CRIKeyboardView.h"

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

#import "QGTeacherRegisterController.h"
#import "QGTeacherPublishController.h"
#import "KKButton.h"
@interface QGTeacherWaitController ()<UITableViewDelegate,UITableViewDataSource,QGNewTeacherTextCellDelegate,QGNewTeacherMulImgCellDelegate,QGNewTeacherBigImgCellDelegate,keyboardInputViewDelegate>
@property (nonatomic,strong) SASRefreshTableView *tableView;
@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UIButton *messageBtn;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UIImageView *personImgView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *signBtn;
@property (nonatomic,strong) NSString *service_id;

@property (nonatomic,copy) NSString *moment_id;
@property (nonatomic, assign) NSInteger mypage;
@property (nonatomic,strong) NSMutableArray *teacherList;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic,strong) NSDictionary *teacherDic;//老师注册信息

@end

@implementation QGTeacherWaitController

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
	_mypage = 1;
	self.view.backgroundColor = [UIColor whiteColor];
	[self p_creatUI];
	[self initPlayer];

	[self p_loadTeacherData];
	[self p_loadTeacherListData:0];
	[self p_loadTeacherResgisterData];
}
- (void)p_creatUI
{
	[self add_viewUI];

	self.agreeBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(15, SCREEN_HEIGHT-40-20, SCREEN_WIDTH-30, 40);
		[tabBtn setTitle:@"发布动态" forState:UIControlStateNormal];
		[tabBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		[tabBtn setTitleColor:[UIColor colorFromHexString:@"E62C2A"] forState:UIControlStateNormal];
//		tabBtn.backgroundColor = [UIColor colorFromHexString:@"E62C2A"];
		tabBtn.layer.borderColor = [UIColor colorFromHexString:@"E62C2A"].CGColor;
		tabBtn.layer.borderWidth = 1.;
		tabBtn.layer.masksToBounds = YES;
		tabBtn.layer.cornerRadius = 20;
		[self.view addSubview:tabBtn];
		tabBtn;
	});
}
- (void)agreeBtnClick:(UIButton *)btn
{
	PL_CODE_WEAK(weakSelf);
	QGTeacherPublishController *vc = [[QGTeacherPublishController alloc]init];
	vc.modalPresentationStyle = UIModalPresentationFullScreen;
	vc.refreshBlock = ^{
		weakSelf.mypage=1;
		[weakSelf p_loadTeacherListData:0];
	};
	[self presentViewController:vc animated:NO completion:nil];
}

-(void)add_viewUI {
    if (_tableView==nil) {
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-60) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor =COLOR(242, 243, 244, 1);
        _tableView.backgroundColor =[UIColor whiteColor];
		_tableView.tableHeaderView = [self tableViewHeaderView];
//		_tableView.tableFooterView = [[UIView alloc]init];
		PL_CODE_WEAK(weakSelf);
		[_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
			weakSelf.mypage=1;
			[weakSelf p_loadTeacherListData:0];
		}];
		[_tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {
			[weakSelf loadMoreData];
		}];
		
		if (@available(iOS 11.0, *)) {
			_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		}
    }
	else {
        [_tableView reloadData];
    }
    [self.view addSubview:_tableView];

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

#pragma mark 头视图
- (UIView *)tableViewHeaderView
{
	UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170+Height_TopBar)];
//	headView.backgroundColor = COLOR(242, 243, 244, 1);
	headView.backgroundColor = [UIColor whiteColor];
	
	UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, Height_TopBar+70)];
	img1.image = [UIImage imageNamed:@"img_bg"];
	img1.userInteractionEnabled = YES;
	[headView addSubview:img1];

	PL_CODE_WEAK(weakSelf);
	UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBtn setImage:[UIImage imageNamed:@"ic_返回"]];
	backBtn.frame = CGRectMake(20, 28+kTopEdgeHeight, 20, 20);
	[backBtn addClick:^(UIButton *button) {
		[weakSelf.navigationController popToRootViewControllerAnimated:NO];
	}];
	[headView addSubview:backBtn];
	
	self.messageBtn = ({
			UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			tabBtn.frame = CGRectMake(SCREEN_WIDTH-15-20, 28+kTopEdgeHeight, 20, 20);
			[tabBtn setBackgroundImage:[UIImage imageNamed:@"ic_新留言"]];
			[tabBtn addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
			[headView addSubview:tabBtn];
			tabBtn;
		});

//	self.messageLabel = ({
//		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-15,_messageBtn.top-7,15,15)];
//		label.font = FONT_SYSTEM(10);
//		label.text = @"3";
//		label.textColor = [UIColor colorFromHexString:@"E62C2A"];
//		label.layer.masksToBounds = YES;
//		label.layer.cornerRadius = 15/2;
//		label.adjustsFontSizeToFitWidth = YES;
//		label.backgroundColor = [UIColor whiteColor];
//		label.textAlignment = NSTextAlignmentCenter;
//		[headView addSubview:label];
//		label;
//	});

	UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(15, _messageBtn.bottom+15, SCREEN_WIDTH-30, 100)];
	bgView.backgroundColor = [UIColor whiteColor];
	bgView.layer.masksToBounds = YES;
	bgView.layer.cornerRadius = 10;
	// 阴影颜色
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    // 阴影偏移，默认(0, -3)
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    bgView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    bgView.layer.shadowRadius = 5;
	[headView addSubview:bgView];

		self.personImgView = ({
			UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
			img1.image = [UIImage imageNamed:@"未登录头像"];
			img1.layer.masksToBounds = YES;
			img1.layer.cornerRadius = 60/2;
			img1.userInteractionEnabled = YES;
			[bgView addSubview:img1];
			img1;
		});
		
		self.nameLabel = ({
			UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_personImgView.right+15,15, 120, 60)];
			label.font = FONT_SYSTEM(18);
			label.text = @"Lida1110";
			label.textColor = [UIColor colorFromHexString:@"333333"];
			label.adjustsFontSizeToFitWidth = YES;
	//		label.backgroundColor = [UIColor redColor];
			label.textAlignment = NSTextAlignmentLeft;
			[bgView addSubview:label];
			label;
		});

		self.loginBtn = ({
			UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			tabBtn.frame = _nameLabel.frame;
			[tabBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
	//		tabBtn.backgroundColor = [UIColor redColor];
			[bgView addSubview:tabBtn];
			tabBtn;
		});

	
	self.signBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(bgView.width-15-100, (60-24)/2+15, 100, 24);
		[tabBtn addTarget:self action:@selector(signClick:) forControlEvents:UIControlEventTouchUpInside];
		tabBtn.layer.masksToBounds = YES;
		tabBtn.layer.cornerRadius = 12;
		tabBtn.layer.borderWidth = 1;
		[tabBtn setTitle:@"资料认证" forState:UIControlStateNormal];
		[tabBtn setTitleColor:[UIColor colorFromHexString:@"E62C2A"] forState:UIControlStateNormal];
		tabBtn.titleLabel.font = FONT_CUSTOM(12);
		tabBtn.layer.borderColor = [UIColor colorFromHexString:@"E62C2A"].CGColor;
		[bgView addSubview:tabBtn];
		tabBtn;
	});
	
	UIView * cellView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.bottom, SCREEN_WIDTH, 50)];
	cellView.backgroundColor = [UIColor whiteColor];
	[headView addSubview:cellView];
	
	UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(15, (50-24)/2, 24, 24)];
	img.image = [UIImage imageNamed:@"ic_我是学生"];
	[cellView addSubview:img];

	UIImageView * arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-24, (50-12)/2, 12, 14)];
	arrowImg.image = [UIImage imageNamed:@"ic_更多"];
	[cellView addSubview:arrowImg];

	UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(img.right+15,0, 120, 50)];
	label.font = FONT_SYSTEM(16);
	label.text = @"我是学生";
	label.textColor = [UIColor colorFromHexString:@"333333"];
	label.textAlignment = NSTextAlignmentLeft;
	[cellView addSubview:label];

	UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	tabBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
	[tabBtn addTarget:self action:@selector(studentClick:) forControlEvents:UIControlEventTouchUpInside];
	[cellView addSubview:tabBtn];
	
	return headView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _teacherList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
		
//		KKButton * tabBtn = [KKButton buttonWithType:UIButtonTypeCustom];
//		tabBtn.frame = CGRectMake(SCREEN_WIDTH - 15-40, cell.praiseBtn.top, 40, 20);
////		[tabBtn setImage:[UIImage imageNamed:@"ic_点赞"] forState:UIControlStateNormal];
//		[tabBtn setTitle:@"删除" forState:UIControlStateNormal];
//		[tabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//		[tabBtn addTarget:self action:@selector(delectClick:) forControlEvents:UIControlEventTouchUpInside];
//		tabBtn.indexPath = indexPath;
//		[cell.contentView addSubview:tabBtn];

		return cell;
	}
}
//- (void)delectClick:(KKButton *)btn
//{
//	[_teacherList removeObjectAtIndex:btn.indexPath.row];
//	[_tableView deleteRowsAtIndexPaths:@[btn.indexPath] withRowAnimation:UITableViewRowAnimationNone];
//
//}
#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	NLog(@"点击--%ld",indexPath.row);
}

#pragma mark -- 删除item
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	QGNewTeacherStateModel * model = _teacherList[indexPath.row];
	[_teacherList removeObjectAtIndex:indexPath.row];
	[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
	[self deleteData:model];
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

- (void)messageClick:(UIButton *)btn
{
    BLUChatViewController *vc = [[BLUChatViewController alloc]
									 initWithUserID:_service_id.integerValue];
	[self.navigationController pushViewController:vc animated:YES];
}
- (void)loginClick:(UIButton *)btn
{

}
- (void)signClick:(UIButton *)btn
{
	QGTeacherRegisterController * vc = [[QGTeacherRegisterController alloc]init];
	vc.teacherDic = _teacherDic;
	[self.navigationController pushViewController:vc animated:NO];
	
}
- (void)studentClick:(UIButton *)btn
{
	[self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)loadMoreData
{
	_mypage++;
	[self p_loadTeacherListData:1];
}
- (void)p_loadTeacherData
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"teacher_id":@([BLUAppManager sharedManager].currentUser.teacher_id)
	};
	
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getTeacherInfo",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		//		NSLog(@"%@",responseObj);
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);		
		NSDictionary * resultDic = responseObj[@"extra"];
		[self p_headViewDataWithDict:resultDic];
			
		[_tableView reloadData];
		[_tableView endRrefresh];
	} failure:^(NSError *error) {
			NSLog(@"%@",error);
		
	}];
}
- (void)p_headViewDataWithDict:(NSDictionary *)dict
{
	_service_id = dict[@"service_id"];
	[_personImgView sd_setImageWithURL:[NSURL URLWithString:dict[@"head_img"]] placeholderImage:[UIImage imageNamed:@"未登录头像"]];
	_nameLabel.text = dict[@"name"];
}

#pragma mark 获取老师动态列表
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
		@"teacher_id":@([BLUAppManager sharedManager].currentUser.teacher_id),
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

#pragma mark 获取老师注册信息
- (void)p_loadTeacherResgisterData
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"teacher_id":@([BLUAppManager sharedManager].currentUser.teacher_id),
	};
	
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getTeacherRegisterInfo",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		
		NSDictionary * teacherDic = responseObj[@"extra"][@"info"];
		_teacherDic = teacherDic;
		
		if ([_teacherDic[@"status"] isEqualToString:@"1"]) {
			[_signBtn setTitle:@"修改资料" forState:UIControlStateNormal];
		}else
		{
			[_signBtn setTitle:@"资料认证" forState:UIControlStateNormal];
		}
		} failure:^(NSError *error) {
			NSLog(@"%@",error);
		}];
}

- (void)deleteData:(QGNewTeacherStateModel *)model
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"moment_id":@([model.myID intValue]),
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"is_like":@([model.myID intValue]),
	};
	[QGHttpManager post: [NSString stringWithFormat:@"%@/Phone/Edu/deleteMoment",QQG_BASE_APIURLString]params:param success:^(id responseObj) {
		NLog(@"%@",responseObj);
		
	} failure:^(NSError *error) {
		NLog(@"%@",error);

	}];
}




#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
	QGNewTeacherStateModel * model = _teacherList[indexPath.row];
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
