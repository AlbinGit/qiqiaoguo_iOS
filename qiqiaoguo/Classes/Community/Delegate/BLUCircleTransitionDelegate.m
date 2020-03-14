//
//  BLUCircleTransitionDelegate.m
//  Blue
//
//  Created by Bowen on 29/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircleTransitionDelegate.h"
#import "BLUCircle.h"
#import "BLUCircleDetailMainViewController.h"

@implementation BLUCircleTransitionDelegate

- (void)shouldTransitToCircle:(NSDictionary *)circleInfo fromView:(UIView *)view sender:(id)sender {
    BLUCircle *circle = circleInfo[BLUCircleKeyCircle];
    BLUCircleDetailMainViewController *vc = nil;
    
    if (circle) {
        vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:circle.circleID];
    }
    
    if (vc) {
        if (self.viewController) {
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
