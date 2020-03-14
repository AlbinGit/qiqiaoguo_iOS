//
//  BLUHotTagViewController.m
//  Blue
//
//  Created by cws on 16/4/6.
//  Copyright © 2016年 com.boki. All rights reserved.
//

#import "BLUHotTagViewController.h"
#import "BLUHotTagViewModel.h"
#import "BLUPostTag.h"
#import "BLUCirleHotTagNode.h"
#import "BLUPostTagDetailViewController.h"

@interface BLUHotTagViewController ()

@end

@implementation BLUHotTagViewController

- (instancetype)init {
    if (self = [super init]) {

        _tableView = [ASTableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.asyncDelegate = self;
        _tableView.asyncDataSource = self;
        _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
        
    }
    return self;
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    [self.view showIndicator];
    @weakify(self);
    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.hotTagViewModel fetch] subscribeNext:^(id x) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationFade];
            [self.view hideIndicator];
            [self tableViewEndRefreshing:self.tableView];
        } error:^(NSError *error) {
            [self showTopIndicatorWithError:error];
            [self tableViewEndRefreshing:self.tableView];
            [self.view hideIndicator];
        }];
    }];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    [[self.hotTagViewModel fetch] subscribeNext:^(id x) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationFade];
        [self.view hideIndicator];
        [self tableViewEndRefreshing:self.tableView];
    } error:^(NSError *error) {
        [self showTopIndicatorWithError:error];
        [self tableViewEndRefreshing:self.tableView];
        [self.view hideIndicator];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
    _tableView.height -= self.bottomLayoutGuide.length;
}

- (BLUHotTagViewModel *)hotTagViewModel {
    if (_hotTagViewModel == nil) {
        _hotTagViewModel = [BLUHotTagViewModel new];
        //        _hotTagViewModel.delegate = self;
    }
    return _hotTagViewModel;
}

@end
@implementation BLUHotTagViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.hotTagViewModel.tags.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BLUCirleHotTagNode *TagNode = [[BLUCirleHotTagNode alloc] initWithTag:self.hotTagViewModel.tags[indexPath.row]];

    
    return TagNode;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUPostTag *tag = self.hotTagViewModel.tags[indexPath.row];
    UIViewController *vc = nil;
    vc = [[BLUPostTagDetailViewController alloc] initWithTagID:tag.tagID];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableView:(ASTableView *)tableView
willBeginBatchFetchWithContext:(ASBatchContext *)context {
    @weakify(self);
    [[self.hotTagViewModel fetchNext] subscribeNext:^(NSArray *items) {
        @strongify(self);
        if (items) {
            NSInteger initialIndex = self.hotTagViewModel.tags.count - items.count;
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
    return !self.hotTagViewModel.noMoreData;
}



@end
