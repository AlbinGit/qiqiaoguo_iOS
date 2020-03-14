//
//  BLUSecurityCodeViewModel.h
//  Blue
//
//  Created by Bowen on 24/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"
#import "BLUApiManager+User.h"

UIKIT_EXTERN NSInteger BLUSecurityCodeTotalSendingSeconds;
UIKIT_EXTERN NSInteger BLUSecurityCodeSendingInterval;

UIKIT_EXTERN NSString *BLUSecurityCodePromptSending;
UIKIT_EXTERN NSString *BLUSecurityCodePromptWaiting;
UIKIT_EXTERN NSString *BLUSecurityCodePromptNormal;

@interface BLUSecurityCodeViewModel : BLUViewModel

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *password;

+ (instancetype)sharedViewModel;

- (RACCommand *)fetchForReg;
- (RACCommand *)fetchForResetPassword;
- (RACCommand *)fetchForBindMobile;
- (RACCommand *)send;
- (RACCommand *)resetPassword;
- (RACCommand *)bindMobile;

@end
