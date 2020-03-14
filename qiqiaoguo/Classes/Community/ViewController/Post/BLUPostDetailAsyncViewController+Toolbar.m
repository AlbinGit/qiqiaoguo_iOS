//
//  BLUPostDetailAsyncViewController+Toolbar.m
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController+Toolbar.h"
#import "BLUPostDetailToolbar.h"
#import "BLUPostDetailAsyncViewModel+CommentManager.h"
#import "BLUContentReplyView.h"
#import "BLUPostDetailAsyncViewModelHeader.h"
#import "BLUReportViewModel.h"
#import "BLUPostDetailOptionsViewController.h"
#import "QGShareViewController.h"
#import "BLUShareManager.h"
#import "BLUReportViewModel.h"
#import "BLUPost.h"

@implementation BLUPostDetailAsyncViewController (Toolbar)

- (void)shouldReplyFrom:(BLUPostDetailToolbar *)toolbar
                 sender:(id)sender {
    if ([self loginIfNeeded]) {
        return;
    }
    [self.replyView becomeFirstResponder];
}

- (void)shouldShowCommentsFrom:(BLUPostDetailToolbar *)toolbar
                        sender:(id)sender {
    CGRect rectOfCell = [self.tableView rectForRowAtIndexPath:[self.viewModel postLikeIndexPath]];

    CGFloat offset = self.tableView.contentOffset.y - rectOfCell.origin.y;
    if (fabs(offset) < 1.0) {
        [self.tableView setContentOffset:self.tableViewLastContentOffset animated:YES];
    } else {
        self.tableViewLastContentOffset = self.tableView.contentOffset;
        [self.tableView scrollToRowAtIndexPath:[self.viewModel postLikeIndexPath]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

- (void)shouldShareFrom:(BLUPostDetailToolbar *)toolbar
                 sender:(id)sender {
    QGShareViewController *vc = [QGShareViewController new];
    vc.shareObject = [self.viewModel post];
    vc.shareManager.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)shouldShowOtherOptionsFrom:(BLUPostDetailToolbar *)toolbar
                            sender:(id)sender {
    BLUPostDetailOptionsViewController *targetController =
    [[BLUPostDetailOptionsViewController alloc]
     initWithPost:[self.viewModel post]];
    targetController.delegate = self;
    [self presentViewController:targetController animated:YES completion:nil];
}

- (void)shouldChangeCollectionStateForPost:(BLUPost *)post
                        fromViewController:(BLUPostDetailOptionsViewController *)viewController
                                    sender:(id)sender {
    if ([self loginIfNeeded]) {
        return;
    }

    post = [self.viewModel post];
    if (post.didCollect) {
        [self.viewModel cancelCollectPost];
    } else {
        [self.viewModel collectPost];
    }
}

- (void)shouldReportPost:(BLUPost *)post
      fromViewController:(BLUPostDetailOptionsViewController *)viewController
                  sender:(id)sender {
    BLUReportViewModel *reportViewModel =
    [[BLUReportViewModel alloc ] initWithObjectID:post.postID
                                   viewController:self
                                       sourceView:(UIView *)sender
                                       sourceRect:((UIView *)sender).bounds
                                       sourceType:BLUReportSourceTypePost];
    [reportViewModel showReportSheet];
}

- (void)shouldReverseCommentFromViewController:(BLUPostDetailOptionsViewController *)viewController
                                        sender:(id)sender {
    self.viewModel.commentsReverse = !self.viewModel.commentsReverse;
}

@end
