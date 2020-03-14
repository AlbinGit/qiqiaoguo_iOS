//
//  BLURightTransitioningController.m
//  Blue
//
//  Created by Bowen on 23/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLURightTransitioningController.h"
#import "BLURightTransitioningAnimatior.h"

@implementation BLURightTransitioningController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _animator = [BLURightTransitioningAnimatior new];
    }
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
    self.animator.presenting = YES;
    return self.animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animator.presenting = NO;
    return self.animator;
}

@end
