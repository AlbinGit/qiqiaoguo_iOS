//
//  BLUViewControllerRedirectController.m
//  Blue
//
//  Created by Bowen on 30/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewControllerRedirectController.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUWebViewController.h"
#import "BLUPost.h"
#import "BLUCircle.h"

@implementation BLUViewControllerRedirectController

- (void)shouldRedirectToPost:(BLUPost *)post fromView:(UIView *)view sender:(id)sender {
    NSParameterAssert([post isKindOfClass:[BLUPost class]]);
    [self shouldRedirectToPostWithPostID:post.postID fromView:view sender:sender];
}

- (void)shouldRedirectToPostWithPostID:(NSInteger)postID fromView:(UIView *)view sender:(id)sender {
    NSParameterAssert(postID > 0);
    BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:postID];
    [self navToVC:vc];
}

- (void)shouldRedirectToCircle:(BLUCircle *)circle fromView:(UIView *)view sender:(id)sender {
    NSParameterAssert([circle isKindOfClass:[BLUCircle class]]);
    [self shouldRedirectToCircleWithCircleID:circle.circleID fromView:view sender:sender];
}
- (void)shouldRedirectToCircleWithCircleID:(NSInteger)circleID fromView:(UIView *)view sender:(id)sender {
    NSParameterAssert(circleID > 0);
    BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:circleID];
    [self navToVC:vc];
}

- (void)shouldRedirectToWebWithURL:(NSURL *)url fromView:(UIView *)view sender:(id)sender {
    NSParameterAssert([url isKindOfClass:[NSURL class]]);
    BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:url];
    [self navToVC:vc];
}

- (void)shouldRedirectToWebWithURL:(NSURL *)url title:(NSString *)title fromView:(UIView *)view sender:(id)sender {
    NSParameterAssert([url isKindOfClass:[NSURL class]]);
    BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:url];
    vc.title = title;
    [self navToVC:vc];
}

- (BOOL)canNavigate {
    if (self.fromViewController.navigationController) {
        return YES;
    } else {
        return NO;
    }
}

- (void)navToVC:(BLUViewController *)vc {
    if ([self canNavigate]) {
        [self.fromViewController pushViewController:vc];
    }
}

@end
