//
//  BLUPasscodeLockUnlockViewModel.h
//  Blue
//
//  Created by Bowen on 7/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPasscodeLockViewModel.h"

@class BLUPasscodeLockUnlockViewModel;

@protocol BLUPasscodeLockUnlockViewModelDelegate <NSObject>

- (void)validationSuccess;
- (void)validationFailure;

@end

@interface BLUPasscodeLockUnlockViewModel : BLUPasscodeLockViewModel

@property (nonatomic, weak) id <BLUPasscodeLockUnlockViewModelDelegate> delegate;

@end
