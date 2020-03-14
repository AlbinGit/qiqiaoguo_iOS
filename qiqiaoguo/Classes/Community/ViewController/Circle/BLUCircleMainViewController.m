//
//  BLUCircle2ViewController.m
//  Blue
//
//  Created by Bowen on 27/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleMainViewController.h"
#import "BLUCircleViewController.h"
#import "BLUCircleHotViewController.h"
#import "BLUCircleFollowViewController.h"
#import "BLUNavigationController.h"
#import "QGMessageCenterViewController.h"
#import "QGHttpManager+User.h"

@interface BLUCircleMainViewController ()

@property (nonatomic, strong) UIButton * messeageLab;
@property (nonatomic, assign) NSInteger messageCount;

@end

@implementation BLUCircleMainViewController

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.title = @"";
//        self.tabBarItem.image = [BLUCurrentTheme tabCircleNormalIcon];
//        self.tabBarItem.selectedImage = [BLUCurrentTheme tabCircleSelectedIcon];
        self.tabBarItem.title = @"社区";
//        self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
       
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserMessageCount];
    
    
}

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

- (void)updateUserMessageCount{
    if (self.messageCount > 0) {
        _messeageLab.title = @(self.messageCount).stringValue;
    }
    _messeageLab.hidden = self.messageCount == 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *circleTitle = NSLocalizedString(@"circle-main-vc.circle-title", @"Circle");
    NSString *hotTitle = NSLocalizedString(@"circle-main-vc.hot-title", @"Hot");
    NSString *followTitle = NSLocalizedString(@"circle-main-vc.follot-title", @"Follow");
    NSArray *segmentedItems = @[circleTitle, hotTitle, followTitle];

    _circleSegmentedControl =
    [[UISegmentedControl alloc] initWithItems:segmentedItems];
    _circleSegmentedControl.selectedSegmentIndex = 0;
    _circleSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    _circleSegmentedControl.tintColor = [UIColor whiteColor];
    [_circleSegmentedControl addTarget:self
                                action:@selector(selectAndChangeVC:)
                      forControlEvents:UIControlEventValueChanged];
    [_circleSegmentedControl setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_circleSegmentedControl setBackgroundImage:[UIImage new] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [_circleSegmentedControl setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_circleSegmentedControl setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_circleSegmentedControl setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    NSDictionary *selectedAttributes =
    @{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"333333"],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};
    NSDictionary *normalAttributes =
    @{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"999999"],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};
    [_circleSegmentedControl setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    [_circleSegmentedControl setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    _circleSegmentedControl.frame = CGRectMake(0.0, 0.0, MAIN_SCREEN_WIDTH * 0.6, 26.0);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, MAIN_SCREEN_WIDTH * 0.6, 26.0)];
    self.navigationItem.titleView = view;
    [self.navigationItem.titleView addSubview:_circleSegmentedControl];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"message_icon"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(PushTomessage)
     forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    _messeageLab = [[UIButton alloc]initWithFrame:CGRectMake(11, -4, 15, 15)];
    _messeageLab.cornerRadius = _messeageLab.height/2;
    _messeageLab.backgroundColor = [UIColor redColor];
    _messeageLab.titleFont = [UIFont systemFontOfSize:10];
    _messeageLab.hidden = YES;
    [button addSubview:_messeageLab];
    
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;


    BLUCircleViewController *circleVC = [BLUCircleViewController new];
    BLUCircleHotViewController *circleHotVC = [BLUCircleHotViewController new];
    BLUCircleFollowViewController *circleFollowVC =
    [BLUCircleFollowViewController new];
    _circleSegmentedControl.frame = CGRectMake(0.0, 0.0, MAIN_SCREEN_WIDTH * 0.6, 26.0);
    _circleVCs = @[circleVC, circleHotVC, circleFollowVC];

    _pageViewController =
    [[UIPageViewController alloc]
     initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
     navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
     options:nil];
    [_pageViewController setViewControllers:@[circleVC]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    _currentPageIndex = 0;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    self.view.gestureRecognizers = _pageViewController.gestureRecognizers;
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;

    _pageViewController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)PushTomessage{
    if ([self loginIfNeeded]) {
        return;
    }
    QGMessageCenterViewController *vc = [QGMessageCenterViewController new];
    [self pushViewController:vc];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _pageViewController.view.frame = self.view.bounds;
//
//    self.navigationItem.titleView = _circleSegmentedControl;
//    _circleSegmentedControl.frame = CGRectMake(0.0, 0.0, MAIN_SCREEN_WIDTH * 0.6, 26.0);
}

- (void)selectAndChangeVC:(UISegmentedControl *)control {
    NSInteger index = control.selectedSegmentIndex;
    UIPageViewControllerNavigationDirection direction;
    if (index > _currentPageIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    UIViewController *vc = [self viewControllerAtIndex:index];
    @weakify(self);
    [self.pageViewController setViewControllers:@[vc] direction:direction animated:YES completion:^(BOOL finished) {
        if (finished) {
            @strongify(self);
            self.currentPageIndex = index;
        }
    }];
}

#pragma mark - Page View Controller

- (NSInteger)indexOfViewController:(UIViewController *)viewController {
    return [self.circleVCs indexOfObject:viewController];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    BLUParameterAssert(index >= 0 && index < self.circleVCs.count);
    return [self.circleVCs objectAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.circleSegmentedControl.selectedSegmentIndex =
    [self indexOfViewController:pendingViewControllers.firstObject];
    self.currentPageIndex = self.circleSegmentedControl.selectedSegmentIndex;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (finished == YES && completed == NO) {
        self.circleSegmentedControl.selectedSegmentIndex =
        [self indexOfViewController:previousViewControllers.lastObject];
        self.currentPageIndex = self.circleSegmentedControl.selectedSegmentIndex;
    }
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }

    index++;
    if (index == [_circleVCs count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
