//
//  BLUCircleMoreViewController.m
//  Blue
//
//  Created by Bowen on 31/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircleMoreViewController.h"
#import "BLUCircleViewModel.h"
#import "BLUCircle.h"
#import "BLUCircleBriefCell.h"
#import "BLUCircleActionDelegate.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUCircleMO.h"
#import "BLUApiManager+Circle.h"

@interface BLUCircleMoreViewController () <UITableViewDelegate, UITableViewDataSource, BLUCircleActionDelegate>

@property (nonatomic, strong) BLUCircleViewModel *allCirclesViewModel;
@property (nonatomic, strong) BLUCircleActionDelegate *circleAction;
@property (nonatomic, strong) BLUCircleViewModel *circleViewModel;

@property (nonatomic, strong) BLUTableView *tableView;

@end

@implementation BLUCircleMoreViewController

#pragma mark - Life circle

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"circle-more.title", @"More circles");
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    // Table view
    _tableView = [[BLUTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[BLUCircleBriefCell class] forCellReuseIdentifier:NSStringFromClass([BLUCircleBriefCell class])];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [self addTiledLayoutConstrantForView:_tableView];
    
    // Model
    @weakify(self);
    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.allCirclesViewModel fetch] handleFetchForViewController:self tableView:self.tableView reloadBlock:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }];
    
    _tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self.allCirclesViewModel fetchNext] handleFetchForViewController:self tableView:self.tableView reloadBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    [_tableView.mj_header beginRefreshing];
}

- (void)willFollowCircle:(NSInteger)circleID {
    [self.allCirclesViewModel.circles enumerateObjectsUsingBlock:^(BLUCircle *circle, NSUInteger idx, BOOL *stop) {
        if (circle.circleID == circleID) {
            circle.didFollowCircle = YES;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

- (void)didFollowCircle:(NSInteger)circleID error:(NSError *)error {
    void (^refreshCircle)(BLUCircleViewModel *, NSInteger, BOOL) = ^(BLUCircleViewModel *viewModel, NSInteger section, BOOL didFollow) {
        [viewModel.circles enumerateObjectsUsingBlock:^(BLUCircle *circle, NSUInteger idx, BOOL *stop) {
            if (circle.circleID == circleID) {
                circle.didFollowCircle = didFollow;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    };
    
    if (error) {
        [self showAlertForError:error];
        refreshCircle(self.allCirclesViewModel, 0, NO);
    }
}

- (void)willUnfollowCircle:(NSInteger)circleID {
    [self.allCirclesViewModel.circles enumerateObjectsUsingBlock:^(BLUCircle *circle, NSUInteger idx, BOOL *stop) {
        if (circle.circleID == circleID) {
            circle.didFollowCircle = NO;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

- (void)didUnfollowCircle:(NSInteger)circleID error:(NSError *)error {
    void (^refreshCircle)(BLUCircleViewModel *, NSInteger, BOOL) = ^(BLUCircleViewModel *viewModel, NSInteger section, BOOL didFollow) {
        [viewModel.circles enumerateObjectsUsingBlock:^(BLUCircle *circle, NSUInteger idx, BOOL *stop) {
            if (circle.circleID == circleID) {
                circle.didFollowCircle = didFollow;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    };

    if (error) {
        [self showAlertForError:error];
        refreshCircle(self.allCirclesViewModel, 0, YES);
    }
}

#pragma mark - Model

- (BLUCircleViewModel *)allCirclesViewModel {
    if (_allCirclesViewModel == nil) {
        _allCirclesViewModel = [[BLUCircleViewModel alloc] initWithFetchCircleType:BLUFetchCircleTypeAll];
    }
    return _allCirclesViewModel;
}

- (BLUCircleViewModel *)circleViewModel {
    if (_circleViewModel == nil) {
        _circleViewModel = [[BLUCircleViewModel alloc] initWithFetchCircleType:BLUFetchCircleTypeOne];
    }
    return _circleViewModel;
}

- (BLUCircleActionDelegate *)circleAction {
    if (_circleAction == nil) {
        _circleAction = [BLUCircleActionDelegate new];
        _circleAction.viewController = self;
    }
    return _circleAction;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allCirclesViewModel.circles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    BLUCircleBriefCell *briefCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUCircleBriefCell class]) forIndexPath:indexPath];
    briefCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    BOOL shouldShowSeparatorLine = indexPath.row == self.allCirclesViewModel.circles.count - 1 ? NO : YES;
    [briefCell setModel:self.allCirclesViewModel.circles[indexPath.row] shouldShowSeparatorLine:shouldShowSeparatorLine shouldShowQuit:YES shouldShowUnreadPostCount:NO circleActionDelegate:self];
    cell = briefCell;
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BLUCircleBriefCell sizeForLayoutedCellWith:self.view.width sharedCell:nil].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUCircle *circle = self.allCirclesViewModel.circles[indexPath.row];
    BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:circle.circleID];
    [self pushViewController:vc];
}

#pragma mark - BLUCircleActionDelegate.

- (void)shouldFollowCircle:(NSDictionary *)circleInfo fromView:(UIView *)view sender:(id)sender {

    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser == nil) {
        [self loginRequired:nil];
        return;
    }

    BLUCircle *circle = circleInfo[BLUCircleKeyCircle];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(BLUCircleBriefCell *)view];

    if (circle == nil) {
        return;
    }

    circle.isFollowRequesting = YES;
    circle.didFollowCircle = YES;
    [self updateCircleMOWithCircleID:circle.circleID didFollow:YES];
    [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [[self followWithCircleID:circle.circleID] subscribeError:^(NSError *error) {
        [self showTopIndicatorWithError:error];
        circle.isFollowRequesting = NO;
        circle.didFollowCircle = NO;
        [self updateCircleMOWithCircleID:circle.circleID didFollow:NO];
        [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } completed:^{
        circle.isFollowRequesting = NO;
        circle.didFollowCircle = YES;
        [self updateCircleMOWithCircleID:circle.circleID didFollow:YES];
        [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)shouldUnfollowCircle:(NSDictionary *)circleInfo fromView:(UIView *)view sender:(id)sender {

    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser == nil) {
        [self loginRequired:nil];
        return;
    }

    BLUCircle *circle = circleInfo[BLUCircleKeyCircle];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(BLUCircleBriefCell *)view];

    if (circle == nil) {
        return;
    }

    circle.isFollowRequesting = YES;
    circle.didFollowCircle = NO;
    [self updateCircleMOWithCircleID:circle.circleID didFollow:NO];
    [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [[self unfollowWithCircleID:circle.circleID] subscribeError:^(NSError *error) {
        [self showTopIndicatorWithError:error];
        circle.isFollowRequesting = NO;
        circle.didFollowCircle = YES;
        [self updateCircleMOWithCircleID:circle.circleID didFollow:YES];
        [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } completed:^{
        circle.isFollowRequesting = NO;
        circle.didFollowCircle = NO;
        [self updateCircleMOWithCircleID:circle.circleID didFollow:NO];
        [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)updateCircleMOWithCircleID:(NSInteger)circleID didFollow:(BOOL)didFollow{
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    NSInteger userID = currentUser != nil ? currentUser.userID : 0;
    BLUCircleMO *circleMO = [BLUCircleMO circleMOFromCircleID:circleID userID:userID];
    if (circleMO) {
        circleMO.didFollowCircle = @(didFollow);
    }
}

- (RACSignal *)followWithCircleID:(NSInteger)circleID {
    return [[BLUApiManager sharedManager] followCircleWithCircleID:circleID];
}

- (RACSignal *)unfollowWithCircleID:(NSInteger)circleID {
    return [[BLUApiManager sharedManager] unfollowCircleWithCircleID:circleID];
}

@end
