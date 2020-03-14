//
//  BLUUserLevelDetailsViewController.m
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserLevelDetailsViewController.h"
#import "BLUUserSimpleTableCell.h"
#import "BLUUserSimpleLevelView.h"
#import "BLUUserLevelViewModel.h"
#import "BLULevelLog.h"

@interface BLUUserLevelDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BLUUserSimpleLevelView *levelView;
@property (nonatomic, strong) BLUTableView *levelDetailsTableView;

@property (nonatomic, strong) BLUUserLevelViewModel *levelViewModel;

@property (nonatomic, strong) BLUUser *user;

@end

@implementation BLUUserLevelDetailsViewController

- (instancetype)initWithUser:(BLUUser *)user {
    if (self = [super init]) {
        _user = user;
        self.title = NSLocalizedString(@"user-level-detail-vc.title", @"Details");
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    _levelView = [BLUUserSimpleLevelView new];
    _levelView.user = self.user;

    _levelDetailsTableView = [BLUTableView new];
    _levelDetailsTableView.delegate = self;
    _levelDetailsTableView.dataSource = self;
    _levelDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _levelDetailsTableView.tableFooterView = [UIView new];
    _levelDetailsTableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    [_levelDetailsTableView registerClass:[BLUUserSimpleTableCell class] forCellReuseIdentifier:NSStringFromClass([BLUUserSimpleTableCell class])];

    [self.view addSubview:_levelView];
    [self.view addSubview:_levelDetailsTableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _levelView.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.width, [BLUUserSimpleLevelView userSimpleInfoViewHeight]);

    _levelDetailsTableView.x = BLUThemeMargin * 4;
    _levelDetailsTableView.y = _levelView.bottom + BLUThemeMargin * 4;
    _levelDetailsTableView.width = self.view.width - BLUThemeMargin * 8;
    _levelDetailsTableView.height = self.view.height - _levelDetailsTableView.y;
    _levelDetailsTableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self);
    self.levelDetailsTableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self.levelViewModel fetchNextLevelLogs] subscribeNext:^(id x) {
            [self.levelDetailsTableView reloadData];
            [self tableViewEndRefreshing:self.levelDetailsTableView];
        } error:^(NSError *error) {
            [self showAlertForError:error];
            [self tableViewEndRefreshing:self.levelDetailsTableView];
        }];
    }];
}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    @weakify(self);
    [[self.levelViewModel fetchLevelLogs] subscribeNext:^(id x) {
        @strongify(self);
        [self.levelDetailsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } error:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];
}

#pragma mark - Model.

- (BLUUserLevelViewModel *)levelViewModel {
    if (_levelViewModel == nil) {
        _levelViewModel = [BLUUserLevelViewModel new];
    }
    return _levelViewModel;
}

#pragma mark - UITableView.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.levelViewModel.levelLogs.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserSimpleTableCell class]) forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_levelDetailsTableView sizeForCellWithCellClass:[BLUUserSimpleTableCell class] cacheByIndexPath:indexPath width:_levelDetailsTableView.width configuration:^(BLUCell *cell) {
        [self configCell:cell atIndexPath:indexPath];
    }].height;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[BLUUserSimpleTableCell class]]) {
        BLUUserSimpleTableCell *tableCell = (BLUUserSimpleTableCell *)cell;

        if (indexPath.row == 0) {
            tableCell.style = BLUUserSimpleTableCellStyleTitle;
            tableCell.titleLabel.text = NSLocalizedString(@"user-coin-detail-vc.table-cell.title", @"Time");
            tableCell.countLabel.text = NSLocalizedString(@"user-coin-detail-vc.table-cell.count", @"Count");
            tableCell.descLabel.text = NSLocalizedString(@"user-coin-detail-vc.table-cell.desc", @"Description");
            tableCell.backgroundColor = BLUThemeMainColor;
        } else {
            BLULevelLog *log = self.levelViewModel.levelLogs[indexPath.row - 1];
            tableCell.style = BLUUserSimpleTableCellStyleContent;
            tableCell.titleLabel.text =[[NSDateFormatter postTimeYearDateFormater] stringFromDate:log.createDate];
            tableCell.countLabel.text = @(log.exp).description;
            tableCell.descLabel.text = log.title;
            tableCell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : [UIColor colorFromHexString:@"#DEDFDF"];
        }
    }
}

@end
