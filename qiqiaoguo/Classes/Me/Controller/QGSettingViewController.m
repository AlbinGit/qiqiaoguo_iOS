//
//  QGSettingViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/12.
//
//

#import "QGSettingViewController.h"
#import "QGSettingCell.h"
#import "QGAboutViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "QGAlertView.h"
#import "QGUserInfoSettingViewController.h"



static const CGFloat kRowHeight = 50.0;

@interface QGSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) NSString *cacheSizeString;
@property (nonatomic, strong) UIView *tableFootView;


@end

@implementation QGSettingViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"设置";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    // TableView
    _tableView = [[BLUTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.rowHeight = kRowHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[QGSettingCell class] forCellReuseIdentifier:NSStringFromClass([QGSettingCell class])];
    _tableView.tableFooterView = self.tableFootView;
    _tableView.frame = self.view.bounds;
    [self.view addSubview:_tableView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cacheSizeString = NSLocalizedString(@"setting.cacheSizeString", @"Caculating...");
    [self calcCacheSize];
    [self.tableView reloadData];
    if ([BLUAppManager sharedManager].didUserLogin) {
        UIButton *button = [_tableFootView viewWithTag:1];
        button.enabled = YES;
    }else{
        UIButton *button = [_tableFootView viewWithTag:1];
        button.enabled = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.frame;
}

- (UIView *)tableFootView{
    
    if (_tableFootView == nil) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, self.view.width, 100);
        BLUMainTitleButton *button = [BLUMainTitleButton new];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = 1;
//        button.title = @"退出登录";
		[button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cannelbuttonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview: button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.left.equalTo(view).offset(12);
            make.right.equalTo(view).offset(-12);
        }];
        _tableFootView = view;
    }

    
    return _tableFootView;
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return section == 1 ? 3 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2){ // 退出
            return nil;

    }
    
    QGSettingCell *indicatorCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGSettingCell class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        indicatorCell.textLabel.text = @"修改个人资料";
    }else{
        switch (indexPath.row) {
            case 0:{
               indicatorCell.textLabel.text = @"意见反馈";
                indicatorCell.showSolidLine = YES;
            }break;
            case 1:{
                indicatorCell.textLabel.text = @"清除缓存";
                indicatorCell.text = [self cacheSizeString];
                indicatorCell.showCache = YES;
                indicatorCell.showSolidLine = YES;
            }break;
            case 2:{
                indicatorCell.textLabel.text = @"关于";
            }break;
            default:
                break;
        }      
    }
    return indicatorCell;

}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return BLUThemeMargin * 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) { // 修改个人资料
        if ([self loginIfNeeded]) {
            return;
        }
        QGUserInfoSettingViewController *infoVC = [[QGUserInfoSettingViewController alloc]initWithUser:[BLUAppManager sharedManager].currentUser];
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }else{
        switch (indexPath.row) {
            case 0:
            {// 意见反馈
                BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:0];
                [self.navigationController pushViewController:vc animated:YES];
               
            }break;
            case 1:
            {// 清除缓存
                QGAlertView *alert = [[QGAlertView alloc]initWithTitle:@"确定要清除缓存吗?" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
                alert.otherButtonAction = ^{
                    SDImageCache *imageCache = [SDImageCache sharedImageCache];
                    [imageCache clearMemory];
                    @weakify(self);
                    [imageCache clearDiskOnCompletion:^{
                        @strongify(self);
                        [self calcCacheSize];
                    }];
                };
                [alert show];
                
            }break;
            case 2:
            {// 关于
                QGAboutViewController *aboutVC = [QGAboutViewController new];
                [self.navigationController pushViewController:aboutVC animated:YES];
                
            }break;
                
            default:
                break;
        }
        
    }
    
    
}

#pragma mark - cannelbuttonClick
- (void)cannelbuttonClick{
    
    QGAlertView *alert = [[QGAlertView alloc]initWithTitle:@"你确定要退出登录吗?" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
    @weakify(self);
    alert.otherButtonAction = ^{
        @strongify(self);
        [[BLUAppManager sharedManager] logOut];
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [alert show];
    
    
}

#pragma mark - Cache manager
- (void)calcCacheSize {
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        CGFloat cacheSize = 0.0;
        NSString *cacheSizeString = nil;
        cacheSize = (CGFloat)totalSize / (1024.0 * 1024.0);
        cacheSizeString = [NSString stringWithFormat:@"%.2f MB", cacheSize];
        self.cacheSizeString = cacheSizeString;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

@end
