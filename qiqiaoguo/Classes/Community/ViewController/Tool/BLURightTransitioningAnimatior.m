//
//  BLURightTransitioningAnimatior.m
//  Blue
//
//  Created by Bowen on 23/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLURightTransitioningAnimatior.h"

@interface BLURightTransitioningAnimatior () {
    CGFloat _duration;
    BOOL _presenting;
    CGRect _fullScreenFrame;
}

@end

@implementation BLURightTransitioningAnimatior

- (instancetype)init {
    if (self = [super init]) {
        _duration = 0.2;
        _presenting = YES;
        _rightFrame = CGRectZero;
        _fullScreenFrame = CGRectZero;
    }
    return self;
}

- (CGFloat)duration {
    return _duration;
}

- (void)setDuration:(CGFloat)duration {
    BLUParameterAssert(duration >= 0);
    _duration = duration;
}

- (BOOL)presenting {
    return _presenting;
}

- (void)setPresenting:(BOOL)presenting {
    _presenting = presenting;
}

- (CGRect)fullScreenFrame {
    return _fullScreenFrame;
}

- (void)setFullScreenFrame:(CGRect)fullScreenFrame {
    _fullScreenFrame = fullScreenFrame;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *optionsView = _presenting ? toView : [transitionContext viewForKey:UITransitionContextFromViewKey];

    CGRect initialFrameForOptionView;
    CGRect finalFrameForOptionView;

    UIViewAnimationOptions animationOptions;

    if (_presenting) {
        initialFrameForOptionView = _rightFrame;
        finalFrameForOptionView = _fullScreenFrame;
        animationOptions = UIViewAnimationOptionCurveEaseInOut;
    } else {
        initialFrameForOptionView = _fullScreenFrame;
        finalFrameForOptionView = _rightFrame;
        animationOptions = UIViewAnimationOptionCurveEaseOut;
    }

    optionsView.frame = initialFrameForOptionView;

    if (_presenting) {
        fromView.frame = _fullScreenFrame;
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        [containerView bringSubviewToFront:toView];
    }

    [UIView animateWithDuration:_duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (_presenting) {
                             optionsView.frame = finalFrameForOptionView;
                         } else {
                             optionsView.alpha = 0.0;
                             optionsView.frame = finalFrameForOptionView;
                         }
                     } completion:^(BOOL finished) {

                         if (_presenting == NO) {
                             [optionsView removeFromSuperview];
                         }
                         
                         [transitionContext completeTransition:YES];
                     }];
}

@end
