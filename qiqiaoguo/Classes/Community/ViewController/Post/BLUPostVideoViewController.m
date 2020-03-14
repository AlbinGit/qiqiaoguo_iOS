//
//  BLUPostVideoViewController.m
//  Blue
//
//  Created by Bowen on 2/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUPostVideoViewController.h"
#import "BLUPostViewModel.h"
#import "BLUPostCommonVideoNode.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUPost.h"

@implementation BLUPostVideoViewController

- (instancetype)initWithGoodID:(NSNumber *)goodID {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(goodID, [NSNumber class]);
        _goodID = goodID;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self postViewModel];
    [self tableView];

    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    @weakify(self);
    self.tableView.mj_header =
    [BLURefreshHeader headerWithRefreshingBlock:^{
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
}

- (void)viewWillFirstAppear {
    [super viewDidFirstAppear];
    [self.view showIndicator];
    @weakify(self);
    [[self.postViewModel fetch] subscribeError:^(NSError *error) {
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

- (BLUPostViewModel *)postViewModel {
    if (_postViewModel == nil) {
        _postViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeGoodVideos];
        _postViewModel.goodID = _goodID.integerValue;
    }
    return _postViewModel;
}

- (ASTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [ASTableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.asyncDelegate = self;
        _tableView.asyncDataSource = self;
        _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
        _tableView.leadingScreensForBatching = 2;
    }
    return _tableView;
}

@end

@implementation BLUPostVideoViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postViewModel.posts.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[BLUPostCommonVideoNode alloc]
            initWithPost:self.postViewModel.posts[indexPath.row]];
//    return [ASCellNode new];
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
    [context completeBatchFetching:YES];
}

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView {
    return !self.postViewModel.noMoreData;
}

@end
