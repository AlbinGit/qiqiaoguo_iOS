//
//  BLUMessageCell.h
//  Blue
//
//  Created by Bowen on 14/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCell.h"
#import "BLUUserTransitionProtocal.h"

@interface BLUDynamicCell : BLUCell

@property (nonatomic, weak) id <BLUUserTransitionDelegate> userTransitionDelegate;

@end
