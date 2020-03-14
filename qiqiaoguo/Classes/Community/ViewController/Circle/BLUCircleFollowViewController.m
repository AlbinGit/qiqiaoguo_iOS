//
//  BLUCircleFollowViewController.m
//  Blue
//
//  Created by Bowen on 27/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleFollowViewController.h"
#import "BLUCircleFollowedPostNode.h"
#import "BLUCircleFollowViewModel.h"
#import "BLUOtherUserViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUCircle.h"
#import "BLUCircleFollowedPostUserInfoNode.h"
#import "BLUPost.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUCircleFollowHeader.h"
#import "BLUCircleFollowFooterView.h"


@implementation BLUCircleFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _viewModel = [BLUCircleFollowViewModel new];

    _tableView = [ASTableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.asyncDelegate = self;
    _tableView.asyncDataSource = self;
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;

    _footerView = [BLUCircleFollowFooterView new];
    _footerView.delegate = self;
    _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _footerView.frame = CGRectMake(0, 0, self.view.width, 52.0);

    _header = [BLUCircleFollowHeader new];
    _header.headerDelegate = self;

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:_tableView];

    @weakify(self);
    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.viewModel.recommended == NO) {
            [self.viewModel.posts removeAllObjects];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationFade];
        }
        [[self.viewModel fetch] subscribeNext:^(id x) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationFade];
            [self.view hideIndicator];
            [self tableViewEndRefreshing:self.tableView];
            if (self.viewModel.recommended) {
                self.tableView.tableFooterView = self.footerView;
            } else {
                self.tableView.tableFooterView = nil;
            }
        } error:^(NSError *error) {
            [self showTopIndicatorWithError:error];
            [self tableViewEndRefreshing:self.tableView];
            [self.view hideIndicator];
        }];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
    _tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);

}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    [self.view showIndicator];
    @weakify(self);
    [[self.viewModel fetch] subscribeError:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
        [self.view hideIndicator];
        [self tableViewEndRefreshing:self.tableView];
    } completed:^{
        @strongify(self);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationFade];
        [self.view hideIndicator];
        [self tableViewEndRefreshing:self.tableView];
        if (self.viewModel.recommended) {
            self.tableView.tableFooterView = self.footerView;
        } else {
            self.tableView.tableFooterView = nil;
        }
    }];
}

@end

@implementation BLUCircleFollowViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.posts.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUCircleFollowedPostNode *node =
    [[BLUCircleFollowedPostNode alloc]
     initWithPost:self.viewModel.posts[indexPath.row]];
    node.delegate = self;
    node.userNode.delegate = self;
    return node;
}

- (void)tableView:(ASTableView *)tableView
willBeginBatchFetchWithContext:(ASBatchContext *)context {
    @weakify(self);
    [[self.viewModel fetchNext] subscribeNext:^(NSArray *items) {
        @strongify(self);
        if (items) {
            NSInteger initialIndex = self.viewModel.posts.count - items.count;
            NSMutableArray *indexPaths = [NSMutableArray new];
            [items enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                NSUInteger idx,
                                                BOOL * _Nonnull stop) {
                NSIndexPath *indexPath =
                [NSIndexPath indexPathForRow:initialIndex + idx inSection:0];
                [indexPaths addObject:indexPath];
            }];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        [self tableViewEndRefreshing:self.tableView];
        [self.view hideIndicator];
        [context completeBatchFetching:YES];
    } error:^(NSError *error) {
        @strongify(self);
        [self tableViewEndRefreshing:self.tableView];
        [self.view hideIndicator];
        [context completeBatchFetching:YES];
    }];
    [context completeBatchFetching:YES];
}

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView {
    return !self.viewModel.noMoreData;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUPost *post = self.viewModel.posts[indexPath.row];
    BLUPostDetailAsyncViewController *vc =
    [[BLUPostDetailAsyncViewController alloc] initWithPostID:post.postID];
    [self pushViewController:vc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.viewModel.recommended == YES) {
        return 32.0;
    } else {
        return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.viewModel.recommended == YES) {
        return self.header;
    } else {
        return nil;
    }
}

@end

@implementation BLUCircleFollowViewController (Cell)

- (void)shouldShowCircleDetails:(BLUCircle *)circle
                           from:(BLUCircleFollowedPostNode *)node
                         sender:(id)sender {
    BLUAssertObjectIsKindOfClass(circle, [BLUCircle class]);
    BLUCircleDetailMainViewController *vc =
    [[BLUCircleDetailMainViewController alloc] initWithCircleID:circle.circleID];
    [self pushViewController:vc];
}

- (void)shouldShowUserDetails:(BLUUser *)user
                         from:(BLUCircleFollowedPostNode *)node
                       sender:(id)sender {
    BLUAssertObjectIsKindOfClass(user, [BLUUser class]);
    BLUOtherUserViewController *vc =
    [[BLUOtherUserViewController alloc] initWithUserID:user.userID];
    [self pushViewController:vc];
}

- (void)shouldChangeFollowStateForUser:(BLUUser *)user
                                  from:(BLUCircleFollowedPostUserInfoNode *)node
                                sender:(id)sender {
    ASCellNode *cellNode = (ASCellNode *)node.supernode;
    NSIndexPath *indexPath = [self.tableView indexPathForNode:cellNode];
    BLUPost *post = self.viewModel.posts[indexPath.row];

    void (^updateRecommendState)() = ^() {
        BOOL didFollow = NO;
        for (BLUPost *post in self.viewModel.posts) {
            if (post.didFollow == YES) {
                didFollow = YES;
                break;
            }
        }
        self.viewModel.recommended = !didFollow;
        self.footerView.didFollow = didFollow;
    };

    NSArray *(^changeFollowState)(NSInteger , BOOL ) = ^NSArray *(NSInteger userID, BOOL state) {
        NSMutableArray *indexPaths = [NSMutableArray new];
        [self.viewModel.posts enumerateObjectsUsingBlock:^(BLUPost *post, NSUInteger idx, BOOL * _Nonnull stop) {
            if (post.author.userID == userID) {
                post.follow = state;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexPaths addObject:indexPath];
            }
        }];
        return indexPaths;
    };

    if (post.follow == YES) {
        @weakify(self);
        [[self.viewModel unfollowUser:user] subscribeNext:^(id x) {
            @strongify(self);
            NSArray *indexPaths = changeFollowState(user.userID, NO);
            updateRecommendState();

            if (indexPaths.count > 0) {
//                [self.tableView beginUpdates];
                for (NSIndexPath *indexPath in indexPaths) {
                    BLUCircleFollowedPostNode *node =
                    (BLUCircleFollowedPostNode *)[self.tableView nodeForRowAtIndexPath:indexPath];
                    [node.userNode configureFollowWithState:NO];
                }
                self.header.changeButton.hidden = NO;
//                [self.tableView endUpdates];
            }
        } error:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
        }];
    } else {
        @weakify(self);
        [[self.viewModel followUser:user] subscribeNext:^(id x) {
            @strongify(self);
            NSArray *indexPaths = changeFollowState(user.userID, YES);
            updateRecommendState();

            if (indexPaths.count > 0) {
//                [self.tableView beginUpdates];
                for (NSIndexPath *indexPath in indexPaths) {
                    BLUCircleFollowedPostNode *node =
                    (BLUCircleFollowedPostNode *)[self.tableView nodeForRowAtIndexPath:indexPath];
                    [node.userNode configureFollowWithState:YES];
                }
                self.header.changeButton.hidden = YES;
//                [self.tableView endUpdates];
            }
        } error:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
        }];
    }
}

- (void)shouldChangeRecommendedUserFrom:(BLUCircleFollowHeader *)header
                                 sender:(id)sender {
    [self.tableView.mj_header beginRefreshing];
}

- (void)footerViewDidRefresh:(BLUCircleFollowFooterView *)footerView {
    [self.tableView.mj_header beginRefreshing];
}

@end
