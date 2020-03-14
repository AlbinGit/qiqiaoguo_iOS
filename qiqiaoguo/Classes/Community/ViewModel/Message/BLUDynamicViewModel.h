//
//  BLUDynamicViewModel.h
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUDynamicViewModelState) {
    BLUDynamicViewModelStateNormal = 0,
    BLUDynamicViewModelStateFetching,
    BLUDynamicViewModelStateFetchFailed,
    BLUDynamicViewModelStateFetchAgain,
};
@class BLUDynamicViewModel;
@protocol BLUDynamicViewModelDelegate <NSObject>

- (void)viewModelDidFetchNextComplete:(BLUDynamicViewModel *)viewModel;
- (void)shouldDiableFetchNextFromViewModel:(BLUDynamicViewModel *)viewModel;
- (void)viewModelDidFetchNextFailed:(BLUDynamicViewModel *)viewModel error:(NSError *)error;

@end

@interface BLUDynamicViewModel : BLUViewModel

@property (nonatomic, assign, readonly) BLUDynamicViewModelState state;
@property (nonatomic ,weak) id<BLUDynamicViewModelDelegate>delegate;
@property (nonatomic, strong) NSMutableArray * DynamicArray;

- (void)fetch;
- (void)fetchNext;

@end
