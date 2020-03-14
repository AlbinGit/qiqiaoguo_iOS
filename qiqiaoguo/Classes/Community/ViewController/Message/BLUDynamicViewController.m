//
//  BLUMessageListViewController.m
//  Blue
//
//  Created by Bowen on 14/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUDynamicViewController.h"
#import "BLUDynamicCell.h"
#import "BLUDynamicViewModel.h"
#import "BLUDynamic.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUOtherUserViewController.h"
#import "BLUDynamicMO.h"
#import "BLUOtherUserViewController.h"
#import "BLUUserTransitionDelegate.h"
#import "BLURemoteNotification.h"
#import "BLUPostCommentDetailReplyAsyncViewController.h"


@interface BLUDynamicViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) BLUDynamicViewModel *dynamicViewModel;
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) BLUUserTransitionDelegate *userTransition;

@end

@implementation BLUDynamicViewController

#pragma mark - BLUViewController.

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = NSLocalizedString(@"dynamic-vc.title", @"Dynamic");
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;

    _tableView = [BLUTableView new];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[BLUDynamicCell class] forCellReuseIdentifier:NSStringFromClass([BLUDynamicCell class])];
    [self.view addSubview:_tableView];

//    @weakify(self);
//    [RACObserve(self, dynamicViewModel.state) subscribeNext:^(NSNumber *state) {
//        @strongify(self);
//        switch (state.integerValue) {
//            case BLUDynamicViewModelStateFetching:
//            case BLUDynamicViewModelStateNormal: {
//                self.title = NSLocalizedString(@"dynamic-vc.title.normal", @"Dynamic");
//            } break;
//            case BLUDynamicViewModelStateFetching: {
//                self.title = NSLocalizedString(@"dynamic-vc.title.fetching", @"Fetching");
//            } break;
//            case BLUDynamicViewModelStateFetchFailed: {
//                self.title = NSLocalizedString(@"dynamic-vc.title.fetch-failed", @"Fetch failed");
//            } break;
//            case BLUDynamicViewModelStateFetchAgain: {
//                self.title = NSLocalizedString(@"dynamic-vc.title.fetch-again", @"Fetch again");
//            } break;
//        }
//    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.dynamicViewModel fetch];
}

- (void)handleRemoteNotification:(NSNotification *)userInfo {
    BLURemoteNotification *remoteNotification = userInfo.object;
    switch (remoteNotification.type) {
        case BLURemoteNotificationTypeComment:
        case BLURemoteNotificationTypeLikePost:
        case BLURemoteNotificationTypeLikeComment:
        case BLURemoteNotificationTypeCommentReply:
        case BLURemoteNotificationTypeFollow: {
            [self.dynamicViewModel fetch];
        } break;
        default: {
            [super handleRemoteNotification:userInfo];
        } break;
    }
}

#pragma mark - Model.

//- (NSFetchedResultsController *)fetchedResultsController {
////    return self.dynamicViewModel.fetchedResultsController;
//}

- (BLUDynamicViewModel *)dynamicViewModel {
    if (_dynamicViewModel == nil) {
//        _dynamicViewModel = [[BLUDynamicViewModel alloc] initWithFetchedResultsControllerDelegate:self];
    }
    return _dynamicViewModel;
}

- (BLUUserTransitionDelegate *)userTransition {
    if (_userTransition == nil) {
        _userTransition = [BLUUserTransitionDelegate new];
        _userTransition.viewController = self;
    }
    return _userTransition;
}

#pragma mark - UITableView.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUDynamicCell *cell = (BLUDynamicCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUDynamicCell class]) forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [_tableView sizeForCellWithCellClass:[BLUDynamicCell class]
                                      cacheByIndexPath:indexPath
                                                 width:_tableView.width
                                         configuration:^(BLUCell *cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
    BLULogDebug(@"indexPath ==> %@, size ==> %@", indexPath, NSStringFromCGSize(size));
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUDynamicMO *dynamic = [self.fetchedResultsController objectAtIndexPath:indexPath];
    switch (dynamic.type.integerValue) {
        case BLUDynamicMOTypePost :
        case BLUDynamicMOTypeCommentPost:
        case BLUDynamicMOTypeLikePost: {
            NSInteger postID = dynamic.postID.integerValue;
            BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:postID];
            [self pushViewController:vc];
        } break;
        case BLUDynamicMOTypeLikeComment:
        case BLUDynamicMOTypeReplyComment: {
            NSInteger postID = dynamic.postID.integerValue;
            NSInteger commentID = dynamic.commentID.integerValue;
            BLUPostCommentDetailReplyAsyncViewController *vc = [[BLUPostCommentDetailReplyAsyncViewController alloc] initWithCommentID:commentID postID:postID];
            [self pushViewController:vc];
        } break;
        case BLUDynamicMOTypeUserFollow: {
            NSInteger userID = dynamic.fromUserID.integerValue;
            BLUOtherUserViewController *vc = [[BLUOtherUserViewController alloc] initWithUserID:userID];
            [self pushViewController:vc];
        } break;
    }
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BLUDynamicCell *dynamicCell = (BLUDynamicCell *)cell;
    [dynamicCell setModel:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    dynamicCell.userTransitionDelegate = self.userTransition;
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
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        } break;
        case NSFetchedResultsChangeDelete: {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        } break;
        default: break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
