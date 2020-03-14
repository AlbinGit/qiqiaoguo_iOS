//
//  BLUBottomTransitioningController.m
//  Blue
//
//  Created by Bowen on 7/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUBottomTransitioningController.h"
#import "BLUBottomTransitioningAnimator.h"

@implementation BLUBottomTransitioningController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _animator = [BLUBottomTransitioningAnimator new];
    }
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
    self.animator.presenting = YES;

    CGRect mainScreenBounds = [UIScreen mainScreen].bounds;
    self.animator.bottomFrame =
    CGRectMake(0, CGRectGetHeight(mainScreenBounds),
               CGRectGetWidth(mainScreenBounds),
               CGRectGetHeight(mainScreenBounds));
    self.animator.fullScreenFrame = [UIScreen mainScreen].bounds;

    return self.animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animator.presenting = NO;
    return self.animator;
}

@end
