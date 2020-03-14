//
//  BLUMessageCategoryViewModel.h
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"
#import "BLUServerNoticationViewModel.h"

typedef NS_ENUM(NSInteger, BLUMessageCategoryViewModelState) {
    BLUMessageCategoryViewModelStateNormal = 0,
    BLUMessageCategoryViewModelStateFetching,
    BLUMessageCategoryViewModelStateFetchFailed,
    BLUMessageCategoryViewModelStateFetchAgain,
};

@class BLUMessageCategory;

@interface BLUMessageCategoryViewModel : BLUViewModel

@property (nonatomic, assign, readonly) BLUMessageCategoryViewModelState state;
@property (nonatomic, weak) id <BLUServerNotificationViewModelDelegate> delegate;
@property (nonatomic,strong) NSArray *MessageArray;

- (void)fetch;


@end
