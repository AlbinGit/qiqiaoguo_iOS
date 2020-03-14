//
//  BLUAdTransitionDelegate.m
//  Blue
//
//  Created by Bowen on 10/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUAdTransitionDelegate.h"
#import "BLUAd.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUWebViewController.h"
#import "BLUPostTagDetailViewController.h"
#import "BLUPageRedirection.h"
#import "BLUHotTagViewController.h"
#import "BLUPostTag.h"
#import "QGProductDetailsViewController.h"
#import "QGOrgViewController.h"
#import "QGTeacherViewController.h"
#import "QGCourseDetailViewController.h"
#import "QGActivityDetailViewController.h"
#import "QGSearchResultViewController.h"
#import "QGOrgAllTeacherViewController.h"
#import "QGActivityHomeViewController.h"

@implementation BLUAdTransitionDelegate

- (void)shouldTransitWithAd:(BLUAd *)ad fromView:(UIView *)view sender:(id)sender {
    if (ad && self.viewController && self.viewController.navigationController) {
        UIViewController *vc = nil;
        switch (ad.redirectType) {
            case BLUPageRedirectionTypePost: {
                vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:ad.redirectID];
            } break;
            case BLUPageRedirectionTypeCircle: {
                vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:ad.redirectID];
            } break;
            case BLUPageRedirectionTypeWeb: {
                vc = [[BLUWebViewController alloc] initWithPageURL:ad.redirectURL];
                vc.title = ad.title;
            } break;
            case BLUPageRedirectionTypeTag: {
                vc = [[BLUPostTagDetailViewController alloc] initWithTagID:ad.redirectID];
            } break;
            case BLUPageRedirectionTypeGood: {
                QGProductDetailsViewController *jumpvc = [QGProductDetailsViewController new];
                jumpvc.goods_id = @(ad.redirectID).stringValue;
                vc = jumpvc;
                break;
            }
            case BLUPageRedirectionTypeActiv: {
                QGActivityDetailViewController *jumpvc = [QGActivityDetailViewController new];
                jumpvc.activity_id = @(ad.redirectID).stringValue;
                vc = jumpvc;
                break;
            }
            case BLUPageRedirectionTypeOrg: {
                QGOrgViewController *jumpvc = [QGOrgViewController new];
                jumpvc.org_id = @(ad.redirectID).stringValue;
                vc = jumpvc;
                break;
            }
            case BLUPageRedirectionTypeTeacher: {
                QGTeacherViewController *jumpvc = [QGTeacherViewController new];
                jumpvc.teacher_id = @(ad.redirectID).stringValue;
                vc = jumpvc;
                break;
            }
            case BLUPageRedirectionTypeCourse: {
                QGCourseDetailViewController *jumpvc = [QGCourseDetailViewController new];
                jumpvc.course_id = @(ad.redirectID).stringValue;
                vc = jumpvc;
                break;
            }
            case BLUPageRedirectionTypeGoodCategory: {
                QGSearchResultViewController *jumpvc = [QGSearchResultViewController new];
                jumpvc.catogoryId = @(ad.redirectID).stringValue;
                jumpvc.searchOptionType = QGSearchOptionTypeGoods;
                vc = jumpvc;
                break;
            }
            case BLUPageRedirectionTypeOrgList: {
                QGSearchResultViewController *jumpvc = [QGSearchResultViewController new];
                jumpvc.searchOptionType = QGSearchOptionTypeInstitution;
                jumpvc.keyWord = @"";
                vc = jumpvc;
                break;
            }
            case BLUPageRedirectionTypeTercherList: {
                QGOrgAllTeacherViewController *jumpvc = [QGOrgAllTeacherViewController new];
                jumpvc.org_id = [@(ad.redirectID) stringValue];
                vc = jumpvc;
                break;
            }
            case BLUPageRedirectionTypeCourseList: {
                QGSearchResultViewController *jumpvc = [QGSearchResultViewController new];
                jumpvc.searchOptionType = QGSearchOptionTypeCourse;
                jumpvc.keyWord = @"";
                vc = jumpvc;
                break;
            }
            case BLUPageRedirectionTypeActivList: {
                QGActivityHomeViewController *jumpvc = [QGActivityHomeViewController new];
                vc = jumpvc;
                break;
            }
        }
        if (vc) {
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

- (void)shouldTransitWithPostTag:(BLUPostTag *)ptag fromView:(UIView *)view sender:(id)sender
{
    
    UIViewController *vc = nil;
    if (ptag  != nil)
    {
        vc = [[BLUPostTagDetailViewController alloc] initWithTagID:ptag.tagID];
    }
    else
    {
        vc = [[BLUPostTagDetailViewController alloc] initWithTagID:5];
     
    }
    if (vc)
    {
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void) shouldTransMoreTagFromView:(UIView *)view sender:(id)sender
{
    BLUHotTagViewController *vc = [[BLUHotTagViewController alloc] init];
    vc.title = @"全部热门话题";
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
