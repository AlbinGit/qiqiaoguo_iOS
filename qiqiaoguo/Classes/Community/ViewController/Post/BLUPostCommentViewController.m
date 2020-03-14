//
//  BLUPostCommentViewController.m
//  Blue
//
//  Created by Bowen on 15/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommentViewController.h"
#import "BLUPostCommentOptCell.h"
#import "BLUComment.h"
#import "BLUUserTransitionDelegate.h"
#import "BLUPostCommentToolbar.h"
#import "BLUCommentActionViewModel.h"
#import "BLUCommentReply.h"
#import "BLUComment.h"
#import "BLUPost.h"
#import "BLUCommentReplyTextView.h"
#import "BLUApiManager+Comment.h"
#import "BLUPostCommentPromptCell.h"
#import "BLUApiManager+User.h"
#import "BLUApiManager+Post.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUReportViewModel.h"

typedef NS_ENUM(NSInteger, ReplyType) {
    ReplyTypeToComment = 0,
    ReplyTypeToReply,
};

@interface BLUPostCommentViewController () <UITableViewDelegate, UITableViewDataSource, BLUPostCommentActionDelegate, BLUPostCommentToolbarDelegate, BLUCommentReplyTextViewDelegate>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) BLUPostCommentToolbar *toolBar;

@property (nonatomic, copy) BLUComment *comment;
@property (nonatomic, copy) BLUPost *post;
@property (nonatomic, copy) BLUUser *postUser;
@property (nonatomic, strong) BLUUserTransitionDelegate *userTransition;
@property (nonatomic, strong) BLUCommentActionViewModel *commentActionViewModel;

@property (nonatomic, assign) ReplyType replyType;

@property (nonatomic, strong) BLUCommentReply *seletedReply;

@property (nonatomic, assign) NSInteger commentID;
@property (nonatomic, assign) NSInteger postID;
@property (nonatomic, assign) NSInteger postUserID;

@end

@implementation BLUPostCommentViewController

#pragma mark - BLUViewController.

- (instancetype)initWithComment:(BLUComment *)comment user:(BLUUser *)postUser post:(BLUPost *)post {
    NSParameterAssert([comment isKindOfClass:[BLUComment class]]);
    if (self = [super init]) {
        _comment = [comment copy];
        _post = post;
        _postUser = postUser;

        _replyType = ReplyTypeToComment;
        self.title = NSLocalizedString(@"post-comment.title", @"Comment detail");

        // Keyboard notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillHideNotification object:nil];
        return self;
    }
    return nil;
}

- (instancetype)initWithCommentID:(NSInteger)commentID userID:(NSInteger)userID postID:(NSInteger)postID {
    if (self = [super init]) {
        _comment = nil;
        _post = nil;
        _postUser = nil;

        _commentID = commentID;
        _postID = postID;
        _postUserID = userID;

        _replyType = ReplyTypeToComment;
        self.title = NSLocalizedString(@"post-comment.title", @"Comment detail");

        // Keyboard notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillHideNotification object:nil];

        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [BLUTableView new];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[BLUPostCommentOptCell class] forCellReuseIdentifier:NSStringFromClass([BLUPostCommentOptCell class])];

    _toolBar = [BLUPostCommentToolbar new];
    _toolBar.postCommentToolbarDelegate = self;
    _toolBar.translucent = YES;

    [self.view addSubview:_tableView];
    [self.view addSubview:_toolBar];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
    }];

    self.view.backgroundColor = [UIColor whiteColor];

    @weakify(self);
    [[RACObserve(self, replyType) distinctUntilChanged] subscribeNext:^(NSNumber *type) {
        @strongify(self);
        if (type.integerValue != ReplyTypeToReply) {
            if (_comment) {
                NSString *nickname = self.post.anonymousEnable ? NSLocalizedString(@"post-comment-vc.toobar.textfield.title.reply-to-comment.anonymous", @"Anonymous") : _comment.author.nickname;
                self.toolBar.textField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"post-comment-vc.toolbar.placeholder.reply-to-comment %@", @"Reply to comment"), nickname];
            } else {
                self.toolBar.textField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"post-comment-vc.toolbar.placeholder.reply-to-comment %@", @"Reply to comment"), @" "];
            }
        }
    }];

    [RACObserve(self, tableView.contentSize) subscribeNext:^(id x) {
        BLULogDebug(@"tableview.contentSize = %@", NSStringFromCGSize(self.tableView.contentSize));
    }];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"post-comment-vc.right-bar-button.title", @"Post") style:UIBarButtonItemStylePlain target:self action:@selector(showPostAction:)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top, 0, _toolBar.height, 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.toolBar.textField resignFirstResponder];
    self.toolBar.textField.text = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        if (self.comment) {
            @weakify(self);
            [[[BLUApiManager sharedManager] fetchCommentWithCommentID:self.comment.commentID] subscribeNext:^(BLUComment *comment) {
                @strongify(self);
                self.comment = comment;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self tableViewEndRefreshing:self.tableView];
            } error:^(NSError *error) {
                @strongify(self);
                [self showAlertForError:error];
                [self tableViewEndRefreshing:self.tableView];
            }];
        } else {
            @weakify(self);
            [[[BLUApiManager sharedManager] fetchUserWithUserID:self.postUserID] subscribeNext:^(BLUUser *user) {
                @strongify(self);
                self.postUser = user;
                [[[BLUApiManager sharedManager] fetchPostDetail:self.postID] subscribeNext:^(BLUPost *post) {
                    self.post = post;
                    [[[BLUApiManager sharedManager] fetchCommentWithCommentID:self.commentID] subscribeNext:^(BLUComment *comment) {
                        [self tableViewEndRefreshing:self.tableView];
                        self.comment = comment;
                        [self.tableView reloadData];
                        if (self.replyType != ReplyTypeToReply) {
                            self.toolBar.textField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"post-comment-vc.toolbar.placeholder.reply-to-comment %@", @"Reply to comment"), _comment.author.nickname];
                        }
                    } error:^(NSError *error) {
                        [self tableViewEndRefreshing:self.tableView];
                        [self showAlertForError:error];
                    }];
                } error:^(NSError *error) {
                    [self tableViewEndRefreshing:self.tableView];
                    [self showAlertForError:error];
                }];
            } error:^(NSError *error) {
                @strongify(self);
                [self tableViewEndRefreshing:self.tableView];
                [self showAlertForError:error];
            }];
        }
    }];
}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    if (self.comment) {
        [self fetchComment];
    } else {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - Model.

- (BLUUserTransitionDelegate *)userTransition {
    if (_userTransition == nil) {
        _userTransition = [BLUUserTransitionDelegate new];
        _userTransition.viewController = self;
    }
    return _userTransition;
}

- (BLUCommentActionViewModel *)commentActionViewModel {
    if (_commentActionViewModel == nil) {
        _commentActionViewModel = [BLUCommentActionViewModel new];
        _commentActionViewModel.commentID = _comment.commentID;
    }
    return _commentActionViewModel;
}

- (void)fetchComment {
    @weakify(self);
    if (self.comment) {
        [[[BLUApiManager sharedManager] fetchCommentWithCommentID:self.comment.commentID] subscribeNext:^(BLUComment *comment) {
            @strongify(self);
            self.comment = comment;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        } error:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
        }];
    }
}

- (void)showPostAction:(id)sender {
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self] - 1;
    UIViewController *lastViewController = nil;
    if (index >= 0) {
        lastViewController = self.navigationController.viewControllers[index];
    }
    if ([lastViewController isKindOfClass:[BLUPostDetailAsyncViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSInteger postID = 0;
        if (self.post) {
            postID = self.post.postID;
        } else {
            postID = self.postID;
        }

        BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:postID];
        [self pushViewController:vc];
    }
}

#pragma mark - UITableView.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _comment? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUPostCommentOptCell *commentCell = (BLUPostCommentOptCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUPostCommentOptCell class]) forIndexPath:indexPath];
    [commentCell setModel:self.comment postUser:self.postUser post:self.post shouldShowCompleteReplies:YES delegate:self replytTextViewDelegate:self userTransition:self.userTransition];
    commentCell.solidLine.hidden = YES;
    return commentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_tableView sizeForCellWithCellClass:[BLUPostCommentOptCell class] cacheByIndexPath:indexPath width:self.tableView.width configuration:^(BLUCell *cell) {
        [(BLUPostCommentOptCell *)cell setModel:self.comment postUser:self.postUser post:self.post shouldShowCompleteReplies:YES delegate:self replytTextViewDelegate:self userTransition:self.userTransition];
    }].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.toolBar.textField becomeFirstResponder];
}

#pragma mark - UIPostCommentOptCell.

- (void)shouldLikeComment:(NSDictionary *)commentInfo fromView:(UIView *)view sender:(id)sender {
    if (commentInfo == nil) {
        return ;
    }

    BLUUser *currentUser = [[BLUAppManager sharedManager] currentUser];
    if (currentUser == nil) {
        [self loginRequired:nil];
        return ;
    }

    BLUComment *shouldDislikeComment = commentInfo[BLUCommentKeyComment];
    if (shouldDislikeComment.commentID != _comment.commentID) {
        return ;
    }

    if (_comment.didLike) {
        return ;
    }

    _comment.like = YES;
    _comment.likeCount++;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

    @weakify(self);
    [[self.commentActionViewModel like] subscribeError:^(NSError *error) {
        @strongify(self);
        _comment.like = NO;
        _comment.likeCount--;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self showAlertForError:error];
    }];
}

- (void)shouldDislikeComment:(NSDictionary *)commentInfo fromView:(UIView *)view sender:(id)sender {
    if (commentInfo == nil) {
        return ;
    }

    BLUUser *currentUser = [[BLUAppManager sharedManager] currentUser];
    if (currentUser == nil) {
        [self loginRequired:nil];
        return ;
    }

    BLUComment *shouldDislikeComment = commentInfo[BLUCommentKeyComment];
    if (shouldDislikeComment.commentID != _comment.commentID) {
        return ;
    }

    if (!_comment.didLike) {
        return ;
    }

    _comment.like = NO;
    _comment.likeCount--;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

    @weakify(self);
    [[self.commentActionViewModel dislike] subscribeError:^(NSError *error) {
        @strongify(self);
        _comment.like = YES;
        _comment.likeCount++;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self showAlertForError:error];
    }];
}

#pragma mark - Toolbar delegate

- (void)toolbar:(BLUPostCommentToolbar *)toolbar didSendComment:(NSString *)content {

    if (content.length == 0) {
        return;
    }

    if (self.replyType == ReplyTypeToComment) {
        @weakify(self);
        [[self.commentActionViewModel reply:content toUser:nil] subscribeNext:^(id x) {
            @strongify(self);
            [self fetchComment];
        } error:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
        }];

    } else if (self.replyType == ReplyTypeToReply) {
        @weakify(self);
        self.commentActionViewModel.commentID = self.comment.commentID;
        [[self.commentActionViewModel reply:content toUser:self.seletedReply.author] subscribeNext:^(id x) {
            @strongify(self);
            [self fetchComment];
        } error:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
        }];
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

    @weakify(self);
    [[self.commentActionViewModel deleteReply:reply.replyID] subscribeNext:^(id x) {
        @strongify(self);
        [self fetchComment];
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

    self.seletedReply = replyInfo[BLUCommentReplyKeyCommentReply];

    if (self.seletedReply.author.userID == [BLUAppManager sharedManager].currentUser.userID) {
        return ;
    }

    [self.toolBar.textField becomeFirstResponder];
    self.replyType = ReplyTypeToReply;
    NSString *commentUserNickname = self.post.author.userID == self.comment.author.userID && self.post.anonymousEnable == YES ? [BLUUser anonymousNickname] : self.seletedReply.author.nickname;
    self.toolBar.textField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"post-comment.toolbar.placeholder.replyToReply %@", @"Reply to reply"), commentUserNickname];
}

#pragma mark - BLUPostCommentAction.

- (void)shouldShowMoreRepliesForComment:(NSDictionary *)commentInfo formView:(UIView *)view sender:(id)sender {
    BLULogDebug(@"");
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

    if (notification.name == UIKeyboardWillShowNotification) {
    } else if (notification.name == UIKeyboardWillHideNotification) {
        self.replyType = ReplyTypeToComment;
        self.toolBar.textField.text = nil;
    }

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

#pragma mark - UIScrollView.

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_toolBar.textField resignFirstResponder];
}

@end
