//
//  BLUChatViewController.m
//  Blue
//
//  Created by Bowen on 27/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUChatViewController.h"
#import "BLUChatCell.h"
#import "BLUPostCommentToolbar.h"
#import "BLUMessage.h"
#import "BLUMessageMO.h"
#import "BLUChatViewModel.h"
#import "BLURemoteNotification.h"
#import "BLUUserTransitionDelegate.h"
#import "BLUNoCoinIndicator.h"
#import "BLUApiManager.h"
#import "BLUUserCoinViewController.h"
//#import "BLUGoodMO.h"
#import "BLUMessageHeader.h"
//#import "BLUChatGoodHintCell.h"
#import "BLUAlertView.h"
#import "BLUUserLevelViewController.h"
#import "BLUChatGoodHintCell.h"
#import "QGChatHeaderView.h"
#import "QGProductDetailsViewController.h"
#import "QGCourseDetailViewController.h"
#import "QGActivityDetailViewController.h"
#import "QGTeacherViewController.h"
#import "QGOrgViewController.h"
#import "QGSecKillDetailViewController.h"
#import "QGRemoteNotiModel.h"
//#import "BLUGoodDetailsViewController.h"

NSInteger BLUApiErrorNoCoinToChat             = 11001;
NSInteger BLUApiErrorInsufficientLevelToChat  = 11003;

static const NSInteger kDimViewTag = 1001;
static const NSInteger kNoCointIndicatorTag = 1002;

@interface BLUChatViewController () <UITableViewDelegate, UITableViewDataSource, BLUPostCommentToolbarDelegate, NSFetchedResultsControllerDelegate, BLUChatCellProtocol>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) BLUPostCommentToolbar *toolbar;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSIndexPath *lastInsertPath;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) BLUUser *user;
@property (nonatomic, assign) BOOL showKeyboard;
@property (nonatomic, strong) BLUUserTransitionDelegate *userTransition;

@end

@implementation BLUChatViewController

- (instancetype)initWithUser:(BLUUser *)user {
    if (self = [super init]) {
        _user = user;
        self.title = user.nickname;
        self.hidesBottomBarWhenPushed = YES;
        _chatViewModel = [[BLUChatViewModel alloc] initWithUserID:user.userID fetchedResultsControllerDelegate:self];
        _isFirstLoad = YES;
        // Keyboard notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillHideNotification object:nil];
        _showKeyboard = NO;
        return self;
    }
    return nil;
}

- (instancetype)initWithUserID:(NSInteger)userID{
    if (self = [super init]) {
        self.title = @"客服";
        self.navigationController.navigationBar.hidden = NO;
        self.hidesBottomBarWhenPushed = YES;
        _chatViewModel = [[BLUChatViewModel alloc] initWithUserID:userID fetchedResultsControllerDelegate:self];
        _isFirstLoad = YES;
        // Keyboard notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillHideNotification object:nil];
        _showKeyboard = NO;
        return self;
    }
    return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = APPBackgroundColor;

    _tableView = [BLUTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = APPBackgroundColor;
    [_tableView registerClass:[BLUChatCell class]
       forCellReuseIdentifier:NSStringFromClass([BLUChatCell class])];
//    [_tableView registerClass:[BLUChatGoodHintCell class]
//       forCellReuseIdentifier:NSStringFromClass([BLUChatGoodHintCell class])];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    // Tool bar
    _toolbar = [BLUPostCommentToolbar new];
    _toolbar.postCommentToolbarDelegate = self;
    _toolbar.translucent = YES;
//    _toolbar.textField.placeholder = NSLocalizedString(@"chat-vc.toolbar.textfield.placeholder", @"Reply");

    [self.view addSubview:_tableView];
    [self.view addSubview:_toolbar];

    [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];

    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        BLULogError(@"Error = %@", error);
        abort();
    }

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.showKeyboard == NO) {
        _tableView.frame = self.view.bounds;
    }
    UIEdgeInsets contentInset = _tableView.contentInset;
    contentInset.bottom = self.toolbar.height + BLUThemeMargin * 2;
    _tableView.contentInset = contentInset;
    [self scrollToBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.chatViewModel fetch];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.toolbar.textField resignFirstResponder];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self.toolbar.textField resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Model.

- (NSFetchedResultsController *)fetchedResultsController {
    return self.chatViewModel.fetchedResultsController;
}

- (BLUUserTransitionDelegate *)userTransition {
    if (_userTransition == nil) {
        _userTransition = [BLUUserTransitionDelegate new];
        _userTransition.viewController = self;
    }
    return _userTransition;
}

- (void)tapDimViewAction:(id)sender {
    [self removeDimViewAndNoCoinIndicatorWithAnime];
}

- (void)earnCoinAction:(id)sender {
    [self removeDimViewAndNoCoinIndicatorWithAnime];
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    BLUUserCoinViewController *vc = [[BLUUserCoinViewController alloc] initWithUser:currentUser];
    [self pushViewController:vc];
}

- (void)cancelAction:(id)sender {
    [self removeDimViewAndNoCoinIndicatorWithAnime];
}

- (void)removeDimViewAndNoCoinIndicatorWithAnime {
    UIView *dimView = [self.view viewWithTag:kDimViewTag];
    BLUNoCoinIndicator *indicator = [self.view viewWithTag:kNoCointIndicatorTag];
    [UIView animateWithDuration:0.2 animations:^{
        dimView.alpha = 0.0;
        indicator.alpha = 0.0;
    } completion:^(BOOL finished) {
        [dimView removeFromSuperview];
        [indicator removeFromSuperview];
    }];
}

#pragma mark - UITableView.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Class cellClass;
    cellClass = [BLUChatCell class];

    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)
                                    forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    BLUMessageMO *messageMO = [self.fetchedResultsController
                               objectAtIndexPath:indexPath];
    NSInteger styleType = messageMO.styleType.integerValue;
    switch (styleType) {
        default: {
            return [self.tableView
                    sizeForCellWithCellClass:[BLUChatCell class]
                    cacheByIndexPath:indexPath
                    width:self.tableView.width
                    model:[self.fetchedResultsController
                           objectAtIndexPath:indexPath]].height;
        } break;
    }
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[BLUChatCell class]]) {
        BLUChatCell *chatCell = (BLUChatCell *)cell;
        [chatCell setModel:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        chatCell.delegate = self;
        chatCell.userTransitionDelegate = self.userTransition;
        chatCell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        return ;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.headModel) {
        QGChatHeaderView *header = [[QGChatHeaderView alloc] initWithGoodMO:self.headModel];
        [header.sendButton
         addTarget:self
         action:@selector(HeadtapAndSendGoodURL:)
         forControlEvents:UIControlEventTouchUpInside];
        return header;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headModel ? 130 : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUMessageMO *messageMO = [self.fetchedResultsController objectAtIndexPath:indexPath];
    BLUAssertObjectIsKindOfClass(messageMO, [BLUMessageMO class]);
    if (messageMO.styleType.integerValue == BLUMessageStyleTypeGoodPrompt) {
        switch (messageMO.redirectType.integerValue) {
            case BLUPageRedirectionTypeGood:
            {
                QGProductDetailsViewController *vc = [QGProductDetailsViewController new];
                vc.goods_id = [NSString stringWithFormat:@"%@",messageMO.redirectID];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            case BLUPageRedirectionTypeSeckillGood:
            {
                QGSecKillDetailViewController *vc = [QGSecKillDetailViewController new];
                vc.goods_id= [NSString stringWithFormat:@"%@",messageMO.redirectID];
//                seckDetail.seckilling_no = listModel.seckilling_no;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }break;
            case BLUPageRedirectionTypeOrg:
            {
                QGOrgViewController *vc = [QGOrgViewController new];
                vc.org_id = [NSString stringWithFormat:@"%@",messageMO.redirectID];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            case BLUPageRedirectionTypeTeacher:
            {
                QGTeacherViewController *vc = [QGTeacherViewController new];
                vc.teacher_id = [NSString stringWithFormat:@"%@",messageMO.redirectID];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            case BLUPageRedirectionTypeCourse:
            {
                QGCourseDetailViewController *vc = [QGCourseDetailViewController new];
                vc.course_id = [NSString stringWithFormat:@"%@",messageMO.redirectID];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            case BLUPageRedirectionTypeActiv:
            {
                QGActivityDetailViewController *vc = [QGActivityDetailViewController new];
                vc.activity_id = [NSString stringWithFormat:@"%@",messageMO.redirectID];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            case BLUPageRedirectionTypePost:
            {
//                QGCourseDetailViewController *vc = [QGCourseDetailViewController new];
//                vc.course_id = [NSString stringWithFormat:@"%@",messageMO.redirectID];
//                [self.navigationController pushViewController:vc animated:YES];
            }break;
                
            default:
                break;
        }
    }
}

- (void)scrollToBottom {
    NSInteger count = self.fetchedResultsController.fetchedObjects.count;
    if (count > 0) {
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: !self.isFirstLoad];
        self.isFirstLoad = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.toolbar.textField resignFirstResponder];
}

- (void)tapAndSendGoodURL:(UIButton *)sender {
    BLUChatGoodHintCell *cell = (BLUChatGoodHintCell *)sender.superview.superview.superview;
    BLUAssertObjectIsKindOfClass(cell, [BLUChatGoodHintCell class]);
    BLUGoodMO *good = cell.model;
//    BLUAssertObjectIsKindOfClass(good, [BLUGoodMO class]);
    @weakify(self);
    [[self.chatViewModel sendGood:good] subscribeError:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
    }];
}

- (void)HeadtapAndSendGoodURL:(UIButton *)sender {
    QGChatHeaderView *header = (QGChatHeaderView *)sender.superview.superview;
    id good = header.good;
    @weakify(self);
    [[self.chatViewModel sendGood:good] subscribeError:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
    }];
}

#pragma mark - BLUPostCommentToolbar.

- (void)toolbar:(BLUPostCommentToolbar *)toolbar didSendComment:(NSString *)comment {
    self.toolbar.textField.text = @"";
    if (comment.length > 0) {
        [[self.chatViewModel sendMessage:comment] subscribeError:^(NSError *error) {
            [self handleErrorForSendComment:error];
        } completed:^{
            self.toolbar.sendButton.enabled = NO;
        }];
    }
}

- (void)handleErrorForSendComment:(NSError *)error {
    if (error.code == BLUApiErrorNoCoinToChat) {
        [self handleNoCoinError:error];
    } else if (error.code == BLUApiErrorInsufficientLevelToChat){
        [self handleInsufficientLevelWithMessage:error.localizedDescription];
    } else {
        [self showAlertForError:error];
    }
}

- (void)handleInsufficientLevelWithMessage:(NSString *)message {
    BLUAlertView *alertView =
    [[BLUAlertView alloc]
     initWithTitle:message
     message:nil
     cancelButtonTitle:NSLocalizedString(@"circle-detail-main-vc.OK", @"OK")
     otherButtonTitle:NSLocalizedString(@"char-vc.details", @"Details")];

    alertView.titleLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);

    @weakify(alertView);
    alertView.otherButtonAction = ^() {
        @strongify(alertView);
        [alertView dismiss];
        BLUUserLevelViewController *vc =
        [[BLUUserLevelViewController alloc]
         initWithUser:[BLUAppManager sharedManager].currentUser];
        [self pushViewController:vc];
    };

    alertView.messageBottomPadding = 40;
    [alertView show];
}

- (void)handleNoCoinError:(NSError *)error {
    UIView *dimView = [UIView new];
    dimView.backgroundColor = [UIColor blackColor];
    dimView.alpha = 0.0;
    dimView.tag = kDimViewTag;
    UITapGestureRecognizer *tapDimView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDimViewAction:)];
    [dimView addGestureRecognizer:tapDimView];
    [self.view addSubview:dimView];

    BLUNoCoinIndicator *indicator = [BLUNoCoinIndicator new];
    indicator.indicatorTextView.text = NSLocalizedString(@"chat-vc.no-coin-indicator.title", @"No coin to chat!");
    indicator.alpha = 0.0;
    indicator.tag = kNoCointIndicatorTag;
    [indicator.earnButton addTarget:self action:@selector(earnCoinAction:) forControlEvents:UIControlEventTouchUpInside];
    [indicator.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:indicator];

    dimView.frame = self.view.bounds;

    [indicator sizeToFit];
    indicator.centerX = self.view.width / 2;
    indicator.centerY = self.view.height / 2;

    [UIView animateWithDuration:0.2 animations:^{
        indicator.alpha = 1.0;
        dimView.alpha = 0.5;
    }];
}

#pragma mark - BLUChatCell.

- (void)shouldResendMessage:(BLUMessageMO *)message fromChatCell:(BLUChatCell *)chatCell sender:(id)sender {
    [[self.chatViewModel resendMessage:message] subscribeError:^(NSError *error) {
        [self handleErrorForSendComment:error];
    }];
}

- (void)shouldShowGoodDetails:(BLUGoodMO *)good
                 fromChatCell:(BLUChatCell *)charCell
                       sender:(id)sender {
//    BLUGoodDetailsViewController *vc =
//    [[BLUGoodDetailsViewController alloc] initWithGoodID:good.goodID];
//    [self pushViewController:vc];
}

#pragma mark - NSFetchResultController.

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    self.lastInsertPath = nil;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.lastInsertPath = newIndexPath;
        } break;
        case NSFetchedResultsChangeDelete: {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } break;
        case NSFetchedResultsChangeUpdate: {
            [self configCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
        } break;
        case NSFetchedResultsChangeMove: {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        } break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    UITableView *tableView = self.tableView;

    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        } break;
        case NSFetchedResultsChangeDelete: {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        } break;
        default: break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self scrollToBottom];
}

#pragma mark - Keyboard.

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

    [self.toolbar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        if (notification.name == UIKeyboardWillShowNotification) {
            make.bottom.equalTo(self.view).offset(-keyboardEndFrame.size.height);
        } else if (notification.name == UIKeyboardWillHideNotification) {
            make.bottom.equalTo(self.view);
        }
    }];
    [self.view layoutIfNeeded];

    BOOL shouldChangeTableViewOrigin = NO;

    NSInteger count = self.fetchedResultsController.fetchedObjects.count;
    CGFloat tableViewOffset = 0.0;
    if (count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        UITableViewCell *lastCell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGRect cellFrame = [lastCell convertRect:lastCell.bounds toView:self.view];
        tableViewOffset = self.view.height - (cellFrame.origin.y + cellFrame.size.height + self.topLayoutGuide.length);
        tableViewOffset = tableViewOffset - (keyboardEndFrame.size.height + self.toolbar.height + BLUThemeMargin * 2);
        shouldChangeTableViewOrigin = YES;
    }

    if (shouldChangeTableViewOrigin) {
        if (notification.name == UIKeyboardWillShowNotification) {
            self.showKeyboard = YES;
            self.tableView.y += tableViewOffset;
        } else if (notification.name == UIKeyboardWillHideNotification) {
            self.showKeyboard = NO;
            self.tableView.frame = self.view.bounds;
        }
    }

    UIEdgeInsets contentInset = _tableView.contentInset;
    contentInset.bottom = self.toolbar.height + BLUThemeMargin * 2;
    _tableView.contentInset = contentInset;

    [UIView commitAnimations];
}

- (void)handleRemoteNotification:(NSNotification *)userInfo {
    QGRemoteNotiModel *notification = userInfo.object;
    if (notification.type == QGRemoteNotificationTypeChatMeassage) {
        [self.chatViewModel fetch];
    } else {
        [super handleRemoteNotification:userInfo];
    }
}

@end
