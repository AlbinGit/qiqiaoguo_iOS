//
//  BLUCircleDetailAsyncViewController.m
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleDetailAsyncViewController.h"
#import "BLUPostViewModel.h"
#import "BLUPostCommonNode.h"
#import "BLUPost.h"
#import "BLUCircleViewModel.h"
#import "BLUCircle.h"
#import "BLUCircleBriefAsyncNode.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUApiManager+Circle.h"
#import "BLUSendPost2ViewController.h"
#import "BLUSendPost2ViewControllerDelegate.h"
#import "BLUCircleMO.h"

@implementation BLUCircleDetailAsyncViewController

- (instancetype)initWithCircleID:(NSInteger)circleID type:(BLUPostType)type {
    if (self = [super init]) {
//        BLUParameterAssert(circleID > 0);
        _circleID = circleID;
        _type = type;

        _postViewModel = [[BLUPostViewModel alloc] initWithPostType:type];
        _postViewModel.circleID = circleID;

        _circleViewModel = [[BLUCircleViewModel alloc] initWithFetchCircleType:BLUFetchCircleTypeOne];
        _circleViewModel.circleID = _circleID;

        _tableView = [ASTableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.asyncDelegate = self;
        _tableView.asyncDataSource = self;
        _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;

        _sendButton = [UIButton new];
        [_sendButton setImage:[UIImage imageNamed:@"send-post"]
                     forState:UIControlStateNormal];
        [_sendButton addTarget:self
                        action:@selector(tapAndSend:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tableView];
    [self.view addSubview:_sendButton];
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-BLUThemeMargin * 8);
    }];

    @weakify(self);
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        [[_circleViewModel fetch] subscribeError:^(NSError *error) {
            @strongify(self);
            [self showTopIndicatorWithError:error];
            [self.view hideIndicator];
            [self tableViewEndRefreshing:self.tableView];
        } completed:^{
            @strongify(self);
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

            [[_postViewModel fetch] subscribeError:^(NSError *error) {
                [self showTopIndicatorWithError:error];
                [self.view hideIndicator];
                [self tableViewEndRefreshing:self.tableView];
            } completed:^{
                [self.view hideIndicator];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                [self tableViewEndRefreshing:self.tableView];
            }];
        }];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewWillFirstAppear {
    [super viewDidFirstAppear];
    [self.view showIndicator];
    @weakify(self);
    [[_circleViewModel fetch] subscribeError:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
        [self.view hideIndicator];
    } completed:^{
        @strongify(self);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

        [[_postViewModel fetch] subscribeError:^(NSError *error) {
            [self showTopIndicatorWithError:error];
            [self.view hideIndicator];
        } completed:^{
            [self.view hideIndicator];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    @weakify(self);
    if (self.circleViewModel.circle) {
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            [[_circleViewModel fetch] subscribeError:^(NSError *error) {
                @strongify(self);
                [self showTopIndicatorWithError:error];
            } completed:^{
                @strongify(self);
                BLUCircleBriefAsyncNode *node =
                (BLUCircleBriefAsyncNode *)[self.tableView nodeForRowAtIndexPath:
                 [NSIndexPath indexPathForRow:0 inSection:0]];
                [node setCircle:self.circleViewModel.circle];
            }];
        }
    }
}

- (void)tapAndSend:(id)sender {
    if ([self loginIfNeeded]) {
        return;
    }

    BLUSendPost2ViewController *vc = [BLUSendPost2ViewController new];

    vc.circle = self.circleViewModel.circle;
    vc.delegate = self;

    BLUNavigationController *navVC =
    [[BLUNavigationController alloc] initWithRootViewController:vc];

    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)sendPostViewControllerDidSendPost:(BLUSendPost2ViewController *)viewController {
    [self showTopIndicatorWithSuccessMessage:NSLocalizedString(@"circle-detail-vc.send-post-success", @"Send post success")];
}

@end

@implementation BLUCircleDetailAsyncViewController (TableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.circleViewModel.circle != nil ? 1 : 0;
    } else if (section == 1) {
        return self.postViewModel.posts.count;
    } else {
        return 0;
    }
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *node = nil;

    if (indexPath.section == 0) {
        BLUCircleBriefAsyncNode *circleNode =
        [[BLUCircleBriefAsyncNode alloc]
         initWithCircle:self.circleViewModel.circle];
        circleNode.delegate = self;
        node = circleNode;
    } else if (indexPath.section == 1) {
        BLUPostCommonNode *postNode = [[BLUPostCommonNode alloc]
                                       initWithPost:self.postViewModel.posts[indexPath.row]];
        node = postNode;
    } else {
        node = nil;
    }

    return node;
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
                [NSIndexPath indexPathForRow:initialIndex + idx inSection:1];
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
        dispatch_sync(dispatch_get_main_queue(), ^{
        [self tableViewEndRefreshing:self.tableView];
            });
        [self.view hideIndicator];
        [context completeBatchFetching:YES];
    }];
    [context completeBatchFetching:YES];
}

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView {
    return !self.postViewModel.noMoreData;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        BLUPost *post = self.postViewModel.posts[indexPath.row];
        BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc]
                                           initWithPostID:post.postID];
        [self pushViewController:vc];
    }
}

@end

@implementation BLUCircleDetailAsyncViewController (Cell)

- (void)shouldChangeFollowStateForCircle:(BLUCircle *)circle
                                    from:(BLUCircleBriefAsyncNode *)node
                                  sender:(id)sender {

    void (^reloadNode)(BLUCircle *) = ^(BLUCircle *circle){
        [self.tableView beginUpdates];
        [node setCircle:circle];
        [self.tableView endUpdates];
    };

    if (circle.didFollowCircle) {
        circle.didFollowCircle = NO;
        [self updateCircleMOWithCircleID:circle.circleID didFollow:circle.didFollowCircle];
        reloadNode(circle);
        @weakify(self);
        [[[BLUApiManager sharedManager] unfollowCircleWithCircleID:circle.circleID]
         subscribeError:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
            circle.didFollowCircle = YES;
            [self updateCircleMOWithCircleID:circle.circleID didFollow:circle.didFollowCircle];
            reloadNode(circle);
        }];
    } else {
        circle.didFollowCircle = YES;
        [self updateCircleMOWithCircleID:circle.circleID didFollow:circle.didFollowCircle];
        reloadNode(circle);
        @weakify(self);
        [[[BLUApiManager sharedManager] followCircleWithCircleID:circle.circleID]
         subscribeError:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
            circle.didFollowCircle = NO;
            [self updateCircleMOWithCircleID:circle.circleID didFollow:circle.didFollowCircle];
            reloadNode(circle);
        }];
    }
}

- (void)updateCircleMOWithCircleID:(NSInteger)circleID didFollow:(BOOL)didFollow{
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    NSInteger userID = currentUser != nil ? currentUser.userID : 0;
    BLUCircleMO *circleMO = [BLUCircleMO circleMOFromCircleID:circleID userID:userID];
    if (circleMO) {
        circleMO.didFollowCircle = @(didFollow);
    }
}

@end
