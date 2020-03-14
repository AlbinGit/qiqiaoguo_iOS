//
//  BLUPostCommonOptCell.h
//  Blue
//
//  Created by Bowen on 1/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCell.h"
#import "BLUUserTransitionProtocal.h"

@class BLUPostCommonOptView;

@interface BLUPostCommonOptCell : BLUCell

@property (nonatomic, assign) BOOL showThickLine;
@property (nonatomic, weak) id <BLUUserTransitionDelegate> userTransitionDelegate;

@end
