//
//  BLUCircleHotViewController.m
//  Blue
//
//  Created by Bowen on 27/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleHotViewController.h"
#import "BLUPostViewModel.h"
#import "BLUPostCommonNode.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUPost.h"
#import "BLUPostDetailAsyncViewController.h"

@implementation BLUCircleHotViewController

- (instancetype)init {
    if (self = [super init]) {
        // TODO: 换成热门
        _postViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeHot];
        _postViewModel.circleID = 4;

        _tableView = [ASTableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.asyncDelegate = self;
        _tableView.asyncDataSource = self;
        _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
        _tableView.leadingScreensForBatching = 2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    @weakify(self);
    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.postViewModel fetch] subscribeError:^(NSError *error) {
            [self showTopIndicatorWithError:error];
            [self.view hideIndicator];
            [self tableViewEndRefreshing:self.tableView];
        } completed:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationFade];
            [self.view hideIndicator];
            [self tableViewEndRefreshing:self.tableView];
        }];
    }];
    
    _tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
    _tableView.height -= self.bottomLayoutGuide.length;
    _tableView.y += self.topLayoutGuide.length;
}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    [self.view showIndicator];
    @weakify(self);
    [[_postViewModel fetch] subscribeError:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
        [self.view hideIndicator];
    } completed:^{
        @strongify(self);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationFade];
        [self.view hideIndicator];
    }];
}

@end

@implementation BLUCircleHotViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.postViewModel.posts.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUPostCommonNode *postNode = [[BLUPostCommonNode alloc]
                                   initWithPost:self.postViewModel.posts[indexPath.row]];
    return postNode;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUPost *post = self.postViewModel.posts[indexPath.row];
    BLUPostDetailAsyncViewController *vc =
    [[BLUPostDetailAsyncViewController alloc] initWithPostID:post.postID];
    [self pushViewController:vc];
}

- (void)tableView:(ASTableView *)tableView
willBeginBatchFetchWithContext:(ASBatchContext *)context {
    @weakify(self);
    NSLog(@"123");
    [[self.postViewModel fetchNext] subscribeNext:^(NSArray *items) {
        @strongify(self);
        if (items) {
            NSInteger initialIndex = self.postViewModel.posts.count - items.count;
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
}

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView {
    return !self.postViewModel.noMoreData;
}

@end
