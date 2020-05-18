//
//  QGViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/6/6.
//
//

#import "QGViewController.h"
#import "QGJpushService.h"
#import "QGAnalyticsService.h"
#import "QGRemoteNotiModel.h"
#import "QGLoginViewController.h"
#import "QGNavigationViewController.h"
#import "BLUUserProfit.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUWebViewController.h"
#import "BLUPostTagDetailViewController.h"
#import "QGCardMessageViewController.h"
#import "QGOrderMessageViewController.h"
#import "QGActivMessageViewController.h"
#import "BLUDialogueViewController.h"
#import "QGDynamicViewController.h"
#import "QGActivityDetailViewController.h"
#import "QGActivityHomeViewController.h"
#import "QGCourseDetailViewController.h"
#import "QGTeacherViewController.h"
#import "QGOrgViewController.h"
#import "QGOrganizationListViewController.h"
#import "QGProductDetailsViewController.h"
#import "QGOrgAllCourseViewController.h"
#import "QGOrgAllTeacherViewController.h"
#import "QGSearchResultViewController.h"
#import "QGHttpManager+User.h"

@interface QGViewController ()

@property (nonatomic, assign) BOOL firstWillAppear;
@property (nonatomic, assign) BOOL firstDidAppear;

@property (nonatomic, strong) UILabel *cannotFindLabel;
@property (nonatomic, strong) UIImageView *cannotFindImageView;
@property (nonatomic, strong) UIView *cannotFindView;
@property (nonatomic, assign) BOOL showNoContentPrompt;

@end

@implementation QGViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoteNotification:) name:QGJpushServiceRemoteNotification object:nil];
    
    [QGAnalyticsService beginLogPageViewWithClass:[self class] name:self.title];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginIfError:) name:@"QGApiManagerLoginRequireNotification" object:nil];
    
    if (self.firstWillAppear) {
        [self viewWillFirstAppear];
        self.firstWillAppear = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view hideIndicator];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QGJpushServiceRemoteNotification object:nil];
    [QGAnalyticsService endLogPageViewWithClass:[self class] name:self.title];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QGApiManagerLoginRequireNotification" object:nil];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.firstWillAppear = YES;
    self.firstDidAppear = YES;
//    [self initBaseData];
    
    self.view.backgroundColor = COLOR(242, 243, 244, 1);
    
}

- (void)viewWillFirstAppear{
    
    
}
#pragma mark - Remote notification


- (void)handleRemoteNotification:(NSNotification *)userInfo {
    QGRemoteNotiModel *notification = userInfo.object;
    UIViewController *goToVc = nil;
    switch (notification.type){
        case QGRemoteNotificationTypeGoods: {
            // 商品详情
            NSInteger objectID = notification.objectID;
            QGProductDetailsViewController *vc = [QGProductDetailsViewController new];
            vc.goods_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeCostom: {
            // 网页
            if (notification.url) {
                BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:notification.url];
                vc.title = @"七巧国";
                goToVc = vc;
            }
            break;
        }
        case QGRemoteNotificationTypeEdu: {
            if (self.tabBarController) {
                [self.tabBarController setSelectedIndex:1];
            }
            break;
        }
        case QGRemoteNotificationTypeOrgList: {
            // 机构列表
            QGSearchResultViewController *vc = [QGSearchResultViewController new];
            vc.searchOptionType = QGSearchOptionTypeInstitution;
            vc.keyWord = @"";
            goToVc = vc;
            
            break;
        }
        case QGRemoteNotificationTypeTeacherList: {
            // 老师列表
            NSInteger objectID = notification.objectID;
            QGOrgAllTeacherViewController *vc = [QGOrgAllTeacherViewController new];
            vc.org_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeCourseList: {
            // 课程列表
            QGSearchResultViewController *vc = [QGSearchResultViewController new];
            vc.searchOptionType = QGSearchOptionTypeCourse;
            vc.keyWord = @"";
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeOrgDetail: {
            // 机构详情
            NSInteger objectID = notification.objectID;
            QGOrgViewController *vc = [QGOrgViewController new];
            vc.org_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeTeacherDetail: {
            // 老师详情
            NSInteger objectID = notification.objectID;
            QGTeacherViewController *vc = [QGTeacherViewController new];
            vc.teacher_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeCourseDetail: {
            // 课程详情
            NSInteger objectID = notification.objectID;
            QGCourseDetailViewController *vc = [QGCourseDetailViewController new];
            vc.course_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeActiv: {
            // 活动首页
            if (self.tabBarController) {
                [self.tabBarController setSelectedIndex:1];
            }
            break;
//            QGActivityHomeViewController *vc = [QGActivityHomeViewController new];
//            goToVc = vc;
//            break;
        }
        case QGRemoteNotificationTypeActivDetail: {
            // 活动详情
            NSInteger objectID = notification.objectID;
            QGActivityDetailViewController *vc = [QGActivityDetailViewController new];
            vc.activity_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeCircle: {
            // 巧妈帮
            if (self.tabBarController) {
                [self.tabBarController setSelectedIndex:2];
            }
            
        }
        case QGRemoteNotificationTypePost: {
            // 帖子详情
            NSInteger objectID = notification.objectID;
            BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:objectID];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeCircleDetail: {
            // 某一个圈子
            NSInteger objectID = notification.objectID;
            BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:objectID];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypePostTag: {
            // 帖子标签列表
            NSInteger objectID = notification.objectID;
            BLUPostTagDetailViewController *vc =
            [[BLUPostTagDetailViewController alloc] initWithTagID:objectID];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeChatMeassage: {
            // 私信消息
            BLUDialogueViewController *vc = [BLUDialogueViewController new];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeCardMeassage: {
            // 优惠券消息
            QGCardMessageViewController *vc = [QGCardMessageViewController new];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypePostMeassage: {
            // 帖子动态
            QGDynamicViewController *vc = [QGDynamicViewController new];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeActivMeassage: {
            // 活动助手
            QGActivMessageViewController *vc = [QGActivMessageViewController new];
            vc.type= QGMessageTypeActiv;
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeOrderMeassage: {
            // 订单助手
            QGOrderMessageViewController *vc = [QGOrderMessageViewController new];
            goToVc = vc;
            break;
        }
        case QGRemoteNotificationTypeEduOrderMeassage: {
            // 教育订单助手
            QGActivMessageViewController *vc = [QGActivMessageViewController new];
            vc.type = QGMessageTypeEdu;
            goToVc = vc;
            break;
            break;
        }
    }
    
    
    if (notification.showInfoDirectly) {
        if ([self.view window]) {
            if (self.navigationController && goToVc) {
                [self.navigationController pushViewController:goToVc animated:YES];
            } else {
            
                if (goToVc) {
                [self presentViewController:goToVc animated:YES completion:nil];
                }
             
            }
        }
    } else {
        //        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        //        [[NSNotificationCenter defaultCenter] postNotificationName:QGMessageShowRedDotNotification object:userInfo];
    }
}

- (void)setTitle:(NSString *)title {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorFromHexString:@"333333"];
    [titleLabel sizeToFit];
    if (self.navigationItem.titleView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:titleLabel.frame];
        self.navigationItem.titleView = view;
        [self.navigationItem.titleView addSubview:titleLabel];
    }else
    {
        [self.navigationItem.titleView removeFromSuperview];
        UIView *view = [[UIView alloc]initWithFrame:titleLabel.frame];
        self.navigationItem.titleView = view;
        [self.navigationItem.titleView addSubview:titleLabel];
    }

}

#pragma mark - 获取用户消息
- (void)getUserMessageCount{
    
    if (![[BLUAppManager sharedManager] didUserLogin]) {
        return ;
    }
    
    [QGHttpManager getUserMessageConutSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *countStr = responseObject[@"notifyCount"];
        _messageCount = countStr.integerValue;
        [self updateUserMessageCount];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark - Login required.

- (void)loginRequired:(NSNotification *)userInfo {
    BLULogVerbose(@"Login request");
    if ([self isKindOfClass:[QGLoginViewController class]]) {
        return ;
    }
    [[BLUApiManager sharedManager] deleteAllCookie];
    [SAUserDefaults removeWithKey:USERDEFAULTS_COOKIE];
    QGLoginViewController *loginVc= [[QGLoginViewController alloc]init];
    
 
    UINavigationController *nav = [[QGNavigationViewController alloc]initWithRootViewController:loginVc];
      nav.modalPresentationStyle = 0;
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)loginIfError:(NSNotification *)userInfo {
    
    if ([self isKindOfClass:[QGLoginViewController class]]) {
        return ;
    }
    
    [self performSelector:@selector(gotoLogin) withObject:nil afterDelay:1.5];
    
}

- (void)gotoLogin{
    QGLoginViewController *loginVc= [[QGLoginViewController alloc]init];
    QGNavigationViewController *nav = [[QGNavigationViewController alloc]initWithRootViewController:loginVc];
    [self presentViewController:nav animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

}

- (BOOL)loginIfNeeded {
    if ([[BLUAppManager sharedManager] didUserLogin]) {
        return NO;
    } else {
        [self loginRequired:nil];
        return YES;
    }
}

#pragma mark - 下拉刷新控件

- (void)tableViewEndRefreshing:(UITableView *)tableView {
    
    if (tableView.mj_header) {
        [tableView.mj_header endRefreshing];
    }
    
    if (tableView.mj_footer) {
        [tableView.mj_footer endRefreshing];
    }
    
}

- (void)tableViewEndRefreshing:(UITableView *)tableView noMoreData:(BOOL)noMoreData {
    if (tableView.mj_footer) {
        if (noMoreData) {
            [tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [tableView.mj_footer endRefreshing];
        }
    }
    
    if (tableView.mj_header) {
        [tableView.mj_header endRefreshing];
    }
}

#pragma mark - Top indicator UI.

- (void)showTopIndicatorWithError:(NSError *)error {
    if ([error isKindOfClass:[NSString class]]) {
        [self showTopIndicatorWithMessage:(NSString *)error image:[UIImage imageNamed:@"common-failed-prompt-icon"]];
        return;
    }
    [self showTopIndicatorWithMessage:error.localizedDescription image:[UIImage imageNamed:@"common-failed-prompt-icon"]];
}

- (void)showTopIndicatorWithErrorMessage:(NSString *)errorMessage {
    [self showTopIndicatorWithMessage:errorMessage image:[UIImage imageNamed:@"common-failed-prompt-icon"]];
}

- (void)showTopIndicatorWithSuccessMessage:(NSString *)message {
    [self showTopIndicatorWithMessage:message image:[UIImage imageNamed:@"common-success-prompt-icon"]];
}

- (void)showTopIndicatorWithMessage:(NSString *)message image:(UIImage *)image {
    UIView *indicatorView = [UIView new];
    indicatorView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.8];
    indicatorView.X = 0;
    indicatorView.Y = 0;
    indicatorView.width = self.view.width;
    indicatorView.alpha = 0.0;
    [self.view addSubview:indicatorView];
    [self.view bringSubviewToFront:indicatorView];
    
    UIImageView *imageView = [UIImageView new];
    if (image) {
        imageView.image = image;
    }
    
    //    UILabel *titleLabel = [UILabel makeThemeLabelWithType:QGLabelTypeTitle];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = message;
    titleLabel.numberOfLines = 2;
    
    [indicatorView addSubview:imageView];
    [indicatorView addSubview:titleLabel];
    
    [imageView sizeToFit];
    
    CGFloat titleLabelMaxWidth = indicatorView.width - 4 * 9 - imageView.width;
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(titleLabelMaxWidth, CGFLOAT_MAX)];
    
    titleLabel.size = titleLabelSize;
    
    CGFloat contentWidth = imageView.width + titleLabel.width + 4;
    imageView.X = indicatorView.width / 2.0 - contentWidth / 2.0;
    titleLabel.X = imageView.right + 4;
    
    indicatorView.height = 4 * 6 + titleLabel.height;
    imageView.centerY = indicatorView.height / 2.0;
    titleLabel.centerY = indicatorView.height / 2.0;
    
    CGFloat height = self.navigationController.navigationBarHidden ? 64 : self.topLayoutGuide.length;
    
    [UIView animateWithDuration:0.2 animations:^{
        indicatorView.alpha = 1.0;
        indicatorView.Y = height;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:2.0 options:0 animations:^{
            indicatorView.alpha = 0.0;
            indicatorView.Y = 0;
        } completion:^(BOOL finished) {
            [indicatorView removeFromSuperview];
        }];
    }];
}

- (void)showTopIndicatorWithWarningMessage:(NSString *)message {
    [self showTopIndicatorWithMessage:message image:[UIImage imageNamed:@"common-info-prompt"]];
}
#pragma mark - Public Accessor

- (CGFloat)statusBarHeight {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

- (CGFloat)navigationBarHeight {
    return self.navigationController.navigationBar.height;
}

- (CGFloat)tabBarHeight {
    return self.tabBarController.tabBar.height;
}

- (void)initBaseData
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _page = 1;
    [self createNavImageView];
}

- (void)createBgImageView
{
    SAImageView *bgImageView = [[SAImageView alloc]init];
    bgImageView.frame = self.view.bounds;

    [self.view addSubview:bgImageView];
    [self.view insertSubview:bgImageView belowSubview:_navImageView];
}

#pragma mark Nav Method
- (void)createNavImageView
{
    _navImageView = [[SAImageView alloc]init];
//    _navImageView.frame = CGRectMake(0, 0, self.view.width, PL_UTILS_IOS7 ? 64 : 44);
    _navImageView.frame = CGRectMake(0, 0, self.view.width, IS_IPhoneX_All ? Height_TopBar : 64);
    _navImageView.backgroundColor = [UIColor whiteColor];
    UIView *vc = [[UIView alloc] initWithFrame:CGRectMake(0, Height_TopBar-1, self.view.width, 1)];
    vc.backgroundColor = COLOR(222, 222, 222, 1);
    [_navImageView addSubview:vc];
    [self.view addSubview:_navImageView];
}


- (void)createNavLeftImageBtn:(NSString *)imageName
{
    if(!_leftBtn)
    {
        _leftBtn = [SAButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, _navImageView.height - 49, 50, 49);
        [_leftBtn setNormalImage:imageName];
        PL_CODE_WEAK(weakSelf)
        [_leftBtn addClick:^(SAButton *button) {
            [weakSelf navLeftBtnClick];
        }];
        [_navImageView addSubview:_leftBtn];
    }
}
- (void)navLeftBtnClick
{
    
}


- (void)createNavRightBtn:(NSString *)textName
{
    if(!_rightBtn)
    {
        _rightBtn = [SAButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [SAUtils getCGSzieWithText:textName width:200 height:10000 font:_rightBtn.titleLabel.font];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH - size.width - 25, _navImageView.height - 46, size.width + 20, 49);
        _rightBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        _rightBtn.titleLabel.textAlignment=NSTextAlignmentRight;
        [_rightBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_rightBtn setNormalTitle:textName];
        PL_CODE_WEAK(weakSelf)
        [_rightBtn addClick:^(SAButton *button) {
            [weakSelf navRightBtnClick];
        }];
        [_navImageView addSubview:_rightBtn];
    }
}


- (void)navRightImageViewIsNullBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoVC" object:nil userInfo:@{@"首页":@"0"}];
}
- (void)navRightBtnClick
{

}

- (void)createReturnButton
{
    if(!_leftBtn)
    {
        _leftBtn = [SAButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, _navImageView.height - 49, 50, 49);
        [_leftBtn setNormalImage:@"icon_classification_back"];
        PL_CODE_WEAK(weakSelf)
        [_leftBtn addClick:^(SAButton *button) {
//            [[QGRequest sharedInstance] cancelRequest];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [_navImageView addSubview:_leftBtn];
    }
}
- (void)createCustomReturnButton
{
    if(!_customLeftBtn)
    {
        _customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _customLeftBtn.frame = CGRectMake(0, _navImageView.height - 49, 50, 44);
        [_customLeftBtn setImage:[UIImage imageNamed:@"icon_classification_back"] forState:UIControlStateNormal];
        PL_CODE_WEAK(weakSelf)
        [_customLeftBtn addClick:^(UIButton *button) {
            
            [weakSelf navCustomLeftBtnClick];
        }];
        [_navImageView addSubview:_customLeftBtn];
    }
}
- (void)navCustomLeftBtnClick
{
    
}
- (void)createNavTitle:(NSString *)text
{
    if(!_navTitleLabel)
    {
        _navTitleLabel = [[SALabel alloc]init];
        _navTitleLabel.frame = CGRectMake(60, self.navImageView.height - 49, SCREEN_WIDTH - 60 * 2, 49);
        _navTitleLabel.numberOfLines = 1;
        _navTitleLabel.text = text;
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.font = [UIFont systemFontOfSize:17];
        _navTitleLabel.textColor = QGTitleColor;
        
        [self.navImageView addSubview:_navTitleLabel];
    }
}


#pragma mark KeyBoard Method
- (void)addKeyboardNotification
{
    PL_CODE_NOTIFICATION_ADD(UIKeyboardWillShowNotification, keyboardWillShow:)
    PL_CODE_NOTIFICATION_ADD(UIKeyboardWillHideNotification, keyboardWillHide:)
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self addBaseTapGesture];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self removeBaseTapGesture];
}

- (void)addBaseTapGesture
{
    if(!_baseTap)
    {
        _baseTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(baseTapGesture:)];
        [self.view addGestureRecognizer:_baseTap];
    }
}

- (void)baseTapGesture:(UITapGestureRecognizer *)tap
{
    PL_CODE_RETURNKEYBOARD
}

- (void)removeBaseTapGesture
{
    [self.view removeGestureRecognizer:_baseTap];
    _baseTap = nil;
}

- (void)dealloc
{
    PL_CODE_NOTIFICATION_REMOVE(UIKeyboardWillShowNotification)
    PL_CODE_NOTIFICATION_REMOVE(UIKeyboardWillHideNotification)
    NSLog(@"释放类%@",NSStringFromClass([self class]));
    
    [[[QGHttpManager sharedManager] operationQueue]cancelAllOperations];
    
    
}

// 空记录提示
- (void)showEmpty
{
    if(!_emptyImageView)
    {
        _emptyImageView = [[SAImageView alloc]init];
        UIImage *emptyImage = [UIImage imageNamed:@"no-orders"];
        
        _emptyImageView.image = emptyImage;
        _emptyImageView.frame = CGRectMake((self.view.width - emptyImage.size.width) / 2, (self.view.height - emptyImage.size.height) / 2, emptyImage.size.width, emptyImage.size.height);
        [self.view addSubview:_emptyImageView];
    }
}
- (void)showEmptyString:(NSString *)imagename
{
    if(!_emptyPic)
    {
        _emptyPic = [[SAImageView alloc]init];
        UIImage *emptyImage = [UIImage imageNamed:imagename];
        
        _emptyPic.image = emptyImage;
        _emptyPic.frame = CGRectMake((self.view.width - emptyImage.size.width) / 2, (self.view.height - emptyImage.size.height) / 2, emptyImage.size.width, emptyImage.size.height);
        [self.view addSubview:_emptyPic];
    }
}
- (void)hiddenEmpty
{
    if(_emptyImageView)
    {
        PL_CODE_SAFEREMOVEW(_emptyImageView)
    }
    if(_emptyPic)
    {
        PL_CODE_SAFEREMOVEW(_emptyPic)
    }
}

#pragma mark - User Reward.

- (void)showUserRewardPromptIndicatorWithUserProfit:(BLUUserProfit *)profit {
    
    NSInteger itemCount = 1;
    
    if (profit.coin > 0 && profit.exp > 0) {
        itemCount = 2;
    } else {
        itemCount = 1;
    }
    
    if (itemCount == 2) {
        UIView *customView = [UIView new];
        
        UILabel *titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        titleLabel.textColor = [UIColor whiteColor];
        
        BLUSolidLine *separator = [BLUSolidLine new];
        separator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        
        UIImageView *leftImageView = [UIImageView new];
        leftImageView.image = [UIImage imageNamed:@"user-exp-indicator"];
        
        UIImageView *rightImageView =[ UIImageView new];
        rightImageView.image = [UIImage imageNamed:@"user-coin-indicator"];
        
        UILabel *leftPromptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        leftPromptLabel.textColor = titleLabel.textColor;
        
        UILabel *rightPromptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        rightPromptLabel.textColor = titleLabel.textColor;
        
        [customView addSubview:titleLabel];
        [customView addSubview:separator];
        [customView addSubview:leftImageView];
        [customView addSubview:rightImageView];
        [customView addSubview:leftPromptLabel];
        [customView addSubview:rightPromptLabel];
        
        titleLabel.text = profit.title;
        leftPromptLabel.text = profit.expDesc;
        rightPromptLabel.text = profit.coinDesc;
        
        [titleLabel sizeToFit];
        titleLabel.y = BLUThemeMargin * 2;
        
        separator.x = 0;
        separator.y = titleLabel.bottom + BLUThemeMargin;;
        separator.height = BLUThemeOnePixelHeight;
        
        leftImageView.y = separator.bottom + BLUThemeMargin * 2;
        leftImageView.width = 20;
        leftImageView.height = 20;
        
        rightImageView.y = leftImageView.y;
        rightImageView.width = leftImageView.width;
        rightImageView.height = leftImageView.height;
        
        [leftPromptLabel sizeToFit];
        leftPromptLabel.y = leftImageView.bottom;
        leftPromptLabel.width = leftPromptLabel.width > leftImageView.width ? leftPromptLabel.width : leftImageView.width;
        leftPromptLabel.textAlignment = NSTextAlignmentCenter;
        
        [rightPromptLabel sizeToFit];
        rightPromptLabel.y = leftPromptLabel.y;
        rightPromptLabel.width = rightPromptLabel.width > rightImageView.width ? rightPromptLabel.width : rightImageView.width;
        rightPromptLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat contentWidth = 0.0;
        
        contentWidth = contentWidth > titleLabel.width ? contentWidth : titleLabel.width;
        CGFloat maxLabelSectionWidth = leftPromptLabel.width > rightPromptLabel.width ? leftPromptLabel.width : rightPromptLabel.width;
        maxLabelSectionWidth = maxLabelSectionWidth * 2 + BLUThemeMargin * 4;
        contentWidth = contentWidth > maxLabelSectionWidth ? contentWidth : maxLabelSectionWidth;
        contentWidth += BLUThemeMargin * 4;
        
        contentWidth = contentWidth > leftPromptLabel.bottom + BLUThemeMargin * 2 ? contentWidth : leftPromptLabel.bottom + BLUThemeMargin;
        contentWidth += BLUThemeMargin * 6;
        customView.frame = CGRectMake(0, 0, contentWidth, leftPromptLabel.bottom + BLUThemeMargin * 2);
        
        titleLabel.centerX = contentWidth / 2;
        separator.width = contentWidth;
        leftPromptLabel.centerX = contentWidth / 4.0 + BLUThemeMargin;
        rightPromptLabel.centerX = contentWidth / 4.0 * 3.0 - BLUThemeMargin;
        leftImageView.centerX = leftPromptLabel.centerX;
        rightImageView.centerX = rightPromptLabel.centerX;
        
        customView.cornerRadius = 10;
        customView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.8];
        customView.alpha = 0;
        customView.center = [UIApplication sharedApplication].keyWindow.center;
        
        [[UIApplication sharedApplication].keyWindow addSubview:customView];
        
        [UIView animateWithDuration:0.2 animations:^{
            customView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:1 options:0 animations:^{
                customView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [customView removeFromSuperview];
            }];
        }];
    } else if (itemCount == 1) {
        UIView *customView = [UIView new];
        
        UILabel *titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        titleLabel.textColor = [UIColor whiteColor];
        
        BLUSolidLine *separator = [BLUSolidLine new];
        separator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        
        UIImageView *leftImageView = [UIImageView new];
        
        UILabel *leftPromptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        leftPromptLabel.textColor = titleLabel.textColor;
        
        [customView addSubview:titleLabel];
        [customView addSubview:separator];
        [customView addSubview:leftImageView];
        [customView addSubview:leftPromptLabel];
        
        titleLabel.text = profit.title;
        if (profit.coin > 0) {
            leftPromptLabel.text = profit.coinDesc;
            leftImageView.image = [UIImage imageNamed:@"user-coin-indicator"];
        } else {
            leftPromptLabel.text = profit.expDesc;
            leftImageView.image = [UIImage imageNamed:@"user-exp-indicator"];
        }
        
        [titleLabel sizeToFit];
        titleLabel.y = BLUThemeMargin * 2;
        
        separator.x = 0;
        separator.y = titleLabel.bottom + BLUThemeMargin;;
        separator.height = BLUThemeOnePixelHeight;
        
        leftImageView.y = separator.bottom + BLUThemeMargin * 2;
        leftImageView.width = 20;
        leftImageView.height = 20;
        
        [leftPromptLabel sizeToFit];
        leftPromptLabel.y = leftImageView.bottom;
        leftPromptLabel.width = leftPromptLabel.width > leftImageView.width ? leftPromptLabel.width : leftImageView.width;
        leftPromptLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat contentWidth = 0.0;
        
        contentWidth = contentWidth > titleLabel.width ? contentWidth : titleLabel.width;
        CGFloat maxLabelSectionWidth = leftPromptLabel.width;
        maxLabelSectionWidth = maxLabelSectionWidth + BLUThemeMargin * 2;
        contentWidth = contentWidth > maxLabelSectionWidth ? contentWidth : maxLabelSectionWidth;
        contentWidth += BLUThemeMargin * 4;
        
        contentWidth = contentWidth > leftPromptLabel.bottom + BLUThemeMargin * 2 ? contentWidth : leftPromptLabel.bottom + BLUThemeMargin;
        customView.frame = CGRectMake(0, 0, contentWidth, leftPromptLabel.bottom + BLUThemeMargin * 2);
        
        titleLabel.centerX = contentWidth / 2;
        separator.width = contentWidth;
        leftPromptLabel.centerX = contentWidth / 2.0;
        leftImageView.centerX = leftPromptLabel.centerX;
        
        customView.cornerRadius = 10;
        customView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.8];
        customView.alpha = 0;
        customView.center = [UIApplication sharedApplication].keyWindow.center;
        [[UIApplication sharedApplication].keyWindow addSubview:customView];
        
        [UIView animateWithDuration:0.2 animations:^{
            customView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:2.0 options:0 animations:^{
                customView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [customView removeFromSuperview];
            }];
        }];
    }
}


#pragma mark - Public Method

- (void)addTiledLayoutConstrantForView:(UIView *)view {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = @{@"view": view};
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"H:|-(0)-[view]-(0)-|"
      options:0 metrics:nil views:viewsDictionary]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
      options:0 metrics:nil views:viewsDictionary]];
    
}

- (UIImageView *)cannotFindImageView {
    if (_cannotFindImageView == nil) {
        _cannotFindImageView = [UIImageView new];
        _cannotFindImageView.image = [UIImage imageNamed:@"search-notfind"];
    }
    return _cannotFindImageView;
}

- (UILabel *)cannotFindLabel {
    if (_cannotFindLabel == nil) {
        _cannotFindLabel = [UILabel new];
        _cannotFindLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00];
        _cannotFindLabel.text = @"没有相关数据~";
        
    }
    return _cannotFindLabel;
}

- (UIView *)cannotFindView {
    if (_cannotFindView == nil) {
        _cannotFindView = [UIView new];
    }
    return _cannotFindView;
}

- (void)configCannotView {
    
    [self.view addSubview:self.cannotFindView];
    [self.cannotFindView addSubview:self.cannotFindImageView];
    [self.cannotFindView addSubview:self.cannotFindLabel];
    
    [self.cannotFindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(- 40);
    }];
    
    UIView *superview = self.cannotFindView;
    
    [self.cannotFindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview);
        make.left.greaterThanOrEqualTo(superview);
        make.right.lessThanOrEqualTo(superview);
        make.centerX.equalTo(superview);
    }];
    
    [self.cannotFindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cannotFindImageView.mas_bottom).offset(BLUThemeMargin * 2);
        make.centerX.equalTo(superview);
        make.left.greaterThanOrEqualTo(superview);
        make.right.lessThanOrEqualTo(superview);
        make.bottom.equalTo(superview);
    }];
}

- (void)showCannotViewIfNeed:(BOOL)hidden {
    if (![self.view isDescendantOfView:self.cannotFindView]) {
        [self configCannotView];
    }
    self.cannotFindView.hidden = hidden;
}

- (void)shareManage:(BLUShareManager *)shareManage
     didShareObject:(id <BLUShareObject>)object
        withMessage:(NSString *)message {
    [self showTopIndicatorWithSuccessMessage:message];
}


@end
