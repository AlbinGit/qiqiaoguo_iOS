//
//  BLUPostDetailAsyncViewController+PostDetailNode.m
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController+PostDetailNode.h"
#import "BLUPostDetailAsyncViewModelHeader.h"
#import "BLUPost.h"
#import "BLUPostTagDetailViewController.h"
#import "BLUPostLikedUserViewController.h"
#import "BLUOtherUserViewController.h"
#import "BLUWebViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BLUPostTagDetailViewController.h"
#import "BLUShowImageController.h"
#import "BLUContentParagraph.h"
#import "QGProductDetailsViewController.h"
#import "QGSearchResultViewController.h"
#import "QGOrgAllTeacherViewController.h"
#import "QGActivityHomeViewController.h"
#import "QGActivityDetailViewController.h"
#import "QGOrgViewController.h"
#import "QGTeacherViewController.h"
#import "QGCourseDetailViewController.h"

@implementation BLUPostDetailAsyncViewController (PostDetailNode)

- (void)shouldShowTagDetailForTag:(BLUPostTag *)tag
                             from:(BLUPostDetailNode *)node
                           sender:(id)sender {

    BLUAssertObjectIsKindOfClass(tag, [BLUPostTag class]);
    BLUPostTagDetailViewController *vc =
    [[BLUPostTagDetailViewController alloc] initWithTagID:tag.tagID];
    [self pushViewController:vc];
}

- (void)shouldShowImagesForParagraphs:(NSArray *)paragraphs
                              atIndex:(NSInteger)index
                                 from:(BLUPostDetailNode *)node
                               sender:(id)sender {
    // TODO
}

- (void)shouldShowImage:(UIImage *)image from:(BLUPostDetailNode *)node sender:(id)sender {
    // TODO
}

//- (void)showImage:(UIImage *)image fromSender:(id)sender {
//
//}

- (void)shouldShowUserDetail:(BLUUser *)user
                        from:(BLUPostDetailNode *)node
                      sender:(id)sender {
    BLUAssertObjectIsKindOfClass(user, [BLUUser class]);
    BLUOtherUserViewController *vc =
    [[BLUOtherUserViewController alloc] initWithUserID:user.userID];
    [self pushViewController:vc];
}

- (void)shouldShowWebDetailForURL:(NSURL *)url
                             from:(BLUPostDetailNode *)node
                           sender:(id)sender {
    BLUAssertObjectIsKindOfClass(url, [NSURL class]);
    BLUWebViewController *vc =
    [[BLUWebViewController alloc] initWithPageURL:url];
    [self pushViewController:vc];
}

- (void)shouldShowCircleDetailForCircleID:(NSInteger)circleID
                                     from:(BLUPostDetailNode *)node
                                   sender:(id)sender {
    BLUParameterAssert(circleID > 0);
    BLUCircleDetailMainViewController *vc =
    [[BLUCircleDetailMainViewController alloc] initWithCircleID:circleID];
    [self pushViewController:vc];
}

- (void)shouldShowPostDetailForPostID:(NSInteger)postID
                                 from:(BLUPostDetailNode *)node
                               sender:(id)sender {
    BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:postID];
    [self pushViewController:vc];
}

- (void)shouldShowOtherVCWithType:(BLUContentParagraphRedirectType)type ObjectID:(NSInteger)objectID{
    UIViewController *goToVc = nil;
    switch (type) {
        case BLUContentParagraphRedirectTypeGood: {
            QGProductDetailsViewController *vc = [QGProductDetailsViewController new];
            vc.goods_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case BLUContentParagraphRedirectTypeGoodCategory: {
            QGSearchResultViewController *vc = [QGSearchResultViewController new];
            vc.searchOptionType = QGSearchOptionTypeGoods;
            vc.catogoryId = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case BLUContentParagraphRedirectTypeOrgList: {
            QGSearchResultViewController *vc = [QGSearchResultViewController new];
            vc.searchOptionType = QGSearchOptionTypeInstitution;
            vc.keyWord = @"";
            goToVc = vc;
            break;
        }
        case BLUContentParagraphRedirectTypeTercherList: {
            QGOrgAllTeacherViewController *vc = [QGOrgAllTeacherViewController new];
            vc.org_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case BLUContentParagraphRedirectTypeCourseList: {
            QGSearchResultViewController *vc = [QGSearchResultViewController new];
            vc.searchOptionType = QGSearchOptionTypeCourse;
            vc.keyWord = @"";
            goToVc = vc;
            break;
        }
        case BLUContentParagraphRedirectTypeActivList: {
            QGActivityHomeViewController *vc = [QGActivityHomeViewController new];
            goToVc = vc;
            break;
        }
        case BLUContentParagraphRedirectTypeActiv: {
            QGActivityDetailViewController *vc = [QGActivityDetailViewController new];
            vc.activity_id = [@(objectID) stringValue];
            goToVc = vc;

            break;
        }
        case BLUContentParagraphRedirectTypeOrg: {
            QGOrgViewController *vc = [QGOrgViewController new];
            vc.org_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case BLUContentParagraphRedirectTypeTeacher: {
            QGTeacherViewController *vc = [QGTeacherViewController new];
            vc.teacher_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
        case BLUContentParagraphRedirectTypeCourse: {
            QGCourseDetailViewController *vc = [QGCourseDetailViewController new];
            vc.course_id = [@(objectID) stringValue];
            goToVc = vc;
            break;
        }
    }
    if (goToVc){
        [self.navigationController pushViewController:goToVc animated:YES];
    }
}

- (void)shouldPlayVideoWithURL:(NSURL *)URL
                          from:(BLUPostDetailNode *)node
                        sender:(id)sender {
    BLUAssertObjectIsKindOfClass(URL, [NSURL class]);
    AVPlayerViewController *vc = [AVPlayerViewController new];
    vc.player = [[AVPlayer alloc] initWithURL:URL];
    [vc.player play];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)shouldShowTagDetailWithTagID:(NSInteger)tagID
                                from:(BLUPostDetailNode *)node
                              sender:(id)sender {
    BLUParameterAssert(tagID > 0);
    BLUPostTagDetailViewController *vc = [[BLUPostTagDetailViewController alloc] initWithTagID:tagID];
    [self pushViewController:vc];
}

- (void)shouldChangeLikeStateForPost:(BLUPost *)post
                                from:(BLUPostDetailLikeNode *)node
                              sender:(id)sender {
    BLUAssertObjectIsKindOfClass(post, [BLUPost class]);

    if ([self loginIfNeeded]) return;

    if (post.didLike == YES) {
        [self.viewModel dislikePost];
    } else {
        [self.viewModel likePost];
    }
}

- (void)shouldShowUserDetailsForUser:(BLUUser *)user
                                from:(BLUPostDetailLikeNode *)node
                              sender:(id)sender {
    BLUAssertObjectIsKindOfClass(user, [BLUUser class]);
    BLUOtherUserViewController *vc =
    [[BLUOtherUserViewController alloc] initWithUserID:user.userID];
    [self pushViewController:vc];

}

- (void)shouldShowLikedUsersForPost:(BLUPost *)post
                               from:(BLUPostDetailLikeNode *)node
                             sender:(id)sender {
    BLUAssertObjectIsKindOfClass(post, [BLUPost class]);
    BLUPostLikedUserViewController *vc = [[BLUPostLikedUserViewController alloc] initWithPost:post];
    [self pushViewController:vc];
}

@end
