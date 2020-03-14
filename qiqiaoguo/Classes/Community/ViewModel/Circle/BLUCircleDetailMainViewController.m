//
//  BLUCircleDetailMainViewController.m
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleDetailMainViewController.h"
#import "BLUCircleDetailAsyncViewController.h"
#import "BLUApiManager+Circle.h"
#import "BLUCircle.h"
#import "BLUAlertView.h"

@implementation BLUCircleDetailMainViewController

- (instancetype)initWithCircleID:(NSInteger)circleID {
    if (self = [super init]) {
//        BLUParameterAssert(circleID > 0);
        _circleID = circleID;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *circleTitle = NSLocalizedString(@"circle-main-detail-vc.all", @"All");
    NSString *hotTitle = NSLocalizedString(@"circle-main-detail-vc.new", @"New");
    NSString *followTitle = NSLocalizedString(@"circle-main-detail-vc.featured", @"Featured");
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


    BLUCircleDetailAsyncViewController *allCircleVC =
    [[BLUCircleDetailAsyncViewController alloc] initWithCircleID:_circleID
                                                            type:BLUPostTypeForCircle];
    BLUCircleDetailAsyncViewController *newCircleVC =
    [[BLUCircleDetailAsyncViewController alloc] initWithCircleID:_circleID
                                                            type:BLUPostTypeFresh];
    BLUCircleDetailAsyncViewController *featuredCircleVC =
    [[BLUCircleDetailAsyncViewController alloc] initWithCircleID:_circleID
                                                            type:BLUPostTypeEssential];

    allCircleVC.view.backgroundColor = [UIColor randomColor];
    newCircleVC.view.backgroundColor = [UIColor randomColor];
    featuredCircleVC.view.backgroundColor = [UIColor randomColor];

    _circleVCs = @[allCircleVC, newCircleVC, featuredCircleVC];

    _pageViewController =
    [[UIPageViewController alloc]
     initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
     navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
     options:nil];
    [_pageViewController setViewControllers:@[allCircleVC]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    self.view.gestureRecognizers = _pageViewController.gestureRecognizers;
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;

    _pageViewController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    _circleSegmentedControl.frame = CGRectMake(0.0, 0.0, MAIN_SCREEN_WIDTH * 0.6, 26.0);
//    self.navigationItem.titleView = _circleSegmentedControl;
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    @weakify(self);
    [[[[BLUApiManager sharedManager] fetchCircleWithCircleID:self.circleID] retry:3] subscribeNext:^(BLUCircle *circle) {
        @strongify(self);
        self.circle = circle;
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"circle-detail-prompt"]
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(tapAndShowPrompt:)];
    } error:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
    }];
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

- (void)tapAndShowPrompt:(id)sender {
    BLUAlertView *alertView = [[BLUAlertView alloc] initWithTitle:self.circle.name message:self.circle.circleDescription cancelButtonTitle:NSLocalizedString(@"circle-detail-main-vc.OK", @"OK") otherButtonTitle:nil];
    alertView.messageBottomPadding = 40;
    [alertView show];
}

#pragma mark - Page view controller;

- (NSInteger)indexOfViewController:(UIViewController *)viewController {
    return [self.circleVCs indexOfObject:viewController];
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

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    BLUParameterAssert(index >= 0 && index < self.circleVCs.count);
    return [self.circleVCs objectAtIndex:index];
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
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
