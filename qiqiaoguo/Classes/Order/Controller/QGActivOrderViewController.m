//
//  QGActivOrderViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/19.
//
//

#import "QGActivOrderViewController.h"
#import "VTMagic.h"
#import "QGCategoryButton.h"
#import "QGMallOrderListViewController.h"
#import "QGHttpManager+Order.h"
#import "QGActivOrderListViewController.h"

@interface QGActivOrderViewController () <VTMagicViewDataSource,VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong)  NSArray *menuList;
@property (nonatomic, strong) NSArray *dataArr;

@end


@implementation QGActivOrderViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"活动订单";
        self.view.backgroundColor = APPBackgroundColor;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [_magicController.magicView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithnorImage:[UIImage imageNamed:@"icon_classification_back"] heighImage:nil targer:self action:@selector(back)];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateViewConstraints
{
    UIView *magicView = _magicController.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [super updateViewConstraints];
}

- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = QGMainRedColor;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.sliderHeight = 3;
        _magicController.magicView.separatorColor = QGCellbottomLineColor;
        _magicController.magicView.separatorHeight = QGOnePixelLineHeight;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}


#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    NSMutableArray *titleList = [NSMutableArray array];
    [titleList addObjectsFromArray:@[@"全部订单",@"待付款",@"已付款",@"已完成"]];
    _menuList = titleList;
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    QGCategoryButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [QGCategoryButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:QGMainRedColor forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    menuItem.showLine = YES;
    if (_menuList.count - 1 == itemIndex) {
        menuItem.showLine = NO;
    }
    
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    if (pageIndex == 0) {
        static NSString *gridId = @"allOrder";
        QGActivOrderListViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[QGActivOrderListViewController alloc] init];
            viewController.orderStatus = QGMallOrderStatusAll;
        }
        return viewController;
    }
    if (pageIndex == 1) {
        static NSString *gridId = @"daifukuan";
        QGActivOrderListViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[QGActivOrderListViewController alloc] init];
            viewController.orderStatus = QGMallOrderStatusPayment;
        }
        return viewController;
    }
    if (pageIndex == 2) {
        static NSString *gridId = @"yifukuan";
        QGActivOrderListViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[QGActivOrderListViewController alloc] init];
            viewController.orderStatus = QGMallOrderStatusPrepare;
        }
        return viewController;
    }
    if (pageIndex == 3) {
        static NSString *gridId = @"yiwancheng";
        QGActivOrderListViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[QGActivOrderListViewController alloc] init];
            viewController.orderStatus = QGMallOrderStatusComplete;
        }
        return viewController;
    }
    return nil;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex{
//    NSLog(@"viewDidAppear:%ld", (long)pageIndex);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex{
//    NSLog(@"viewDidDisappear:%ld", (long)pageIndex);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex
{
//    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}


@end
