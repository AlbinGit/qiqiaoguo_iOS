//
//  QGDouYinController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/17.
//

#import "QGDouYinController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "QGDouYinCell.h"
#import "ZFDouYinControlView.h"
#import "QGNewTeacherStateModel.h"

static NSString *kIdentifier = @"kIdentifier";

@interface QGDouYinController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFDouYinControlView *controlView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic,strong) QGNewTeacherStateModel *lastModel;
@property (nonatomic,strong) QGNewTeacherStateModel *currentModel;
@property (nonatomic,strong) QGNewTeacherStateModel *nextModel;

@end

@implementation QGDouYinController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backBtn];
    [self requestData];
    
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.tableView.mj_header = header;

    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];

    /// player,tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.assetURLs = self.urls;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
    self.player.controlView = self.controlView;
    self.player.allowOrentitaionRotation = NO;
    self.player.WWANAutoPlay = YES;
	self.player.stopWhileNotVisible = YES;
    /// 1.0是完全消失时候
    self.player.playerDisapperaPercent = 1.0;
    
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
    
    self.player.presentationSizeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, CGSize size) {
        @strongify(self)
        if (size.width >= size.height) {
            self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
        } else {
            self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
        }
    };
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backBtn.frame = CGRectMake(15, CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame), 36, 36);
}

//- (void)loadNewData {
//    [self.dataSource removeAllObjects];
//    [self.urls removeAllObjects];
//    @weakify(self)
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        /// 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
//        [self.player stopCurrentPlayingCell];
//        [self requestData];
//        [self.tableView reloadData];
//        /// 找到可以播放的视频并播放
//        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
//            @strongify(self)
//            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
//        }];
//    });
//}

//- (void)requestData {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//
//    NSArray *videoList = [rootDict objectForKey:@"list"];
//    for (NSDictionary *dataDic in videoList) {
//        ZFTableData *data = [[ZFTableData alloc] init];
//        [data setValuesForKeysWithDictionary:dataDic];
//        [self.dataSource addObject:data];
//        NSString *URLString = [data.video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        NSURL *url = [NSURL URLWithString:URLString];
//        [self.urls addObject:url];
//    }
//    [self.tableView.mj_header endRefreshing];
//}
//- (void)browseTimeData
//{
//	
//}
- (void)requestData {
	[_dataSource removeAllObjects];
	[self.urls removeAllObjects];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"moment_id":@([_moment_id intValue]),
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getMomentInfo",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		_lastModel = [[QGNewTeacherStateModel alloc]init];
		_currentModel = [[QGNewTeacherStateModel alloc]init];
		_nextModel = [[QGNewTeacherStateModel alloc]init];
		_lastModel =	[QGNewTeacherStateModel mj_objectWithKeyValues:responseObj[@"extra"][@"prev_info"]];
		_currentModel =	[QGNewTeacherStateModel mj_objectWithKeyValues:responseObj[@"extra"][@"curr_info"]];
		_nextModel =	[QGNewTeacherStateModel mj_objectWithKeyValues:responseObj[@"extra"][@"next_info"]];
		
		if (_lastModel.resources.count>0) {
			[self.urls addObject:[NSURL URLWithString:_lastModel.resources[0]]];
		}else
		{
			[self.urls addObject:[NSURL URLWithString:@""]];
		}
		if (_currentModel.resources.count>0) {
			[self.urls addObject:[NSURL URLWithString:_currentModel.resources[0]]];
		}else
		{
			[self.urls addObject:[NSURL URLWithString:@""]];
			
		}
		if (_nextModel.resources.count>0) {
			[self.urls addObject:[NSURL URLWithString:_nextModel.resources[0]]];
		}else
		{
			[self.urls addObject:[NSURL URLWithString:@""]];
		}
		
		[self.dataSource addObject:_lastModel];
		[self.dataSource addObject:_currentModel];
		[self.dataSource addObject:_nextModel];

		self.player.assetURLs = self.urls;
		[self.tableView reloadData];
		[self.player stopCurrentPlayingCell];
		[self playTheIndex:1];

	} failure:^(NSError *error) {
		NSLog(@"%@",error);
	}];
}


- (void)playTheIndex:(NSInteger)index {
    @weakify(self)
    /// 指定到某一行播放
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
    /// 如果是最后一行，去请求新数据
    if (index == self.dataSource.count-1) {
        /// 加载下一页数据
    }
	if (index==0) {
		
	}
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGDouYinCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
//    cell.data = self.dataSource[indexPath.row];
	cell.model = _currentModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - private method

- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    [self.controlView resetControlView];
    [self.controlView showCoverViewWithUrl:_currentModel.cover_img withImageMode:UIViewContentModeScaleAspectFill];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
        [_tableView registerClass:[QGDouYinCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.frame = self.view.bounds;
        _tableView.rowHeight = _tableView.frame.size.height;
        _tableView.scrollsToTop = NO;
        
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if (self.player.playingIndexPath) return;
            if (indexPath.row == self.dataSource.count-1) {
                /// 加载下一页数据
				if (self.nextModel.myID.length>0) {
					self.moment_id = self.nextModel.myID;
					[self requestData];
				}
            }
            if (indexPath.row == 0) {
                /// 加载下一页数据
				if (self.lastModel.myID.length>0) {
					self.moment_id = self.lastModel.myID;
					[self requestData];
				}
            }
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
    }
    return _tableView;
}

- (ZFDouYinControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFDouYinControlView new];
    }
    return _controlView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (NSMutableArray *)urls {
    if (!_urls) {
        _urls = @[].mutableCopy;
    }
    return _urls;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"round-back-icon"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end