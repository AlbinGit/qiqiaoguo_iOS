//
//  BLUPasscodeLockUnlockViewModel.m
//  Blue
//
//  Created by Bowen on 7/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPasscodeLockUnlockViewModel.h"

static NSString *const kLocalPasscode = @"1234";

@implementation BLUPasscodeLockUnlockViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.enterPasscodeString = NSLocalizedString(@"passcode-lock.unlock-view-model.enter-passcode", @"Enter passcode");
        self.failedString = nil;
        self.title = NSLocalizedString(@"passcode-lock.unlock-view-model.unlock", @"Unlock");
        
        [[RACObserve(self, passcode) distinctUntilChanged] subscribeNext:^(NSString *passcode) {
            if (passcode.length == 4) {
                
                NSString *storePasscode = [BLUKeyChainUtils getPasswordForUsername:BLUKeyChainUsername andServiceName:BLUKeyChainServiceName error:nil];
                
                if ([passcode isEqualToString:storePasscode]) {
                    if ([self.delegate respondsToSelector:@selector(validationSuccess)]) {
                        [self.delegate validationSuccess];
                    }
                } else {
                    if ([self.delegate respondsToSelector:@selector(validationFailure)]) {
                        [self.delegate validationFailure];
                    }
                }
            }
        }];
    }
    return self;
}

@end
