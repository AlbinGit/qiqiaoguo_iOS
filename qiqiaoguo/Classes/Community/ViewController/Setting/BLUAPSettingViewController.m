//
//  BLUAPSettingViewController.m
//  Blue
//
//  Created by Bowen on 12/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUAPSettingViewController.h"
#import "BLUSettingSwitchCell.h"
#import "BLUApSettingViewModel.h"
#import "BLUAPSetting.h"

@interface BLUAPSettingViewController () <UITableViewDelegate, UITableViewDataSource, BLUSettingSwitchCellDelegate>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) NSArray *APItemTitles;
@property (nonatomic, strong) BLUApSettingViewModel *settingViewModel;

@end

@implementation BLUAPSettingViewController

#pragma mark - Life circle


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    self.title = NSLocalizedString(@"ap-setting.title", @"Push notification");

    _tableView = [BLUTableView new];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[BLUSettingSwitchCell class] forCellReuseIdentifier:NSStringFromClass([BLUSettingSwitchCell class])];
    [self.view addSubview:_tableView];
}

- (void)viewWillFirstAppear {
    @weakify(self);
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.settingViewModel.fetchDisposable = [[self.settingViewModel fetch] subscribeNext:^(id x) {
            [self.tableView reloadData];
        }];
        [self.tableView.mj_header endRefreshing];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

#pragma mark - Model

- (BLUApSettingViewModel *)settingViewModel {
    if (_settingViewModel == nil) {
        _settingViewModel = [BLUApSettingViewModel new];
    }
    return _settingViewModel;
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingViewModel.stateSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)(self.settingViewModel.stateSections[section])).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUSettingSwitchCell *cell = (BLUSettingSwitchCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUSettingSwitchCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [self.settingViewModel titleAtIndexPath:indexPath];
    cell.passcodeSwitch.on = ((NSNumber *)[self.settingViewModel stateAtIndexPath:indexPath]).boolValue;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *states = self.settingViewModel.stateSections[indexPath.section];
    if (indexPath.row == states.count - 1) {
        cell.showSolidLine = NO;
    } else {
        cell.showSolidLine = YES;
    }

    cell.textLabel.textColor = [UIColor colorFromHexString:@"666666"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return BLUThemeMargin * 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = BLUThemeSubTintBackgroundColor;
    return view;
}

#pragma mark - Setting switch cell

- (void)settingSwitchCell:(BLUSettingSwitchCell *)settingSwitchCell didChangeSwitchValue:(UISwitch *)settingSwitch {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:settingSwitchCell];
    @weakify(self);
    [[self.settingViewModel switchAtIndexPath:indexPath] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
        [self.tableView reloadData];
    }];
}

@end
