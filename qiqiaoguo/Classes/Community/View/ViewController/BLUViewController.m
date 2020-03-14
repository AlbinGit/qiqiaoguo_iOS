//
//  BLUViewController.m
//  Blue
//
//  Created by Bowen on 30/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUPasscodeLockViewController.h"
#import "BLUKeyChainUtils.h"
//#import "BLUAnalyticsService.h"
#import "QGJpushService.h"
#import "BLUApiManager.h"
#import "BLULoginViewController.h"
#import "BLUApService.h"
#import "BLURemoteNotification.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUWebViewController.h"
#import "BLUAps.h"
#import "BLUDynamicViewController.h"
#import "BLUDialogueViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "BLUMessageViewController.h"
#import "BLUUserProfit.h"
#import "BLUApiManager+User.h"
#import "BLUUserBalance.h"
#import "BLUPostTagDetailViewController.h"
#import "BLUCircleMainViewController.h"

#import "MyCircleMainViewController.h"
#import "QGAnalyticsService.h"
#import "QGLoginViewController.h"
#import "QGNavigationViewController.h"
//#import "BLUGoodDetailsViewController.h"

NSInteger BLUTabbarRedDotBaseTag = 6900;
NSString * BLUMessageShowRedDotNotification = @"BLUMessageShowRedDotNotification";

@interface BLUViewController ()

@property (nonatomic, assign) BOOL firstWillAppear;
@property (nonatomic, assign) BOOL firstDidAppear;
@property (nonatomic, strong) UIViewController *targetViewController;

@end

@implementation BLUViewController

#pragma mark - Life Circle

- (instancetype)init {
    if (self = [super init]) {

        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    
#ifdef BLUViewControllerVerboseLog
    BLULogVerbose(@"%@ did load", self.class);
#endif
    
    self.firstWillAppear = YES;
    self.firstDidAppear = YES;
}

- (void)setTitle:(NSString *)title {

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorFromHexString:@"333333"];
    [titleLabel sizeToFit];

    self.navigationItem.titleView = titleLabel;
}

- (void)leftBarButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#ifdef BLUViewControllerVerboseLog
    BLULogVerbose(@"%@ will appear.", self.class);
#endif
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    self.navigationController.navigationBar.topItem.title = @" ";

    [QGAnalyticsService beginLogPageViewWithClass:[self class] name:self.title];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginifError:) name:BLUApiManagerLoginRequireNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoteNotification:) name:BLUApServiceRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoteNotification:) name:QGJpushServiceRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserProfit:) name:BLUApiManagerUserProfitNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNocoinWarningNotification:) name:BLUUserBalanceCoinWarningNotification object:nil];

    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];

    if (self.firstWillAppear) {
        [self viewWillFirstAppear];
        self.firstWillAppear = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
#ifdef BLUViewControllerVerboseLog
    BLULogVerbose(@"%@ will disappear.", self.class);
#endif

    [QGAnalyticsService endLogPageViewWithClass:[self class] name:self.title];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUApiManagerLoginRequireNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QGJpushServiceRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUApiManagerUserProfitNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUUserBalanceCoinWarningNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

#ifdef BLUViewControllerVerboseLog
    BLULogVerbose(@"%@ did appear.", self.class);
#endif

    if (self.firstDidAppear) {
        [self viewDidFirstAppear];
        self.firstDidAppear = NO;
    }

    if (self.targetViewController) {
        if (self.navigationController) {
            [self pushViewController:self.targetViewController];
        } else {
            [self presentViewController:self.targetViewController animated:YES completion:nil];
        }
        self.targetViewController = nil;
    }

}

- (void)viewWillFirstAppear {
#ifdef BLUViewControllerVerboseLog
    BLULogVerbose(@"%@ will first appear", self.class);
#endif
}

- (void)viewDidFirstAppear {
#ifdef BLUViewControllerVerboseLog
    BLULogVerbose(@"%@ view did first appear", self.class);
#endif
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
#ifdef BLUViewControllerVerboseLog
    BLULogVerbose(@"%@ did disappear.", self.class);
#endif
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
#ifdef BLUViewControllerVerboseLog
    BLULogVerbose(@"%@ did layout subviews.", self.class);
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
#ifdef BLUViewControllerVerboseLog
    BLULogVerbose(@"%@ received memory warning.", self.class);
#endif
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
#ifdef BLUViewControllerVerboseLog
    BLULogVerbose(@"%@ dealloced.", self.class);
#endif
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

- (void)handleUserProfit:(NSNotification *)userInfo {
    BLUUserProfit *profit = userInfo.object;
    if ([profit isKindOfClass:[BLUUserProfit class]]) {
        [self showUserRewardPromptIndicatorWithUserProfit:profit];
    }
}

#pragma mark - Top indicator UI.

- (void)showTopIndicatorWithError:(NSError *)error {
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
    indicatorView.x = 0;
    indicatorView.y = 0;
    indicatorView.width = self.view.width;
    indicatorView.alpha = 0.0;
    [self.view addSubview:indicatorView];
    [self.view bringSubviewToFront:indicatorView];

    UIImageView *imageView = [UIImageView new];
    if (image) {
        imageView.image = image;
    }

    UILabel *titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = message;
    titleLabel.numberOfLines = 0;

    [indicatorView addSubview:imageView];
    [indicatorView addSubview:titleLabel];

    [imageView sizeToFit];

    CGFloat titleLabelMaxWidth = indicatorView.width - BLUThemeMargin * 9 - imageView.width;
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(titleLabelMaxWidth, CGFLOAT_MAX)];

    titleLabel.size = titleLabelSize;

    CGFloat contentWidth = imageView.width + titleLabel.width + BLUThemeMargin;
    imageView.x = indicatorView.width / 2.0 - contentWidth / 2.0;
    titleLabel.x = imageView.right + BLUThemeMargin;

    indicatorView.height = BLUThemeMargin * 6 + titleLabel.height;
    imageView.centerY = indicatorView.height / 2.0;
    titleLabel.centerY = indicatorView.height / 2.0;

    [UIView animateWithDuration:0.2 animations:^{
        indicatorView.alpha = 1.0;
        indicatorView.y = self.topLayoutGuide.length;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:2.0 options:0 animations:^{
            indicatorView.alpha = 0.0;
            indicatorView.y = 0;
        } completion:^(BOOL finished) {
            [indicatorView removeFromSuperview];
        }];
    }];
}

- (void)showTopIndicatorWithWarningMessage:(NSString *)message {
    [self showTopIndicatorWithMessage:message image:[UIImage imageNamed:@"common-info-prompt"]];
}

#pragma mark - No coin warning.

- (void)handleNocoinWarningNotification:(NSNotification *)notification {
    BLUUserBalance *balance = (BLUUserBalance *)notification.object;
    if ([balance isKindOfClass:[BLUUserBalance class]]) {
        [self showTopIndicatorWithWarningMessage:balance.coinWarningMessage];
    }
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
    QGNavigationViewController *nav = [[QGNavigationViewController alloc]initWithRootViewController:loginVc];
    [self presentViewController:nav animated:YES completion:nil];
    
}


- (void)loginifError:(NSNotification *)userInfo {
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

#pragma mark - Remote notification

- (void)handleRemoteNotification:(NSNotification *)userInfo {
    BLULogInfo(@"Handle remote notification, userInfo = %@", userInfo);
    BLURemoteNotification *remoteNotification = userInfo.object;
    BLUViewController *vc = nil;
    switch (remoteNotification.type) {
        case BLURemoteNotificationTypeComment:
        case BLURemoteNotificationTypeLikePost:
        case BLURemoteNotificationTypeLikeComment:
        case BLURemoteNotificationTypeCommentReply:
        case BLURemoteNotificationTypeFollow: {
            vc = [BLUDynamicViewController new];
        } break;
        case BLURemoteNotificationTypePost: {
            vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:remoteNotification.objectID];
        } break;
        case BLURemoteNotificationTypeCircle: {
            vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:remoteNotification.objectID];
        } break;
        case BLURemoteNotificationTypeWeb: {
            vc = [[BLUWebViewController alloc] initWithPageURL:remoteNotification.url];
            vc.title = remoteNotification.aps.alert;
        } break;
        case BLURemoteNotificationTypePrivateMessage: {
            vc = [BLUDialogueViewController new];
        } break;
        case BLURemoteNotificationTypeSecretary: {
        } break;
        case BLURemoteNotificationTypeTopics: {
            vc = [[BLUPostTagDetailViewController alloc]
                  initWithTagID:remoteNotification.objectID];
        } break;
        case BLURemoteNotificationTypeToy: {
//            vc = [[BLUGoodDetailsViewController alloc]
//                  initWithGoodID:@(remoteNotification.objectID)];
        } break;
    }

    if (remoteNotification.showInfoDirectly) {
        if ([self.view window]) {
            if (self.navigationController) {
                [self pushViewController:vc];
            } else {
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
    } else {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        [[NSNotificationCenter defaultCenter] postNotificationName:BLUMessageShowRedDotNotification object:userInfo];
    }
}

#pragma mark - Tab red dot UI.

- (void)addRedDotAtTabBarItemIndex:(NSInteger)index {

    if (self.view == nil || self.tabBarController == nil) {
        return ;
    }

    NSInteger redDotTag = index + BLUTabbarRedDotBaseTag;

    for (UIView *view in self.tabBarController.tabBar.subviews) {
        if (view.tag == redDotTag) {
            [view removeFromSuperview];
            break;
        }
    }

    CGFloat redDotRadius = 5;
    CGFloat redDotDiameter = redDotRadius * 2;
    CGFloat topMargin = 5;
    CGFloat tabBarItemCount = (CGFloat)(self.tabBarController.tabBar.items.count);
    CGFloat halfItemWidth = CGRectGetWidth(self.view.bounds) / (tabBarItemCount * 2);
    CGFloat xOffset = halfItemWidth * (CGFloat)(index * 2 + 1);
    if (index >= self.tabBarController.tabBar.items.count) {
        return;
    }
    CGFloat imageHalfWidth = ((UITabBarItem *)(self.tabBarController.tabBar.items[index])).selectedImage.size.width / 2;
    UIView *redDot = [[UIView alloc] initWithFrame:CGRectMake(xOffset + imageHalfWidth, topMargin, redDotDiameter, redDotDiameter)];

    redDot.tag = redDotTag;
    redDot.backgroundColor = BLUThemeMainColor;
    redDot.layer.cornerRadius = redDotRadius;

    [self.tabBarController.tabBar addSubview:redDot];
}

- (void)removeRedDotAtTabBarItemIndex:(NSInteger)index {

    if (self.view == nil || self.tabBarController == nil) {
        return ;
    }

    NSInteger redDotTag = index + BLUTabbarRedDotBaseTag;

    for (UIView *view in self.tabBarController.tabBar.subviews) {
        if (view.tag == redDotTag) {
            [view removeFromSuperview];
            break;
        }
    }
}

#pragma mark - Push and Present

- (void)pushViewController:(UIViewController *)viewController {
    if (!self.navigationController || [self.navigationController.viewControllers containsObject:viewController])
        return ;
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    });
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

@end
