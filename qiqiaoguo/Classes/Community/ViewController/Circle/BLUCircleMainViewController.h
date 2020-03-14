//
//  BLUCircle2ViewController.h
//  Blue
//
//  Created by Bowen on 27/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@interface BLUCircleMainViewController : BLUViewController
<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *circleVCs;
@property (nonatomic, strong) UISegmentedControl *circleSegmentedControl;
@property (nonatomic, assign) NSInteger currentPageIndex;


@end
