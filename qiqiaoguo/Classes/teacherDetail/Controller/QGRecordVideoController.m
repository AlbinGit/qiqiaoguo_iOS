//
//  QGRecordVideoController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/20.
//

#import "QGRecordVideoController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import "HLSegementView.h"
#import "QGRecordFieldCollectionCell.h"

#import "QGFileWebController.h"
#import "QGChatModel.h"
#import "QGChatCell.h"
static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

static const CGFloat kLineSpaceing = 15;  // 行间距 横向
static const CGFloat kItermSpaceing = 15;  // 列间距 纵向之间的间距

@interface QGRecordVideoController ()<HLSegementViewDelegate,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;
@property (nonatomic,strong) HLSegementView *segmentView;
@property (nonatomic,strong)UIScrollView*scrollView;
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)SASRefreshTableView * tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation QGRecordVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self p_creatUI];
	[self initPlayer];
	[self gotoLiveRoomChatData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.player.viewControllerDisappear = NO;

}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:YES];
    self.player.viewControllerDisappear = YES;
	
//	NSDate * currentDate = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]/1000.0];
//	NSString * formDateStr = [formatter stringFromDate:currentDate];

	[self browseTimeDataWithTime:self.player.currentTime andFinsh:1];


}
- (void)initPlayer
{
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    
	self.player.WWANAutoPlay = YES;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
        [self.player playTheNext];
        if (!self.player.isLastAssetURL) {
//            NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
            [self.controlView showTitle:self.model.title coverURLString:self.model.images fullScreenMode:ZFFullScreenModeLandscape];
        } else {
            [self.player stop];
			
			
			[self browseTimeDataWithTime:self.player.progress andFinsh:1];
        }
    };
    self.player.assetURLs = self.assetURLs;
	

}
- (void)p_creatUI {
	
	self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.playBtn];

	PL_CODE_WEAK(weakSelf);
	UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBtn setImage:[UIImage imageNamed:@"ic_返回"]];
	backBtn.frame = CGRectMake(10, kTopEdgeHeight+20, 44, 44);
	[backBtn addClick:^(UIButton *button) {
		[weakSelf.navigationController popToRootViewControllerAnimated:NO];
	}];
	[self.view addSubview:backBtn];
	
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = SCREEN_WIDTH;
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
		
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
	
	UIImageView * iconImg = [UIImageView new];
	[iconImg setImageWithURLString:_teacherImgUrl placeholder:[UIImage imageNamed:@"common-app-logo"]];
	iconImg.frame = CGRectMake(15, _containerView.bottom+20, 90, 60);
	[self.view addSubview:iconImg];
	
	UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+10, iconImg.top+10, SCREEN_WIDTH-90-30, 20)];
	titLab.text = _model.title;
	titLab.textAlignment = NSTextAlignmentLeft;
	titLab.font = FONT_CUSTOM(15);
	[self.view addSubview:titLab];
	
	UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+10, titLab.bottom+10, SCREEN_WIDTH-90-30, 20)];
	nameLab.text =_teacherName;
	nameLab.textAlignment = NSTextAlignmentLeft;
	nameLab.font = FONT_CUSTOM(12);
	nameLab.textColor = [UIColor colorFromHexString:@"666666"];
	[self.view addSubview:nameLab];
	
	NSArray * titlss = @[@"课件",@"聊天"];
	HLSegementView * segmentView = [[HLSegementView alloc] initWithFrame:CGRectMake(0, iconImg.bottom+10, SCREEN_WIDTH, 40) titles:titlss];
	segmentView.selectIndex = 0;
	segmentView.isShowUnderLine = YES;
	segmentView.delegate = self;
	_segmentView = segmentView;
	[self.view addSubview:segmentView];

	UIScrollView * scrollView = [[UIScrollView alloc]init];
	scrollView.frame = CGRectMake(0,_segmentView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-_segmentView.bottom);
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.bounces = NO;
	scrollView.backgroundColor =COLOR(242, 243, 244, 1);
    scrollView.pagingEnabled = YES;
	scrollView.directionalLockEnabled = YES;
	scrollView.delegate = self;
	if (@available(iOS 11.0, *)) {
		scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	} else {
	}
	scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
	[self.view addSubview:scrollView];
	_scrollView = scrollView;

	
	UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
	flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;//垂直
	[flowLayout setMinimumLineSpacing:kLineSpaceing];//行
	[flowLayout setMinimumInteritemSpacing:kItermSpaceing];//列
	[flowLayout setSectionInset:UIEdgeInsetsMake(kLineSpaceing, kLineSpaceing, kLineSpaceing, kLineSpaceing)];

	self.collectionView = ({
		UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, _scrollView.height) collectionViewLayout:flowLayout];
		collectionView.backgroundColor = COLOR(242, 243, 244, 1);
		//注册cell
		[collectionView registerClass:[QGRecordFieldCollectionCell class] forCellWithReuseIdentifier:@"QGRecordFieldCollectionCell"];
		collectionView.delegate = self;
		collectionView.dataSource = self;
		[_scrollView addSubview:collectionView];
		collectionView;
	});

	[self add_viewUI];
}
-(void)add_viewUI {
    if (_tableView==nil) {
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, _scrollView.height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =COLOR(242, 243, 244, 1);
		_tableView.tableFooterView.hidden = YES;
		PL_CODE_WEAK(ws);
//		[_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
//			ws.perPage = 1;
//			[ws p_loadAllStyudyData:0 andType:ws.currentIndex];
//		}];
//		[_tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {
//			ws.perPage++;
//			[ws p_loadAllStyudyData:1 andType:ws.currentIndex];
//		}];
    }else {
        [_tableView reloadData];
    }
    [_scrollView addSubview:_tableView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


#pragma mark tag  didSelectWithIndex
- (void)hl_didSelectWithIndex:(NSInteger)index{
	NLog(@"代理实现的方法%ld",index);
	
    //1. 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);

}

#pragma mark dataSource 数据源
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}
//Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
		
	return _model.fileList.count;
//	return 5;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return CGSizeMake((SCREEN_WIDTH-30-15)/2, 108);
}


//Item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	QGfileListModel * model = _model.fileList[indexPath.row];
//	QGfileListModel * model = _model.fileList[0];
	QGRecordFieldCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QGRecordFieldCollectionCell" forIndexPath:indexPath];
	cell.titleLabel.text = model.file_name;
	return cell;
	
}
//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"点击了item %ld",indexPath.row)
	QGfileListModel * model = _model.fileList[indexPath.row];
	QGFileWebController *vc = [[QGFileWebController alloc]init];
	vc.filePDFUrl = model.url;
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	 QGChatCell * cell=[tableView dequeueReusableCellWithIdentifier:@"CELL"];
	   if (cell==nil) {
		   cell=[[QGChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
	   }
	cell.model = self.dataArray[indexPath.row];
	return cell;
}
#pragma make - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	  
	UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}




#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //1. 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
	_segmentView.selectIndex = index;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = YES;
    }
    return _controlView;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        [_containerView setImageWithURLString:_model.images placeholder:[ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)]];
		_containerView.backgroundColor = [UIColor redColor];
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"play-video"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    [self.controlView showTitle:_model.title coverURLString:_model.images fullScreenMode:ZFFullScreenModeAutomatic];
}

- (NSArray<NSURL *> *)assetURLs {
    if (!_assetURLs) {
		NSString *URLString = [_model.video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
		_assetURLs = @[[NSURL URLWithString:URLString]];

    }
    return _assetURLs;
}


#pragma mark 聊天记录
- (void)gotoLiveRoomChatData
{
	_dataArray = [NSMutableArray array];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"section_id":@([_model.myID intValue]),//课节id
		@"page":@"",
		@"pageSize":@(10000),
			
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Live/getChatRecordList",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		NSDictionary * resultDic = responseObj[@"extra"];
		
		
//		NSArray * arr = @[
//		@{
//			@"nickName": @"dd",   //昵称
//			@"avatar": @"http://t.api.qiqiaoguo.com//Public/Uploads/User/50/2020/0526/5eccc6efce7b2.jpg", //头像
//			@"role": @"3",        //角色（1老师 2助教 3学生）
//			@"content": @"发解放路健身房房间爱了看见fa就发了开发可垃圾分类科技风科技房间爱了看见山大路口附近房间爱了放假拉开的芳姐 ",  //聊天内容
//			@"logTime": @"2020-06-09 15:34:25",  //聊天时间
//			@"uid": @"100793",
//			@"uuid": @"10"
//		},
//		@{
//			@"nickName": @"dzer",
//			@"avatar": @"http://t.api.qiqiaoguo.com//Public/Uploads/User/50/2020/0526/5eccc6efce7b2.jpg",
//			@"role": @"1",
//			@"content": @"[ok]",
//			@"logTime": @"2020-06-09 15:15:22",
//			@"uid": @"100788",
//			@"uuid": @"18581855415"
//		},
//		];
		
//		_dataArray = [QGChatModel mj_objectArrayWithKeyValuesArray:arr];

		_dataArray = [QGChatModel mj_objectArrayWithKeyValuesArray:resultDic[@"list"]];
		
		[_tableView reloadData];
	}
		failure:^(NSError *error) {
		NSLog(@"%@",error);
	}];

}
- (void)browseTimeDataWithTime:(NSTimeInterval)time andFinsh:(int)finsh
{
	int timeP = time;
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
//		@"teacher_id":@([BLUAppManager sharedManager].currentUser.teacher_id),
		@"course_id":@(_course_id),
		@"course_section_id":@([_model.myID intValue]),
		@"view_time":@(timeP),
		@"is_finish":@(finsh),
	};

	[[QGHttpManager sharedManager] POST:[NSString stringWithFormat:@"%@/Phone/Edu/courseStudyTime",QQG_BASE_APIURLString] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"%@",responseObject);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"%@",error);

	}];
}
@end
