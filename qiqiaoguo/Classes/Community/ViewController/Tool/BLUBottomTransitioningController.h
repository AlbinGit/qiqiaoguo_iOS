//
//  BLUBottomTransitioningController.h
//  Blue
//
//  Created by Bowen on 7/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLUBottomTransitioningAnimator;

@interface BLUBottomTransitioningController : NSObject
<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) BLUBottomTransitioningAnimator *animator;

@end
