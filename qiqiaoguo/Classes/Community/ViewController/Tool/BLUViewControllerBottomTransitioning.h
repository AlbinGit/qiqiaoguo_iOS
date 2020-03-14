//
//  BLUBottomTransitioningAnimator.h
//  Blue
//
//  Created by Bowen on 7/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BLUViewControllerTransitioning.h"

@protocol BLUViewControllerBottomTransitioning <BLUViewControllerTransitioning>

@property (nonatomic, assign) CGRect bottomFrame;

@end
