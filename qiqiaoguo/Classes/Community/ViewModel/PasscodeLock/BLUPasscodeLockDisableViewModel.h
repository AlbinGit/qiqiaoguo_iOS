//
//  BLUPasscodeLockDisableViewModel.h
//  Blue
//
//  Created by Bowen on 7/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPasscodeLockViewModel.h"

@class BLUPasscodeLockDisableViewModel;

@protocol BLUPasscodeLockDisableViewModelDelegate <NSObject>

- (void)disableSuccess;
- (void)disableFailure;

@end

@interface BLUPasscodeLockDisableViewModel : BLUPasscodeLockViewModel

@property (nonatomic, weak) id <BLUPasscodeLockDisableViewModelDelegate> delegate;

@end
