//
//  BLUCircleDetailViewController.h
//  Blue
//
//  Created by Bowen on 8/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

@class BLUCircle;

@interface BLUCircleDetailViewController : BLUViewController

@property (nonatomic, copy) BLUCircle *circle;
@property (nonatomic, assign) NSInteger circleID;

- (instancetype)initWithCircle:(BLUCircle *)circle;
- (instancetype)initWithCircleID:(NSInteger)circleID;

@end
