//
//  BLUServerNoticationViewModel.h
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUServerNotificationViewModelState) {
    BLUServerNotificationViewModelStateNormal = 0,
    BLUServerNotificationViewModelStateFetching,
    BLUServerNotificationViewModelStateFetchFailed,
    BLUServerNotificationViewModelStateFetchAgain,
};

@class BLUServerNoticationViewModel;

@protocol BLUServerNotificationViewModelDelegate <NSObject>

- (void)shouldDiableFetchNextFromViewModel:(id)viewModel;
- (void)viewModelDidFetchNextComplete:(id)viewModel;
- (void)viewModelDidFetchNextFailed:(id)viewModel error:(NSError *)error;

@end

@interface BLUServerNoticationViewModel : BLUViewModel

@property (nonatomic, assign, readonly) BLUServerNotificationViewModelState state;
@property (nonatomic, weak) id <BLUServerNotificationViewModelDelegate> delegate;
@property (nonatomic, strong)NSMutableArray *ServerNoticationArray;

- (void)fetch;
- (void)fetchNext;


@end
