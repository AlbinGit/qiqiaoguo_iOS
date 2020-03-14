//
//  BLUPostLikedUserViewController.m
//  Blue
//
//  Created by Bowen on 24/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostLikedUserViewController.h"
#import "BLUPost.h"
#import "BLUOtherUserViewController.h"
#import "BLUApiManager+User.h"
#import "BLUPagination.h"
#import "BLUUserSimpleCell.h"

@implementation BLUPostLikedUserViewController

- (instancetype)initWithPost:(BLUPost *)post {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(post, [BLUPost class]);
        _post = post;

        _tableView = [BLUTableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[BLUUserSimpleCell class]
           forCellReuseIdentifier:NSStringFromClass([BLUUserSimpleCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        self.title = NSLocalizedString(@"post-liked-user-vc.title", @"Liked user");

        _users = [NSMutableArray new];

        _pagination = [[BLUPagination alloc] initWithPerpage:20
                                                       group:nil
                                                       order:BLUPaginationOrderNone];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.view showIndicator];
    self.pagination.page = BLUPaginationPageBase;
    @weakify(self);
    [[[BLUApiManager sharedManager] fetchUsersLikingPost:self.post.postID pagination:self.pagination] subscribeNext:^(NSArray *users) {
        @strongify(self);
        if (users.count > 0) {
            [self.users removeAllObjects];
            [self.users addObjectsFromArray:users];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationFade];
        }
        [self tableViewEndRefreshing:self.tableView];
        [self.view hideIndicator];
    } error:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
        [self tableViewEndRefreshing:self.tableView];
        [self.view hideIndicator];
    } completed:^{
        @strongify(self);
        self.pagination.page++;
        [self.view hideIndicator];
    }];

    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pagination.page = BLUPaginationPageBase;
        [self.view hideIndicator];
        [[[BLUApiManager sharedManager] fetchUsersLikingPost:self.post.postID pagination:self.pagination] subscribeNext:^(NSArray *users) {
            if (users.count > 0) {
                [self.users removeAllObjects];
                [self.users addObjectsFromArray:users];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationFade];
            }
            [self tableViewEndRefreshing:self.tableView];
        } error:^(NSError *error) {
            [self showTopIndicatorWithError:error];
            [self tableViewEndRefreshing:self.tableView];
        } completed:^{
            self.pagination.page++;
        }];
    }];

    _tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.view hideIndicator];
        [[[BLUApiManager sharedManager] fetchUsersLikingPost:self.post.postID pagination:self.pagination] subscribeNext:^(NSArray *users) {
            if (users.count > 0) {
                [self.users addObjectsFromArray:users];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationFade];
                [self tableViewEndRefreshing:self.tableView];
            } else {
                [self tableViewEndRefreshing:self.tableView noMoreData:YES];
            }
        } error:^(NSError *error) {
            [self showTopIndicatorWithError:error];
            [self tableViewEndRefreshing:self.tableView noMoreData:NO];
        } completed:^{
            self.pagination.page++;
        }];
        BLULogDebug(@"do something");
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

@end

@implementation BLUPostLikedUserViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUUserSimpleCell *cell = (BLUUserSimpleCell *)[_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserSimpleCell class])
                                           forIndexPath:indexPath
                                                  model:_users[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView sizeForCellWithCellClass:[BLUUserSimpleCell class] cacheByIndexPath:indexPath width:self.tableView.width model:_users[indexPath.row]].height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUUser *user = _users[indexPath.row];
    BLUOtherUserViewController *vc = [[BLUOtherUserViewController alloc]
                                      initWithUserID:user.userID];
    [self pushViewController:vc];
}

@end
