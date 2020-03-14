//
//  BLUTransitioningAnimator.h
//  Blue
//
//  Created by Bowen on 7/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol BLUViewControllerTransitioning <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) CGRect fullScreenFrame;

@end