//
//  QGMyParticipateViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/14.
//
//

#import "QGMyParticipateViewController.h"
#import "VTMagic.h"
#import "QGCategoryButton.h"
#import "BLUUsersViewController.h"
#import "BLUUsersViewModel.h"
#import "BLUPostViewModel.h"
#import "BLUUserPostsViewController.h"
#import "QGUserPostsViewController.h"
#import "QGActivityListViewController.h"


@interface QGMyParticipateViewController () <VTMagicViewDataSource,VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation QGMyParticipateViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我参与的";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.view setNeedsUpdateConstraints];
    [_magicController.magicView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
    [titleList addObjectsFromArray:@[@"活动",@"帖子"]];
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
        static NSString *gridId = @"QGActivityListViewController";
        QGActivityListViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[QGActivityListViewController alloc] init];
            viewController.type = QGActivityTypeParticipate;
        }
        return viewController;
    }
    if (pageIndex == 1) {
        static NSString *gridId = @"QGUserPostsViewController";
        QGUserPostsViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[QGUserPostsViewController alloc] init];
            viewController.type = UserPostTypeParticipated;
        }
        return viewController;
    }
    return nil;
}


@end
