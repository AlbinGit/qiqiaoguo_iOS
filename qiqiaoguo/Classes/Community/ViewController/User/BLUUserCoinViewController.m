//
//  BLUUserCoinViewController.m
//  Blue
//
//  Created by Bowen on 12/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserCoinViewController.h"
#import "BLUUserSimpleCoinView.h"
#import "BLUUserCoinTaskCell.h"
#import "BLUUserSimpleTableCell.h"
#import "BLUUserCoinViewModel.h"
#import "BLUCoinNewBieRule.h"
#import "BLUCoinDailyRule.h"
#import "BLUUserCoinDetailsViewController.h"
#import "BLUWebViewController.h"
#import "BLUApiManager+User.h"
#import "BLUUserSettingViewController.h"
#import "BLUWebViewController.h"
#import "BLUApiManager+User.h"

@interface BLUUserCoinViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *dailyLabel;
@property (nonatomic, strong) BLUUserSimpleCoinView *coinView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *coinDescriptionLabel;

@property (nonatomic, strong) BLUTableView *coinTaskTableView;
@property (nonatomic, strong) BLUTableView *dailyTaskTableView;

@property (nonatomic, strong) UILabel *taskLabel;
@property (nonatomic, strong) UIButton *coinRuleButton;

@property (nonatomic, strong) BLUUser *user;

@property (nonatomic, strong) BLUUserCoinViewModel *coinViewModel;

@end

@implementation BLUUserCoinViewController

- (instancetype)initWithUser:(BLUUser *)user {
    if (self = [super init]) {
        _user = user;
        self.title = NSLocalizedString(@"user-coin-vc.title", @"Coin info");
        self.hidesBottomBarWhenPushed = YES;
        return self;
    }
    return nil;
}

- (instancetype)init {
    return [self initWithUser:[BLUUser defaultUser]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    _coinView = [BLUUserSimpleCoinView new];
    _coinView.user = self.user;

    _coinDescriptionLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _coinDescriptionLabel.text = NSLocalizedString(@"user-coin-vc.desc-label.title", @"desc");

    _taskLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _taskLabel.text = NSLocalizedString(@"user-coin-vc.task-label.title", @"Earn blue coin");
    _taskLabel.textColor = BLUThemeMainColor;

    _coinTaskTableView = [BLUTableView new];
    _coinTaskTableView.delegate = self;
    _coinTaskTableView.dataSource = self;
    _coinTaskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_coinTaskTableView registerClass:[BLUUserCoinTaskCell class] forCellReuseIdentifier:NSStringFromClass([BLUUserCoinTaskCell class])];

    _dailyLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _dailyLabel.text = NSLocalizedString(@"user-coin-vc.daily-label.title", @"Earn blue coin(Daily)");
    _dailyLabel.textColor = BLUThemeMainColor;

    _dailyTaskTableView = [BLUTableView new];
    _dailyTaskTableView.delegate = self;
    _dailyTaskTableView.dataSource = self;
    _dailyTaskTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_dailyTaskTableView registerClass:[BLUUserSimpleTableCell class] forCellReuseIdentifier:NSStringFromClass([BLUUserSimpleTableCell class])];

    _coinRuleButton = [UIButton new];
    NSString *ruleTitle = NSLocalizedString(@"user-coin-vc.coin-rule-button.title.rule", @"Coin rules");
    NSString *coinRuleButtonTitle = [NSString stringWithFormat:NSLocalizedString(@"user-coin-vc.coin-rule-button.title.tap%@", @"Tap"), ruleTitle];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:coinRuleButtonTitle];
    [attrStr addAttribute:NSFontAttributeName value:BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge) range:NSMakeRange(0, coinRuleButtonTitle.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#646566"] range:NSMakeRange(0, coinRuleButtonTitle.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:BLUThemeMainColor range:[coinRuleButtonTitle rangeOfString:ruleTitle]];
    [_coinRuleButton setAttributedTitle:attrStr forState:UIControlStateNormal];
    [_coinRuleButton addTarget:self action:@selector(showAllCoinRulesAction:) forControlEvents:UIControlEventTouchUpInside];

    _scrollView = [UIScrollView new];

    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_coinView];
    [_scrollView addSubview:_coinDescriptionLabel];
    [_scrollView addSubview:_taskLabel];
    [_scrollView addSubview:_coinTaskTableView];
    [_scrollView addSubview:_dailyLabel];
    [_scrollView addSubview:_dailyTaskTableView];
    [_scrollView addSubview:_coinRuleButton];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"user-coin-vc.right-bar-button.details", @"Details") style:UIBarButtonItemStylePlain target:self action:@selector(showCoinDetailsAction:)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat containerHeight = 0.0;
    CGFloat leftMargin = BLUThemeMargin * 4;
    CGFloat contentWidth = self.view.width - leftMargin * 2;

    _scrollView.frame = self.view.bounds;
    _coinView.frame = self.view.bounds;
    _coinView.height = [BLUUserSimpleCoinView userSimpleInfoViewHeight];

    CGSize coinDescriptionLabelSize = [_coinDescriptionLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    _coinDescriptionLabel.size = coinDescriptionLabelSize;
    _coinDescriptionLabel.y = _coinView.bottom + BLUThemeMargin * 4;
    _coinDescriptionLabel.x = leftMargin;

    [_taskLabel sizeToFit];
    _taskLabel.x = leftMargin;
    _taskLabel.y = _coinDescriptionLabel.bottom + BLUThemeMargin * 4;

    _coinTaskTableView.x = leftMargin;
    _coinTaskTableView.y = _taskLabel.bottom + BLUThemeMargin * 4;
    _coinTaskTableView.width = contentWidth;
    _coinTaskTableView.height = _coinTaskTableView.contentSize.height;

    [_dailyLabel sizeToFit];
    _dailyLabel.x = leftMargin;
    _dailyLabel.y = _coinTaskTableView.bottom + BLUThemeMargin * 4;

    _dailyTaskTableView.x = leftMargin;
    _dailyTaskTableView.y = _dailyLabel.bottom + BLUThemeMargin * 4;
    _dailyTaskTableView.width = contentWidth;
    _dailyTaskTableView.height = _dailyTaskTableView.contentSize.height;

    [_coinRuleButton sizeToFit];
    _coinRuleButton.x = self.view.width - leftMargin - _coinRuleButton.width;
    _coinRuleButton.y = _dailyTaskTableView.bottom + BLUThemeMargin * 4;

    containerHeight = _coinRuleButton.bottom + BLUThemeMargin * 4;

    CGFloat contentHeight = _scrollView.height - self.topLayoutGuide.length - self.bottomLayoutGuide.length;
    containerHeight = containerHeight > _scrollView.height ? containerHeight : contentHeight;
    _scrollView.contentSize = CGSizeMake(_scrollView.width, containerHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    @weakify(self);
    [[self.coinViewModel fetchCoinNewbieRules] subscribeNext:^(id x) {
        @strongify(self);
        if (self.coinViewModel.coinNewbieRules.count > 0) {
            [self.coinTaskTableView reloadData];
        } else {
            [self.coinTaskTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } error:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];
}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    @weakify(self);
    [[self.coinViewModel fetchCoinDailyRules] subscribeNext:^(id x) {
        @strongify(self);
        if (self.coinViewModel.coinDailyRules.count > 0) {
            [self.dailyTaskTableView reloadData];
        } else {
            [self.dailyTaskTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
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

- (void)showCoinDetailsAction:(id)sender {
    if ([BLUAppManager sharedManager].currentUser) {
        BLUUserCoinDetailsViewController *vc = [[BLUUserCoinDetailsViewController alloc] initWithUser:self.user];
        [self pushViewController:vc];
    }
}

- (void)showCoinRulesAction:()sender {
    BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:[BLUApiManager sharedManager].coinRulesURL];
    vc.title = NSLocalizedString(@"user-coin-vc.coin-rule-button.title.rule", @"Coin rules");
    [self pushViewController:vc];
}

- (void)showAllCoinRulesAction:(id)sender {
    BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:[BLUApiManager sharedManager].coinRulesURL];
    vc.title = NSLocalizedString(@"user-coin-vc.coin-rule-vc.title", @"Blue coin rules");
    [self pushViewController:vc];
}

#pragma mark - UITableView.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (tableView == _coinTaskTableView) {
        count = self.coinViewModel.coinNewbieRules.count;
    } else if (tableView ==_dailyTaskTableView) {
        count = self.coinViewModel.coinDailyRules.count + 1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == _coinTaskTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserCoinTaskCell class])];
        [self configCell:cell atIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserSimpleTableCell class])];
        [self configCell:cell atIndexPath:indexPath];
    }
    return cell;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[BLUUserCoinTaskCell class]]) {
        BLUUserCoinTaskCell *taskCell = (BLUUserCoinTaskCell *)cell;

        NSString *finishedStr = NSLocalizedString(@"user-coin-vc.task-cell.finish-button.completed", @"Completed");
        NSString *incompleteStr = NSLocalizedString(@"user-coin-vc.task-cell.finish-button.incompleted", @"Incompleted");
        BLUCoinNewBieRule *newbieRule = self.coinViewModel.coinNewbieRules[indexPath.row];

        taskCell.titleLabel.text = newbieRule.title;
        taskCell.coinLabel.text = @(newbieRule.profit).description;
        [taskCell.finishButton addTarget:self action:@selector(finishTaskAction:) forControlEvents:UIControlEventTouchUpInside];
        if (newbieRule.finished) {
            taskCell.finishButton.title = finishedStr;
            taskCell.finishButton.backgroundColor = BLUThemeSubTintBackgroundColor;
            taskCell.finishButton.titleColor = BLUThemeSubTintContentForegroundColor;
            taskCell.finishButton.enabled = NO;
        } else {
            taskCell.finishButton.title = incompleteStr;
            taskCell.finishButton.backgroundColor = BLUThemeMainColor;
            taskCell.finishButton.titleColor = [UIColor whiteColor];
            taskCell.finishButton.enabled = YES;
        }

        taskCell.topLine.hidden = indexPath.row == 0 ? NO : YES;

    } else if ([cell isKindOfClass:[BLUUserSimpleTableCell class]]) {
        BLUUserSimpleTableCell *tableCell = (BLUUserSimpleTableCell *)cell;

        if (indexPath.row == 0) {
            tableCell.style = BLUUserSimpleTableCellStyleTitle;
            tableCell.titleLabel.text = NSLocalizedString(@"user-coin-vc.table-cell.behavior", @"Behavior");
            tableCell.countLabel.text = NSLocalizedString(@"user-coin-vc.table-cell.coin", @"Blue coin");
            tableCell.descLabel.text = NSLocalizedString(@"user-coin-vc.table-cell.desc", @"Description");
            tableCell.backgroundColor = BLUThemeMainColor;
        } else {
            BLUCoinDailyRule *rule = self.coinViewModel.coinDailyRules[indexPath.row - 1];
            tableCell.style = BLUUserSimpleTableCellStyleContent;
            tableCell.titleLabel.text = rule.title;
            tableCell.countLabel.text = rule.profitDesc;
            tableCell.descLabel.text = rule.desc;
            tableCell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : [UIColor colorFromHexString:@"#DEDFDF"];
        }
    }
}

- (void)finishTaskAction:(id)sender {
    BLUUserSettingViewController *vc = [[BLUUserSettingViewController alloc] initWithUser:self.user];
    [self pushViewController:vc];
}

#pragma mark - TableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (tableView == _coinTaskTableView) {
        height = [_coinTaskTableView sizeForCellWithCellClass:[BLUUserCoinTaskCell class] cacheByIndexPath:indexPath width:_coinTaskTableView.width configuration:^(BLUCell *cell) {
            [self configCell:cell atIndexPath:indexPath];
        }].height;
    } else if (tableView == _dailyTaskTableView) {
        height = [_dailyTaskTableView sizeForCellWithCellClass:[BLUUserSimpleTableCell class] cacheByIndexPath:indexPath width:_dailyTaskTableView.width configuration:^(BLUCell *cell) {
            [self configCell:cell atIndexPath:indexPath];
        }].height;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
