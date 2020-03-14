//
//  QGMyFollowViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/13.
//
//

#import "QGMyFollowViewController.h"
#import "VTMagic.h"
#import "BLUUsersViewController.h"
#import "QGCategoryButton.h"
#import "BLUUsersViewModel.h"
#import "QGTeacherListViewController.h"
#import "QGOrganizationListViewController.h"

@interface QGMyFollowViewController () <VTMagicViewDataSource>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation QGMyFollowViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我的关注";
          NSLog(@"ssssuuuu %@",self.title);
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
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    [titleList addObjectsFromArray:@[@"用户",@"机构",@"老师"]];
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
        static NSString *gridId = @"BLUUsersViewController";
        BLUUsersViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            BLUUsersViewModel *usersViewModel = [BLUUsersViewModel new];
            usersViewModel.userID = [BLUAppManager sharedManager].currentUser.userID;
            usersViewModel.type = BLUUsersViewModelTypeFollowing;
            viewController = [[BLUUsersViewController alloc] initWithUsersViewModel:usersViewModel];
        }
        return viewController;
    }
    if (pageIndex == 1) {
        static NSString *gridId = @"QGOrganizationListViewController";
        QGOrganizationListViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[QGOrganizationListViewController alloc] init];
        }
        return viewController;
    }
    if (pageIndex == 2) {
        static NSString *gridId = @"QGTeacherListViewController";
        QGTeacherListViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[QGTeacherListViewController alloc] init];
        }
        return viewController;
    }
    return nil;
}



@end
