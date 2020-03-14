//
//  BLUUserLevelViewController.m
//  Blue
//
//  Created by Bowen on 12/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserLevelViewController.h"
#import "BLUUserSimpleLevelView.h"
#import "BLUUserLevelComponentView.h"
#import "BLUUserSimpleTableCell.h"
#import "BLUUserLevelViewModel.h"
#import "BLULevelSpec.h"
#import "BLULevelRule.h"
#import "BLUUserLevelDetailsViewController.h"

@interface BLUUserLevelViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BLUUserSimpleLevelView *levelView;
@property (nonatomic, strong) BLUUserLevelComponentView *levelComponentView;
@property (nonatomic, strong) UILabel *levelDescriptionLabel;
@property (nonatomic, strong) BLUTableView *levelInfoTableView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) BLUUser *user;

@property (nonatomic, strong) BLUUserLevelViewModel *levelViewModel;

@end

@implementation BLUUserLevelViewController

- (instancetype)init {
    return [self initWithUser:[BLUUser defaultUser]];
}

- (instancetype)initWithUser:(BLUUser *)user {
    if (self = [super init]) {
        _user = user;
        self.title = NSLocalizedString(@"user-level-vc.title", @"Level info");
        self.hidesBottomBarWhenPushed = YES;
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    _levelView = [BLUUserSimpleLevelView new];
    _levelView.user = self.user;

    _levelComponentView = [BLUUserLevelComponentView new];

    _levelDescriptionLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _levelDescriptionLabel.text = NSLocalizedString(@"user-level-vc.desc-label.title", @"desc");

    _levelInfoTableView = [BLUTableView new];
    _levelInfoTableView.delegate = self;
    _levelInfoTableView.dataSource = self;
    _levelInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_levelInfoTableView registerClass:[BLUUserSimpleTableCell class] forCellReuseIdentifier:NSStringFromClass([BLUUserSimpleTableCell class])];

    _scrollView = [UIScrollView new];

    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_levelView];
    [_scrollView addSubview:_levelComponentView];
    [_scrollView addSubview:_levelDescriptionLabel];
    [_scrollView addSubview:_levelInfoTableView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"user-level-vc.right-bar-button.title", @"Details") style:UIBarButtonItemStylePlain target:self action:@selector(showLevelDetailsAction:)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat leftMargin = BLUThemeMargin * 4;
    CGFloat contentWidth = self.view.width - leftMargin * 2;

    _scrollView.frame = self.view.bounds;
    _levelView.frame = CGRectMake(0, 0, self.view.width, [BLUUserSimpleLevelView userSimpleInfoViewHeight]);

    _levelComponentView.x = leftMargin;
    _levelComponentView.y = _levelView.bottom + BLUThemeMargin * 4;
    _levelComponentView.width = contentWidth;
    _levelComponentView.height = [BLUUserLevelComponentView userLevelViewHeight];

    CGSize levelComponentViewSize = [_levelDescriptionLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    _levelDescriptionLabel.size = levelComponentViewSize;
    _levelDescriptionLabel.x = leftMargin;
    _levelDescriptionLabel.y = _levelComponentView.bottom + BLUThemeMargin * 4;

    _levelInfoTableView.x = leftMargin;
    _levelInfoTableView.y = _levelDescriptionLabel.bottom + BLUThemeMargin * 4;
    _levelInfoTableView.width = contentWidth;
    _levelInfoTableView.height = _levelInfoTableView.contentSize.height;

    CGFloat contentHeight = _levelInfoTableView.bottom + BLUThemeMargin * 4;

    _scrollView.contentSize = CGSizeMake(_scrollView.width, contentHeight);
}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    @weakify(self);
    [[self.levelViewModel fetchLevelRules] subscribeNext:^(id x) {
        @strongify(self);
//        [self.levelInfoTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.levelInfoTableView reloadData];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } error:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];

    [[self.levelViewModel fetchLevelSpecs] subscribeNext:^(id x) {
        @strongify(self);
        [self.levelComponentView setUser:self.user levelSpecs:self.levelViewModel.levelSpecs];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
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

- (void)showLevelDetailsAction:(id)sender {
    if ([BLUAppManager sharedManager].currentUser) {
        BLUUserLevelDetailsViewController *vc = [[BLUUserLevelDetailsViewController alloc] initWithUser:self.user];
        [self pushViewController:vc];
    }
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.levelViewModel.levelRules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserSimpleTableCell class]) forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[BLUUserSimpleTableCell class]]) {
        BLUUserSimpleTableCell *tableCell = (BLUUserSimpleTableCell *)cell;

        if (indexPath.row == 0) {
            tableCell.style = BLUUserSimpleTableCellStyleTitle;

            tableCell.titleLabel.text = NSLocalizedString(@"user-coin-vc.table-cell.behavior", @"Behavior");
            tableCell.countLabel.text = NSLocalizedString(@"user-level-vc.table-cell.exp", @"Exp");
            tableCell.descLabel.text = NSLocalizedString(@"user-coin-vc.table-cell.desc", @"Description");

            tableCell.backgroundColor = BLUThemeMainColor;
        } else {
            BLULevelRule *rule = self.levelViewModel.levelRules[indexPath.row - 1];

            tableCell.style = BLUUserSimpleTableCellStyleContent;

            tableCell.titleLabel.text = rule.title;
            tableCell.countLabel.text = rule.expDesc;
            tableCell.descLabel.text = rule.desc;
            tableCell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : [UIColor colorFromHexString:@"#DEDFDF"];
        }
    }
}

#pragma mark - TableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [_levelInfoTableView sizeForCellWithCellClass:[BLUUserSimpleTableCell class] cacheByIndexPath:indexPath width:tableView.width configuration:^(BLUCell *cell) {
        [self configCell:cell atIndexPath:indexPath];
    }].height;
    return height;
}

@end
