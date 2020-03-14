//
//  BLUOtherUserViewController.m
//  Blue
//
//  Created by Bowen on 13/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUOtherUserViewController.h"
#import "BLUUserInfoView.h"
#import "BLUTabButton.h"
#import "BLURadioButtonView.h"
#import "BLUUserBarView.h"
#import "BLUUserIndicatorCell.h"
#import "BLUUserBlurView.h"
#import "BLUPostViewModel.h"
#import "BLUUserViewModel.h"
#import "BLUOtherUserViewController.h"
#import "BLUPost.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUPostCommonOptCell.h"
#import "BLUUserTransitionDelegate.h"
#import "BLUUsersViewModel.h"
#import "BLUUsersViewController.h"
#import "BLUChatViewController.h"
#import "BLUReportViewModel.h"
#import "BLUUserLevelViewController.h"
#import "BLUUserCoinViewController.h"
#import "BLUPostCommonNode.h"
#import "BLUUserindicatorNode.h"

static const CGFloat kUserInfoViewHeight = 240;
static const CGFloat kHeightOfSelctionToolBar = 44.0;

typedef NS_ENUM(NSInteger, TableViewType) {
    TableViewTypePost = 0,
    TableViewTypeInfo = 1,
};

@interface BLUOtherUserViewController () <ASTableViewDelegate, ASTableViewDataSource, BLUUserInfoViewDelegate>

@property (nonatomic, strong) ASTableView *tableView;
@property (nonatomic, strong) BLUUserInfoView *userInfoView;
@property (nonatomic, assign) TableViewType tableViewType;
@property (nonatomic, strong) BLUUserBarView *userBarView;

@property (nonatomic, strong) UIImage *navigationBarBackgroundImage;
@property (nonatomic, strong) UIImage *navigationBarShadowImage;

@property (nonatomic, strong) BLUUserBlurView *userBlurView;

@property (nonatomic, strong) NSArray *userInfoTypeArray;

@property (nonatomic, strong) BLUPostViewModel *postsViewModel;
@property (nonatomic, strong) BLUUserViewModel *userViewModel;

@property (nonatomic, strong) BLUUserTransitionDelegate *userTransition;
@property (nonatomic, strong) UIView *watermarkView;

@property (nonatomic, strong) UITapGestureRecognizer *tapNavBarGestureRecognizer;

@end

@implementation BLUOtherUserViewController

- (instancetype)initWithUserID:(NSInteger)userID {
    if (self = [super init]) {
        _userID = userID;
        self.hidesBottomBarWhenPushed = YES;

    }
    return self;
}

#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    
    _watermarkView = [self makeWatermarkView];
    _watermarkView.hidden = YES;
    _watermarkView.alpha = 0.0;
    _watermarkView.userInteractionEnabled = NO;
    
    [self.view addSubview:_watermarkView];
    
    
    
    // Model
    BLUUser *user = self.user ? self.user : nil;
    
    // Table view
    _tableView = [ASTableView new];
    _tableView.backgroundColor = nil;
    _tableView.asyncDelegate = self;
    _tableView.asyncDataSource = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableFooterView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.clipsToBounds = YES;
   
    [_tableView registerClass:[BLUPostCommonOptCell class] forCellReuseIdentifier:NSStringFromClass([BLUPostCommonOptCell class])];
    [_tableView registerClass:[BLUUserIndicatorCell class] forCellReuseIdentifier:NSStringFromClass([BLUUserIndicatorCell class])];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:_tableView];
    
    // User info view
    _userInfoView = [BLUUserInfoView userInfoViewWithType:BLUUserInfoViewOtherPeople];
    _userInfoView.frame = CGRectMake(0, 0, self.view.width, kUserInfoViewHeight);
    _userInfoView.backgroundColor = [UIColor clearColor];
    _userInfoView.user = user;
    _userInfoView.delegate = self;
    _tableView.tableHeaderView = _userInfoView;
    
    // User blur view
    _userBlurView = [BLUUserBlurView new];
    self.tableView.backgroundView = [UIView new];
    _userBlurView.user = user;
    [self.tableView.backgroundView addSubview:_userBlurView];

    // Bar view
    _userBarView = [BLUUserBarView new];
    _userBarView.barColor = [BLUCurrentTheme mainColor];
    _userBarView.user = user;
    [self.view addSubview:_userBarView];

    // Model
    self.tableViewType = TableViewTypePost;

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];

    
//    // Constraints
//    [self addTiledLayoutConstrantForView:_tableView];
    
    [_watermarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
//        make.centerY.equalTo(self.view).offset(-BLUThemeMargin * 6);
    }];


    
    

    
    RAC(self, userViewModel.userID) = RACObserve(self, userID);
    RAC(self, postsViewModel.userID) = RACObserve(self, userID);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _navigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
    _navigationBarBackgroundImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0]];
    self.navigationController.navigationBar.opaque = NO;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillFirstAppear {
    @weakify(self);
    [[self.userViewModel fetch] subscribeError:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    } completed:^{
        @strongify(self);
        self.user = self.userViewModel.user;
        [self reloadData];
    }];

    [[self.postsViewModel fetch] handleFetchForViewController:self tableView:self.tableView reloadBlock:^{
        @strongify(self);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self showWatermarkView];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setBackgroundImage:_navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:_navigationBarShadowImage];
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.translucent = NO;

    if (self.tapNavBarGestureRecognizer) {
        [self.navigationController.navigationBar removeGestureRecognizer:self.tapNavBarGestureRecognizer];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.frame;
    _userInfoView.frame = CGRectMake(0, 0, _tableView.width, kUserInfoViewHeight);
    _userBarView.frame = CGRectMake(0, 0, self.view.width, self.topLayoutGuide.length);
    _userBarView.totalOffset = 32;
    _userBlurView.frame = CGRectMake(0, 0, self.view.width, - self.tableView.contentOffset.y + self.navigationBarHeight + kUserInfoViewHeight - 44);
    _userBarView.currentOffset = self.tableView.contentOffset.y - kUserInfoViewHeight + self.navigationBarHeight * 2;
    _watermarkView.centerY = (self.view.height - kUserInfoViewHeight)/2 + kUserInfoViewHeight;
}

- (void)showWatermarkView {
    BOOL hide = self.postsViewModel.posts.count > 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.watermarkView.alpha = hide ? 0.0 : 1.0;
    } completion:^(BOOL finished) {
        self.watermarkView.hidden = hide ? YES : NO;
    }];
}


- (UIView *)makeWatermarkView {
    UIView *container = [UIView new];
    
    UILabel *promptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    promptLabel.textColor = BLUThemeSubTintContentForegroundColor;
    promptLabel.attributedText = [NSAttributedString contentAttributedStringWithContent:@"TA还没有发布过任何内容哦!"];
    promptLabel.numberOfLines = 0;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[BLUCurrentTheme postNoPost]];
    
    [container addSubview:promptLabel];
    [container addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container);
        make.centerX.equalTo(container);
    }];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(BLUThemeMargin * 4);
        make.bottom.equalTo(container);
        make.centerX.equalTo(container);
    }];
    
    return container;
}



#pragma mark - Reload data

- (void)headerRefreshAction {
    
    static BOOL shouldReloadUser = NO;
    
    [self reloadData];
    
    void (^reloadUser)() = ^() {
        @weakify(self);
        [[self.userViewModel fetch] subscribeError:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
        } completed:^{
            @strongify(self);
            self.user = self.userViewModel.user;
            [self reloadData];
        }];
    };
   
    if (self.user == nil) {
        reloadUser();
    } else {
        if ([self.user isDefaultUser]) {
            reloadUser();
        }
        if (shouldReloadUser) {
            reloadUser();
        }
        shouldReloadUser = YES;
    }
    
    @weakify(self);
    [[self.postsViewModel fetch] handleFetchForViewController:self tableView:self.tableView reloadBlock:^{
        @strongify(self);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)footerRefreshAction {

    @weakify(self);
    [[self.postsViewModel fetchNext] subscribeNext:^(NSArray *posts) {
        @strongify(self);
        [self.tableView reloadData];
        [self tableViewEndRefreshing:self.tableView noMoreData:posts.count == 0];
    } error:^(NSError *error) {
        [self showAlertForError:error];
    }];
}

- (void)reloadData {
    _userInfoView.user = self.user;
    _userBarView.user = self.user;
    _userBlurView.user = self.user;
}

#pragma mark - View model

- (void)setUser:(BLUUser *)user {
    _user = user;
    self.userID=  user.userID;
}

- (BLUPostViewModel *)postsViewModel {
    if (_postsViewModel == nil) {
        _postsViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeForUser];
    }
    return _postsViewModel;
}

- (BLUUserViewModel *)userViewModel {
    if (_userViewModel == nil) {
        _userViewModel = [BLUUserViewModel new];
    }
    return _userViewModel;
}

- (BLUUserTransitionDelegate *)userTransition {
    if (_userTransition == nil) {
        _userTransition = [BLUUserTransitionDelegate new];
        _userTransition.viewController = self;
    }
    return _userTransition;
}

- (void)setTableViewType:(TableViewType)tableViewType {
    _tableViewType = tableViewType;
    if (tableViewType == TableViewTypePost) {
        _tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    } else {
        _tableView.mj_footer = nil;
    }
}

- (void)moreAction:(UIBarButtonItem *)barButton {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"other-user.alert-action.report", @"Report") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        BLUReportViewModel *reportViewModel = [[BLUReportViewModel alloc ] initWithObjectID:self.user.userID viewController:self sourceView:self.navigationController.navigationBar sourceRect:self.navigationController.navigationBar.bounds sourceType:BLUReportSourceTypeUser];
        [reportViewModel showReportSheet];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction cancelAction];
    
    [alertController addAction:reportAction];
    [alertController addAction:cancelAction];
    alertController.popoverPresentationController.barButtonItem = barButton;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO:
    NSInteger count = 0;
    count = self.postsViewModel.posts.count;
    return count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {

        BLUPostCommonNode *postNode = [[BLUPostCommonNode alloc]
                                       initWithPost:self.postsViewModel.posts[indexPath.row]];
        return postNode;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Tool bar
    UIToolbar *toolBar = [UIToolbar new];
    
    // Tab post button
    BLUTabButton *postButton = [BLUTabButton new];
    postButton.tag = TableViewTypePost;
    postButton.title = NSLocalizedString(@"other-user.header.post", @"Post");
    [postButton addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
    // Tab info button
    BLUTabButton *infoButton = [BLUTabButton new];
    infoButton.tag = TableViewTypeInfo;
    infoButton.title = NSLocalizedString(@"other-user.header.info", @"Info");
    [infoButton addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // Solid line
    BLUSolidLine *solidLine = [BLUSolidLine new];
    solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    void (^configButton)(BLUTabButton *) = ^(BLUTabButton *tabButton) {
        RAC(tabButton, selected) = [[RACObserve(self, tableViewType) distinctUntilChanged] map:^id(NSNumber *type) {
            if (type.integerValue == tabButton.tag) {
                return @(YES);
            } else {
                return @(NO);
            }
        }];
    };
    
    configButton(postButton);
    configButton(infoButton);
    
    [toolBar addSubview:postButton];
    [toolBar addSubview:infoButton];
    [toolBar addSubview:solidLine];
   
    [postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(toolBar);
        make.width.equalTo(infoButton);
    }];
    
    [infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(toolBar);
        make.left.equalTo(postButton.mas_right);
    }];
    
    [solidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(toolBar);
        make.centerX.equalTo(toolBar);
        make.width.equalTo(@(BLUThemeOnePixelHeight));
    }];
    
    return nil;
    return toolBar;
}

- (void)_buttonClicked:(BLUTabButton *)button {
    self.tableViewType = button.tag;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
              withRowAnimation:UITableViewRowAnimationFade];
    [_tableView reloadData];

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // TODO:
    return 0.0000000000000000000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        BLUPost *post = self.postsViewModel.posts[indexPath.row];
        BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:post.postID];
        [self pushViewController:vc];

}

- (void)tableView:(ASTableView *)tableView
willBeginBatchFetchWithContext:(ASBatchContext *)context {
    @weakify(self);
    [[self.postsViewModel fetchNext] subscribeNext:^(NSArray *items) {
        @strongify(self);
        if (items) {
            NSInteger initialIndex = self.postsViewModel.posts.count - items.count;
            NSMutableArray *indexPaths = [NSMutableArray new];
            [items enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                NSUInteger idx,
                                                BOOL * _Nonnull stop) {
                NSIndexPath *indexPath =
                [NSIndexPath indexPathForRow:initialIndex + idx inSection:0];
                [indexPaths addObject:indexPath];
            }];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        [self tableViewEndRefreshing:self.tableView];
        [self.view hideIndicator];
        [context completeBatchFetching:YES];
    } error:^(NSError *error) {
        @strongify(self);
        [self tableViewEndRefreshing:self.tableView];
        [self.view hideIndicator];
        [context completeBatchFetching:YES];
    }];
    [context completeBatchFetching:YES];
}

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView {
    return !self.postsViewModel.noMoreData;
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGFloat height = self.navigationBarHeight + kUserInfoViewHeight - 44;
    _userBlurView.frame = CGRectMake(0, 0, self.view.width, -offset.y + height);
    BLULogDebug(@"offset = %@", NSStringFromCGPoint(offset));
    _userBarView.currentOffset = offset.y - kUserInfoViewHeight + self.navigationBarHeight * 2;
}

#pragma mark - BLUserInfoView.

- (void)shouldShowFollowingsFromUserInfoView:(BLUUserInfoView *)userInfoView {
    [self showUsersViewControllerWithType:BLUUsersViewModelTypeFollowing];
}

- (void)shouldShowFollowersFromUserInfoView:(BLUUserInfoView *)userInfoView {
    [self showUsersViewControllerWithType:BLUUsersViewModelTypeFollower];
}

- (void)showUsersViewControllerWithType:(BLUUsersViewModelType)type {
    BLUUsersViewModel *usersViewModel = [BLUUsersViewModel new];
    usersViewModel.userID = self.userID;
    usersViewModel.type = type;
    BLUUsersViewController *vc = [[BLUUsersViewController alloc] initWithUsersViewModel:usersViewModel];
    if (type == BLUUsersViewModelTypeFollowing) {
        vc.title = NSLocalizedString(@"other-user-vc.users-vc.title.following", @"Followings");
    } else {
        vc.title = NSLocalizedString(@"other-user-vc.users-vc.title.follower", @"Followers");
    }
    [self pushViewController:vc];
}

- (void)shouldFollowUser:(BLUUser *)user fromUserInfoView:(BLUUserInfoView *)userInfoView {
    if (self.user.didFollow) {
        return ;
    }

    if ([BLUAppManager sharedManager].currentUser == nil) {
        [self loginRequired:nil];
        return ;
    }

    self.userViewModel.user.didFollow = YES;
    self.user.didFollow = YES;

    [self reloadData];
    @weakify(self);
    [[self.userViewModel follow] subscribeError:^(NSError *error) {
        @strongify(self);
        self.userViewModel.user.didFollow = NO;
        self.user.didFollow = NO;

        [self showAlertForError:error];
        [self reloadData];
    } completed:^{
        @strongify(self);
        [[self.userViewModel fetch] subscribeError:^(NSError *error) {
            [self showAlertForError:error];
        } completed:^{
            self.user = self.userViewModel.user;
            [self reloadData];
        }];
    }];
}

- (void)shouldUnfollowUser:(BLUUser *)user fromUserInfoView:(BLUUserInfoView *)userInfoView {
    if (!self.user.didFollow) {
        return ;
    }

    if ([BLUAppManager sharedManager].currentUser == nil) {
        [self loginRequired:nil];
        return ;
    }

    self.userViewModel.user.didFollow = NO;
    self.user.didFollow = NO;

    [self reloadData];
    @weakify(self);
    [[self.userViewModel unfollow] subscribeError:^(NSError *error) {
        @strongify(self);
        self.userViewModel.user.didFollow = YES;
        self.user.didFollow = YES;

        [self showAlertForError:error];
        [self reloadData];
    } completed:^{
        @strongify(self);
        [[self.userViewModel fetch] subscribeError:^(NSError *error) {
            [self showAlertForError:error];
        } completed:^{
            self.user = self.userViewModel.user;
            [self reloadData];
        }];
    }];
}

- (void)shouldChatWithUser:(BLUUser *)user fromUserInfoView:(BLUUserInfoView *)userInfoView {
    if ([self loginIfNeeded]) {
        return;
    }
    if ([BLUAppManager sharedManager].currentUser.userID != user.userID) {
        BLUChatViewController *vc = [[BLUChatViewController alloc] initWithUser:user];
        [self pushViewController:vc];
    }
}

- (void)shouldShowLevelInfoFromUserInfoView:(BLUUserInfoView *)userInfoView {
    BLUUserLevelViewController *vc = [[BLUUserLevelViewController alloc] initWithUser:self.user];
    [self pushViewController:vc];
}

- (void)shouldShowCoinInfoFromUserInfoView:(BLUUserInfoView *)userInfoView {
    BLUUserCoinViewController *vc = [[BLUUserCoinViewController alloc] initWithUser:self.user];
    [self pushViewController:vc];
}

@end
