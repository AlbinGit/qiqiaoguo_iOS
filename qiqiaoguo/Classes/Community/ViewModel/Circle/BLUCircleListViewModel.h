//
//  BLUCircleListViewModel.h
//  Blue
//
//  Created by Bowen on 24/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUCircleListViewModelState) {
    BLUCircleListViewModelStateNormal = 0,
    BLUCircleListViewModelStateFetcing,
    BLUCircleListViewModelStateFailed,
    BLUCircleListViewModelStateAgain,
};

@interface BLUCircleListViewModel : BLUViewModel

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign, readonly) BLUCircleListViewModelState state;

- (instancetype)initWithFetchedResultsControllerDelegate:(id <NSFetchedResultsControllerDelegate>)delegate;

- (RACSignal *)fetch;
- (RACSignal *)fetchFollowedCircles;
- (RACSignal *)fetchRecommendedCircles;

@end
