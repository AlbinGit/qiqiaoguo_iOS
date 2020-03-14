//
//  BLUSearchResultsViewControllerDelegate.h
//  Blue
//
//  Created by Bowen on 8/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUCircle, BLUCircleSearchResultsViewController;

@protocol BLUCircleSearchResultsViewControllerDelegate <NSObject>

- (void)circleSearchResultsViewControllerDidSelectCircle:(BLUCircle *)circle
                       circleSearchResultsViewController:(BLUCircleSearchResultsViewController *)circleSearchResultsViewController;

@end
