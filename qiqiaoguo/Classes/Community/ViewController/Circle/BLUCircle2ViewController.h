//
//  BLUCircle2ViewController.h
//  Blue
//
//  Created by Bowen on 13/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class BLUCircleActionDelegate;
@class BLUAdTransitionDelegate;
@class BLUCircleAdViewModel;
@class BLUCircleListViewModel;

@interface BLUCircle2ViewController : BLUViewController

@property (nonatomic, strong) BLUCircleListViewModel *circleListViewModel;
@property (nonatomic, strong) BLUCircleActionDelegate *circleAction;

@end
