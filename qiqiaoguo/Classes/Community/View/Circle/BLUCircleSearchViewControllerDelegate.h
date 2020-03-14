//
//  BLUCircleSearchViewControllerDelegate.h
//  Blue
//
//  Created by Bowen on 8/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUCircleSearchViewController, BLUCircle;

@protocol BLUCircleSearchViewControllerDelegate <NSObject>

- (void)circleSearchViewControllerDidSelectCircle:(BLUCircle *)circle
                       circleSearchViewController:(BLUCircleSearchViewController *)circleSearchViewController;

@end
