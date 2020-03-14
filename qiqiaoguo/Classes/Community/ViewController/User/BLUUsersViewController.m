//
//  BLUUsersViewController.m
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUsersViewController.h"
#import "BLUUserSimpleCell.h"
#import "BLUUsersViewModel.h"
#import "BLUOtherUserViewController.h"

@interface BLUUsersViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BLUTableView *tableView;

@property (nonatomic, strong) UILabel *cannotFindLabel;
@property (nonatomic, strong) UIImageView *cannotFindImageView;
@property (nonatomic, strong) UIView *cannotFindView;
@property (nonatomic, assign) BOOL showNoContentPrompt;
@end

@implementation BLUUsersViewController

- (instancetype)initWithUsersViewModel:(BLUUsersViewModel *)usersViewModel {
    if (self = [super init]) {
        _usersViewModel = usersViewModel;
        self.hidesBottomBarWhenPushed = YES;
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    _tableView = [BLUTableView new];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[BLUUserSimpleCell class] forCellReuseIdentifier:NSStringFromClass([BLUUserSimpleCell class])];
    [self.view addSubview:_tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    
    [self.view showIndicator];
    @weakify(self);
    [[self.usersViewModel fetch] subscribeNext:^(id x) {
        @strongify(self);
        [self.view hideIndicator];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } error:^(NSError *error) {
        @strongify(self);
        [self.view hideIndicator];
        [self showAlertForError:error];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self);
    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.view hideIndicator];
        [[self.usersViewModel fetch] subscribeNext:^(id x) {
            [self tableViewEndRefreshing:self.tableView];
            [self.tableView reloadData];
        } error:^(NSError *error) {
            [self tableViewEndRefreshing:self.tableView];
            [self showAlertForError:error];
        }];
    }];

    _tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.view hideIndicator];
        [[self.usersViewModel fetchNext] subscribeNext:^(NSArray *items) {
            [self tableViewEndRefreshing:self.tableView noMoreData:items.count == 0];
            [self.tableView reloadData];
        } error:^(NSError *error) {
            [self tableViewEndRefreshing:self.tableView];
            [self showAlertForError:error];
        }];
    }];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self showCannotViewIfNeed:self.usersViewModel.users.count > 0];
    return self.usersViewModel.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUUserSimpleCell *cell = (BLUUserSimpleCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserSimpleCell class]) forIndexPath:indexPath model:self.usersViewModel.users[indexPath.row]];
    if (indexPath.row == self.usersViewModel.users.count - 1) {
        cell.separator.hidden = YES;
    } else {
        cell.separator.hidden = NO;
    }
    return cell;
}

#pragma mark - TableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView sizeForCellWithCellClass:[BLUUserSimpleCell class] cacheByIndexPath:indexPath width:self.tableView.width model:self.usersViewModel.users[indexPath.row]].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUUser *user = self.usersViewModel.users[indexPath.row];
    BLUOtherUserViewController *vc = [[BLUOtherUserViewController alloc] initWithUserID:user.userID];
    [self pushViewController:vc];
}





- (UIImageView *)cannotFindImageView {
    if (_cannotFindImageView == nil) {
        _cannotFindImageView = [UIImageView new];
        _cannotFindImageView.image = [UIImage imageNamed:@"search-notfind"];
    }
    return _cannotFindImageView;
}

- (UILabel *)cannotFindLabel {
    if (_cannotFindLabel == nil) {
        _cannotFindLabel = [UILabel new];
        _cannotFindLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00];
        _cannotFindLabel.text = @"没有相关数据~";
        
    }
    return _cannotFindLabel;
}

- (UIView *)cannotFindView {
    if (_cannotFindView == nil) {
        _cannotFindView = [UIView new];
    }
    return _cannotFindView;
}

- (void)configCannotView {
    
    [self.view addSubview:self.cannotFindView];
    [self.cannotFindView addSubview:self.cannotFindImageView];
    [self.cannotFindView addSubview:self.cannotFindLabel];
    
    [self.cannotFindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(- 40);
    }];
    
    UIView *superview = self.cannotFindView;
    
    [self.cannotFindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview);
        make.left.greaterThanOrEqualTo(superview);
        make.right.lessThanOrEqualTo(superview);
        make.centerX.equalTo(superview);
    }];
    
    [self.cannotFindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cannotFindImageView.mas_bottom).offset(BLUThemeMargin * 2);
        make.centerX.equalTo(superview);
        make.left.greaterThanOrEqualTo(superview);
        make.right.lessThanOrEqualTo(superview);
        make.bottom.equalTo(superview);
    }];
}

- (void)showCannotViewIfNeed:(BOOL)hidden {
    if (![self.view isDescendantOfView:self.cannotFindView]) {
        [self configCannotView];
    }
    self.cannotFindView.hidden = hidden;
}


@end
