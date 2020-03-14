//
//  BLUCircleDetailViewController.m
//  Blue
//
//  Created by Bowen on 8/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircleDetailViewController.h"
#import "BLUCircleBriefCell.h"
#import "BLUCircle.h"
#import "BLUPostViewModel.h"
#import "BLUPost.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUSendPostViewController.h"
#import "BLUCircleActionDelegate.h"
#import "BLUUserTransitionDelegate.h"
#import "BLUPostCommonOptCell.h"
#import "BLUCircleViewModel.h"
#import "BLURemoteNotification.h"
#import "BLUApiManager+Circle.h"
#import "BLUCircleMO.h"

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionBrief = 0,
    TableViewSectionPost,
    TableViewSectionCount,
};

typedef NS_ENUM(NSInteger, TableViewType) {
    TableViewTypeAll = 0,
    TableViewTypeFresh,
    TableViewTypeEssential,
    TableViewTypeCount,
};

@interface BLUCircleDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, BLUSendPostViewControllerProtocal>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BLUTableView *allPostTableView;
@property (nonatomic, strong) BLUTableView *freshPostTableView;
@property (nonatomic, strong) BLUTableView *essentialPostTableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) BLUPostViewModel *allPostViewModel;
@property (nonatomic, strong) BLUPostViewModel *freshPostViewModel;
@property (nonatomic, strong) BLUPostViewModel *essentialPostViewModel;
@property (nonatomic, strong) BLUCircleActionDelegate *circleAction;
@property (nonatomic, strong) BLUUserTransitionDelegate *userTransition;

@property (nonatomic, strong) BLUCircleViewModel *circleViewModel;

@property (nonatomic, assign) NSInteger lastLoadIndex;

@end

@implementation BLUCircleDetailViewController

#pragma mark - Life Circle

- (instancetype)initWithCircle:(BLUCircle *)circle {
    if (self = [super init]) {
        _circle = circle;
        _circleID = circle.circleID;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype)initWithCircleID:(NSInteger)circleID {
    if (self = [super init]) {
        _circleID = circleID;
        _circle = nil;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
  
    // Segmented Control
    NSString *allString = NSLocalizedString(@"circle.segmented-control.all", @"All");
    NSString *newString = NSLocalizedString(@"circle.segmented-control.new", @"New");
    NSString *featureString = NSLocalizedString(@"circle.segmented-control.feature", @"Feature");
    NSArray *segmentTextContent = @[allString, newString, featureString];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    _segmentedControl.selectedSegmentIndex = TableViewTypeAll;
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _segmentedControl.frame = CGRectMake(0, 0, 240.0f, 26.0f);
    _segmentedControl.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = _segmentedControl;
    
    // ScrollView
    _scrollView = [UIScrollView new];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
   
    // Table View
    _allPostTableView = [self makeTableView];
    _freshPostTableView = [self makeTableView];
    _essentialPostTableView = [self makeTableView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Bar button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BLUCurrentTheme sendPostIcon] style:UIBarButtonItemStylePlain target:self action:@selector(sendPostAction:)];

    // Constraints
    [self addTiledLayoutConstrantForView:_scrollView];
    
    // Model
    RAC(self, allPostViewModel.circleID) = RACObserve(self, circleID);
    RAC(self, freshPostViewModel.circleID) = RACObserve(self, circleID);
    RAC(self, essentialPostViewModel.circleID) = RACObserve(self, circleID);
    RAC(self, circleViewModel.circleID) = RACObserve(self, circleID);
    
    self.lastLoadIndex = -1;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    
    [self configTableView:self.allPostTableView viewModel:self.allPostViewModel index:TableViewTypeAll];
    [self configTableView:self.freshPostTableView viewModel:self.freshPostViewModel index:TableViewTypeFresh];
    [self configTableView:self.essentialPostTableView viewModel:self.essentialPostViewModel index:TableViewTypeEssential];
   
    // Content size
    _scrollView.contentSize = CGSizeMake(_scrollView.width * 3, _allPostTableView.height);
    [_scrollView setContentOffset:CGPointMake(_scrollView.width * _segmentedControl.selectedSegmentIndex, 0) animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_segmentedControl addTarget:self action:@selector(changePageAction:) forControlEvents:UIControlEventValueChanged];
    _scrollView.delegate = self;
    [self configModelForTableView:self.allPostTableView viewModel:self.allPostViewModel];
    [self configModelForTableView:self.freshPostTableView viewModel:self.freshPostViewModel];
    [self configModelForTableView:self.essentialPostTableView viewModel:self.essentialPostViewModel];
}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    [self loadDataForTableView:[self currentTableView] viewModel:[self viewModelForTableView:[self currentTableView]] seletedIndex:self.segmentedControl.selectedSegmentIndex];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.circleViewModel.fetchDisposable dispose];
    [self.circleViewModel.fetchNextDisposable dispose];
    [self.allPostViewModel.fetchDisposable dispose];
    [self.allPostViewModel.fetchNextDisposable dispose];
    [self.freshPostViewModel.fetchDisposable dispose];
    [self.freshPostViewModel.fetchNextDisposable dispose];
    [self.essentialPostViewModel.fetchDisposable dispose];
    [self.essentialPostViewModel.fetchNextDisposable dispose];
    [self.view hideIndicator];
}

- (void)handleRemoteNotification:(NSNotification *)userInfo {
    BLURemoteNotification *remoteNotification = userInfo.object;
    if (remoteNotification.type != BLURemoteNotificationTypeCircle) {
        [super handleRemoteNotification:userInfo];
    }
}

- (void)willFollowCircle:(NSInteger)circleID {
    self.circle.didFollowCircle = YES;
    [[self currentTableView] reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionBrief] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didFollowCircle:(NSInteger)circleID error:(NSError *)error {
    if (error) {
        [self showAlertForError:error];
        self.circle.didFollowCircle = NO;
        [[self currentTableView] reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionBrief] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self updateSendPostState];
}

- (void)willUnfollowCircle:(NSInteger)circleID {
    self.circle.didFollowCircle = NO;
    [[self currentTableView] reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionBrief] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didUnfollowCircle:(NSInteger)circleID error:(NSError *)error {
    if (error) {
        [self showAlertForError:error];
        self.circle.didFollowCircle = YES;
        [[self currentTableView] reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionBrief] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self updateSendPostState];
}

- (BLUTableView *)makeTableView {
    BLUTableView *tableView = [[BLUTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[BLUCircleBriefCell class] forCellReuseIdentifier:NSStringFromClass([BLUCircleBriefCell class])];
    [tableView registerClass:[BLUPostCommonOptCell class] forCellReuseIdentifier:NSStringFromClass([BLUPostCommonOptCell class])];
    [self.scrollView addSubview:tableView];
    return tableView;
}

- (void)configTableView:(BLUTableView *)tableView viewModel:(BLUPostViewModel *)viewModel index:(NSInteger)index {
    // Frame
    CGRect tableViewFrame = CGRectMake(index * _scrollView.width, 0, _scrollView.width, _scrollView.height);
    tableView.frame = tableViewFrame;
    
    // Content Inset
    CGFloat topOffset = self.topLayoutGuide.length;
    CGFloat bottomOffset = self.bottomLayoutGuide.length;
    
    UIEdgeInsets tableViewContentInsets = UIEdgeInsetsMake(topOffset, 0, bottomOffset, 0);
    tableView.contentInset = tableViewContentInsets;
    
    // Scroll indicator insets
    tableView.scrollIndicatorInsets = tableViewContentInsets;
}

- (void)configModelForTableView:(BLUTableView *)tableView viewModel:(BLUPostViewModel *)viewModel {
    @weakify(tableView, viewModel, self);
    tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        
        @strongify(tableView, viewModel, self);
        [self.view hideIndicator];
        
        self.circleViewModel.fetchDisposable = [[self.circleViewModel fetch] subscribeNext:^(id x) {
            self.circle = self.circleViewModel.circle;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionBrief] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            viewModel.fetchDisposable = [[viewModel fetch] subscribeNext:^(id x) {
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionPost] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView.mj_header endRefreshing];
                [tableView.mj_footer endRefreshing];
            } error:^(NSError *error) {
                [tableView.mj_header endRefreshing];
                [tableView.mj_footer endRefreshing];
                [self showAlertForError:error];
            }];
            
        }];
    }];
    
    tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        @strongify(tableView, viewModel, self);
        [self.view hideIndicator];

        viewModel.fetchDisposable = [[viewModel fetchNext] subscribeNext:^(NSArray *posts) {
            [tableView reloadData];
            [self tableViewEndRefreshing:tableView noMoreData:posts.count == 0];
        } error:^(NSError *error) {
            [self tableViewEndRefreshing:tableView];
            [self showAlertForError:error];
        }];
    }];
}

#pragma mark - Segemnted Control Action

- (void)changePageAction:(UISegmentedControl *)control {
    NSInteger index = control.selectedSegmentIndex;
    if (control.selectedSegmentIndex < 0) {
        index = TableViewTypeAll;
    }
    if (control.selectedSegmentIndex >= 3) {
        index = TableViewTypeEssential;
    }
    [self loadDataForTableView:[self currentTableView] viewModel:[self viewModelForTableView:[self currentTableView]] seletedIndex:index];
    [_scrollView setContentOffset:CGPointMake(_scrollView.width * index, 0) animated:YES];
}

- (void)sendPostAction:(UIBarButtonItem *)barButton {
    BLUSendPostViewController *vc = [[BLUSendPostViewController alloc] initWithCircle:self.circleID];
    vc.delegate = self;
    BLUNavigationController *nav = [[BLUNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (BLUPostViewModel *)viewModelForTableView:(BLUTableView *)tableView {
    BLUPostViewModel *viewModel = nil;
    
    if (tableView == self.allPostTableView) {
        viewModel = self.allPostViewModel;
    } else if (tableView == self.freshPostTableView) {
        viewModel = self.freshPostViewModel;
    } else if (tableView == self.essentialPostTableView) {
        viewModel = self.essentialPostViewModel;
    } else {
        viewModel = nil;
    }
    
    return viewModel;
}

- (BLUTableView *)currentTableView {
    BLUTableView *tableView = nil;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case TableViewTypeAll: {
            tableView = self.allPostTableView;
        } break;
        case TableViewTypeFresh: {
            tableView = self.freshPostTableView;
        } break;
        case TableViewTypeEssential: {
            tableView = self.essentialPostTableView;
        } break;
        default: break;
    }
    return tableView;
}

#pragma mark - View Model

- (BLUPostViewModel *)allPostViewModel {
    if (_allPostViewModel == nil) {
        _allPostViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeForCircle];
    }
    return _allPostViewModel;
}

- (BLUPostViewModel *)freshPostViewModel {
    if (_freshPostViewModel == nil) {
        _freshPostViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeFresh];
    }
    return _freshPostViewModel;
}

- (BLUPostViewModel *)essentialPostViewModel {
    if (_essentialPostViewModel == nil) {
        _essentialPostViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeEssential];
    }
    return  _essentialPostViewModel;
}

- (BLUCircleActionDelegate *)circleAction {
    if (_circleAction == nil) {
        _circleAction = [BLUCircleActionDelegate new];
        _circleAction.viewController = self;
    }
    return _circleAction;
}

- (BLUUserTransitionDelegate *)userTransition {
    if (_userTransition == nil) {
        _userTransition = [BLUUserTransitionDelegate new];
        _userTransition.viewController = self;
    }
    return _userTransition;
}

- (void)loadDataForTableView:(BLUTableView *)tableView viewModel:(BLUPostViewModel *)viewModel seletedIndex:(NSInteger)seletedIndex{
    if (self.lastLoadIndex == seletedIndex) {
        return ;
    }
    
    self.lastLoadIndex = seletedIndex;
    
    BLULogInfo(@"load index = %@", @(seletedIndex));
    
    if (self.circle && viewModel.fetchCount > 0) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionBrief] withRowAnimation:UITableViewRowAnimationAutomatic];
        return ;
    }
    
    [self.view showIndicator];

    @weakify(self);
    void (^fetchPosts)() = ^() {
        if (viewModel.fetchCount == 0) {
            BLULogInfo(@"load posts");
            viewModel.fetchDisposable = [[viewModel fetch] subscribeNext:^(id x) {
                BLULogInfo(@"load posts success");
                @strongify(self);
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionPost] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.view hideIndicator];
            } error:^(NSError *error) {
                BLULogInfo(@"load posts error = %@", error);
                @strongify(self);
                [self showAlertForError:error];
                [self.view hideIndicator];
            }];
        } else {
            [self.view hideIndicator];
        }
    };
    
    if (self.circle == nil) {
        BLULogInfo(@"load circle");
        self.circleViewModel.fetchDisposable = [[[self circleViewModel] fetch] subscribeNext:^(id x) {
            BLULogInfo(@"load circle success");
            @strongify(self);
            self.circle = self.circleViewModel.circle;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionBrief] withRowAnimation:UITableViewRowAnimationAutomatic];
            fetchPosts();
        } error:^(NSError *error) {
            BLULogInfo(@"load circle error = %@", error);
            @strongify(self);
            [self showAlertForError:error];
            [self.view hideIndicator];
        }];
    } else {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionBrief] withRowAnimation:UITableViewRowAnimationAutomatic];
        fetchPosts();
    }
}

- (BLUCircleViewModel *)circleViewModel {
    if (_circleViewModel == nil) {
        _circleViewModel = [[BLUCircleViewModel alloc] initWithFetchCircleType:BLUFetchCircleTypeOne];
    }
    return _circleViewModel;
}

- (void)setCircle:(BLUCircle *)circle {
    _circle = circle;
    [self updateSendPostState];
}

- (void)updateSendPostState {

}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    
    BLUPostViewModel *viewModel = [self viewModelForTableView:(BLUTableView *)tableView];
   
    switch (section) {
        case TableViewSectionBrief: {
            count = self.circle ? 1 : 0;
        } break;
        case TableViewSectionPost: {
            count = viewModel.posts.count;
        } break;
        default: {
            count = 0;
        } break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    BLUPostViewModel *viewModel = [self viewModelForTableView:(BLUTableView *)tableView];
    
    switch (indexPath.section) {
        case TableViewSectionBrief: {
            BLUCircleBriefCell *briefCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUCircleBriefCell class]) forIndexPath:indexPath];
            [briefCell setModel:self.circle shouldShowSeparatorLine:NO shouldShowQuit:YES shouldShowUnreadPostCount:NO circleActionDelegate:self];
            cell = briefCell;
        } break;
        case TableViewSectionPost: {
            BLUPostCommonOptCell *postCell = (BLUPostCommonOptCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUPostCommonOptCell class]) forIndexPath:indexPath model:viewModel.posts[indexPath.row]];;
            postCell.userTransitionDelegate = self.userTransition;
            if (indexPath.row == viewModel.posts.count - 1) {
                postCell.showThickLine = NO;
            } else {
                postCell.showThickLine = YES;
            }
            cell = postCell;
        } break;
        default: {
            cell = nil;
        } break;
    }
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = tableView.width;
    CGSize size;
    
    BLUPostViewModel *viewModel = [self viewModelForTableView:(BLUTableView *)tableView];
    
    switch (indexPath.section) {
        case TableViewSectionBrief: {
            size = [(BLUTableView *)tableView sizeForCellWithCellClass:[BLUCircleBriefCell class] cacheByIndexPath:indexPath width:width model:self.circle];
        } break;
        case TableViewSectionPost: {
            size = [(BLUTableView *)tableView sizeForCellWithCellClass:[BLUPostCommonOptCell class] cacheByIndexPath:indexPath width:width configuration:^(BLUCell *cell) {
                BLUPostCommonOptCell *postCell = (BLUPostCommonOptCell *)cell;
                postCell.model = viewModel.posts[indexPath.row];
                if (indexPath.row == viewModel.posts.count - 1) {
                    postCell.showThickLine = NO;
                } else {
                    postCell.showThickLine = YES;
                }
            }];
        } break;
        default: {
            size = CGSizeZero;
        } break;
    }
    
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0;
    switch (section) {
        case TableViewSectionBrief: {
            if (self.circle) {
                height = [BLUCurrentTheme topMargin] * 4;
            } else {
                height = 0.0;
            }
        } break;
        default: {
            height = 0.0;
        } break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;

    switch (section) {
        case TableViewSectionBrief: {
            if (self.circle) {
                view = [UIView new];
                view.backgroundColor = BLUThemeSubTintBackgroundColor;
            }
        } break;
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableViewSectionPost) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        BLUPostViewModel *viewModel = [self viewModelForTableView:(BLUTableView *)tableView];
        BLUPost *post = viewModel.posts[indexPath.row];
        BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:post.postID];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat offset = self.scrollView.contentOffset.x;
        if (offset == self.scrollView.width * 2) {
            self.segmentedControl.selectedSegmentIndex = TableViewTypeEssential;
        } else if (offset == self.scrollView.width) {
            self.segmentedControl.selectedSegmentIndex = TableViewTypeFresh;
        } else if (offset == 0) {
            self.segmentedControl.selectedSegmentIndex = TableViewTypeAll;
        }
        [self loadDataForTableView:[self currentTableView] viewModel:[self viewModelForTableView:[self currentTableView]] seletedIndex:self.segmentedControl.selectedSegmentIndex];
    }
}

#pragma mark - BLUSendPostViewController.

- (void)didSendPost:(BLUPost *)post fromSendPostViewController:(BLUSendPostViewController *)sendPostViewController {
    [self showTopIndicatorWithSuccessMessage:NSLocalizedString(@"circle-detail-vc.send-post-success", @"Send post success")];
}

- (void)shouldShowUserProfit:(BLUUserProfit *)userProfit fromSendPostViewController:(BLUSendPostViewController *)sendPostViewController {
    [self showUserRewardPromptIndicatorWithUserProfit:userProfit];
}

#pragma mark - BLUCircleAction.

- (void)shouldFollowCircle:(NSDictionary *)circleInfo fromView:(UIView *)view sender:(id)sender {

    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser == nil) {
        [self loginRequired:nil];
        return;
    }

    self.circle.isFollowRequesting = YES;
    self.circle.didFollowCircle = YES;
    [self updateCircleMOWithCircleID:self.circle.circleID didFollow:YES];
    [[self currentTableView] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [[self followWithCircleID:self.circle.circleID] subscribeError:^(NSError *error) {
        self.circle.isFollowRequesting = NO;
        self.circle.didFollowCircle = NO;
    [self updateCircleMOWithCircleID:self.circle.circleID didFollow:NO];
        [[self currentTableView] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } completed:^{
        self.circle.isFollowRequesting = NO;
        self.circle.didFollowCircle = YES;
    [self updateCircleMOWithCircleID:self.circle.circleID didFollow:YES];
        [[self currentTableView] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)shouldUnfollowCircle:(NSDictionary *)circleInfo fromView:(UIView *)view sender:(id)sender {

    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser == nil) {
        [self loginRequired:nil];
        return;
    }

    self.circle.isFollowRequesting = YES;
    self.circle.didFollowCircle = NO;
    [self updateCircleMOWithCircleID:self.circle.circleID didFollow:NO];
    [[self currentTableView] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [[self unfollowWithCircleID:self.circle.circleID] subscribeError:^(NSError *error) {
        self.circle.isFollowRequesting = NO;
        self.circle.didFollowCircle = YES;
    [self updateCircleMOWithCircleID:self.circle.circleID didFollow:YES];
        [[self currentTableView] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } completed:^{
        self.circle.isFollowRequesting = NO;
        self.circle.didFollowCircle = NO;
    [self updateCircleMOWithCircleID:self.circle.circleID didFollow:NO];
        [[self currentTableView] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)updateCircleMOWithCircleID:(NSInteger)circleID didFollow:(BOOL)didFollow{
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    NSInteger userID = currentUser != nil ? currentUser.userID : 0;
    BLUCircleMO *circleMO = [BLUCircleMO circleMOFromCircleID:circleID userID:userID];
    if (circleMO) {
        circleMO.didFollowCircle = @(didFollow);
    }
}

- (RACSignal *)followWithCircleID:(NSInteger)circleID {
    return [[BLUApiManager sharedManager] followCircleWithCircleID:circleID];
}

- (RACSignal *)unfollowWithCircleID:(NSInteger)circleID {
    return [[BLUApiManager sharedManager] unfollowCircleWithCircleID:circleID];
}

@end
