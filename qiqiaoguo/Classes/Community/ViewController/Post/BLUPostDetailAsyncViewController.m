//
//  BLUPostDetailAsyncViewController.m
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController.h"
#import "BLUPostDetailAsyncViewController+TableView.h"
#import "BLUPostDetailAsyncViewController+ViewModel.h"
#import "BLUPostDetailAsyncViewModelHeader.h"
#import "BLUPostDetailFeaturedCommentsHeader.h"
#import "BLUPostDetailAllCommentsHeader.h"
#import "BLUPostDetailToolbar.h"
#import "BLUPostDetailAsyncViewController+Toolbar.h"
#import "BLUContentReplyView.h"
#import "BLUPostDetailAsyncViewController+Reply.h"
#import "BLUBottomTransitioningAnimator.h"
#import "BLUPostDetailTakeSofaFooterView.h"
#import "BLUShowImageController.h"

@implementation BLUPostDetailAsyncViewController

- (instancetype)initWithPostID:(NSInteger)postID {
    if (self = [super init]) {
        NSParameterAssert(postID > 0);
        self.title = NSLocalizedString(@"post-detail-async-vc.title",
                                       @"Post detail");

        _tableView = [[ASTableView alloc] init];
        
        _tableView.frame = CGRectZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.asyncDataSource = self;
        _tableView.asyncDelegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];

        _viewModel = [BLUPostDetailAsyncViewModel new];
        _viewModel.delegate = self;
        _viewModel.postID = postID;

        _featuredCommentsHeader = [BLUPostDetailFeaturedCommentsHeader new];

        _allCommentsHeader = [BLUPostDetailAllCommentsHeader new];
        _allCommentsHeader.headerDelegate = self;
        _allCommentsHeader.commentsReverse = self.viewModel.commentsReverse;

        _allCommentsButton = [[UIBarButtonItem alloc]
                              initWithImage:[BLUCurrentTheme postJustLooikngFirstfloorIcon]
                              style:UIBarButtonItemStylePlain
                              target:self
                              action:@selector(tapAndShowOwnerComments:)];
        _allCommentsButton.enabled = NO;

        _ownerCommentButton = [[UIBarButtonItem alloc]
                               initWithImage:[BLUCurrentTheme postViewAllIcon]
                               style:UIBarButtonItemStylePlain
                               target:self
                               action:@selector(tapAndShowAllComments:)];
        _ownerCommentButton.enabled = NO;

        [self configureRightNavBarButton];

        _toolbar = [BLUPostDetailToolbar new];
        _toolbar.toolbarDelegate = self;
        _toolbar.enabled = NO;

        _replyView = [BLUContentReplyView new];
        _replyView.replyDelegate = self;
        [_replyView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _replyView.prompt =
        NSLocalizedString(@"post-detail-async-vc.reply-view.prompt",
                          @"Good comment earn good prize.");

        _upPullEnable = NO;

        self.hidesBottomBarWhenPushed = YES;

        _tableViewLastContentOffset = CGPointZero;

        _showImageController = [BLUShowImageController new];
        _showImageController.fromViewController = self;
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tableView];
    [self.view addSubview:_toolbar];
    [self.view addSubview:_replyView];
    self.view.backgroundColor = [UIColor whiteColor];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];

    [_replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];

    @weakify(self);
    _tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel fetchAll];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    UIEdgeInsets tableViewContentInsets = _tableView.contentInset;
    tableViewContentInsets.bottom = [BLUPostDetailToolbar toolbarHeight];
    _tableView.contentInset = tableViewContentInsets;

    CGFloat toolbarY =
    self.view.height - [BLUPostDetailToolbar toolbarHeight];
    _toolbar.frame =
    CGRectMake(0, toolbarY, self.view.width,
               [BLUPostDetailToolbar toolbarHeight]);
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    [_viewModel fetchAll];
    [self.view showIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChanged:)
     name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardChanged:)
     name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];

    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
}

- (void)configureAfterPostArrived {
    BLUPost *post = [self.viewModel post];
    _toolbar.enabled = YES;
    NSString *placeholder =
    NSLocalizedString(@"post-detail-async-vc.placeholder.reply-to-%@",
                      @"Reply to");
    _replyView.placeHolder =
    [NSString stringWithFormat:placeholder, post.author.nickname];
    [_toolbar showCornerMarkerWithNumberofComments:post.commentCount];

    _ownerCommentButton.enabled = YES;
    _allCommentsButton.enabled = YES;

    _upPullEnable = YES;
}

- (void)configureRightNavBarButton {
    if (self.viewModel.showOwnerComments) {
        self.navigationItem.rightBarButtonItem = _ownerCommentButton;
    } else {
        self.navigationItem.rightBarButtonItem = _allCommentsButton;
    }
}

- (void)tapAndShowAllComments:(UIBarButtonItem *)barButtonItem {
    self.viewModel.showOwnerComments = NO;
    [self configureRightNavBarButton];
    self.allCommentsButton.enabled = NO;
    self.ownerCommentButton.enabled = NO;
    [self performSelector:@selector(buttonEnable) withObject:nil afterDelay:0.5];
}

- (void)tapAndShowOwnerComments:(UIBarButtonItem *)barButtonItem {
    self.viewModel.showOwnerComments = YES;
    [self configureRightNavBarButton];
    self.allCommentsButton.enabled = NO;
    self.ownerCommentButton.enabled = NO;
    [self performSelector:@selector(buttonEnable) withObject:nil afterDelay:0.5];
}

- (void)buttonEnable {
    self.allCommentsButton.enabled = YES;
    self.ownerCommentButton.enabled = YES;
}

@end
