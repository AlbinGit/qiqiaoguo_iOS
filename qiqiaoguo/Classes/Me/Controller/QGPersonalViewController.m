//
//  QGPersonalViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/6/13.
//
//  我的界面

#import "QGPersonalViewController.h"
#import "QGAdiceCell.h"
#import "QGTableView.h"
//#import "QGUserInfoView.h"
#import "QGNewUserInfoView.h"
#import "BLUUserBarView.h"
#import "BLUUserBlurView.h"
#import "BLUUserViewModel.h"

#import "QGLoginViewController.h"
#import "QGNavigationViewController.h"
#import "QGMessageCenterViewController.h"
#import "QGSearchResultViewController.h"


#import "QGPersonalOrderCell.h"
#import "QGHttpManager+User.h"
#import "QGSettingViewController.h"
#import "BLUUsersViewModel.h"
#import "BLUUsersViewController.h"
#import "QGMyFollowViewController.h"
#import "QGMyCollectionViewController.h"
#import "QGMyParticipateViewController.h"
#import "BLUUserPostsViewController.h"
#import "BLUPostViewModel.h"
#import "QGUserPostsViewController.h"
#import "QGMallOrderViewController.h"
#import "QGActivOrderViewController.h"
#import "QGActCalendarViewController.h"
#import "QGEducatiionOrderViewController.h"
#import "QGTeacherEnterPrivacyController.h"//老师入驻协议
#import "QGTeacherWaitController.h"
@interface QGPersonalViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,OrderCellDalegate,QGNewUserInfoViewDelegate>

@property (nonatomic, strong) QGTableView *tableView;

/** 用户信息所用到的View*/
//@property (nonatomic, strong) QGUserInfoView *userInfoView;
@property (nonatomic, strong) QGNewUserInfoView *myUserInfoView;

@property (nonatomic, strong) BLUUserBarView *userBarView;
@property (nonatomic, strong) UIImage *navigationBarBackgroundImage;
@property (nonatomic, strong) UIImage *navigationBarShadowImage;
@property (nonatomic, strong) BLUUserBlurView *userBlurView;
@property (nonatomic, strong) BLUUserViewModel *userViewModel;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) BLUUser *user;
@end

//static const CGFloat kUserInfoViewHeight = 260;
static const CGFloat kUserInfoViewHeight = 230;
#define kHeight 210+Height_TopBar

@implementation QGPersonalViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"我";
        self.isPush  = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    // Table view
    _tableView = [[QGTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorFromHexString:@"ececec"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    
    [_tableView registerClass:[QGAdiceCell class] forCellReuseIdentifier:NSStringFromClass([QGAdiceCell class])];
    [_tableView registerClass:[QGPersonalOrderCell class] forCellReuseIdentifier:NSStringFromClass([QGPersonalOrderCell class])];
    
    BLUUser *user = self.user ? self.user : nil;
    // User info view
//    _userInfoView = [[QGUserInfoView alloc]init];
//    _userInfoView.frame = CGRectMake(0, 0, self.view.width, kUserInfoViewHeight);
//    _userInfoView.user = user;
//    _userInfoView.backgroundColor = [UIColor clearColor];
//    _userInfoView.delegate = self;
//    _tableView.tableHeaderView = _userInfoView;
    
	
	_myUserInfoView = [[QGNewUserInfoView alloc]init];
    _myUserInfoView.frame = CGRectMake(0, 0, self.view.width, kHeight);
    _myUserInfoView.user = user;
    _myUserInfoView.backgroundColor = [UIColor clearColor];
    _myUserInfoView.delegate = self;
    _tableView.tableHeaderView = _myUserInfoView;
	
	
    // User blur view
    _userBlurView = [BLUUserBlurView new];
    self.tableView.backgroundView = [UIView new];
    _userBlurView.user = user;
    [self.tableView.backgroundView addSubview:_userBlurView];
   self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
          _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      }

    
    // Bar view
    _userBarView = [BLUUserBarView new];
    _userBarView.barColor = [BLUCurrentTheme mainColor];
    _userBarView.user = user;
    [self.tableView.backgroundView addSubview:_userBarView];
    
    @weakify(self);
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
        if (currentUser) {
            [QGHttpManager getUserDetaileWithUserID:currentUser.userID Success:^(NSURLSessionDataTask *task, id responseObject) {
                [self tableViewEndRefreshing:self.tableView];
                BLUUser *user = responseObject;
                [BLUAppManager sharedManager].currentUser = user;
                self.user = user;
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self showTopIndicatorWithError:error];
            }];
            
        } else {
            [self.tableView reloadData];
            [self tableViewEndRefreshing:self.tableView];
            [self loginRequired:nil];
        }
    }];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[SAUserDefaults getValueWithKey:USERINFONEEDUPDATE] isEqualToString:@"1"]) {
        BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
        if (currentUser) {
            @weakify(self);
            [QGHttpManager getUserDetaileWithUserID:currentUser.userID Success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(self);
                [self tableViewEndRefreshing:self.tableView];
                BLUUser *user = responseObject;
                [BLUAppManager sharedManager].currentUser = user;
                self.user = user;
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                @strongify(self);
                [self showTopIndicatorWithError:error];
            }];
            
        } else {
            [self.tableView reloadData];
            [self tableViewEndRefreshing:self.tableView];
            [self loginRequired:nil];
        }
        [SAUserDefaults saveValue:@"0" forKey:USERINFONEEDUPDATE];
    }
    [self.navigationController setNavigationBarHidden:YES animated:_isPush];
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser) {
        if (self.user == nil) {
            self.user = currentUser;
        }
    } else {
        self.user = nil;
        [self.tableView  reloadData];
    }
    
    [self getUserMessageCount];
}

- (void)updateUserMessageCount{

//    self.userInfoView.MeassageCount = self.messageCount;
	self.myUserInfoView.messageLabel.text = [NSString stringWithFormat:@"%ld",(long)self.messageCount];

}

- (void)viewWillFirstAppear{
    [super viewWillFirstAppear];
    self.navigationController.navigationBar.hidden = YES;
    
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    
    if (currentUser) {
        self.user = currentUser;
        self.userViewModel.userID = currentUser.userID;
        BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
        if (currentUser) {
            [QGHttpManager getUserDetaileWithUserID:currentUser.userID Success:^(NSURLSessionDataTask *task, id responseObject) {
                [self tableViewEndRefreshing:self.tableView];
                BLUUser *user = responseObject;
                [BLUAppManager sharedManager].currentUser = user;
                self.user = user;
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self showTopIndicatorWithError:error];
            }];
            
        } else {
            [self.tableView reloadData];
            [self tableViewEndRefreshing:self.tableView];
            [self loginRequired:nil];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _isPush = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.frame;
//    _userInfoView.frame = CGRectMake(0, 0, _tableView.width, kUserInfoViewHeight);
//    _userBlurView.frame = CGRectMake(0, 0, self.view.width, - self.tableView.contentOffset.y + self.navigationBarHeight + kHeight - 44);

	_userBlurView.frame = CGRectMake(0, 0, self.view.width, - self.tableView.contentOffset.y + self.navigationBarHeight + kUserInfoViewHeight - 44);
	  _myUserInfoView.frame = CGRectMake(0, 0, _tableView.width, kHeight);
	
    UIEdgeInsets tableViewInsets = _tableView.contentInset;
    tableViewInsets.bottom = self.bottomLayoutGuide.length;
    _tableView.contentInset = tableViewInsets;
}

#pragma mark - 属性的set方法
- (void)setUser:(BLUUser *)user
{
    _user = user;
    self.myUserInfoView.user = user;
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 2;
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return section == 1 ? 3 : 1;
	
    return 3;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
//    if (indexPath.section == 0) {
//        // 订单cell
//        QGPersonalOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGPersonalOrderCell class]) forIndexPath:indexPath];
//        orderCell.delegate = self;
//        cell = orderCell;
//    }
//    else
//    {// 普通cell
//        QGAdiceCell *AdiceCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGAdiceCell class]) forIndexPath:indexPath];
//        AdiceCell.AdviceType = indexPath.section *100 + indexPath.row;
//        cell = AdiceCell;
//    }
	QGAdiceCell *AdiceCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGAdiceCell class]) forIndexPath:indexPath];
	AdiceCell.AdviceType = 100 + indexPath.row;
	cell = AdiceCell;
	
    return cell;
}



#pragma make - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGSize size = CGSizeZero;
//    CGFloat width = self.view.width;
//    if (indexPath.section == 0) {
//      size = [_tableView sizeForCellWithCellClass:[QGPersonalOrderCell class] cacheByIndexPath:indexPath width:width configuration:^(QGCell *cell) {
//        }];
//        return size.height;
//    }
//        size = [_tableView sizeForCellWithCellClass:[QGAdiceCell class] cacheByIndexPath:indexPath width:width configuration:^(QGCell *cell) {
//            QGAdiceCell *navCell = (QGAdiceCell *)cell;
//            navCell.AdviceType = indexPath.section * 100 + indexPath.row;
//        }];
//    return size.height;
		CGSize size = CGSizeZero;
		CGFloat width = self.view.width;

	   size = [_tableView sizeForCellWithCellClass:[QGAdiceCell class] cacheByIndexPath:indexPath width:width configuration:^(QGCell *cell) {
		   QGAdiceCell *navCell = (QGAdiceCell *)cell;
		   navCell.AdviceType = 100 + indexPath.row;
	   }];
	   return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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
//    if (indexPath.section == 1) {
//        switch (indexPath.row) {
//            case 0:
//            {
//                QGUserPostsViewController *vc = [[QGUserPostsViewController alloc] init];
//                vc.title = @"我的发布";
//                vc.editAble = YES;
//                vc.type = UserPostTypePublished;
//                [self.navigationController pushViewController:vc animated:YES];
//
//            }break;
//            case 1:
//            {
//                QGMyParticipateViewController *vc = [QGMyParticipateViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
//            }break;
//            case 2:
//            {
//                QGMyCollectionViewController *vc = [QGMyCollectionViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
//            }break;
//
//            default:
//                break;
//        }
//    }

	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
			{//参与
				QGMyParticipateViewController *vc = [QGMyParticipateViewController new];
				[self.navigationController pushViewController:vc animated:YES];

			}break;
			case 1:
			{
				//课程订单
				QGActivOrderViewController *vc = [QGActivOrderViewController new];
				[self.navigationController pushViewController:vc animated:YES];

			}break;
			case 2:
			{
				NSLog(@"老师入驻");
				if ([BLUAppManager sharedManager].currentUser.teacher_id>0) {
					//修改
					QGTeacherWaitController *vc = [QGTeacherWaitController new];
					[self.navigationController pushViewController:vc animated:YES];
				}else
				{
					//==0老师
					QGTeacherEnterPrivacyController *vc = [QGTeacherEnterPrivacyController new];
					[self.navigationController pushViewController:vc animated:YES];
				}
//				QGTeacherEnterPrivacyController *vc = [QGTeacherEnterPrivacyController new];
//				[self.navigationController pushViewController:vc animated:YES];
				
//				QGTeacherWaitController *vc = [QGTeacherWaitController new];
//				[self.navigationController pushViewController:vc animated:YES];
				
			}break;

			default:
				break;
		}
	}

    _isPush = YES;

}


#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _userBlurView.frame =
    CGRectMake(0, 0, self.view.width, -self.tableView.contentOffset.y + self.navigationBarHeight + kUserInfoViewHeight - 44);

//	_userBlurView.frame =
//    CGRectMake(0, 0, self.view.width, -self.tableView.contentOffset.y + self.navigationBarHeight + kHeight - 44);

}

#pragma mark - OrderCellDalegate

- (void)shouldPushOrderVC:(UIButton *)button{
    if([self loginIfNeeded]){
        return;
    }
    if (button.tag == 100) {// 课程订单
        QGActivOrderViewController *vc = [QGActivOrderViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (button.tag == 101) {// 活动订单
        QGActivOrderViewController *vc = [QGActivOrderViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (button.tag == 102) {// 商城订单
        
        QGMallOrderViewController *vc = [QGMallOrderViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        QGEducatiionOrderViewController *vc = [QGEducatiionOrderViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    _isPush = YES;
}


#pragma mark -  QGUserInfoViewDelegate
/**
//登录
- (void)shouldLoginFromUserInfoView:(QGUserInfoView *)userInfoView
{
    
    if ([self loginIfNeeded]) {
        return;
    };
    QGLoginViewController *LoginViewController= [[QGLoginViewController alloc]init];
    QGNavigationViewController *nav = [[QGNavigationViewController alloc]initWithRootViewController:LoginViewController];
    [self presentViewController:nav animated:YES completion:nil];
}


// 消息中心
- (void)shouldShowNewsFromUserInfoView:(QGUserInfoView *)userInfoView{
    if ([self loginIfNeeded]) {
        return;
    };
    QGMessageCenterViewController *vc = [QGMessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    _isPush = YES;
}

// 签到
- (void)shouldSignActionfromUserInfoView:(QGUserInfoView *)userInfoView{
    if ([self loginIfNeeded]) {
        return;
    };
    [self.view showIndicator];
    @weakify(self);
    [QGHttpManager UserCheckInSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self.view hideIndicator];
        [self showUserRewardPromptIndicatorWithUserProfit:responseObject];
        self.userInfoView.signImageButton.enabled = NO;
        self.userInfoView.signTitleButton.enabled = NO;
        [self.userInfoView layoutSubviews];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self.view hideIndicator];
    }];
}

// 设置
- (void)shouldSettingUesrInfoFromUserInfoView:(QGUserInfoView *)userInfoView{

    QGSettingViewController *settingVC = [QGSettingViewController new];
    [self.navigationController pushViewController:settingVC animated:YES];
    _isPush = YES;
}

// 粉丝
- (void)shouldShowFollowingsFromUserInfoView:(QGUserInfoView *)userInfoView {
    if ([self loginIfNeeded]) {
        return;
    };
    QGMyFollowViewController *vc = [QGMyFollowViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    _isPush = YES;
}

- (void)shouldShowFollowersFromUserInfoView:(QGUserInfoView *)userInfoView {
    if ([self loginIfNeeded]) {
        return;
    };
    [self showUsersViewControllerWithType:BLUUsersViewModelTypeFollower];
}

- (void)showUsersViewControllerWithType:(BLUUsersViewModelType)type {
    if ([self loginIfNeeded]) {
        return;
    };
    BLUUsersViewModel *usersViewModel = [BLUUsersViewModel new];
    usersViewModel.userID = self.user.userID;
    usersViewModel.type = type;
    BLUUsersViewController *vc = [[BLUUsersViewController alloc] initWithUsersViewModel:usersViewModel];
    if (type == BLUUsersViewModelTypeFollowing) {
        vc.title = NSLocalizedString(@"other-user-vc.users-vc.title.following", @"Followings");
    } else {
        vc.title = NSLocalizedString(@"other-user-vc.users-vc.title.follower", @"Followers");
    }
    [self.navigationController pushViewController:vc animated:YES];
    _isPush = YES;
}
*/

#pragma mark
//登录
- (void)shouldLoginFromUserInfoView:(QGNewUserInfoView *)userInfoView
{
    
    if ([self loginIfNeeded]) {
        return;
    };
    QGLoginViewController *LoginViewController= [[QGLoginViewController alloc]init];
    QGNavigationViewController *nav = [[QGNavigationViewController alloc]initWithRootViewController:LoginViewController];
    [self presentViewController:nav animated:YES completion:nil];
}
// 签到
- (void)shouldSignActionfromUserInfoView:(QGNewUserInfoView *)userInfoView{
    if ([self loginIfNeeded]) {
        return;
    };
    [self.view showIndicator];
    @weakify(self);
    [QGHttpManager UserCheckInSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self.view hideIndicator];
        [self showUserRewardPromptIndicatorWithUserProfit:responseObject];
		[self.myUserInfoView.signBtn setTitle:@"已签到" forState:UIControlStateNormal];
		self.myUserInfoView.signBtn.enabled = NO;

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self.view hideIndicator];
		[self showTopIndicatorWithSuccessMessage:@"签到失败"];
    }];
}

// 设置
- (void)shouldSettingUesrInfoFromUserInfoView:(QGNewUserInfoView *)userInfoView{

    QGSettingViewController *settingVC = [QGSettingViewController new];
    [self.navigationController pushViewController:settingVC animated:YES];
    _isPush = YES;
}
// 消息中心
- (void)shouldShowNewsFromUserInfoView:(QGNewUserInfoView *)userInfoView{
    if ([self loginIfNeeded]) {
        return;
    };
    QGMessageCenterViewController *vc = [QGMessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    _isPush = YES;
}
// 收藏
- (void)shouldCollectionfromUserInfoView:(QGNewUserInfoView *)userInfoView{
    if ([self loginIfNeeded]) {
        return;
    };
    QGMyCollectionViewController *vc = [QGMyCollectionViewController new];
	[self.navigationController pushViewController:vc animated:YES];
    _isPush = YES;
}

// 粉丝
- (void)shouldShowFollowingsFromUserInfoView:(QGNewUserInfoView *)userInfoView {
    if ([self loginIfNeeded]) {
        return;
    };
    QGMyFollowViewController *vc = [QGMyFollowViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    _isPush = YES;
}
//关注的人
- (void)shouldShowFollowersFromUserInfoView:(QGNewUserInfoView *)userInfoView {
    if ([self loginIfNeeded]) {
        return;
    };
    [self showUsersViewControllerWithType:BLUUsersViewModelTypeFollower];
}
- (void)showUsersViewControllerWithType:(BLUUsersViewModelType)type {
    if ([self loginIfNeeded]) {
        return;
    };
    BLUUsersViewModel *usersViewModel = [BLUUsersViewModel new];
    usersViewModel.userID = self.user.userID;
    usersViewModel.type = type;
    BLUUsersViewController *vc = [[BLUUsersViewController alloc] initWithUsersViewModel:usersViewModel];
    if (type == BLUUsersViewModelTypeFollowing) {
        vc.title = NSLocalizedString(@"other-user-vc.users-vc.title.following", @"Followings");
    } else {
        vc.title = NSLocalizedString(@"other-user-vc.users-vc.title.follower", @"Followers");
    }
    [self.navigationController pushViewController:vc animated:YES];
    _isPush = YES;
}
@end
