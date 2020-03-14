//
//  BLUUserTransitionDelegate.m
//  Blue
//
//  Created by Bowen on 29/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUUserTransitionDelegate.h"
#import "BLUOtherUserViewController.h"

@implementation BLUUserTransitionDelegate

- (void)shouldTransitToUser:(NSDictionary *)userInfo fromView:(UIView *)view sender:(id)sender {
    BLUUser *user = userInfo[BLUUserKeyUser];
    NSNumber *userID = userInfo[BLUUserKeyUserID];
    BLUOtherUserViewController *vc = nil;
    
    if (user) {
        vc = [[BLUOtherUserViewController alloc] initWithUserID:user.userID];
    }
    
    if (userID) {
        vc = [[BLUOtherUserViewController alloc] initWithUserID:userID.integerValue];
    }
    
    if (vc) {
        if (self.viewController) {
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
