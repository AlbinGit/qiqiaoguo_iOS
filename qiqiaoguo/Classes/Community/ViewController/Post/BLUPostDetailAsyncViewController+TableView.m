//
//  BLUPostDetailAsyncViewController+TableView.m
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController+TableView.h"
#import "BLUPostDetailAsyncViewModelHeader.h"
#import "BLUPostDetailNode.h"
#import "BLUPostDetailCommentNode.h"
#import "BLUPostDetailCommentReplyNode.h"
#import "BLUPostDetailCommentReplyTextNode.h"
#import "BLUPostDetailAsyncViewController+PostDetailCommentNode.h"
#import "BLUPostDetailFeaturedCommentsHeader.h"
#import "BLUPostDetailAllCommentsHeader.h"
#import "BLUPostDetailAsyncViewController+PostDetailNode.h"
#import "BLUPostDetailToolbar.h"
#import "BLUPost.h"
#import "BLUPostDetailLikeNode.h"
#import "BLUReportViewModel.h"
#import "BLUPostDetailAsyncViewModel+CommentInteraction.h"
#import "BLUPostCommentDetailReplyAsyncViewController.h"
#import "BLUShowImageController.h"

@implementation BLUPostDetailAsyncViewController (TableView)

#pragma mark - Cell node

- (void)configureNode:(ASCellNode *)node
          atIndexPath:(NSIndexPath *)indexPath {
    if ([node isKindOfClass:[BLUPostDetailNode class]]) {
        BLUPostDetailNode *postNode = (BLUPostDetailNode *)node;
        postNode.post = [[self viewModel] objectAtIndexPath:indexPath];
    } else if ([node isKindOfClass:[BLUPostDetailCommentNode class]]) {
        BLUPostDetailCommentNode *commentNode = (BLUPostDetailCommentNode *)node;
        BLUComment *comment = [[self viewModel] objectAtIndexPath:indexPath];
        [commentNode setComment:comment];
    } else if ([node isKindOfClass:[BLUPostDetailLikeNode class]]) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        return ;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = [[self viewModel] numberOfSections];
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[self viewModel] numberOfRowsInSection:section];
}

- (ASCellNode *)tableView:(ASTableView *)tableView
    nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [[self viewModel] objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[BLUPost class]]) {
        if (indexPath.row == [self.viewModel postIndexPath].row) {
            BLUPost *post = (BLUPost *)object;

            [self configureAfterPostArrived];

            BLUPostDetailNode *node = [[BLUPostDetailNode alloc] initWithPost:post];
            node.showImageDelegate = self.showImageController;
            node.delegate = self;
            return node;
        } else if (indexPath.row == [self.viewModel postLikeIndexPath].row) {
            BLUPost *post = (BLUPost *)object;

            BLUPostDetailLikeNode *node = [[BLUPostDetailLikeNode alloc]
                                           initWithPost:post];
            node.delegate = self;
            return node;
        } else {
            return nil;
        }
    } else if ([object isKindOfClass:[BLUComment class]]) {
        BLUComment *comment = (BLUComment *)object;
        BOOL showSeparator = indexPath.row !=
        ([self.viewModel numberOfRowsInSection:indexPath.section] - 1);
        BOOL anonymous = NO;
        if (self.viewModel.post.anonymousEnable) {
            anonymous = self.viewModel.post.author.userID == comment.author.userID;
        }
        BLUPostDetailCommentNode *node =
        [[BLUPostDetailCommentNode alloc] initWithComment:comment
                                                     post:[self.viewModel post]
                                               replyCount:2
                                                anonymous:anonymous
                                                separator:showSeparator];
        node.delegate = self;
        node.replyNode.delegate = self;
        node.replyNode.replyTextNodeDelegate = self;
        return node;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUPostDetailAsyncSectionType sectionType = [self.viewModel sectionTypeOfSection:indexPath.section];
    if (sectionType == BLUPostDetailAsyncSectionTypeFeaturedComments ||
        sectionType == BLUPostDetailAsyncSectionTypeComments) {
        BLUComment *comment = [self.viewModel objectAtIndexPath:indexPath];
        BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
        BLUPostCommentDetailReplyAsyncViewController *vc =
        [[BLUPostCommentDetailReplyAsyncViewController alloc] initWithComment:comment
                                                                         post:[self.viewModel post]];
        vc.shouldReplyToComment = YES;
        [self pushViewController:vc];
    }
}

#pragma mark - Header

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    BLUPostDetailAsyncSectionType type = [self.viewModel sectionTypeOfSection:section];

    CGFloat height = 0.0;

    switch (type) {
        case BLUPostDetailAsyncSectionTypeFeaturedComments: {
            height = [self headerHeight];
        } break;
        case BLUPostDetailAsyncSectionTypeComments: {
            height = [self headerHeight];
        } break;
        default: break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BLUPostDetailAsyncSectionType type = [self.viewModel sectionTypeOfSection:section];
    switch (type) {
        case BLUPostDetailAsyncSectionTypeNone:
        case BLUPostDetailAsyncSectionTypePost: {
            return nil;
        } break;
        case BLUPostDetailAsyncSectionTypeFeaturedComments: {
            return self.featuredCommentsHeader;
        } break;
        case BLUPostDetailAsyncSectionTypeComments: {
            self.allCommentsHeader.orderButton.hidden =
            self.viewModel.showOwnerComments == YES ||
            self.viewModel.currentComments.count == 0;
            return self.allCommentsHeader;
        } break;
    }
}

- (CGFloat)headerHeight {
    return 32.0;
}

#pragma mark - Trasaction


- (void)tableView:(ASTableView *)tableView
willDisplayNodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *node = [self.tableView nodeForRowAtIndexPath:indexPath];
    if ([node isKindOfClass:[BLUPostDetailCommentNode class]]) {
        [self.toolbar hideCornerMarker];
    }
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    [self.viewModel fetchMoreComments];
    self.batchContext = context;
}

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView {
    return self.upPullEnable;
}

#pragma mark - Edit

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUPostDetailAsyncSectionType type =
    [self.viewModel sectionTypeOfSection:indexPath.section];

    if (type == BLUPostDetailAsyncSectionTypeComments) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUComment *comment = [self.viewModel objectAtIndexPath:indexPath];
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    ASCellNode *cellNode = [self.tableView nodeForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (comment.author.userID == [BLUAppManager sharedManager].currentUser.userID) {
            [self.viewModel deleteCommentAtIndexPath:indexPath];
        } else {
            BLUReportViewModel *reportViewModel =
            [[BLUReportViewModel alloc ] initWithObjectID:comment.commentID
                                           viewController:self
                                               sourceView:cellNode.view
                                               sourceRect:cellNode.view.bounds
                                               sourceType:BLUReportSourceTypeComment];
            [reportViewModel showReportSheet];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUComment *comment = [self.viewModel objectAtIndexPath:indexPath];
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    if (comment.author.userID == [BLUAppManager sharedManager].currentUser.userID) {
        return NSLocalizedString(@"post-detail.table-view-action.delete",
                                 @"delete");
    } else {
        return NSLocalizedString(@"post-detail.table-view-action.report",
                                 @"Report");
    }
}

#pragma mark - Post detail all comment header

- (void)shouldChangeCommentsReverse:(BOOL)reverse
                               from:(BLUPostDetailAllCommentsHeader *)header
                             sender:(id)sender {
    self.viewModel.commentsReverse = reverse;
}

@end
