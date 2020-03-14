//
//  BLUCircleAdViewModel.h
//  Blue
//
//  Created by Bowen on 24/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

@class BLUCircleAdViewModel;

@protocol BLUCircleAdViewModelDelegate <NSObject>

- (void)shouldRefreshAds:(NSArray *)ads fromViewModel:(BLUCircleAdViewModel *)circleAdViewModel;
- (void)shouldHandleFetchError:(NSError *)error fromViewModel:(BLUCircleAdViewModel *)circleAdViewModel;

@end

@interface BLUCircleAdViewModel : BLUViewModel

@property (nonatomic, strong, readonly) NSArray *ads;
@property (nonatomic, weak) id <BLUCircleAdViewModelDelegate> delegate;

- (RACSignal *)fetch;

@end
