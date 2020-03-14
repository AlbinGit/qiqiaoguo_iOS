//
//  BLUPostDetailAsyncViewController+ViewModel.m
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController+ViewModel.h"
#import "BLUPostDetailAsyncViewController+TableView.h"
#import "BLUContentReplyView.h"
#import "BLUPostDetailTakeSofaFooterView.h"

@implementation BLUPostDetailAsyncViewController (ViewModel)

- (void)shouldShowNoCommentPrompt:(BOOL)show
                    fromViewModel:(BLUPostDetailAsyncViewModel *)viewModel {
    

    if (show) {
        BLUPostDetailTakeSofaFooterView *footerView =
        [BLUPostDetailTakeSofaFooterView new];
        footerView.delegate = self;
        footerView.alpha = 0.0;
        footerView.frame = CGRectMake(0, 0, self.view.width, 108);
        self.tableView.tableFooterView = footerView;
        [UIView animateWithDuration:0.2 animations:^{
            footerView.alpha = 1.0;
        }];
    } else {
        if ([self.tableView.tableFooterView
             isKindOfClass:[BLUPostDetailTakeSofaFooterView class]]) {
            BLUPostDetailTakeSofaFooterView *footerView =
            (BLUPostDetailTakeSofaFooterView *)[self.tableView tableFooterView];
            [UIView animateWithDuration:0.2 animations:^{
                footerView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.tableView.tableFooterView = nil;
            }];
        }
    }
}

- (void)shouldShowRowAtIndexPath:(NSIndexPath *)indexPath
                   fromViewModel:(BLUPostDetailAsyncViewModel *)viewModel {
    // Do nothing
}

- (void)viewModel:(BLUPostDetailAsyncViewModel *)viewModel
     didMeetError:(NSError *)error {
    [self showTopIndicatorWithError:error];
    [self.view hideIndicator];
}

- (void)viewModelWillChangeContent:(BLUPostDetailAsyncViewModel *)viewModel {
    [[self tableView] beginUpdates];
}

- (void)viewModelDidChangeContent:(BLUPostDetailAsyncViewModel *)viewModel {
    [[self tableView] endUpdates];
}

- (void)viewModel:(BLUPostDetailAsyncViewModel *)viewModel
  didChangeObject:(id)object
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(BLUViewModelObjectChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case BLUViewModelObjectChangeTypeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        } break;
        case BLUViewModelObjectChangeTypeUpdate: {
            [self configureNode:[self.tableView nodeForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } break;
        case BLUViewModelObjectChangeTypeMove: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        } break;
        case BLUViewModelObjectChangeTypeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        } break;
    }
}

- (void)viewModel:(BLUPostDetailAsyncViewModel *)viewModel
didChangeSectionAtIndex:(NSInteger)index
    forChangeType:(BLUViewModelObjectChangeType)type {
    switch (type) {
        case BLUViewModelObjectChangeTypeInsert: {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index]
                          withRowAnimation:UITableViewRowAnimationFade];
        } break;
        case BLUViewModelObjectChangeTypeDelete: {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index]
                          withRowAnimation:UITableViewRowAnimationFade];
        } break;
        default: break;
    }
}

- (void)viewModel:(BLUPostDetailAsyncViewModel *)viewModel
didSuccessWithMessage:(NSString *)message {
    [self.view hideIndicator];
    if (message.length > 0) {
        [self showTopIndicatorWithSuccessMessage:message];
    }
}

- (void)viewModel:(BLUPostDetailAsyncViewModel *)viewModel
     didReplyPost:(BLUPost *)post
      withContent:(NSString *)content {
    [self.replyView clear];
    [self.replyView resignFirstResponder];
}

- (void)viewModelDidReload:(BLUPostDetailAsyncViewModel *)viewModel {
    [self.tableView.mj_header endRefreshing];
    [self.view hideIndicator];
}

- (void)viewModelDidLoadMoreData:(BLUPostDetailAsyncViewModel *)viewModel {
    [self.tableView.mj_header endRefreshing];
    [self.view hideIndicator];
    [self.batchContext completeBatchFetching:YES];
}

- (void)viewModelDidReloadData:(BLUPostDetailAsyncViewModel *)viewModel {
    [self.tableView reloadData];
}

#pragma mark - Footer view

- (void)footerViewNeedComment:(BLUPostDetailTakeSofaFooterView *)footerView {
    [self.replyView becomeFirstResponder];
}

@end
