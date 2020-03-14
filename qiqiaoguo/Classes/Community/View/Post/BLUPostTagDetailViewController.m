//
//  BLUPostTagDetailViewController.m
//  Blue
//
//  Created by Bowen on 9/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagDetailViewController.h"
#import "BLUPostTagTitleView.h"
#import "BLUPostTagDetailSelector.h"
#import "BLUPostTag.h"
#import "BLUPostTagDetailBarView.h"
#import "BLUPostCommonNode.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUPostViewModel.h"
#import "BLUApiManager+Tag.h"
#import "BLUPost.h"
#import "BLUSendPost2ViewController.h"
#import "QGShareViewController.h"
#import "BLUShareManager.h"
#import "BLUSendPost2ViewControllerDelegate.h"

@interface BLUPostTagDetailViewController ()

@property (nonatomic, strong) UIImage *navigationBarBackgroundImage;
@property (nonatomic, strong) UIImage *navigationBarShadowImage;

@end

@implementation BLUPostTagDetailViewController

- (instancetype)initWithTagID:(NSInteger)tagID {
    if (self = [super init]) {
        BLUParameterAssert(tagID > 0);
        _tagID = tagID;

        _allViewModel = [[BLUPostViewModel alloc]
                         initWithPostType:BLUPostTypeTag];
        _allViewModel.tagID = tagID;

        _recommendedViewModel = [[BLUPostViewModel alloc]
                                 initWithPostType:BLUPostTypeTagRecommended];
        _recommendedViewModel.tagID = tagID;

        _postTagTitleView = [BLUPostTagTitleView new];
        _postTagTitleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        _postTagSelector = [BLUPostTagDetailSelector new];
        [_postTagSelector addTarget:self
                             action:@selector(handleSelection:)
                   forControlEvents:UIControlEventValueChanged];

        _tableView = [[ASTableView alloc] init];
        _tableView.frame = CGRectZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.asyncDataSource = self;
        _tableView.asyncDelegate = self;

        _postTagBar = [BLUPostTagDetailBarView new];

        _tagImageNode = [[ASNetworkImageNode alloc] initWithWebImage];
        _tagImageNode.clipsToBounds = YES;
        _tagImageNode.frame  = CGRectMake(0, 0, 100, 100);

        _tableView.backgroundView = [UIView new];
        [_tableView.backgroundView addSubnode:_tagImageNode];

        _sendButton = [UIButton new];
        [_sendButton setImage:[UIImage imageNamed:@"send-post"]
                     forState:UIControlStateNormal];
        [_sendButton addTarget:self
                        action:@selector(tapAndSend:)
              forControlEvents:UIControlEventTouchUpInside];

        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithImage:[UIImage imageNamed:@"post-tag-share"]
         style:UIBarButtonItemStylePlain
         target:self
         action:@selector(tapAndShare:)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        self.hidesBottomBarWhenPushed = YES;

        @weakify(self);
        [RACObserve(self, tableView.contentOffset) subscribeNext:^(id x) {
            @strongify(self);
            [self updateUIWithOffset:self.tableView.contentOffset];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _postTagTitleView.frame = CGRectMake(0, 0, self.view.width,
                                         [BLUPostTagTitleView
                                          postTagTitleViewHeight]);
    _tagImageNode.frame =
    CGRectMake(0, 0, self.view.width,
               [BLUPostTagTitleView postTagTitleViewHeight] + 64);

    _tableView.tableHeaderView = _postTagTitleView;
    [self.view addSubview:_tableView];
    [self.view addSubview:_postTagBar];
    [self.view addSubview:_sendButton];

    _postTagSelector.backgroundColor = [UIColor lightGrayColor];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-BLUThemeMargin * 8);
    }];

    BLUPostViewModel *currentViewModel = [self currentViewModel];
    @weakify(self);
    self.tableView.mj_header =
    [MJRefreshHeader headerWithRefreshingBlock:^{
        [[currentViewModel fetch] subscribeError:^(NSError *error) {
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
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavBarToTransparent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self recoverNavBarToNormal];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    BLUPostViewModel *currentViewModel = [self currentViewModel];
    [self.view showIndicator];
    @weakify(self);
    [[currentViewModel fetch] subscribeNext:^(NSArray *item) {
        @strongify(self);
        if (item.count > 0) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.view hideIndicator];
    } error:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
        [self.view hideIndicator];
    }];

    [[[BLUApiManager sharedManager] fetchTagWithTagID:_tagID] subscribeNext:^(BLUPostTag *tag) {
        @strongify(self);
        BLUAssertObjectIsKindOfClass(tag, [BLUPostTag class]);
        self.postTag = tag;
        self.postTagTitleView.postTag = tag;
        self.postTagBar.postTag = tag;
        if (tag.image) {
            self.tagImageNode.URL = tag.image.originURL;
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } error:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
    _postTagBar.frame = CGRectMake(0, 0, self.view.width,
                                   self.topLayoutGuide.length);
    _postTagBar.statusBarOffset = self.statusBarHeight;
    _postTagTitleView.frame = CGRectMake(0, 0, self.view.width,
                                         [BLUPostTagTitleView postTagTitleViewHeight]);
}

- (void)updateUIWithOffset:(CGPoint)offset {
    CGFloat height = self.topLayoutGuide.length;
    CGFloat progress = (offset.y - [BLUPostTagTitleView postTagTitleViewHeight] + self.topLayoutGuide.length * 2) / height;
    if (progress >= 0 && progress <= 1) {
        _postTagBar.displayProgress = progress;
    } else if (progress < 0){
        _postTagBar.displayProgress = 0.0;
    } else {
        _postTagBar.displayProgress = 1.0;
    }

    CGFloat tagImageHeight = [self.postTagSelector convertRect:self.postTagSelector.bounds toView:self.view].origin.y;
    if (tagImageHeight != 0) {
        _tagImageNode.frame = CGRectMake(0, 0, self.view.width, tagImageHeight);
    }
}

- (void)configureNavBarToTransparent {
    
    _navigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
    _navigationBarBackgroundImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0]];
    self.navigationController.navigationBar.opaque = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


- (void)recoverNavBarToNormal {
    [self.navigationController.navigationBar setBackgroundImage:_navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:_navigationBarShadowImage];
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:BLUThemeSubColor];
}

- (BLUPostViewModel *)currentViewModel {
    if (_postTagSelector.selectedIndex == 0) {
        return _allViewModel;
    } else if (_postTagSelector.selectedIndex == 1) {
        return _recommendedViewModel;
    } else {
        return nil;
    }
}

- (void)tapAndSend:(id)sender {
    if ([self loginIfNeeded]) {
        return;
    }
    if (self.postTag) {
        BLUSendPost2ViewController *vc = [BLUSendPost2ViewController new];
        vc.tags = @[self.postTag];
        vc.delegate = self;
        BLUNavigationController *navVC =
        [[BLUNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVC animated:YES completion:nil];
    }

}

- (void)tapAndShare:(id)sender {
    if (self.postTag) {
        QGShareViewController *vc = [QGShareViewController new];
        vc.shareObject = self.postTag;
        vc.shareManager.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)sendPostViewControllerDidSendPost:(BLUSendPost2ViewController *)viewController {
    [self showTopIndicatorWithSuccessMessage:NSLocalizedString(@"circle-detail-vc.send-post-success", @"Send post success")];
}

@end

@implementation BLUPostTagDetailViewController (ASTableView)

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    BLUPostViewModel *currentViewModel = [self currentViewModel];
    return currentViewModel.posts.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUPostViewModel *currentViewModel = [self currentViewModel];
    
    BLUPostCommonNode *node = [[BLUPostCommonNode alloc]
                               initWithPost:currentViewModel.posts[indexPath.row]];
    return node;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUPost *post = [[[self currentViewModel] posts] objectAtIndex:indexPath.row];
    BLUPostDetailAsyncViewController *vc =
    [[BLUPostDetailAsyncViewController alloc] initWithPostID:post.postID];
    [self pushViewController:vc];
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    return _postTagSelector;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return [BLUPostTagDetailSelector postTagDetailSelectorHeight];
}

- (void)tableView:(ASTableView *)tableView
willBeginBatchFetchWithContext:(ASBatchContext *)context {
    BLUPostViewModel *currentViewModel = [self currentViewModel];
    @weakify(self);
    [[currentViewModel fetchNext] subscribeNext:^(NSArray *items) {
        @strongify(self);
        if (items) {
            NSInteger initialIndex = currentViewModel.posts.count - items.count;
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
    BLUPostViewModel *currentViewModel = [self currentViewModel];
    return !currentViewModel.noMoreData;
}

- (void)handleSelection:(BLUPostTagDetailSelector *)selector {
    BLULogDebug(@"index = %@", @(selector.selectedIndex));
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];

    BLUPostViewModel *currentViewModel = [self currentViewModel];
    if (currentViewModel.noMoreData != YES &&
        currentViewModel.posts.count <= 0) {
        [self.view showIndicator];
        @weakify(self);
        [[currentViewModel fetch] subscribeNext:^(NSArray *item) {
            @strongify(self);
            if (item.count > 0) {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationFade];
            }
            [self.view hideIndicator];
        } error:^(NSError *error) {
            @strongify(self);
            [self showTopIndicatorWithError:error];
            [self.view hideIndicator];
        }];
    }
}

@end
