//
//  BLUPasscodeLockEnableViewModel.h
//  Blue
//
//  Created by Bowen on 7/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPasscodeLockViewModel.h"

@class BLUPasscodeLockEnableViewModel;

@protocol BLUPasscodeLockEnableViewModelDelegate <NSObject>

- (void)shouldConfirmPasscode;
- (void)enablePasscodeLockSuccess;
- (void)shouldSetPasscodeAgain;

@end

@interface BLUPasscodeLockEnableViewModel : BLUPasscodeLockViewModel

@property (nonatomic, weak) id <BLUPasscodeLockEnableViewModelDelegate> delegate;

@end
