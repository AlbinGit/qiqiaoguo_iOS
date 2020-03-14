//
//  BLUSettingViewController.m
//  Blue
//
//  Created by Bowen on 2/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUSettingViewController.h"
#import "BLUSettingViewController+Private.h"
#import "BLUSettingIndicatorCell.h"
#import "BLUSettingLogOutCell.h"
#import "BLUSettingSwitchCell.h"
#import "BLUKeyChainUtils.h"
#import "BLUPasscodeLockViewController.h"
#import "BLUSettingTextCell.h"
#import "QGAboutViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUApiManager+User.h"
#import "BLUAPSettingViewController.h"
#import "BLUAlertView.h"

#undef BLUSettingPushNotification
#undef BLUSettingRecommandAppON

static const CGFloat kRowHeight = 50.0;

@interface BLUSettingViewController () <UITableViewDelegate, UITableViewDataSource, BLUSettingSwitchCellDelegate>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) NSString *cacheSizeString;

@end

@implementation BLUSettingViewController

#pragma mark - Life Circle

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"setting.title", @"Setting");
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
    [_tableView registerClass:[BLUSettingIndicatorCell class] forCellReuseIdentifier:NSStringFromClass([BLUSettingIndicatorCell class])];
    [_tableView registerClass:[BLUSettingLogOutCell class] forCellReuseIdentifier:NSStringFromClass([BLUSettingLogOutCell class])];
    [_tableView registerClass:[BLUSettingSwitchCell class] forCellReuseIdentifier:NSStringFromClass([BLUSettingSwitchCell class])];
    [_tableView registerClass:[BLUSettingTextCell class] forCellReuseIdentifier:NSStringFromClass([BLUSettingTextCell class])];
    [self.view addSubview:_tableView];
   
    // Constrants
    [self addTiledLayoutConstrantForView:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cacheSizeString = NSLocalizedString(@"setting.cacheSizeString", @"Caculating...");
    [self calcCacheSize];
    [self.tableView reloadData];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case SettingSectionSecurity: {
            count = SecurityCount;
        } break;
        case SettingSectionPushMessage: {
            count = PushMessageCount;
        } break;
        case SettingSectionClearCache: {
            count = 1;
        } break;
        case SettingSectionAbout: {
            count = AboutCount;
        } break;
        case SettingSectionLogOut: {
            count = LogOutCount;
        } break;
        default: {
            count = 0;
        } break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
 
    switch (indexPath.section) {
        case SettingSectionSecurity: {
            BLUSettingSwitchCell *sCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUSettingSwitchCell class]) forIndexPath:indexPath];
            sCell.textLabel.text = NSLocalizedString(@"setting.switch-setting-cell.privacy-password", @"Privacy password");
            sCell.delegate = self;
            sCell.passcodeSwitch.on = NO;
            sCell.showSolidLine = NO;
            sCell.passcodeSwitch.on = [BLUKeyChainUtils getPasswordForUsername:BLUKeyChainUsername andServiceName:BLUKeyChainServiceName error:nil] != nil ? YES : NO;
            cell = sCell;
        } break;
        case SettingSectionLogOut: {
            BLUSettingLogOutCell *logOutCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUSettingLogOutCell class]) forIndexPath:indexPath];
            logOutCell.titleLabel.text = NSLocalizedString(@"setting.log-out-setting-cell.log-out", @"Log out");
            if (![self isUserExist]) {
                logOutCell.selectionStyle = UITableViewCellSelectionStyleNone;
                logOutCell.titleLabel.textColor = BLUThemeSubTintContentForegroundColor;
            }
            cell = logOutCell;
        } break;
        case SettingSectionClearCache: {
            BLUSettingTextCell *clearCacheCell = (BLUSettingTextCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUSettingTextCell class]) forIndexPath:indexPath];
            // FIX: local
            clearCacheCell.text = [self cacheSizeString];
            clearCacheCell.textLabel.text = NSLocalizedString(@"setting.indicator-setting-cell.clear-cache", @"Clear cache");
            cell = clearCacheCell;
        } break;
        default: {
            BLUSettingIndicatorCell *indicatorCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUSettingIndicatorCell class]) forIndexPath:indexPath];
            switch (indexPath.section) {
                case SettingSectionPushMessage: {
                    indicatorCell.textLabel.text = NSLocalizedString(@"setting.indicator-setting-cell.push-notification", @"Push notification");
                } break;
                case SettingSectionAbout: {
                    switch (indexPath.row) {
//                        case AboutQA: {
//                            indicatorCell.textLabel.text = NSLocalizedString(@"setting.indicator-setting-cell.q&a", @"Q&A");
//                        } break;
                        case AboutIdea: {
                            indicatorCell.textLabel.text = NSLocalizedString(@"setting.indicator-setting-cell.advice", @"Advice");
                            indicatorCell.showSolidLine = YES;
                        } break;
                        case AboutInfo: {
                            indicatorCell.textLabel.text = NSLocalizedString(@"setting.indicator-setting-cell.info", @"Abount us");
                        } break;
//                        case AboutMark: {
//                            indicatorCell.textLabel.text = NSLocalizedString(@"setting.indicator-setting-cell.user-reviews", @"User reviews");
//                        } break;
                        default: {
                            indicatorCell.textLabel.text = nil;
                        } break;
                    }
                } break;
                case SettingSectionRecommand: {
                    indicatorCell.textLabel.text = NSLocalizedString(@"setting.indicator-setting-cell.app-recommanded", @"App recommaned");
                } break;
                default: {
                    indicatorCell.textLabel.text = nil;
                } break;
            }
            cell = indicatorCell;
        } break;
    }

    cell.textLabel.textColor = [UIColor colorFromHexString:@"666666"];
    return cell;
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
   
    switch (indexPath.section) {
        case SettingSectionClearCache: {
            [self clearCache];
        } break;
        case SettingSectionLogOut: {
            [self logout];
        } break;
        case SettingSectionPushMessage: {
            if ([BLUAppManager sharedManager].currentUser) {
                BLUAPSettingViewController *vc = [BLUAPSettingViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self loginRequired:nil];
            }
        } break;
        case SettingSectionAbout: {
            if (indexPath.row == AboutInfo) {
                QGAboutViewController *vc = [QGAboutViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == AboutIdea) {
                BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:10];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } break;
    }
}

#pragma mark - Setting switch cell delegate

- (void)settingSwitchCell:(BLUSettingSwitchCell *)settingSwitchCell didChangeSwitchValue:(UISwitch *)settingSwitch {
    BLUPasscodeLockViewController *passcodeLockViewController = nil;
    
    if (settingSwitch.on) {
        passcodeLockViewController = [BLUPasscodeLockViewController passcodeLockViewControllerWithType:BLUPasscodeLockTypeEnable];
    } else {
        passcodeLockViewController = [BLUPasscodeLockViewController passcodeLockViewControllerWithType:BLUPasscodeLockTypeDisablePasscode];
    }
    
    [self.navigationController pushViewController:passcodeLockViewController animated:YES];
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
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SettingSectionClearCache] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)logout {
    if ([self isUserExist]) {
        BLUAlertView *alertView =
        [[BLUAlertView alloc] initWithTitle:NSLocalizedString(@"setting.alert-controller.title.log-out",
                                                              @"Log out?")
                                    message:nil
                          cancelButtonTitle:NSLocalizedString(@"setting.alert-controller.title.confirm",
                                                              @"Confirm")
                           otherButtonTitle:NSLocalizedString(@"send-post-2-vc.cancel",
                                                              @"cancel")];

        alertView.messageBottomPadding = 32;

        alertView.cancelButtonAction = ^() {
            [self.navigationController popViewControllerAnimated:YES];
            BLULogInfo(@"Did logout");
            [[BLUAppManager sharedManager] logOut];
            [[[BLUApiManager sharedManager] logout] subscribeNext:^(id x) {
                [[BLUApiManager sharedManager] deleteAllCookie];
            } error:^(NSError *error) {
                [[BLUApiManager sharedManager] deleteAllCookie];
            }];
        };

        @weakify(alertView);
        alertView.otherButtonAction = ^() {
            @strongify(alertView);
            [alertView dismiss];
        };
        
        [alertView show];
    }
}

- (void)clearCache {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"setting.clear-cache-alert-controller.title", @"Clear cache?") message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"setting.clear-cache-alert-controller.confirm-button.title", @"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearMemory];
        @weakify(self);
        [imageCache clearDiskOnCompletion:^{
            @strongify(self);
            [self calcCacheSize];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"setting.clear-cache-alert-controller.cancen-button.title", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isUserExist {
    return [[BLUAppManager sharedManager] currentUser] != nil;
}

@end
