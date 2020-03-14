//
//  BLUAlterUserViewModel.m
//  Blue
//
//  Created by Bowen on 27/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUAlterUserViewModel.h"
#import "BLUApiManager+User.h"

static const NSInteger kSignatureLength = 40;

@implementation BLUAlterUserViewModel

- (RACSignal *)_validateNickname {
    return [RACObserve(self, nickname) map:^id(NSString *nickname) {
        return @([nickname isNickname]);
    }];
}

- (RACSignal *)_validateSignature {
    return [RACObserve(self, signature) map:^id(NSString *signature) {
        return @(signature.length <= kSignatureLength);
    }];
}

- (RACSignal *)_validate {
    return [[RACSignal combineLatest:@[[self _validateNickname], [self _validateSignature]]] reduceEach:^id(NSNumber *isNickname, NSNumber *isSignature){
        return @(isNickname.boolValue && isSignature.boolValue);
    }];
}

- (RACSignal *)alter {
    return [[[BLUApiManager sharedManager] alterUserWithNicname:self.nickname signature:self.signature birthday:self.birthday marriage:self.marriage avatarImage:self.avatarImage] doNext:^(BLUUser *user) {
        BLUAppManager *manager = [BLUAppManager sharedManager];
        [manager setCurrentUser:user];
        BLULogDebug(@"user = %@", user);
    }];
}

- (RACSignal *)updateNickname{
    return [[[BLUApiManager sharedManager] updateUserNickname:self.nickname] doNext:^(id object) {
        [SAUserDefaults saveValue:@"1" forKey:USERINFONEEDUPDATE];
    }];
}

- (RACSignal *)updateHeadImage{
    return [[[BLUApiManager sharedManager] updateUserHeadimage:self.avatarImage] doNext:^(id object) {
        
    }];
}

@end
