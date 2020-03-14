//
//  BLUPostRecommendedOptCell.h
//  Blue
//
//  Created by Bowen on 6/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCell.h"
#import "BLUCircleActionProtocal.h"
#import "BLUCircleTransitionProtocal.h"
#import "BLUUserTransitionProtocal.h"

@class BLUPostCommonOptView;

@interface BLUPostRecommendedOptCell : BLUCell

@property (nonatomic, weak) id <BLUCircleActionDelegate> circleActionDelegate;
@property (nonatomic, weak) id <BLUCircleTransitionDelegate> circleTransitionDelegate;
@property (nonatomic, weak) id <BLUUserTransitionDelegate> userTransitionDelegate;

@end
