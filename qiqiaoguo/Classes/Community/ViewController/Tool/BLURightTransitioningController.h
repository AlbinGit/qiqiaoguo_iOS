//
//  BLURightTransitioningController.h
//  Blue
//
//  Created by Bowen on 23/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLURightTransitioningAnimatior;

@interface BLURightTransitioningController : NSObject
<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) BLURightTransitioningAnimatior *animator;

@end
