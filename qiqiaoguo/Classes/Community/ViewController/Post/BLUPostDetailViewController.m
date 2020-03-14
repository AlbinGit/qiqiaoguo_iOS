//
//  BLUPostDetailViewController.m
//  Blue
//
//  Created by Bowen on 11/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#undef BLUPostDetailOptCellON
#define BLUPostDetailOptCellON

#undef BLUPostCommentOptCellON
#define BLUPostCommentOptCellON

#import "BLUPostDetailViewController.h"
#import "BLUPostTitleCell.h"
#import "BLUPostCommentToolbar.h"
#import "BLUBriefHeader.h"
#import "BLUPostDetailViewModel.h"
#import "BLUPostCommentViewModel.h"
#import "BLUPostActionViewModel.h"
#import "BLUPost.h"
#import "BLUCommentActionViewModel.h"
#import "BLUComment.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUUserTransitionDelegate.h"
#import "BLUPostDetailOptCell.h"
#import "BLUPostCommentOptCell.h"
#import "BLUPostCommentViewModel.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BLUCommentReply.h"
#import "BLUCommentReplyTextView.h"
#import "BLUPostCommentViewController.h"
#import "BLURemoteNotification.h"
#import "BLUReportViewModel.h"
#import "BLUCircle.h"
#import "BLUShowImageController.h"
#import "BLUViewControllerRedirectController.h"

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionTitle = 0,
    TableViewSectionPost,
    TableViewSectionComment,
    TableViewSectionCount,
};

typedef NS_ENUM(NSInteger, CommentType) {
    CommentTypeAll = 0,
    CommentTypeOwner,
};

typedef NS_ENUM(NSInteger, ReplyType) {
    ReplyTypeToOwner = 0,
    ReplyTypeToComment,
    ReplyTypeToTargetUser,
};

@protocol BLUCommentReplyTextViewDelegate;

@interface BLUPostDetailViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, BLUPostCommentToolbarDelegate, BLUPostTitleCellDelegate, BLUCircleTransitionDelegate, BLUUserTransitionDelegate, BLUPostCommentActionDelegate, BLUPostDetailActionDelegate, BLUCommentReplyTextViewDelegate>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) BLUPostCommentToolbar *toolBar;
@property (nonatomic, strong) BLUPostDetailViewModel *postDetailViewModel;
@property (nonatomic, strong) BLUPostCommentViewModel *allCommentViewModel;
@property (nonatomic, strong) BLUPostCommentViewModel *ownerCommentViewModel;
@property (nonatomic, strong) BLUPostActionViewModel *postActionViewModel;
@property (nonatomic, strong) BLUCommentActionViewModel *commentActionViewModel;
@property (nonatomic, strong) BLUUserTransitionDelegate *userTransition;
@property (nonatomic, strong) BLUShowImageController *showImageDelegator;

@property (nonatomic, strong) UIBarButtonItem *allCommentButton;
@property (nonatomic, strong) UIBarButtonItem *ownerCommentButton;

@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, strong) BLUPostCommentViewModel *currentPostCommentViewModel;

@property (nonatomic, assign) ReplyType replyType;
@property (nonatomic, strong) BLUCommentReply *seletedReply;
@property (nonatomic, strong) BLUComment *seletedComment;
@property (nonatomic, strong) NSIndexPath *seletedCommentIndex;

@property (nonatomic, strong) MJRefreshHeader *header;
@property (nonatomic, strong) MJRefreshFooter *footer;

@property (nonatomic, strong) NSIndexPath *indexPathForReply;

@property (nonatomic, assign) BOOL didShowPost;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic, strong) BLUViewControllerRedirectController *redirectController;

@end

@implementation BLUPostDetailViewController

- (instancetype)initWithPostID:(NSInteger)postID {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"post-detail.title", @"Post detail");
        self.hidesBottomBarWhenPushed = YES;
        _postID = postID;
        _replyType = ReplyTypeToOwner;

        // Keyboard notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillHideNotification object:nil];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *superview = self.view;
    superview.backgroundColor = BLUThemeSubTintBackgroundColor;

    // Table view
    _tableView = [BLUTableView new];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIView *tableFooterView = [self makeTableViewFooterView];
    tableFooterView.frame = CGRectMake(0, 0, self.view.width, 108);
    self.tableFooterView = tableFooterView;
    _tableView.tableFooterView = tableFooterView;

    [_tableView registerClass:[BLUPostTitleCell class] forCellReuseIdentifier:NSStringFromClass([BLUPostTitleCell class])];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [_tableView registerClass:[BLUPostDetailOptCell class] forCellReuseIdentifier:NSStringFromClass([BLUPostDetailOptCell class])];
    [_tableView registerClass:[BLUPostCommentOptCell class] forCellReuseIdentifier:NSStringFromClass([BLUPostCommentOptCell class])];

    [superview addSubview:_tableView];
    
    // Navigaton bar
    self.allCommentButton = [[UIBarButtonItem alloc] initWithImage:[BLUCurrentTheme postViewAllIcon] style:UIBarButtonItemStylePlain target:self action:@selector(allCommentAction:)];
    self.ownerCommentButton = [[UIBarButtonItem alloc] initWithImage:[BLUCurrentTheme postJustLooikngFirstfloorIcon] style:UIBarButtonItemStylePlain target:self action:@selector(ownerCommentAction:)];
    
    self.navigationItem.rightBarButtonItem = self.ownerCommentButton;
    self.currentPostCommentViewModel = self.allCommentViewModel;
    self.commentType = CommentTypeAll;
    
    // Tool bar
    _toolBar = [BLUPostCommentToolbar new];
    _toolBar.postCommentToolbarDelegate = self;
    _toolBar.translucent = YES;
    [superview addSubview:_toolBar];
   
    // Constraints
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview);
    }];
    
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(superview);
        make.left.equalTo(superview);
        make.right.equalTo(superview);
    }];

    // Model
    RAC(self, postDetailViewModel.postID) = RACObserve(self, postID);
    RAC(self, allCommentViewModel.postID) = RACObserve(self, postID);
    RAC(self, ownerCommentViewModel.postID) = RACObserve(self, postID);

    @weakify(self);
    [[RACObserve(self, replyType) distinctUntilChanged] subscribeNext:^(NSNumber *type) {
        @strongify(self);
        if (type.integerValue != ReplyTypeToComment) {
            // LOCAL
            self.toolBar.textField.placeholder = NSLocalizedString(@"post-detail.toolbar.placeholder.reply", @"Reply");
        }
        self.toolBar.textField.text = nil;
    }];

    [[[RACSignal combineLatest:@[RACObserve(self, allCommentViewModel.commentCount), RACObserve(self, didShowPost)]] reduceEach:^id(NSNumber *commentCountNumber, NSNumber *didShowPostNumber){
        NSInteger commentCount = commentCountNumber.integerValue;
        BOOL didShowPost = didShowPostNumber.boolValue;

        return @(commentCount == 0 && didShowPost);
    }] subscribeNext:^(NSNumber *showFooterViewNumber) {
        @strongify(self);
        bool showFooterView = showFooterViewNumber.boolValue;

        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.tableFooterView.alpha = showFooterView ? 1.0 : 0.0;
        } completion:^(BOOL finished) {
            self.tableView.tableFooterView.hidden = !showFooterView;
            self.tableView.tableFooterView = showFooterView ? self.tableFooterView : nil;
        }];
    }];
}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    
    [self.view showIndicator];
    @weakify(self);
    self.postDetailViewModel.fetchDisposable = [[self.postDetailViewModel fetch] subscribeNext:^(id x) {
        @strongify(self);
        [self.view hideIndicator];
        [self tableViewEndRefreshing:self.tableView];
        NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
        [mutableIndexSet addIndex:TableViewSectionTitle];
        [mutableIndexSet addIndex:TableViewSectionPost];
        [self.tableView reloadSections:mutableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [[self.currentPostCommentViewModel fetch] handleFetchForViewController:self tableView:self.tableView reloadBlock:^{
            [self reloadCommentSection];
        }];
    } error:^(NSError *error) {
        @strongify(self);
        [self.view hideIndicator];
        [self tableViewEndRefreshing:self.tableView];
        [self showAlertForError:error];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self);
    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        [self.view hideIndicator];
        @strongify(self);
        self.postDetailViewModel.fetchDisposable = [[self.postDetailViewModel fetch] subscribeNext:^(id x) {
            [self.view hideIndicator];
            [self tableViewEndRefreshing:self.tableView];
            NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
            [mutableIndexSet addIndex:TableViewSectionTitle];
            [mutableIndexSet addIndex:TableViewSectionPost];
            [self.tableView reloadSections:mutableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            self.currentPostCommentViewModel.fetchDisposable = [[self.currentPostCommentViewModel fetch] subscribeNext:^(id x) {
                [self tableViewEndRefreshing:self.tableView];
                [self reloadCommentSection];
            } error:^(NSError *error) {
                [self tableViewEndRefreshing:self.tableView];
                [self showAlertForError:error];
            }];
        } error:^(NSError *error) {
            [self.view hideIndicator];
            [self tableViewEndRefreshing:self.tableView];
            [self showAlertForError:error];
        }];
    }];
    _header = _tableView.mj_header;
    
    BLURefreshFooter *footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.view hideIndicator];
        self.currentPostCommentViewModel.fetchNextDisposable = [[self.currentPostCommentViewModel fetchNext] subscribeNext:^(NSArray *comments) {
            [self.view hideIndicator];
            [self.tableView reloadData];
            [self tableViewEndRefreshing:self.tableView noMoreData:comments.count == 0];
        } error:^(NSError *error) {
            [self.view hideIndicator];
            [self showAlertForError:error];
        }];
    }];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    _tableView.mj_footer = footer;
    _footer = _tableView.mj_footer;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat topOffset = self.tableView.contentInset.top;
    CGFloat bottomOffset = _toolBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, bottomOffset, 0);
    self.tableFooterView.frame = CGRectMake(0, self.tableView.tableFooterView.y, self.view.width, 108);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_toolBar.textField resignFirstResponder];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self.toolBar.textField resignFirstResponder];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.toolBar.textField resignFirstResponder];
}

- (void)handleRemoteNotification:(NSNotification *)userInfo {
    BLURemoteNotification *remoteNotification = userInfo.object;
    if (remoteNotification.type != BLURemoteNotificationTypePost) {
        [super handleRemoteNotification:userInfo];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)makeTableViewFooterView {
    UIView *container = [UIView new];

    container.backgroundColor = BLUThemeMainTintBackgroundColor;
    container.alpha = 0.0;
    container.hidden = YES;

    UILabel *promptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    promptLabel.textColor = BLUThemeSubTintContentForegroundColor;
    promptLabel.text = NSLocalizedString(@"post-detail-vc.tableview-footer-view.prompt-label.text", @"There is no comment.");

    UIButton *commentButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
    commentButton.title = NSLocalizedString(@"post-detail-vc.tableview-footer-view.comment-button.title", @"Comment");
    commentButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
    commentButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin, BLUThemeMargin * 12, BLUThemeMargin, BLUThemeMargin * 12);
    [commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    commentButton.borderColor = [UIColor grayColor];
    commentButton.titleColor = [UIColor blackColor];

    BLUSolidLine *solidLine = [BLUSolidLine new];
    solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;

    [container addSubview:promptLabel];
    [container addSubview:commentButton];
    [container addSubview:solidLine];

    [solidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container).offset(-1);
        make.left.equalTo(container);
        make.right.equalTo(container);
        make.height.equalTo(@(BLUThemeOnePixelHeight));
    }];

    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container).offset(BLUThemeMargin * 4);
        make.centerX.equalTo(container);
    }];

    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel.mas_bottom).offset(BLUThemeMargin * 4);
        make.centerX.equalTo(container);
    }];

    return container;
}

#pragma mark - Model

- (BLUPostDetailViewModel *)postDetailViewModel {
    if (_postDetailViewModel == nil) {
        _postDetailViewModel = [BLUPostDetailViewModel new];
    }
    return _postDetailViewModel;
}

- (BLUPostCommentViewModel *)allCommentViewModel {
    if (_allCommentViewModel == nil) {
        _allCommentViewModel = [[BLUPostCommentViewModel alloc] initWithPostCommentType:BLUPostCommentTypeForPost];
    }
    return _allCommentViewModel;
}

- (BLUPostCommentViewModel *)ownerCommentViewModel {
    if (_ownerCommentViewModel == nil) {
        _ownerCommentViewModel = [[BLUPostCommentViewModel alloc] initWithPostCommentType:BLUPostCommentTypeForOwner];
    }
    return _ownerCommentViewModel;
}

- (BLUPostActionViewModel *)postActionViewModel {
    if (_postActionViewModel == nil) {
        _postActionViewModel = [BLUPostActionViewModel new];
    }
    return _postActionViewModel;
}

- (BLUCommentActionViewModel *)commentActionViewModel {
    if (_commentActionViewModel == nil) {
        _commentActionViewModel = [BLUCommentActionViewModel new];
    }
    return _commentActionViewModel;
}

- (BLUUserTransitionDelegate *)userTransition {
    if (_userTransition == nil) {
        _userTransition = [BLUUserTransitionDelegate new];
        _userTransition.viewController = self;
    }
    return _userTransition;
}

- (BLUShowImageController *)showImageDelegator {
    if (_showImageDelegator == nil) {
        _showImageDelegator = [[BLUShowImageController alloc] init];
        _showImageDelegator.fromViewController = self;
    }
    return _showImageDelegator;
}

- (BLUViewControllerRedirectController *)redirectController {
    if (_redirectController == nil) {
        _redirectController = [BLUViewControllerRedirectController new];
        _redirectController.fromViewController = self;
    }
    return _redirectController;
}

- (void)allCommentAction:(UIBarButtonItem *)barButton {
    self.navigationItem.rightBarButtonItem = self.ownerCommentButton;
    [self changePostCommentViewModelAndReloadWithType:CommentTypeAll];
}

- (void)ownerCommentAction:(UIBarButtonItem *)barButton {
    self.navigationItem.rightBarButtonItem = self.allCommentButton;
    [self changePostCommentViewModelAndReloadWithType:CommentTypeOwner];
}

- (void)changePostCommentViewModelAndReloadWithType:(CommentType)type {
    self.commentType = type;
    switch (type) {
        case CommentTypeAll: {
            self.currentPostCommentViewModel = self.allCommentViewModel;
        } break;
        case CommentTypeOwner: {
            self.currentPostCommentViewModel = self.ownerCommentViewModel;
        } break;
    }
    
    if (self.currentPostCommentViewModel.comments.count == 0) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionComment] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[self.currentPostCommentViewModel fetchNext] handleFetchForViewController:self tableView:self.tableView reloadBlock:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionComment] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    } else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionComment] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)reloadCommentSection {
    NSMutableIndexSet *mutableIndexSet = [NSMutableIndexSet new];
    [mutableIndexSet addIndex:TableViewSectionComment];
    [self.tableView reloadSections:mutableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)commentAction:(id)sender {
    [self.toolBar.textField becomeFirstResponder];
}

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case TableViewSectionTitle: {
            count = self.postDetailViewModel.post ? 1 : 0;
            self.didShowPost = self.postDetailViewModel.post ? YES : NO;
        } break;
        case TableViewSectionPost: {
            count = self.postDetailViewModel.post ? 1 : 0;
        } break;
        case TableViewSectionComment: {
            count = self.currentPostCommentViewModel.comments.count;
        } break;
        default: {
            count = 0;
        } break;
    }
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableViewSectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
   
    switch (indexPath.section) {
        case TableViewSectionTitle: {
            if (self.postDetailViewModel.post.circle.shouldVisible == NO) {
                cell = [UITableViewCell new];
            } else {
                BLUPostTitleCell *titleCell = (BLUPostTitleCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUPostTitleCell class]) forIndexPath:indexPath model:self.postDetailViewModel.post];
                titleCell.delegate = self;
                titleCell.circleTransitionDelegate = self;
                cell = titleCell;
            }
        } break;
        case TableViewSectionPost: {
            BLUPostDetailOptCell *postCell = (BLUPostDetailOptCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUPostDetailOptCell class]) forIndexPath:indexPath model:self.postDetailViewModel.post];
            postCell.redirectDelegate = self.redirectController;
            postCell.delegate = self;
            postCell.userTransitionDelegate = self.userTransition;
            postCell.showImageDelegate = self.showImageDelegator;
            cell = postCell;
        } break;
        case TableViewSectionComment: {
            BLUPostCommentOptCell *commentCell = (BLUPostCommentOptCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUPostCommentOptCell class]) forIndexPath:indexPath];
            [commentCell setModel:self.currentPostCommentViewModel.comments[indexPath.row] postUser:self.postDetailViewModel.post.author post:self.postDetailViewModel.post shouldShowCompleteReplies:NO delegate:self replytTextViewDelegate:self userTransition:self.userTransition];
            if (self.currentPostCommentViewModel.comments.count - 1 == indexPath.row) {
                commentCell.solidLine.hidden = YES;
            } else {
                commentCell.solidLine.hidden = NO;
            }
            cell = commentCell;
        } break;
        default: {
            cell = nil;
        } break;
    }
   
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.width;
    CGSize size;
    
    switch (indexPath.section) {
        case TableViewSectionTitle: {
            if (self.postDetailViewModel.post.circle.shouldVisible) {
                size = [_tableView sizeForCellWithCellClass:[BLUPostTitleCell class] cacheByIndexPath:indexPath width:width model:self.postDetailViewModel.post];
            } else {
                size = CGSizeZero;
            }
        } break;
        case TableViewSectionPost: {
            size = [_tableView sizeForCellWithCellClass:[BLUPostDetailOptCell class] cacheByIndexPath:indexPath width:width model:self.postDetailViewModel.post];
        } break;
        case TableViewSectionComment: {
            @weakify(self);
            size = [_tableView sizeForCellWithCellClass:[BLUPostCommentOptCell class] cacheByIndexPath:indexPath width:width configuration:^(BLUCell *cell) {
                @strongify(self);
                [(BLUPostCommentOptCell *)cell setModel:self.currentPostCommentViewModel.comments[indexPath.row] postUser:self.postDetailViewModel.post.author post:self.postDetailViewModel.post shouldShowCompleteReplies:NO delegate:self replytTextViewDelegate:self userTransition:self.self.userTransition];
            }];
        } break;
        default: {
            size = CGSizeZero;
        } break;
    }

    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == TableViewSectionComment) {
        if (self.currentPostCommentViewModel.comments.count > 0) {
            return BLUBriefHeaderHeight;
        }
    }
    return 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableViewSectionComment) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUComment *comment = self.currentPostCommentViewModel.comments[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (comment.author.userID == [BLUAppManager sharedManager].currentUser.userID) {
            // TODO
            self.commentActionViewModel.commentID = comment.commentID;
            NSInteger index = [self.currentPostCommentViewModel deleteComment:comment];
            [self reloadCommentSection];
            @weakify(self);
            [[self.commentActionViewModel deleteComment] subscribeError:^(NSError *error) {
                @strongify(self);
                [self.currentPostCommentViewModel insertComment:comment atIndex:index];
                [self reloadCommentSection];
                [self showAlertForError:error];
            }];
        } else {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            BLUReportViewModel *reportViewModel = [[BLUReportViewModel alloc ] initWithObjectID:comment.commentID viewController:self sourceView:[self.tableView cellForRowAtIndexPath:indexPath] sourceRect:cell.bounds sourceType:BLUReportSourceTypeComment];
            [reportViewModel showReportSheet];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUComment *comment = self.currentPostCommentViewModel.comments[indexPath.row];
    if (comment.author.userID == [BLUAppManager sharedManager].currentUser.userID) {
        return NSLocalizedString(@"post-detail.table-view-action.delete", @"delete");
    } else {
        return NSLocalizedString(@"post-detail.table-view-action.report", @"Report");
    }
}

#pragma mark - Table view header

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == TableViewSectionComment) {
        if (self.currentPostCommentViewModel.comments.count > 0) {
            BLUBriefHeader *header = [BLUBriefHeader new];
            // FIX:
            header.titleLabel.text = NSLocalizedString(@"post-detail.table-view.header.comment", @"Comment");
            return header;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == TableViewSectionComment) {

        if (![BLUAppManager sharedManager].currentUser) {
            [self loginRequired:nil];
        }

        self.indexPathForReply = indexPath;
        self.replyType = ReplyTypeToComment;
        BLUPostCommentViewModel *viewModel = self.currentPostCommentViewModel;
        BLUComment *comment = viewModel.comments[indexPath.row];
        NSString *commentUserNickname = self.postDetailViewModel.post.author.userID == comment.author.userID && self.postDetailViewModel.post.anonymousEnable == YES ? [BLUUser anonymousNickname] : comment.author.nickname;
        self.toolBar.textField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"post-detail.toolbar.placeholder.replyToComment %@", @"Reply to comment"), commentUserNickname];
        [self.toolBar.textField becomeFirstResponder];

        if (_seletedComment.commentID != comment.commentID) {
            self.toolBar.textField.text = nil;
        }

        self.seletedCommentIndex = indexPath;
        self.seletedComment = comment;

    }
}

#pragma mark - UIScrollView.

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_toolBar.textField resignFirstResponder];
}

#pragma mark - Keyboard manager

- (void)keyboardChanged:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    CGRect keyboardBeginFrame;

    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBeginFrame];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    [_toolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        if (notification.name == UIKeyboardWillShowNotification) {
            make.bottom.equalTo(self.view).offset(-keyboardEndFrame.size.height);
        } else if (notification.name == UIKeyboardWillHideNotification) {
            make.bottom.equalTo(self.view);
        }
    }];
    [self.view layoutIfNeeded];

    [UIView commitAnimations];
}

#pragma mark - Post detail cell delegate

- (void)_actionSignalThenReload:(RACSignal *)signal {
    [signal subscribeError:^(NSError *error) {
        [self showAlertForError:error];
    } completed:^{
        [self.tableView.mj_header beginRefreshing];
    }];
}

- (void)shouldLikePost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender {

    if (postInfo) {
        BLUPost *post = postInfo[BLUPostKeyPost];
        if (post) {
            if (post.didLike) {
                return ;
            }
            
            BLUUser *currentUser = [[BLUAppManager sharedManager] currentUser];
            if (currentUser == nil) {
                [self loginRequired:nil];
                return ;
            }
            
            self.postActionViewModel.postID = post.postID;
            self.postDetailViewModel.post.like = YES;
            self.postDetailViewModel.post.likeCount++;
            NSMutableArray *likedUsers = [NSMutableArray arrayWithArray:self.postDetailViewModel.post.likedUsers];
            [likedUsers insertObject:currentUser atIndex:0];
            self.postDetailViewModel.post.likedUsers = likedUsers;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionPost] withRowAnimation:UITableViewRowAnimationAutomatic];

            @weakify(self);
            [[self.postActionViewModel like] subscribeError:^(NSError *error) {
                @strongify(self);
                [self showAlertForError:error];
                self.postDetailViewModel.post.like = NO;
                self.postDetailViewModel.post.likeCount--;
                [likedUsers removeObject:currentUser];
                self.postDetailViewModel.post.likedUsers = likedUsers;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionPost] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }
    }
}

- (void)shouldDislikePost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender {
    if (postInfo) {
        BLUPost *post = postInfo[BLUPostKeyPost];
        if (post) {
            if (post.didLike == NO) {
                return ;
            }
            
            BLUUser *currentUser = [[BLUAppManager sharedManager] currentUser];
            if (currentUser == nil) {
                [self loginRequired:nil];
                return ;
            }
            
            self.postActionViewModel.postID = post.postID;
            self.postDetailViewModel.post.like = NO;
            self.postDetailViewModel.post.likeCount--;
            NSMutableArray *likedUsers = [NSMutableArray arrayWithArray:post.likedUsers];
            
            for (BLUUser *user in likedUsers) {
                if (user.userID == currentUser.userID) {
                    [likedUsers removeObject:user];
                    break;
                }
            }
            
            self.postDetailViewModel.post.likedUsers = likedUsers;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionPost] withRowAnimation:UITableViewRowAnimationAutomatic];
            @weakify(self);
            [[self.postActionViewModel disLike] subscribeError:^(NSError *error) {
                @strongify(self);
                [self showAlertForError:error];
                self.postDetailViewModel.post.like = YES;
                self.postDetailViewModel.post.likeCount++;
                [likedUsers addObject:currentUser];
                self.postDetailViewModel.post.likedUsers = likedUsers;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionPost] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }
    }
}

- (void)shouldSharePost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender {
//    BLUPost *post = nil;
//
//    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
//    if (currentUser == nil) {
//        [self loginRequired:nil];
//        return;
//    }
//    
//    if (postInfo) {
//        post = postInfo[BLUPostKeyPost];
//    } else {
//        return ;
//    }
//    
//    if (!post) {
//        return ;
//    }
//   
//    if (![BLUSocialService isSupportWX] && ![BLUSocialService isSupportQQ] && ![BLUSocialService isSupportSina]) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"post-detail.share-alert-controller.no-share-action", @"Share Success!") message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction okAction]];
//        [self presentViewController:alertController animated:YES completion:nil];
//        return ;
//    }
//    
//    UIAlertController *alertController = [UIAlertController new];
//   
//    UIAlertAction * (^makeShareAction)(NSString *, BLUShareType) = ^UIAlertAction *(NSString *title, BLUShareType type) {
//
//        @weakify(self);
//        UIAlertAction *shareAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            @strongify(self);
//            [[BLUSocialService postShareContentWithType:type
//                                                  title:post.shareTitle
//                                                content:post.shareContent image:[UIImage imageNamed:@"logo-40"] jumpsURL:post.shareURL.absoluteString location:nil resourceURL:post.shareImageURL resourceType:BLUShareResourceTypeImage presentedController:nil] subscribeNext:^(id x) {
//                BLULogDebug(@"x = %@", x);
//            } error:^(NSError *error) {
//                [self showTopIndicatorWithErrorMessage:NSLocalizedString(@"post-detail.share-alert.share-failed", @"Share Failed!")];
//            } completed:^{
//                [self showTopIndicatorWithSuccessMessage:NSLocalizedString(@"post-detail.share-alert.share-success", @"Share Success!")];
//            }];
//        }];
//        
//        return shareAction;
//    };
//    
//    UIAlertAction *shareToWechatSessionAction = makeShareAction(NSLocalizedString(@"post-detail.share-alert-controller.share-to-wechat-session-action", @"Share to wechat session"), BLUShareTypeWechatSession);
//    UIAlertAction *shareToWechatTimelineAction = makeShareAction(NSLocalizedString(@"post-detail.share-alert-controller.share-to-wechat-timeline-action", @"Share to wechat timeline"), BLUShareTypeWechatTimeline);
//    UIAlertAction *shareToQQ = makeShareAction(NSLocalizedString(@"post-detail.share-alert-controller.share-to-qq-action", @"Share to QQ"), BLUShareTypeQQSession);
//    UIAlertAction *shareToQZone = makeShareAction(NSLocalizedString(@"post-detail.share-alert-controller.share-to-qzone-action", @"Share to QZone"), BLUShareTypeQZone);
//    UIAlertAction *shareToSina = makeShareAction(NSLocalizedString(@"post-detail.share-alert-controller.share-to-sina-action", @"Share to sina"), BLUShareTypeSina);
//    UIAlertAction *cancelAction = [UIAlertAction cancelAction];
//    
//    if ([BLUSocialService isSupportWX]) {
//        [alertController addAction:shareToWechatSessionAction];
//        [alertController addAction:shareToWechatTimelineAction];
//    }
//    
//    if ([BLUSocialService isSupportQQ]) {
//        [alertController addAction:shareToQQ];
//        [alertController addAction:shareToQZone];
//    }
//    
//    if ([BLUSocialService isSupportSina]) {
//        [alertController addAction:shareToSina];
//    }
//
//    [alertController addAction:cancelAction];
//
//    alertController.popoverPresentationController.sourceRect = ((UIView *)sender).bounds;
//    alertController.popoverPresentationController.sourceView = (UIView *)sender;
//
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)shouldCommentPost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender {
    [self.toolBar.textField becomeFirstResponder];
}

- (void)shouldTriggerOtherActionForPost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender {
    if (postInfo) {
        BLUPost *post = postInfo[BLUPostKeyPost];
        if (objc_getClass("UIAlertController") != nil) {
            //make and use a UIAlertController
            UIAlertController *alertController = [UIAlertController new];

            @weakify(self);
            UIAlertAction *collectAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"post-detail.alert-controller.collect-action.collect", @"Collect") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                if (post) {
                    self.postActionViewModel.postID = post.postID;
                    [[self.postActionViewModel collect] subscribeError:^(NSError *error) {
                        [self showAlertForError:error];
                    } completed:^{
                        [[self.postDetailViewModel fetch] subscribeError:^(NSError *error) {
                            [self showAlertForError:error];
                        } completed:^{
                            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionPost] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [self showTopIndicatorWithSuccessMessage:NSLocalizedString(@"post-detail-vc.collect-success", @"Bookmarked")];
                        }];
                    }];
                }
            }];

            UIAlertAction *cancelCollectAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"post-detail.alert-controller.cancel-collect-action.cancel-collect", @"Unsubscribe") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                if (post) {
                    self.postActionViewModel.postID = post.postID;
                    [[self.postActionViewModel cancelCollect] subscribeError:^(NSError *error) {
                        [self showAlertForError:error];
                    } completed:^{
                        [[self.postDetailViewModel fetch] subscribeError:^(NSError *error) {
                            [self showAlertForError:error];
                        } completed:^{
                            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionPost] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [self showTopIndicatorWithSuccessMessage:NSLocalizedString(@"post-detail-vc.cancel-collect-success", @"Cancel Bookmarked")];
                        }];
                    }];
                }
            }];

            UIAlertAction *reportAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"post-detail.alert-controller.report-action.report", @"Report") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                BLUReportViewModel *reportViewModel = [[BLUReportViewModel alloc ] initWithObjectID:self.postDetailViewModel.post.postID viewController:self sourceView:view sourceRect:((UIView *)sender).bounds sourceType:BLUReportSourceTypePost];
                [reportViewModel showReportSheet];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"post-detail.alert-controller.cancel-action.cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:reportAction];

            if (post) {
                if (post.didCollect) {
                    [alertController addAction:cancelCollectAction];
                } else {
                    [alertController addAction:collectAction];
                }
            }

            [alertController addAction:cancelAction];

            alertController.popoverPresentationController.sourceRect = ((UIView *)sender).bounds;
            alertController.popoverPresentationController.sourceView = (UIView *)sender;

            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)shouldPlayVideoForPost:(NSDictionary *)postInfo withVideoURL:(NSURL *)videoURL fromView:(UIView *)view sender:(id)sender {
    AVPlayerViewController *vc = [AVPlayerViewController new];
    vc.player = [[AVPlayer alloc] initWithURL:videoURL];
    [vc.player play];
    [self presentViewController:vc animated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)shouldShowMoreRepliesForComment:(NSDictionary *)commentInfo formView:(UIView *)view sender:(id)sender {
    BLUComment *comment = commentInfo[BLUCommentKeyComment];
    if (comment) {
        BLUPostCommentViewController *vc = [[BLUPostCommentViewController alloc] initWithComment:comment user:self.postDetailViewModel.post.author post:self.postDetailViewModel.post];
        [self pushViewController:vc];
    }
}

#pragma mark - Toolbar delegate

- (void)toolbar:(BLUPostCommentToolbar *)toolbar didSendComment:(NSString *)content {

    if (content.length == 0) {
        return ;
    }

    if (![BLUAppManager sharedManager].currentUser) {
        [self loginRequired:nil];
        return ;
    }

    void (^showCommentDetail)(BLUComment *comment, BLUPostCommentOptCell *cell) = ^(BLUComment *comment, BLUPostCommentOptCell *cell) {
        if (comment.replies.count > cell.maxReplyCount) {
            BLUPostCommentViewController *vc = [[BLUPostCommentViewController alloc] initWithComment:comment user:self.postDetailViewModel.post.author post:self.postDetailViewModel.post];
            [self pushViewController:vc];
        }
    };

    if (self.replyType == ReplyTypeToOwner) {
        self.postActionViewModel.postID = self.postID;
        @weakify(self);
        [[self.postActionViewModel comment:content] subscribeError:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
            self.replyType = ReplyTypeToOwner;
        } completed:^{
            @strongify(self);
            [[self.currentPostCommentViewModel fetch] subscribeError:^(NSError *error) {
                [self showAlertForError:error];
            } completed:^{
                [self reloadCommentSection];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:TableViewSectionComment] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }];
            self.replyType = ReplyTypeToOwner;
            self.toolBar.textField.text = @"";
        }];
    } else if (self.replyType == ReplyTypeToComment) {
        BLUPostCommentViewModel *viewModel = self.currentPostCommentViewModel;
        BLUComment *comment = viewModel.comments[self.indexPathForReply.row];
        self.commentActionViewModel.commentID = comment.commentID;


        @weakify(self);
        [[self.commentActionViewModel reply:content toUser:nil] subscribeNext:^(id x) {
            @strongify(self);
            [[viewModel fetchCommentWithCommentID:comment.commentID] subscribeNext:^(BLUComment *newComment) {
                [self.tableView reloadRowsAtIndexPaths:@[self.indexPathForReply] withRowAnimation:UITableViewRowAnimationAutomatic];
                showCommentDetail(newComment, [self.tableView cellForRowAtIndexPath:self.indexPathForReply]);
            } error:^(NSError *error) {
                [self showAlertForError:error];
            }];
            self.replyType = ReplyTypeToOwner;
            self.toolBar.textField.text = @"";

        } error:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
            self.replyType = ReplyTypeToOwner;
        }];

    } else if (self.replyType == ReplyTypeToTargetUser) {
        BLUPostCommentViewModel *viewModel = self.currentPostCommentViewModel;
        BLUCommentReply *reply = self.seletedReply;
        BLUComment *comment = self.seletedComment;

        if (!comment) {
            return ;
        }

        if (reply.author.userID == [BLUAppManager sharedManager].currentUser.userID) {
            return ;
        }

        @weakify(self);
        self.commentActionViewModel.commentID = comment.commentID;
        [[self.commentActionViewModel reply:content toUser:reply.author] subscribeNext:^(id x) {
            @strongify(self);
            [[viewModel fetchCommentWithCommentID:comment.commentID] subscribeNext:^(BLUComment *newComment) {
                [self.tableView reloadRowsAtIndexPaths:@[self.seletedCommentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                showCommentDetail(newComment, [self.tableView cellForRowAtIndexPath:self.indexPathForReply]);
            } error:^(NSError *error) {
                [self showAlertForError:error];
            }];
            self.replyType = ReplyTypeToOwner;
            self.toolBar.textField.text = @"";

        } error:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
            self.replyType = ReplyTypeToOwner;
        }];
    }
}

#pragma mark - Post comment cell delegate 

- (void)shouldLikeComment:(NSDictionary *)commentInfo fromView:(UIView *)view sender:(id)sender {
    if (commentInfo) {
        BLUComment *comment = commentInfo[BLUCommentKeyComment];
        BLUUser *currentUser = [[BLUAppManager sharedManager] currentUser];
        if (currentUser == nil) {
            [self loginRequired:nil];
            return ;
        }
        
        if (comment) {
            if (!comment.didLike) {
                __block BLUComment *cmt = nil;
                __block NSInteger row = 0;
                [self.currentPostCommentViewModel.comments enumerateObjectsUsingBlock:^(BLUComment *c, NSUInteger idx, BOOL *stop) {
                    if (comment.commentID == c.commentID) {
                        cmt = c;
                        row = idx;
                        *stop = YES;
                    }
                }];
                cmt.likeCount++;
                cmt.like = YES;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:TableViewSectionComment]] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                self.commentActionViewModel.commentID = comment.commentID;

                @weakify(self);
                [[self.commentActionViewModel like] subscribeError:^(NSError *error) {
                    @strongify(self);
                    [self showAlertForError:error];
                    cmt.likeCount--;
                    cmt.like = NO;
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:TableViewSectionComment]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
            }
        }
    }
}

- (void)shouldDislikeComment:(NSDictionary *)commentInfo fromView:(UIView *)view sender:(id)sender {
    if (commentInfo) {
        BLUComment *comment = commentInfo[BLUCommentKeyComment];
        BLUUser *currentUser = [[BLUAppManager sharedManager] currentUser];
        if (currentUser == nil) {
            [self loginRequired:nil];
            return ;
        }
        
        if (comment) {
            if (comment.didLike) {
                __block BLUComment *cmt = nil;
                __block NSInteger row = 0;
                [self.currentPostCommentViewModel.comments enumerateObjectsUsingBlock:^(BLUComment *c, NSUInteger idx, BOOL *stop) {
                    if (comment.commentID == c.commentID) {
                        cmt = c;
                        row = idx;
                        *stop = YES;
                    }
                }];
                
                cmt.likeCount--;
                cmt.like = NO;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:TableViewSectionComment]] withRowAnimation:UITableViewRowAnimationAutomatic];
                self.commentActionViewModel.commentID = comment.commentID;

                @weakify(self);
                [[self.commentActionViewModel dislike] subscribeError:^(NSError *error) {
                    @strongify(self);
                    [self showAlertForError:error];
                    cmt.likeCount++;
                    cmt.like = YES;
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:TableViewSectionComment]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
            }
        }
    }
}

#pragma mark - Post title cell delegate

- (void)postTitleCell:(BLUPostTitleCell *)cell didCommentPost:(BLUPost *)post {
    [self.toolBar.textField becomeFirstResponder];
}

#pragma mark - Circle transition delegate

- (void)shouldTransitToCircle:(NSDictionary *)circleInfo fromView:(UIView *)view sender:(id)sender {
    UIViewController *lastViewController = nil;
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self] - 1;
    if (index >= 0) {
        lastViewController = self.navigationController.viewControllers[index];
    }
    if ([lastViewController isKindOfClass:[BLUCircleDetailMainViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.postDetailViewModel.post.circle) {
            BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:self.postDetailViewModel.post.circle.circleID];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - BLUCommentReplyTextView.

- (void)shouldReportReply:(NSDictionary *)replyInfo commentReplyTextView:(BLUCommentReplyTextView *)commentReplyTextView {
    BLUCommentReply *reply = replyInfo[BLUCommentReplyKeyCommentReply];
    BLUReportViewModel *reportViewModel = [[BLUReportViewModel alloc ] initWithObjectID:reply.replyID viewController:self sourceView:commentReplyTextView sourceRect:commentReplyTextView.bounds sourceType:BLUReportSourceTypeReply];
    [reportViewModel showReportSheet];
}

- (void)shouldDeleteReply:(NSDictionary *)replyInfo commentReplyTextView:(BLUCommentReplyTextView *)commentReplyTextView {
    if (![BLUAppManager sharedManager].currentUser) {
        [self loginRequired:nil];
        return ;
    }

    BLUCommentReply *reply = replyInfo[BLUCommentReplyKeyCommentReply];

    __block BLUComment *comment;
    __block NSIndexPath *indexForComment;
    BLUPostCommentViewModel *viewModel = self.currentPostCommentViewModel;
    [viewModel.comments enumerateObjectsUsingBlock:^(BLUComment *iterForComment, NSUInteger idx, BOOL * _Nonnull stop) {
        for (BLUCommentReply *iterForReply in iterForComment.replies) {
            if (iterForReply.replyID == reply.replyID) {
                comment = iterForComment;
                indexForComment = [NSIndexPath indexPathForRow:idx inSection:TableViewSectionComment];
                *stop = YES;
            }
        }
    }];

    self.seletedComment = comment;
    self.seletedCommentIndex = indexForComment;

    if (!self.seletedComment) {
        return ;
    }

    if (reply.author.userID != [BLUAppManager sharedManager].currentUser.userID) {
        return ;
    }

    @weakify(self);
    [[self.commentActionViewModel deleteReply:reply.replyID] subscribeNext:^(id x) {
        @strongify(self);
        [[viewModel fetchCommentWithCommentID:comment.commentID] subscribeNext:^(id x) {
            [self.tableView reloadRowsAtIndexPaths:@[self.seletedCommentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        } error:^(NSError *error) {
            [self showAlertForError:error];
        }];
    } error:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];
}

- (void)shouldReplyToReply:(NSDictionary *)replyInfo commentReplyTextView:(BLUCommentReplyTextView *)commentReplyTextView {
    if (![BLUAppManager sharedManager].currentUser) {
        [self loginRequired:nil];
        return ;
    }

    BLUCommentReply *reply = replyInfo[BLUCommentReplyKeyCommentReply];
    if (reply.replyID != self.seletedReply.replyID) {
        self.toolBar.textField.text = nil;
    }
    self.seletedReply = reply;

    __block BLUComment *comment;
    __block NSIndexPath *indexForComment;
    BLUPostCommentViewModel *viewModel = self.currentPostCommentViewModel;
    [viewModel.comments enumerateObjectsUsingBlock:^(BLUComment *iterForComment, NSUInteger idx, BOOL * _Nonnull stop) {
        for (BLUCommentReply *iterForReply in iterForComment.replies) {
            if (iterForReply.replyID == reply.replyID) {
                comment = iterForComment;
                indexForComment = [NSIndexPath indexPathForRow:idx inSection:TableViewSectionComment];
                *stop = YES;
            }
        }
    }];

    self.seletedComment = comment;
    self.seletedCommentIndex = indexForComment;

    if (!self.seletedComment) {
        return ;
    }

    if (self.seletedReply.author.userID == [BLUAppManager sharedManager].currentUser.userID) {
        return ;
    }

    [self.toolBar.textField becomeFirstResponder];
    self.replyType = ReplyTypeToTargetUser;
    NSString *commentUserNickname = self.postDetailViewModel.post.author.userID == comment.author.userID && self.postDetailViewModel.post.anonymousEnable == YES ? [BLUUser anonymousNickname] : self.seletedReply.author.nickname;
    self.toolBar.textField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"post-detail.toolbar.placeholder.replyToComment %@", @"Reply to comment"), commentUserNickname];
}

@end
