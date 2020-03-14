//
//  BLUUserPostsViewController.m
//  Blue
//
//  Created by Bowen on 19/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//


#import "BLUUserPostsViewController.h"
#import "BLUPostViewModel.h"
#import "BLUPost.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUUserTransitionDelegate.h"
#import "BLUPostCommonNode.h"

@interface BLUUserPostsViewController () <ASTableViewDelegate, ASTableViewDataSource>

@property (nonatomic, strong) ASTableView *tableView;
@property (nonatomic, strong) BLUUserTransitionDelegate *userTransition;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) UIView *watermarkView;

@end

@implementation BLUUserPostsViewController

- (instancetype)initWithPostViewModel:(BLUPostViewModel *)postViewModel {
    if (self = [super init]) {
        _postViewModel = postViewModel;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    // Table View
    _tableView = [ASTableView new];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.asyncDelegate = self;
    _tableView.asyncDataSource = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _watermarkView = [self makeWatermarkView];
    _watermarkView.hidden = YES;
    _watermarkView.alpha = 0.0;
    _watermarkView.userInteractionEnabled = NO;

    [self.view addSubview:_tableView];
    [self.view addSubview:_watermarkView];

    // Constraints
    [self addTiledLayoutConstrantForView:_tableView];

    [_watermarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-BLUThemeMargin * 6);
    }];
}

- (void)viewDidLayoutSubviews
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.topLayoutGuide.length, 0);
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    [self.view showIndicator];
    @weakify(self);
    self.postViewModel.fetchDisposable = [[self.postViewModel fetch] subscribeNext:^(id x) {
        @strongify(self);
        [self.view hideIndicator];
        self.posts = self.postViewModel.posts;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self tableViewEndRefreshing:self.tableView];
        [self showWatermarkView];
    } error:^(NSError *error) {
        @strongify(self);
        [self.view hideIndicator];
        [self tableViewEndRefreshing:self.tableView];
        [self showAlertForError:error];
        [self showWatermarkView];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self);
    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.view hideIndicator];
        self.postViewModel.fetchDisposable = [[self.postViewModel fetch] subscribeNext:^(id x) {
            self.posts = self.postViewModel.posts;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self tableViewEndRefreshing:self.tableView];
            [self showWatermarkView];
        } error:^(NSError *error) {
            [self showAlertForError:error];
            [self tableViewEndRefreshing:self.tableView];
            [self showWatermarkView];
        }];
    }];
}

- (void)showWatermarkView {
    BOOL hide = self.postViewModel.posts.count > 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.watermarkView.alpha = hide ? 0.0 : 1.0;
    } completion:^(BOOL finished) {
        self.watermarkView.hidden = hide ? YES : NO;
    }];
}

- (UIView *)makeWatermarkView {
    UIView *container = [UIView new];

    UILabel *promptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    promptLabel.textColor = BLUThemeSubTintContentForegroundColor;
    promptLabel.attributedText = [NSAttributedString contentAttributedStringWithContent:[self promptForWatermark]];
    promptLabel.numberOfLines = 0;
    promptLabel.textAlignment = NSTextAlignmentCenter;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageForWatermark]];

    [container addSubview:promptLabel];
    [container addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container);
        make.centerX.equalTo(container);
    }];

    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(BLUThemeMargin * 4);
        make.bottom.equalTo(container);
        make.centerX.equalTo(container);
    }];

    return container;
}

- (NSString *)promptForWatermark {
    NSString *prompt = nil;

    switch (self.postViewModel.type) {
        case BLUPostTypeForUser: {
            prompt = NSLocalizedString(@"user-post-vc.watermark-view.prompt.no-post", @"There is no post.");
        } break;
        case BLUPostTypeForCollection: {
            prompt = NSLocalizedString(@"user-post-vc.watermark-view.prompt.no-collection", @"There is no post.");
        } break;
        case BLUPostTypeForParticipated: {
            prompt = NSLocalizedString(@"user-post.vc.watermark-view.prompt.no-participated", @"There is no post.");
        } break;
        default: prompt = nil; break;
    }

    return prompt;
}

- (UIImage *)imageForWatermark {
    UIImage *image = nil;

    switch (self.postViewModel.type) {
        case BLUPostTypeForUser: {
            image = [BLUCurrentTheme postNoPost];
        } break;
        case BLUPostTypeForCollection: {
            image = [BLUCurrentTheme postNoCollection];
        } break;
        case BLUPostTypeForParticipated: {
            image = [BLUCurrentTheme postNoParticipated];
        } break;
        default: {
            image = nil;
        } break;
    }
    return image;
}

#pragma mark - Model

- (BLUUserTransitionDelegate *)userTransition {
    if (_userTransition == nil) {
        _userTransition = [BLUUserTransitionDelegate new];
        _userTransition.viewController = self;
    }
    return _userTransition;
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUPostCommonNode *postNode = [[BLUPostCommonNode alloc]
                                   initWithPost:self.postViewModel.posts[indexPath.row]];
    return postNode;
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

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUPost *post = self.posts[indexPath.row];
    BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:post.postID];
    [self pushViewController:vc];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isEditAble;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditAble) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            if (self.posts.count > 0) {
                NSMutableArray *posts = [NSMutableArray arrayWithArray:self.posts];
                BLUPost *post = self.posts[indexPath.row];
                [posts removeObjectAtIndex:indexPath.row];
                self.posts = posts;
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self showWatermarkView];
                @weakify(self);
                [[self.postViewModel deletePost:post] subscribeError:^(NSError *error) {
                    @strongify(self);
                    [self showAlertForError:error];
                    self.posts = self.postViewModel.posts;
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                } completed:^{
                    [self showWatermarkView];
                }];
            }
        }
    }
}

@end
