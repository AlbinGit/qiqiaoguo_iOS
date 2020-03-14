//
//  BLUUserCoinDetailsViewController.m
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserCoinDetailsViewController.h"
#import "BLUUserSimpleTableCell.h"
#import "BLUUserSimpleCoinView.h"
#import "BLUUserCoinViewModel.h"
#import "BLUCoinLog.h"

@interface BLUUserCoinDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BLUUserSimpleCoinView *coinView;
@property (nonatomic, strong) BLUTableView *coinDetailsTableView;
@property (nonatomic, strong) BLUUserCoinViewModel *coinViewModel;

@property (nonatomic, strong) BLUUser *user;

@end

@implementation BLUUserCoinDetailsViewController

- (instancetype)initWithUser:(BLUUser *)user {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"user-coin-details-vc.title", @"Blue coin details");
        _user = user;
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    _coinView = [BLUUserSimpleCoinView new];
    _coinView.user = self.user;

    _coinDetailsTableView = [BLUTableView new];
    _coinDetailsTableView.tableFooterView = [UIView new];
    _coinDetailsTableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _coinDetailsTableView.delegate = self;
    _coinDetailsTableView.dataSource = self;
    _coinDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_coinDetailsTableView registerClass:[BLUUserSimpleTableCell class] forCellReuseIdentifier:NSStringFromClass([BLUUserSimpleTableCell class])];

    [self.view addSubview:_coinView];
    [self.view addSubview:_coinDetailsTableView];

    @weakify(self);
    self.coinDetailsTableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self.coinViewModel fetchNextCoinLogs] subscribeNext:^(id x) {
            [self.coinDetailsTableView reloadData];
            [self tableViewEndRefreshing:self.coinDetailsTableView];
        } error:^(NSError *error) {
            [self showAlertForError:error];
            [self tableViewEndRefreshing:self.coinDetailsTableView];
        }];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _coinView.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.width, [BLUUserSimpleCoinView userSimpleInfoViewHeight]);

    _coinDetailsTableView.x = BLUThemeMargin * 4;
    _coinDetailsTableView.y = _coinView.bottom + BLUThemeMargin * 4;
    _coinDetailsTableView.width = self.view.width - BLUThemeMargin * 8;
    _coinDetailsTableView.height = self.view.height - _coinDetailsTableView.y;
    _coinDetailsTableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    @weakify(self);
    [[self.coinViewModel fetchCoinLogs] subscribeNext:^(id x) {
        @strongify(self);
        [self.coinDetailsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } error:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];
}

#pragma mark - Model.

- (BLUUserCoinViewModel *)coinViewModel {
    if (_coinViewModel == nil) {
        _coinViewModel = [BLUUserCoinViewModel new];
    }
    return _coinViewModel;
}

#pragma mark - UITableView.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coinViewModel.coinLogs.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserSimpleTableCell class]) forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_coinDetailsTableView sizeForCellWithCellClass:[BLUUserSimpleTableCell class] cacheByIndexPath:indexPath width:_coinDetailsTableView.width configuration:^(BLUCell *cell) {
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
            tableCell.contentView.backgroundColor = BLUThemeMainColor;
        } else {
            BLUCoinLog *log = self.coinViewModel.coinLogs[indexPath.row - 1];
            tableCell.style = BLUUserSimpleTableCellStyleContent;
            tableCell.titleLabel.text = [[NSDateFormatter postTimeMonthDateFormater] stringFromDate:log.createDate];
            tableCell.countLabel.text = log.profitDesc;
            tableCell.descLabel.text = log.title;
            tableCell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : [UIColor colorFromHexString:@"#DEDFDF"];
        }
    }
}

@end
