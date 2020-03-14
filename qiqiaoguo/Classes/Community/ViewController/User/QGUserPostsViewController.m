//
//  QGUserPostsViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/16.
//
//

#import "QGUserPostsViewController.h"
#import "QGHttpManager+User.h"
#import "QGHttpManager.h"
#import "BLUPostCommonNode.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUPost.h"
#import "VTMagic.h"

@interface QGUserPostsViewController ()<ASTableViewDelegate, ASTableViewDataSource>

@property (nonatomic, strong) ASTableView *tableView;
//@property (nonatomic, strong) BLUUserTransitionDelegate *userTransition;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) UIView *watermarkView;
@property (nonatomic, assign) BOOL noMoreData;

@end

@implementation QGUserPostsViewController

- (instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        _posts = [NSMutableArray array];
        self.page = 1;
        self.noMoreData = NO;
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
    CGFloat bottomlength = 0.0;
    if ([self.parentViewController isKindOfClass:[VTMagicController class]]) {
        bottomlength = 64.0;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length + bottomlength, 0);
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    @weakify(self);
    self.page = 1;
    [self.view showIndicator];
    [QGHttpManager getUserPostsWithType:self.type page:self.page Success:^(NSURLSessionDataTask *task, id responseObject) {
         @strongify(self);
        [self.view hideIndicator];
        [self.posts removeAllObjects];
        [self.posts addObjectsFromArray:responseObject];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self tableViewEndRefreshing:self.tableView];
        [self showWatermarkView];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self.view hideIndicator];
        [self tableViewEndRefreshing:self.tableView];
        [self showTopIndicatorWithError:error];
        [self showWatermarkView];
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self);
    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self.view showIndicator];
        [QGHttpManager getUserPostsWithType:self.type page:self.page Success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self.view hideIndicator];
            [self.posts removeAllObjects];
            [self.posts addObjectsFromArray:responseObject];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self tableViewEndRefreshing:self.tableView];
            [self showWatermarkView];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self.view hideIndicator];
            [self tableViewEndRefreshing:self.tableView];
            [self showTopIndicatorWithError:error];
            [self showWatermarkView];
        }];
    }];
}

- (void)showWatermarkView {
    
    BOOL hide = self.posts.count > 0;
    [self showCannotViewIfNeed:hide];
//    [UIView animateWithDuration:0.2 animations:^{
//        self.watermarkView.alpha = hide ? 0.0 : 1.0;
//    } completion:^(BOOL finished) {
//        self.watermarkView.hidden = hide ? YES : NO;
//    }];
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
    
    switch (self.type) {
        case UserPostTypePublished: {
            prompt = NSLocalizedString(@"user-post-vc.watermark-view.prompt.no-post", @"There is no post.");
            break;
        }
        case UserPostTypeParticipated: {
             prompt = NSLocalizedString(@"user-post.vc.watermark-view.prompt.no-participated", @"There is no post.");
            break;
        }
        case UserPostTypeCollection: {
            prompt = NSLocalizedString(@"user-post-vc.watermark-view.prompt.no-collection", @"There is no post.");
            break;
        }
    }

    return prompt;
}

- (UIImage *)imageForWatermark {
    UIImage *image = nil;
    
    switch (self.type) {
        case UserPostTypePublished: {
            image = [BLUCurrentTheme postNoPost];
        } break;
        case UserPostTypeCollection: {
            image = [BLUCurrentTheme postNoCollection];
        } break;
        case UserPostTypeParticipated: {
            image = [BLUCurrentTheme postNoParticipated];
        } break;
        default: {
            image = nil;
        } break;
    }
    return image;
}

#pragma mark - Model

//- (BLUUserTransitionDelegate *)userTransition {
//    if (_userTransition == nil) {
//        _userTransition = [BLUUserTransitionDelegate new];
//        _userTransition.viewController = self;
//    }
//    return _userTransition;
//}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUPostCommonNode *postNode = [[BLUPostCommonNode alloc]
                                   initWithPost:self.posts[indexPath.row]];
    return postNode;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (void)tableView:(ASTableView *)tableView
willBeginBatchFetchWithContext:(ASBatchContext *)context {
    @weakify(self);
    self.page ++;
    [self.view showIndicator];
    [QGHttpManager getUserPostsWithType:self.type page:self.page Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%d",self.page);
        [self.view hideIndicator];
        NSArray *items = responseObject;
        [self.posts addObjectsFromArray:items];
        if (items.count > 0) {
            @strongify(self);
            NSInteger initialIndex = self.posts.count - items.count;
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
            [self tableViewEndRefreshing:self.tableView];
            [self.view hideIndicator];
            [context completeBatchFetching:YES];
        }else{
            self.noMoreData = YES;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self tableViewEndRefreshing:self.tableView];
        [self.view hideIndicator];
        [context completeBatchFetching:YES];
    }];
    [context completeBatchFetching:YES];
}

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView {
    return NO;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUPost *post = self.posts[indexPath.row];
    BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:post.postID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isEditAble;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditAble) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            if (self.posts.count > 0) {
                NSArray *oldArr = self.posts;
                NSMutableArray *posts = [NSMutableArray arrayWithArray:self.posts];
                BLUPost *post = self.posts[indexPath.row];
                [posts removeObjectAtIndex:indexPath.row];
                self.posts = posts;
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self showWatermarkView];
                @weakify(self);
                [QGHttpManager delegateUserPostWithPostID:post.postID Success:^(NSURLSessionDataTask *task, id responseObject) {
                    @strongify(self);
                    [self showWatermarkView];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    @strongify(self);
                    [self showTopIndicatorWithError:error];
                    self.posts = [[NSMutableArray alloc]initWithArray:oldArr];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];

            }
        }
    }
}


@end
