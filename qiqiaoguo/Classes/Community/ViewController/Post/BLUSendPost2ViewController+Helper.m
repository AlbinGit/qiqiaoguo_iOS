//
//  BLUSendPost2ViewController+Helper.m
//  Blue
//
//  Created by Bowen on 8/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUSendPost2ViewController+Helper.h"
#import "BLUPostTagContainer.h"
#import "BLUSendPost2Toolbar.h"
#import "BLUCircleSearchViewController.h"
#import "BLUCircle.h"
#import "BLUSendPost2CircleSelector.h"
#import "BLUSendPost2ViewModel.h"

@implementation BLUSendPost2ViewController (Helper)

- (void)postTagSelectionViewControllerDidSelectTags:(NSArray *)tags
                     postTagSelectionViewController:(BLUPostTagSelectionViewController *)postTagSelectionViewController {
    self.tags = tags;
}

- (void)selectorDidTapIndicator:(id)indicator
                       selector:(BLUSendPost2CircleSelector *)selector {
    BLUCircleSearchViewController *vc = [[BLUCircleSearchViewController alloc] init];
    vc.delegate = self;
    [self pushViewController:vc];
}

- (void)circleSearchViewControllerDidSelectCircle:(BLUCircle *)circle
                       circleSearchViewController:(BLUCircleSearchViewController *)circleSearchViewController {
    self.circle = circle;
}

- (void)containerNeedResize:(BLUPostTagContainer *)container {
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutTagContainer];
        [self layoutContentTextView];
    }];
}

@end
