//
//  BLUCircleDetailMainViewController.h
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class BLUCircle;

@interface BLUCircleDetailMainViewController : BLUViewController
<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *circleVCs;

@property (nonatomic, assign) NSInteger circleID;

@property (nonatomic, strong) UISegmentedControl *circleSegmentedControl;
@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) BLUCircle *circle;

- (instancetype)initWithCircleID:(NSInteger)circleID;

@end
