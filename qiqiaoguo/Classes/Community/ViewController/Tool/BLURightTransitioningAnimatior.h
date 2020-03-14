//
//  BLURightTransitioningAnimatior.h
//  Blue
//
//  Created by Bowen on 23/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUViewControllerTransitioning.h"

@interface BLURightTransitioningAnimatior : NSObject
<BLUViewControllerTransitioning>

@property (nonatomic, assign) CGRect rightFrame;

@end
