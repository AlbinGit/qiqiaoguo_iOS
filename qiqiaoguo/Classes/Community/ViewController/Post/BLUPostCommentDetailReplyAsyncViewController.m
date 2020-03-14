//
//  BLUPostDetailCommentReplyAsyncViewController.m
//  Blue
//
//  Created by Bowen on 25/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommentDetailReplyAsyncViewController.h"
#import "BLUComment.h"
#import "BLUPostCommentDetailAsyncViewModel.h"
#import "BLUPostDetailCommentNode.h"
#import "BLUPost.h"
#import "BLUCommentReply.h"
#import "BLUPostCommentDetailReplyAsyncViewController+CommentNode.h"
#import "BLUPostDetailCommentReplyNode.h"
#import "BLUPostDetailCommentReplyTextNode.h"
#import "BLUContentReplyView.h"
#import "BLUOtherUserViewController.h"
#import "BLUReportViewModel.h"
#import "BLUApiManager+Post.h"
#import "BLUPostDetailAsyncViewController.h"

@implementation BLUPostCommentDetailReplyAsyncViewController

- (instancetype)initWithCommentID:(NSInteger)commentID
                           postID:(NSInteger)postID {
    if (self = [super init]) {
        BLUParameterAssert(commentID > 0);
        BLUParameterAssert(postID > 0);
        
        _viewModel = [[BLUPostCommentDetailAsyncViewModel alloc] initWithCommentID:commentID];
        _viewModel.postID = postID;
        _viewModel.delegate = self;
        _viewModel.replyTo = BLUPostCommentReplyToComment;
    }
    return self;
}

- (instancetype)initWithComment:(BLUComment *)comment
                           post:(BLUPost *)post {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(post, [BLUPost class]);
        BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);

        _viewModel = [[BLUPostCommentDetailAsyncViewModel alloc] initWithCommentID:comment.commentID];
        _viewModel.comment = comment;
        _viewModel.post = post;
        _viewModel.postID = post.postID;
        _viewModel.delegate = self;
        _viewModel.replyTo = BLUPostCommentReplyToComment;

        _viewModel.comment = comment;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView =
    [[ASTableView alloc] initWithFrame:CGRectZero
                                 style:UITableViewStylePlain
                     asyncDataFetching:YES];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.asyncDataSource = self;
    _tableView.asyncDelegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];

    _replyView = [BLUContentReplyView new];
    _replyView.replyDelegate = self;
    [_replyView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _replyView.prompt =
    NSLocalizedString(@"post-detail-async-vc.reply-view.prompt",
                      @"Good comment earn good prize.");

    NSString *placeholder =
    NSLocalizedString(@"post-comment-deatil-reply-async-vc.reply-view.placeholder.reply-to-comment-%@",
                      @"Reply to %@");

    BOOL anonymous = self.viewModel.post.anonymousEnable;// && self.viewModel.post.author.userID == self.viewModel.comment.author.userID;
    if (anonymous) {
        self.replyView.placeHolder = NSLocalizedString(@"post-comment-detail-reply-avc.reply-view.anonymous", @"Anonymous");
    } else {
        self.replyView.placeHolder = [NSString stringWithFormat:placeholder, self.viewModel.comment.author.nickname];
    }


    NSInteger index = [self.navigationController.viewControllers indexOfObject:self] - 1;
    UIViewController *lastViewController = nil;
    if (index >= 0) {
        lastViewController = self.navigationController.viewControllers[index];
    }
    if (![lastViewController isKindOfClass:[BLUPostDetailAsyncViewController class]]) {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"post-comment-vc.right-bar-button.title",
                                                                 @"Post")
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(tapAndShowPostDetails:)];
    }

    [self.view addSubview:_tableView];
    [self.view addSubview:_replyView];

    [_replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChanged:)
     name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChanged:)
     name:UIKeyboardWillHideNotification object:nil];

    if (self.viewModel.shouldReplyToComment == YES) {
        [self replyToComment];
        self.viewModel.targetReply = nil;
    } else {
        if ([self.viewModel.targetReply isKindOfClass:[BLUCommentReply class]]) {
            [self replyToReply:self.viewModel.targetReply];
        } else {
            return;
        }
    }
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    if (self.viewModel.post == nil) {
        [self.view showIndicator];
        @weakify(self);
        [[[BLUApiManager sharedManager] fetchPostDetail:self.viewModel.postID] subscribeNext:^(BLUPost *post) {
            @strongify(self);
            BLUAssertObjectIsKindOfClass(post, [BLUPost class]);
            self.viewModel.post = post;
            [self.viewModel updateComment];
            [self.view hideIndicator];
        } error:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
            [self.view hideIndicator];
        }];
    } else {
        [self.viewModel updateComment];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.replyView resignFirstResponder];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];

    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
}

- (void)setShouldReplyToComment:(BOOL)shouldReplyToComment {
    self.viewModel.shouldReplyToComment = shouldReplyToComment;
}

- (void)setTargetReply:(BLUCommentReply *)targetReply {
    self.viewModel.targetReply = targetReply;
}

- (void)replyToReply:(BLUCommentReply *)reply {
    BLUAssertObjectIsKindOfClass(reply, [BLUCommentReply class]);
    self.viewModel.targetReply = reply;
    self.viewModel.replyTo = BLUPostCommentReplyToReply;
    NSString *placeholder =
    NSLocalizedString(@"post-comment-deatil-reply-async-vc.reply-view.placeholder.reply-to-reply-%@",
                      @"Reply to %@");

    BOOL anonymous = self.viewModel.post.anonymousEnable && self.viewModel.post.author.userID == self.viewModel.targetReply.author.userID;
    if (anonymous) {
        self.replyView.placeHolder = NSLocalizedString(@"post-comment-detail-reply-avc.reply-view.anonymous", @"Anonymous");
    } else {
        self.replyView.placeHolder = [NSString stringWithFormat:placeholder, self.viewModel.targetReply.author.nickname];
    }

    [self.replyView becomeFirstResponder];
}

- (void)replyToComment {
    self.viewModel.replyTo = BLUPostCommentReplyToComment;
    NSString *placeholder =
    NSLocalizedString(@"post-comment-deatil-reply-async-vc.reply-view.placeholder.reply-to-comment-%@",
                      @"Reply to %@");

    BOOL anonymous = self.viewModel.post.anonymousEnable && self.viewModel.post.author.userID == self.viewModel.comment.author.userID;
    if (anonymous) {
        self.replyView.placeHolder = NSLocalizedString(@"post-comment-detail-reply-avc.reply-view.anonymous", @"Anonymous");
    } else {
        self.replyView.placeHolder = [NSString stringWithFormat:placeholder, self.viewModel.comment.author.nickname];
    }

    [self.replyView becomeFirstResponder];
}

- (void)tapAndShowPostDetails:(id)sender {
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self] - 1;
    UIViewController *lastViewController = nil;
    if (index >= 0) {
        lastViewController = self.navigationController.viewControllers[index];
    }
    if ([lastViewController isKindOfClass:[BLUPostDetailAsyncViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:self.viewModel.postID];
        [self pushViewController:vc];
    }
}

@end

@implementation BLUPostCommentDetailReplyAsyncViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return (self.viewModel.comment != nil && self.viewModel.post != nil) ? 1 : 0;
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUPostDetailCommentNode *commentNode =
    [[BLUPostDetailCommentNode alloc] initWithComment:self.viewModel.comment
                                                 post:self.viewModel.post
                                           replyCount:NSIntegerMax
                                            anonymous:self.viewModel.post.anonymousEnable
                                            separator:NO];

    NSString *title = NSLocalizedString(@"post-detail-async-vc.reply-vc.title-%@",
                                        @"#");
    self.title = [NSString stringWithFormat:title, @(self.viewModel.comment.floor)];
    commentNode.delegate = self;
    commentNode.replyNode.replyTextNodeDelegate = self;
    return commentNode;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self replyToComment];
}

- (void)configureCommentNode {
    BLUPostDetailCommentNode *commentNode =
    (BLUPostDetailCommentNode *)[_tableView nodeForRowAtIndexPath:
                                 [NSIndexPath indexPathForRow:0 inSection:0]];
    commentNode.comment = self.viewModel.comment;
}

@end

@implementation BLUPostCommentDetailReplyAsyncViewController (ViewModel)

- (void)viewModel:(BLUPostCommentDetailAsyncViewModel *)viewModel
     didMeetError:(NSError *)error {
    [self showTopIndicatorWithError:error];
}

- (void)viewModel:(BLUPostCommentDetailAsyncViewModel *)viewModel
 didChangeComment:(BLUComment *)comment {
    NSString *placeholder =
    NSLocalizedString(@"post-comment-deatil-reply-async-vc.reply-view.placeholder.reply-to-comment-%@",
                      @"Reply to %@");
    self.replyView.placeHolder = [NSString stringWithFormat:placeholder, self.viewModel.comment.author.nickname];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewModel:(BLUPostCommentDetailAsyncViewModel *)viewModel
didSuccessWithMessage:(NSString *)message {
    if (message.length > 0) {
        [self showTopIndicatorWithSuccessMessage:message];
    }
}

@end

@implementation BLUPostCommentDetailReplyAsyncViewController (Reply)

- (BOOL)shouldEnableSendContent:(NSString *)content
                   fomReplyView:(BLUContentReplyView *)replyView {
    return [[content stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceCharacterSet]] length] > 0;
}

- (void)shouldSendContent:(NSString *)content
            fromReplyView:(BLUContentReplyView *)replyView {
    
    if ([self loginIfNeeded]) {
        return;
    }
    
    switch (self.viewModel.replyTo) {
        case BLUPostCommentReplyToComment: {
            [self.viewModel replyComment:content];
        } break;
        case BLUPostCommentReplyToReply: {
            BLUAssertObjectIsKindOfClass(self.viewModel.targetReply,
                                         [BLUCommentReply class]);
            [self.viewModel replyToReply:self.viewModel.targetReply
                                 content:content];
        } break;
    }
    [self.replyView clear];
    self.viewModel.replyTo = BLUPostCommentReplyToComment;
    NSString *placeholder =
    NSLocalizedString(@"post-comment-deatil-reply-async-vc.reply-view.placeholder.reply-to-comment-%@",
                      @"Reply to %@");
    BOOL anonymous = self.viewModel.post.anonymousEnable == YES &&
    self.viewModel.post.author.userID == self.viewModel.comment.author.userID;
    if (anonymous) {
        self.replyView.placeHolder = NSLocalizedString(@"post-comment-detail-reply-avc.reply-view.anonymous", @"Anonymous");
    } else {
        self.replyView.placeHolder =
        [NSString stringWithFormat:placeholder, self.viewModel.comment.author.nickname];
    }
    [self.replyView resignFirstResponder];
}

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
        self.tableView.userInteractionEnabled = NO;
    } else {
        self.tableView.userInteractionEnabled = YES;
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    [self.replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (notification.name == UIKeyboardWillShowNotification) {
            CGFloat offset = keyboardEndFrame.size.height;
            make.bottom.equalTo(self.view).offset(-offset);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];

    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

@end

@implementation BLUPostCommentDetailReplyAsyncViewController (PostDetailCommentNode)

#pragma mark - Commment node

- (void)shouldUpdateLikeStateForComment:(BLUComment *)comment
                                   from:(BLUPostDetailCommentNode *)node
                                 sender:(id)sender {
    if ([self loginIfNeeded]) {
        return;
    }

    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);

    if (comment.didLike) {
        [self.viewModel dislikeComment];
    } else {
        [self.viewModel likeComment];
    }

}

- (void)shouldShowUserDetailForUser:(BLUUser *)user
                               from:(BLUPostDetailCommentNode *)node
                             sender:(id)sender {
    BLUOtherUserViewController *vc =
    [[BLUOtherUserViewController alloc] initWithUserID:user.userID];
    [self pushViewController:vc];
}

#pragma mark - Reply text node

- (void)shouldReplyToCommentReply:(BLUCommentReply *)reply
                             from:(BLUPostDetailCommentReplyTextNode *)node {
    [self replyToReply:reply];
}

- (void)shouldDeleteCommentReply:(BLUCommentReply *)reply
                            from:(BLUPostDetailCommentReplyTextNode *)node {
    [self.viewModel deleteReply:reply];
}

- (void)shouldReportCommentReply:(BLUCommentReply *)reply
                            from:(BLUPostDetailCommentReplyTextNode *)node {
    BLUReportViewModel *reportViewModel =
    [[BLUReportViewModel alloc ] initWithObjectID:reply.replyID
                                   viewController:self
                                       sourceView:node.view
                                       sourceRect:node.view.bounds
                                       sourceType:BLUReportSourceTypeReply];
    [reportViewModel showReportSheet];
}

- (void)shouldShowUserDetails:(BLUUser *)user
                         from:(BLUPostDetailCommentReplyTextNode *)node {
    BLUOtherUserViewController *vc =
    [[BLUOtherUserViewController alloc] initWithUserID:user.userID];
    [self pushViewController:vc];
}

@end