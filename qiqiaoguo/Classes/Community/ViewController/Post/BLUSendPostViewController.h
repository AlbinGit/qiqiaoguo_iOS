//
//  BLUPostViewController.h
//  Blue
//
//  Created by Bowen on 11/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

@class BLUSendPostViewController, BLUPost, BLUUserProfit;

@protocol BLUSendPostViewControllerProtocal <NSObject>

- (void)didSendPost:(BLUPost *)post fromSendPostViewController:(BLUSendPostViewController *)sendPostViewController;
- (void)shouldShowUserProfit:(BLUUserProfit *)userProfit fromSendPostViewController:(BLUSendPostViewController *)sendPostViewController;

@end

@interface BLUSendPostViewController : BLUViewController

@property (nonatomic, assign, readonly) NSInteger circleID;
@property (nonatomic, weak) id <BLUSendPostViewControllerProtocal> delegate;

- (instancetype)initWithCircle:(NSInteger)circleID;

@end
