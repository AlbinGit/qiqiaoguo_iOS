//
//  BLUPasscodeLockDisableViewModel.m
//  Blue
//
//  Created by Bowen on 7/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPasscodeLockDisableViewModel.h"

@implementation BLUPasscodeLockDisableViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.enterPasscodeString = NSLocalizedString(@"passcode-lock.disable-view-model.enter-passcode", @"Enter passcode");
        self.failedString = @"";
        self.title = NSLocalizedString(@"passcode-lock.disable-view-model.title", @"Disable passcode");
        
        [[RACObserve(self, passcode) distinctUntilChanged] subscribeNext:^(NSString *passcode) {
            
            
            if (passcode.length == 4) {
                
                NSString *storedPasscode = [BLUKeyChainUtils getPasswordForUsername:BLUKeyChainUsername andServiceName:BLUKeyChainServiceName error:nil];
                
                if ([passcode isEqualToString:storedPasscode]) {
                    
                        NSError *error = nil;
                        if ([BLUKeyChainUtils deleteItemForUsername:BLUKeyChainUsername andServiceName:BLUKeyChainServiceName error:&error]) {
                            
                            if ([self.delegate respondsToSelector:@selector(disableSuccess)]) {
                                [self.delegate disableSuccess];
                            }
                            
                        } else {
                            
                            self.failedString = error.localizedDescription;
                            if ([self.delegate respondsToSelector:@selector(disableFailure)]) {
                                [self.delegate disableFailure];
                            }
                            
                        }
                } else {
                    
                    if ([self.delegate respondsToSelector:@selector(disableFailure)]) {
                        [self.delegate disableFailure];
                    }
                    
                }
            }
        }];
    }
    return self;
}

@end
