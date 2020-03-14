//
//  QGDynamicViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/1.
//
//  巧妈帮动态

#import "QGDynamicViewController.h"
#import "BLUDynamicViewModel.h"
#import "BLUUserTransitionDelegate.h"
#import "BLUDynamicCell.h"
#import "BLUDynamic.h"
#import "BLURemoteNotification.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUPostCommentDetailReplyAsyncViewController.h"
#import "BLUOtherUserViewController.h"
#import "BLURefreshFooter.h"

@interface QGDynamicViewController () <UITableViewDelegate,UITableViewDataSource,BLUDynamicViewModelDelegate>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) BLUDynamicViewModel *dynamicViewModel;
@property (nonatomic, strong) BLUUserTransitionDelegate *userTransition;

@end

@implementation QGDynamicViewController

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"社区动态";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    _dynamicViewModel = [[BLUDynamicViewModel alloc] init];
    _dynamicViewModel.delegate = self;
    _tableView = [BLUTableView new];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[BLUDynamicCell class] forCellReuseIdentifier:NSStringFromClass([BLUDynamicCell class])];
    [self.view addSubview:_tableView];
  
    self.tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        [_dynamicViewModel fetchNext];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.dynamicViewModel fetch];
}

- (void)handleRemoteNotification:(NSNotification *)userInfo {
    BLURemoteNotification *remoteNotification = userInfo.object;
    switch (remoteNotification.type) {
        case BLURemoteNotificationTypeComment:
        case BLURemoteNotificationTypeLikePost:
        case BLURemoteNotificationTypeLikeComment:
        case BLURemoteNotificationTypeCommentReply:
        case BLURemoteNotificationTypeFollow: {
            [self.dynamicViewModel fetch];
        } break;
        default: {
            [super handleRemoteNotification:userInfo];
        } break;
    }
}



- (BLUUserTransitionDelegate *)userTransition {
    if (_userTransition == nil) {
        _userTransition = [BLUUserTransitionDelegate new];
        _userTransition.viewController = self;
    }
    return _userTransition;
}

#pragma mark - UITableView.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = self.dynamicViewModel.DynamicArray.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUDynamicCell *cell = (BLUDynamicCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUDynamicCell class]) forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [_tableView sizeForCellWithCellClass:[BLUDynamicCell class]
                                      cacheByIndexPath:indexPath
                                                 width:_tableView.width
                                         configuration:^(BLUCell *cell) {
                                             [self configCell:cell atIndexPath:indexPath];
                                         }];
    BLULogDebug(@"indexPath ==> %@, size ==> %@", indexPath, NSStringFromCGSize(size));
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUDynamic *dynamic = self.dynamicViewModel.DynamicArray[indexPath.row];
    switch (dynamic.type) {
        case BLUDynamicTypeCommentPost:
        case BLUDynamicTypeLikePost: {
            NSInteger postID = dynamic.target.postID;
            BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:postID];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case BLUDynamicTypeLikeComment:
        case BLUDynamicTypeReplyComment: {
            NSInteger postID = dynamic.target.postID;
            NSInteger commentID = dynamic.target.commentID;
            BLUPostCommentDetailReplyAsyncViewController *vc = [[BLUPostCommentDetailReplyAsyncViewController alloc] initWithCommentID:commentID postID:postID];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case BLUDynamicTypeUserFollow: {
            NSInteger userID = dynamic.FromUserID;
            BLUOtherUserViewController *vc = [[BLUOtherUserViewController alloc] initWithUserID:userID];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
    }
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BLUDynamicCell *dynamicCell = (BLUDynamicCell *)cell;
    [dynamicCell setModel:self.dynamicViewModel.DynamicArray[indexPath.row]];
    dynamicCell.userTransitionDelegate = self.userTransition;
}

#pragma mark - BLUDynamicViewModelDelegate

- (void)viewModelDidFetchNextComplete:(id)viewModel
{
    [self.tableView reloadData];
    [self tableViewEndRefreshing:self.tableView];
}

- (void)shouldDiableFetchNextFromViewModel:(id)viewModel {
    [self tableViewEndRefreshing:self.tableView noMoreData:YES];
}

- (void)viewModelDidFetchNextFailed:(id)viewModel error:(NSError *)error
{
    [self showTopIndicatorWithError:error];
}

@end
