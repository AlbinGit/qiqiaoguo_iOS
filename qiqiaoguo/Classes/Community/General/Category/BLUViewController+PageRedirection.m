//
//  BLUViewController+PageRedirect.m
//  Blue
//
//  Created by Bowen on 12/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUViewController+PageRedirection.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUWebViewController.h"
#import "BLUPostTagDetailViewController.h"
#import "BLUPageRedirection.h"

@implementation BLUViewController (PageRedirection)

- (void)redirectWithPageRedirection:(id<BLUPageRedirection>)redirection {
    if (redirection &&
        [self isKindOfClass:[BLUViewController class]] &&
        self.navigationController) {
        UIViewController *vc = nil;
        switch (redirection.redirectType) {
            case BLUPageRedirectionTypePost: {
                vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:redirection.redirectID];
            } break;
            case BLUPageRedirectionTypeCircle: {
                vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:redirection.redirectID];
            } break;
            case BLUPageRedirectionTypeWeb: {
                vc = [[BLUWebViewController alloc] initWithPageURL:redirection.redirectURL];
                vc.title = redirection.redirectTitle;
            } break;
            case BLUPageRedirectionTypeTag: {
                vc = [[BLUPostTagDetailViewController alloc] initWithTagID:redirection.redirectID];
            } break;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
