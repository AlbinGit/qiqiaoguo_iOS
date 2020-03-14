//
//  BLUMeViewController.m
//  Blue
//
//  Created by Bowen on 2/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPersonalViewController.h"
#import "BLUUserInfoView.h"
#import "BLUUserBarView.h"
#import "BLUUserNavCell.h"
#import "BLUUserBlurView.h"
#import "BLUUserViewModel.h"
#import "BLULoginViewController.h"
#import "BLUSettingViewController.h"
#import "BLUUserSettingViewController.h"
#import "BLUPostViewModel.h"
#import "BLUUserPostsViewController.h"
#import "BLUUsersViewModel.h"
#import "BLUUsersViewController.h"
#import "BLUUserCoinViewController.h"
#import "BLUUserLevelViewController.h"
#import "BLUNoCoinIndicator.h"
#import "BLUApiManager+User.h"
//#import "BLUGoodExchangeListViewController.h"
//#import "BLUUserOrdersViewController.h"

static const CGFloat kUserInfoViewHeight = 296;

static NSString * const kShouldShowPersonalGuideKey = @"kShouldShowPersonalGuideKey";
static NSString * const kShouldShowCoinShopGuideKey = @"kShouldShowCoinShopGuideKey";

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionPosts = 0,
    TableViewSectionMall,
    TableViewSectionSetting,
    TableViewSectionCount,
};

@interface BLUPersonalViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, BLUUserInfoViewDelegate>

@property (nonatomic, strong) BLUTableView *tableView;

@property (nonatomic, strong) UIImage *navigationBarBackgroundImage;
@property (nonatomic, strong) UIImage *navigationBarShadowImage;

@property (nonatomic, strong) BLUUserBlurView *userBlurView;
@property (nonatomic, strong) BLUUserInfoView *userInfoView;

@property (nonatomic, strong) BLUUser *user;
@property (nonatomic, strong) BLUUserViewModel *userViewModel;

@end

@implementation BLUPersonalViewController

- (instancetype)init {
    if (self = [super init]) {
        self.tabBarItem.image = [BLUCurrentTheme tabMeNormalIcon];
        self.tabBarItem.selectedImage = [BLUCurrentTheme tabMeSelectedIcon];
        self.title = NSLocalizedString(@"me.title", @"Me");
        self.tabBarItem.title = NSLocalizedString(@"me.title", @"Me");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *superview = self.view;
   
    self.user = [BLUAppManager sharedManager].currentUser ? [BLUAppManager sharedManager].currentUser : [BLUUser defaultUser];

    self.view.backgroundColor = BLUThemeMainColor;

    // Title view
    self.navigationItem.titleView = [UIView new];
    
    // Table view
    _tableView = [BLUTableView new];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [superview addSubview:_tableView];
    [_tableView registerClass:[BLUUserNavCell class] forCellReuseIdentifier:NSStringFromClass([BLUUserNavCell class])];
    
    // User info view
    _userInfoView = [BLUUserInfoView userInfoViewWithType:BLUUserInfoViewPersonal];
    _userInfoView.frame = CGRectMake(0, 0, superview.width, kUserInfoViewHeight);
    _userInfoView.backgroundColor = [UIColor clearColor];
    _userInfoView.user = self.user;
    _userInfoView.delegate = self;
    [_userInfoView.settingButton addTarget:self action:@selector(userSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    _userInfoView.frame = CGRectMake(0, 0, self.view.width, kUserInfoViewHeight);
    _tableView.tableHeaderView = _userInfoView;

    // User blur view
    _userBlurView = [BLUUserBlurView new];
    self.tableView.backgroundView = [UIView new];
//    _userBlurView.user = self.user;
    [self.tableView.backgroundView addSubview:_userBlurView];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    @weakify(self);
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
        if (currentUser) {
            self.userViewModel.userID = currentUser.userID;
            [[self.userViewModel fetch] handleFetchForViewController:self tableView:self.tableView reloadBlock:^{
                self.user = self.userViewModel.user;
                [BLUAppManager sharedManager].currentUser = self.user.copy;
                [self reloadData];
                [self tableViewEndRefreshing:self.tableView];
            }];
        } else {
            self.user = [BLUUser defaultUser];
            [self login];
            [self reloadData];
            [self tableViewEndRefreshing:self.tableView];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;

    if (currentUser) {
        self.user = currentUser;
        self.userViewModel.userID = currentUser.userID;
        [[self.userViewModel fetch] handleFetchForViewController:self tableView:self.tableView reloadBlock:^{
            self.user = self.userViewModel.user;
            [BLUAppManager sharedManager].currentUser = self.userViewModel.user;
            [self reloadData];
            [self tableViewEndRefreshing:self.tableView];
        }];
        [self reloadData];
        [self tableViewEndRefreshing:self.tableView];
    } else {
        self.user = [BLUUser defaultUser];
        [self reloadData];
        [self tableViewEndRefreshing:self.tableView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.frame;
    _userInfoView.frame = CGRectMake(0, 0, _tableView.width, kUserInfoViewHeight);
    _userBlurView.frame = CGRectMake(0, 0, self.view.width, -self.tableView.contentOffset.y + self.navigationBarHeight + kUserInfoViewHeight);
    UIEdgeInsets tableViewInsets = _tableView.contentInset;
    tableViewInsets.bottom = self.bottomLayoutGuide.length;
    _tableView.contentInset = tableViewInsets;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configGuideView];
}

#pragma mark - GuideView.

- (void)configGuideView {

    NSNumber *showCoinGuide = nil;
    NSNumber *showCoinShopGuide = nil;

    if ([BLUAppManager sharedManager].currentUser) {
        showCoinGuide = [[NSUserDefaults standardUserDefaults] objectForKey:kShouldShowPersonalGuideKey];
        if (showCoinGuide == nil) {
            showCoinGuide = @(YES);
        }
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:kShouldShowPersonalGuideKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    showCoinShopGuide = [[NSUserDefaults standardUserDefaults] objectForKey:kShouldShowCoinShopGuideKey];
    if (showCoinShopGuide == nil) {
        showCoinShopGuide = @(YES);
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:kShouldShowCoinShopGuideKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self showGuideViewForCoin:(showCoinGuide.boolValue == YES)
                      coinShop:(showCoinShopGuide.boolValue == YES)];

}

- (void)showGuideViewForCoin:(BOOL)showCoin coinShop:(BOOL)showCoinShop {

    if (showCoinShop) {
        UITableViewCell *cell =
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        CGRect cellFrame = [cell convertRect:cell.bounds toView:self.view];
        if (CGRectGetMaxY(cellFrame) >= (self.view.height - self.bottomLayoutGuide.length)) {
            showCoinShop = NO;
        }
    }

    if (showCoin) {
        CGRect coinBacgroundImageViewRect =
        [self.userInfoView.coinBackgroundImageView
         convertRect:self.userInfoView.coinBackgroundImageView.bounds
         toView:self.view];
        if (CGRectGetMinY(coinBacgroundImageViewRect) < 0) {
            showCoin = NO;
        }
    }

    if (showCoin == NO && showCoinShop == NO) {
        return ;
    }

    UIView *dimView = [self dimView];

    NSInteger tag = 1;

    if (showCoin) {
        UIView *coinView = [self configCoinGuideViewForDimView:dimView];
        coinView.tag = tag;
        tag++;
    }

    if (showCoinShop) {
        UIView *coinShopView = [self configCoinShopGuideViewForDimView:dimView];
        coinShopView.tag = tag;
        tag++;
    }

    if (dimView.subviews.count > 0) {
        [self showGuideForDimView:dimView];
    }
}

- (void)showGuideForDimView:(UIView *)dimView {

    if (!(dimView.subviews.count > 0)) {
        return ;
    }

    UITapGestureRecognizer *tapDimView = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(handleDimViewAction:)];
    [dimView addGestureRecognizer:tapDimView];

    for (UIView *subview in dimView.subviews) {
        subview.alpha = 0.0;
    }

    UIView *guideView = [dimView viewWithTag:1];
    guideView.alpha = 1.0;
    dimView.alpha = 0;

    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        dimView.alpha = 1.0;
    }];
}

- (void)handleDimViewAction:(UITapGestureRecognizer *)tap {
    UIView *dimView = tap.view;

    UIView * (^currentAppearingSubview)(UIView *dv) = ^UIView *(UIView *dv) {
        for (UIView *subView in dv.subviews) {
            if (subView.alpha == 1.0) {
                return subView;
            }
        }
        return nil;
    };

    UIView *lastGuideView = currentAppearingSubview(dimView);
    UIView *nextGuideView = [dimView viewWithTag:lastGuideView.tag + 1];

    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        if (nextGuideView) {
            lastGuideView.alpha = 0.0;
            nextGuideView.alpha = 1.0;
        } else {
            dimView.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        if (nextGuideView) {
            [lastGuideView removeFromSuperview];
        } else {
            [dimView removeFromSuperview];
        }
    }];
}

- (UIView *)dimView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIView *dimView = [UIView new];
    dimView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.8];

    [window addSubview:dimView];
    dimView.frame = window.bounds;
    return dimView;
}

- (UIView *)configCoinGuideViewForDimView:(UIView *)dimView {

    UIView *coinView = [UIView new];
    coinView.frame = dimView.bounds;
    [dimView addSubview:coinView];

    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"guide-personal-desc"];

    CGRect coinBacgroundImageViewRect =
    [self.userInfoView.coinBackgroundImageView
     convertRect:self.userInfoView.coinBackgroundImageView.bounds
     toView:dimView];

    [imageView sizeToFit];
    imageView.x = dimView.width - imageView.width;
    imageView.y = coinBacgroundImageViewRect.origin.y - 12;

    [coinView addSubview:imageView];

    return coinView;
}

- (UIView *)configCoinShopGuideViewForDimView:(UIView *)dimView {

    UIView *coinShopView = [UIView new];
    coinShopView.frame = dimView.bounds;
    [dimView addSubview:coinShopView];

    UIImageView *guideImageView = [UIImageView new];
    guideImageView.image = [UIImage imageNamed:@"user-guide-coin-shop"];

    BLUUserNavCell *cell = [self.tableView
                            cellForRowAtIndexPath:
                            [NSIndexPath indexPathForRow:0 inSection:1]];
    BLUAssertObjectIsKindOfClass(cell, [BLUUserNavCell class]);

    UIImageView *promptImageView = [UIImageView new];
    promptImageView.image = cell.promptImageView.image;

    UILabel *contentLabel = [UILabel new];
    contentLabel.text = cell.contentLabel.text;
    contentLabel.font = cell.contentLabel.font;
    contentLabel.textColor = [UIColor whiteColor];

    [coinShopView addSubview:guideImageView];
    [coinShopView addSubview:promptImageView];
    [coinShopView addSubview:contentLabel];

    CGRect cellImageViewRect = [cell.promptImageView
                                convertRect:cell.promptImageView.bounds
                                toView:coinShopView];
    CGRect cellLabelViewRect = [cell.contentLabel
                                convertRect:cell.contentLabel.bounds
                                toView:coinShopView];

    contentLabel.frame = cellLabelViewRect;
    promptImageView.frame = cellImageViewRect;

    CGFloat guideX = contentLabel.right + BLUThemeMargin;
    CGFloat guideY = contentLabel.top - 44;

    guideImageView.frame = CGRectMake(guideX, guideY,
                                      guideImageView.image.size.width,
                                      guideImageView.image.size.height);

    return coinShopView;
}

//- (void)showCoinShopGuideView {
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//
//    UIView *dimView = [UIView new];
//    dimView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.8];
//    UITapGestureRecognizer *tapDimView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCoinGuideView:)];
//    [dimView addGestureRecognizer:tapDimView];
//
//    UIImageView *guideImageView = [UIImageView new];
//    guideImageView.image = [UIImage imageNamed:@"user-guide-coin-shop"];
//
//    BLUUserNavCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    BLUAssertObjectIsKindOfClass(cell, [BLUUserNavCell class]);
//
//    UIImageView *promptImageView = [UIImageView new];
//    promptImageView.image = cell.promptImageView.image;
//
//    UILabel *contentLabel = [UILabel new];
//    contentLabel.text = cell.contentLabel.text;
//    contentLabel.font = cell.contentLabel.font;
//    contentLabel.textColor = [UIColor whiteColor];
//
//    [dimView addSubview:guideImageView];
//    [dimView addSubview:promptImageView];
//    [dimView addSubview:contentLabel];
//    [window addSubview:dimView];
//
//    dimView.frame = window.bounds;
//
//    CGRect cellImageViewRect = [cell.promptImageView convertRect:cell.promptImageView.bounds toView:dimView];
//    CGRect cellLabelViewRect = [cell.contentLabel convertRect:cell.contentLabel.bounds toView:dimView];
//
//    contentLabel.frame = cellLabelViewRect;
//    promptImageView.frame = cellImageViewRect;
//
//    CGFloat guideX = contentLabel.right + BLUThemeMargin;
//    CGFloat guideY = contentLabel.top - 44;
//
//    guideImageView.frame = CGRectMake(guideX, guideY,
//                                      guideImageView.image.size.width,
//                                      guideImageView.image.size.height);
//
//    dimView.alpha = 0.0;
//    [UIView animateWithDuration:0.4 animations:^{
//        dimView.alpha = 1.0;
//    }];
//}

- (void)hideCoinShopGuideView {

}

- (void)showCoinGuideView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIView *dimView = [UIView new];
    dimView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.8];
    UITapGestureRecognizer *tapDimView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCoinGuideView:)];
    [dimView addGestureRecognizer:tapDimView];

    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"guide-personal-desc"];

    dimView.frame = window.bounds;

    CGRect coinBacgroundImageViewRect =
    [self.userInfoView.coinBackgroundImageView
     convertRect:self.userInfoView.coinBackgroundImageView.bounds
     toView:window];

    [imageView sizeToFit];
    imageView.x = window.width - imageView.width;
    imageView.y = coinBacgroundImageViewRect.origin.y - 12;

    dimView.alpha = 0.0;

    [dimView addSubview:imageView];
    [window addSubview:dimView];

    [UIView animateWithDuration:0.4 animations:^{
        dimView.alpha = 1.0;
    }];
}

- (void)hideCoinGuideView:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.2 animations:^{
        recognizer.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [recognizer.view removeFromSuperview];
    }];
}

#pragma mark - Model

- (void)login {
    BLULoginViewController *vc = [BLULoginViewController new];
    BLUNavigationController *nav = [[BLUNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)userSettingAction:(UIButton *)button {
    if ([self.user isDefaultUser]) {
        [self login];
    } else {
        BLUUserSettingViewController *vc = [[BLUUserSettingViewController alloc] initWithUser:self.user];
        [self pushViewController:vc];
    }
}

- (void)reloadData {
    _userInfoView.user = self.user;
    _userBlurView.user = self.user;
}

- (BLUUserViewModel *)userViewModel {
    if (_userViewModel == nil) {
        _userViewModel = [BLUUserViewModel new];
    }
    return _userViewModel;
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return BLUUserNavTypeCount - 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        BLUUserNavCell *navCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserNavCell class]) forIndexPath:indexPath];
        navCell.showSeparatorLine = !(indexPath.row == BLUUserNavTypeCount - 2);
        navCell.navType = indexPath.row;
        cell = navCell;
    } else if (indexPath.section == 1){
        BLUUserNavCell *navCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserNavCell class]) forIndexPath:indexPath];
        navCell.navType = BLUUserNavTypeMall;
        navCell.showSeparatorLine = NO;
        cell = navCell;
    } else {
        BLUUserNavCell *navCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserNavCell class]) forIndexPath:indexPath];
        navCell.navType = BLUUserNavTypeSetting;
        navCell.showSeparatorLine = NO;
        cell = navCell;
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *view = [UIView new];
        view.backgroundColor = BLUThemeSubTintBackgroundColor;
        return view;
    }
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return BLUThemeMargin * 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    CGFloat width = self.view.width;
    
    size = [_tableView sizeForCellWithCellClass:[BLUUserNavCell class] cacheByIndexPath:indexPath width:width configuration:^(BLUCell *cell) {
        BLUUserNavCell *navCell = (BLUUserNavCell *)cell;
        navCell.navType = indexPath.row;
    }];
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case TableViewSectionPosts: {
            if ([self.user isDefaultUser]) {
                [self login];
                break;
                return ;
            }
            
            BLUPostViewModel *postViewModel = nil;
            NSString *title = nil;
            switch (indexPath.row) {
                case BLUUserNavTypePost: {
                    postViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeForUser];
                    title = NSLocalizedString(@"personal.user-post.title.my-posts", @"My posts");
                } break;
                case BLUUserNavTypeCommented: {
                    postViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeForParticipated];
                    title = NSLocalizedString(@"personal.user-post.title.Participated", @"Participated");
                } break;
                case BLUUserNavTypeCollection: {
                    postViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeForCollection];
                    title = NSLocalizedString(@"personal.user-post.title.my-collections", @"My collections");
                } break;
                case BLUuserNavTypeUserOrders: {
//                    BLUUserOrdersViewController *vc = [UIStoryboard userOrdersViewController];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushViewController:vc];
                } return;
                default: return;
            }
            
            postViewModel.userID = self.user.userID;
            BLUUserPostsViewController *vc = [[BLUUserPostsViewController alloc] initWithPostViewModel:postViewModel];
            vc.title = title;
            if (indexPath.row == BLUUserNavTypeCollection || indexPath.row == BLUUserNavTypePost) {
                vc.editAble = YES;
            }
            [self pushViewController:vc];
        } break;
        case TableViewSectionMall: {
            if ([self loginIfNeeded]) {
                return ;
            }
//            BLUGoodExchangeListViewController *vc = [BLUGoodExchangeListViewController new];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self pushViewController:vc];
        } break;
        case TableViewSectionSetting: {
            BLUSettingViewController *vc = [BLUSettingViewController new];
            [self pushViewController:vc];
        } break;
        default: break;
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _userBlurView.frame = CGRectMake(0, 0, self.view.width, -self.tableView.contentOffset.y + self.navigationBarHeight + kUserInfoViewHeight);
}

#pragma mark - BLUUserInfoView.

- (void)shouldLoginFromUserInfoView:(BLUUserInfoView *)userInfoView {
    [self loginRequired:nil];
}

- (void)shouldShowFollowingsFromUserInfoView:(BLUUserInfoView *)userInfoView {
    [self showUsersViewControllerWithType:BLUUsersViewModelTypeFollowing];
}

- (void)shouldShowFollowersFromUserInfoView:(BLUUserInfoView *)userInfoView {
    [self showUsersViewControllerWithType:BLUUsersViewModelTypeFollower];
}

- (void)showUsersViewControllerWithType:(BLUUsersViewModelType)type {
    BLUUsersViewModel *usersViewModel = [BLUUsersViewModel new];
    usersViewModel.userID = self.user.userID;
    usersViewModel.type = type;
    BLUUsersViewController *vc = [[BLUUsersViewController alloc] initWithUsersViewModel:usersViewModel];
    if (type == BLUUsersViewModelTypeFollowing) {
        vc.title = NSLocalizedString(@"personal-vc.users-vc.title.following", @"Followings");
    } else {
        vc.title = NSLocalizedString(@"personal-vc.users-vc.title.follower", @"Followers");
    }
    [self pushViewController:vc];
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
