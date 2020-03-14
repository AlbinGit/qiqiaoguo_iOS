//
//  BLUSecurityCodeViewModel.m
//  Blue
//
//  Created by Bowen on 24/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUSecurityCodeViewModel.h"
#import "BLUApiManager+User.h"

NSInteger BLUSecurityCodeTotalSendingSeconds = 60;
NSInteger BLUSecurityCodeSendingInterval = 1;

#define BLUSecurityCodePromptSending (NSLocalizedString(@"security-view-model.sending", @"Sending"))
#define BLUSecurityCodePromptWaiting (NSLocalizedString(@"security-view-model.resend", @"Resend"))
#define BLUSecurityCodePromptNormal (NSLocalizedString(@"security-view-model.get-security-code", @"Get security code"))

typedef NS_ENUM(NSInteger, PromptType) {
    PromptTypeNormal = 0,
    PromptTypeSending,
    PromptTypeResend,
};

@interface BLUSecurityCodeViewModel ()

@property (nonatomic, strong) NSTimer *repeatingTimer;
@property (nonatomic, assign) NSInteger leftSeconds;
@property (nonatomic, assign) BOOL isSending;

@end

@implementation BLUSecurityCodeViewModel

+ (instancetype)sharedViewModel {
    static BLUSecurityCodeViewModel *viewModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewModel = [BLUSecurityCodeViewModel new];
    });
    return viewModel;
}

- (instancetype)init {
    if (self = [super init]) {
        self.leftSeconds = 0;
        self.isSending = NO;
        @weakify(self);
        [RACObserve(self, leftSeconds) subscribeNext:^(id x) {
            @strongify(self);
            if (self.leftSeconds > 0) {
                self.isSending = NO;
                [self configPromptWithType:PromptTypeResend];
            } else {
                [self configPromptWithType:PromptTypeNormal];
            }
        }];
        
        [RACObserve(self, isSending) subscribeNext:^(NSNumber *isSending) {
            @strongify(self);
            if (isSending.boolValue) {
                [self configPromptWithType:PromptTypeSending];
            }
        }];
    }
    return self;
}

- (void)configPromptWithType:(PromptType)type {
    switch (type) {
        case PromptTypeNormal: {
            self.prompt = BLUSecurityCodePromptNormal;
        } break;
        case PromptTypeResend: {
            self.prompt = [NSString stringWithFormat:@"(%@) %@", @(self.leftSeconds), BLUSecurityCodePromptWaiting];
        } break;
        case PromptTypeSending: {
            self.prompt = BLUSecurityCodePromptSending;
        } break;
        default: {
            self.prompt = BLUSecurityCodePromptNormal;
        } break;
    }
}

- (RACCommand *)makeFetchCommandWithType:(BLUApiManagerUserSecurityCodeTypes)type {
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:[self _validateFetch] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.isSending = YES;
        return [[[[BLUApiManager sharedManager] getSecurityCodeWithMobile:self.mobile type:type] doError:^(NSError *error) {
            [self configPromptWithType:PromptTypeNormal];
        }] doCompleted:^{
            self.leftSeconds = BLUSecurityCodeTotalSendingSeconds;
            [self configPromptWithType:PromptTypeResend];
            [self startTimer];
        }];
    }];
}

- (RACCommand *)fetchForReg {
    return [self makeFetchCommandWithType:BLUApiManagerUserSecurityCodeTypeReg];
}

- (RACCommand *)fetchForResetPassword {
    return [self makeFetchCommandWithType:BLUApiManagerUserSecurityCodeTypeResetPassword];
}

- (RACCommand *)fetchForBindMobile {
    return [self makeFetchCommandWithType:BLUApiManagerUserSecurityCodeTypeBindMobile];
}

- (RACCommand *)send {
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:[self _validateSend] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[BLUApiManager sharedManager] validateSecurityCodeWithMobile:self.mobile code:self.code];
    }];
}

- (RACCommand *)resetPassword {
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:[self _validateResetPassword] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[BLUApiManager sharedManager] resetPassword:self.password mobile:self.mobile code:self.code];
    }];
}

- (RACCommand *)bindMobile {
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:[self _validateResetPassword] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[BLUApiManager sharedManager] bindMobile:self.mobile password:self.password code:self.code];
    }];
}

- (RACSignal *)_validateFetch {
    return [[RACSignal combineLatest:@[[self validateMobile], [self _validateInterval]]] reduceEach:^id(NSNumber *isMobile, NSNumber *rightInterval){
        return @(isMobile.boolValue && rightInterval.boolValue);
    }];
}

- (RACSignal *)_validateSend {
    return [[RACSignal combineLatest:@[[self validateMobile], [self _validateCode]]] reduceEach:^id(NSNumber *isMobile, NSNumber *isCode){
        return @(isMobile.boolValue && isCode.boolValue);
    }];
}

- (RACSignal *)_validateResetPassword {
    return [[RACSignal combineLatest:@[[self validateMobile], [self validatePassword], [self _validateCode]]] reduceEach:^id(NSNumber *isMobile, NSNumber *isPassword, NSNumber *isCode){
        return @(isMobile.boolValue && isPassword.boolValue && isCode.boolValue);
    }];
}

- (RACSignal *)validateMobile {
    return [BLUUser validateMobile:RACObserve(self, mobile)];
}

- (RACSignal *)validatePassword {
    return [BLUUser validatePassword:RACObserve(self, password)];
}

- (RACSignal *)_validateCode {
    return [RACObserve(self, code) map:^id(NSString *code) {
        return @(code.length == 6);
    }];
}

- (RACSignal *)_validateInterval {
    return [RACObserve(self, leftSeconds) map:^id(NSNumber *leftSeconds) {
        return @(leftSeconds.integerValue <= 0);
    }];
}

- (void)timerClicked:(NSTimer *)timer {
    NSInteger left = self.leftSeconds;
    
    left -= BLUSecurityCodeSendingInterval;
    
    if (left <= 0) {
        self.leftSeconds = 0;
        [self stopTimer];
    } else {
        self.leftSeconds = left;
    }
}

- (void)startTimer {
    [self stopTimer];
    self.leftSeconds = BLUSecurityCodeTotalSendingSeconds;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:BLUSecurityCodeSendingInterval target:self selector:@selector(timerClicked:) userInfo:nil repeats:YES];
    
    self.repeatingTimer = timer;
}

- (void)stopTimer {
    [self configPromptWithType:PromptTypeNormal];
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

@end
