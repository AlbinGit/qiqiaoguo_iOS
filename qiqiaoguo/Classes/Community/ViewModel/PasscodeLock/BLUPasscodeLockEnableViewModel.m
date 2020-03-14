//
//  BLUPasscodeLockEnableViewModel.m
//  Blue
//
//  Created by Bowen on 7/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPasscodeLockEnableViewModel.h"
#import "BLUKeyChainUtils.h"

typedef NS_ENUM(NSInteger, EnableState) {
    EnableStateSetPasscode = 0,
    EnableStateConfirmPasscode,
};

@interface BLUPasscodeLockEnableViewModel ()

@property (nonatomic, assign) EnableState state;

@property (nonatomic, strong) NSString *firstPasscode;
@property (nonatomic, strong) NSString *confirmedPasscode;

@end

@implementation BLUPasscodeLockEnableViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        _state = EnableStateSetPasscode;
        
        self.title = NSLocalizedString(@"passcode-lock.enable-view-model.title", @"Enable passcode");
        self.enterPasscodeString = NSLocalizedString(@"passcode-lock.enable-view-model.enter-passcode", @"Enter passcode");
        self.failedString = nil;
  
        @weakify(self);
        [[RACObserve(self, passcode) distinctUntilChanged] subscribeNext:^(NSString *passcode) {
            @strongify(self);
            
            switch (self.state) {
                case EnableStateSetPasscode: {
                    if (passcode.length == 4) {
                        
                        self.firstPasscode = passcode;
                        self.enterPasscodeString = NSLocalizedString(@"passcode-lock.enable-view-model.re-enter-passcode", @"Re-enter passcode");
                        self.failedString = nil;
                        self.state = EnableStateConfirmPasscode;
                        
                        if ([self.delegate respondsToSelector:@selector(shouldConfirmPasscode)]) {
                            [self.delegate shouldConfirmPasscode];
                        }
                    }
                } break;
                case EnableStateConfirmPasscode: {
                    if (passcode.length == 4) {
                        self.confirmedPasscode = passcode;
                        if ([self.confirmedPasscode isEqualToString:self.firstPasscode]) {
                            
                            NSError *error = nil;
                            if ([BLUKeyChainUtils storeUsername:BLUKeyChainUsername andPassword:passcode forServiceName:BLUKeyChainServiceName updateExisting:YES error:&error]) {
                                if ([self.delegate respondsToSelector:@selector(enablePasscodeLockSuccess)]) {
                                    [self.delegate enablePasscodeLockSuccess];
                                }
                            } else {
                                self.failedString = [error localizedDescription];
                                if ([self.delegate respondsToSelector:@selector(shouldSetPasscodeAgain)]) {
                                    [self.delegate shouldSetPasscodeAgain];
                                }
                            }
                            
                        } else {
                            self.enterPasscodeString = NSLocalizedString(@"passcode-lock.enable-view-model.enter-passcode", @"Enter passcode");
                            self.failedString = NSLocalizedString(@"passcode-lock.enable-view-model.try-again", @"Passcode did not match. Try again.");
                            self.firstPasscode = nil;
                            self.confirmedPasscode = nil;
                            self.state = EnableStateSetPasscode;
                            
                            if ([self.delegate respondsToSelector:@selector(shouldSetPasscodeAgain)]) {
                                [self.delegate shouldSetPasscodeAgain];
                            }
                        }
                    }
                } break;
            }
        }];
    }
    return self;
}

@end
