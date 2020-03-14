//
//  BLURegViewModel.m
//  Blue
//
//  Created by Bowen on 27/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLURegViewModel.h"
#import "BLUApiManager+User.h"
#import "BLUApService.h"

@implementation BLURegViewModel

- (RACCommand *)reg {
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:[self _validate] signalBlock:^RACSignal *(id input) {
        @strongify(self);
       return [[[[BLUApiManager sharedManager] regWithMobile:self.mobile password:self.password nickname:self.nickname gender:self.gender avatarImage:self.avatarImage] then:^RACSignal *{
           return [[BLUApiManager sharedManager] loginWithMobile:self.mobile password:self.password];
       }] doNext:^(BLUUser *user) {
           BLUAppManager *appManager = [BLUAppManager sharedManager];
           appManager.currentUser = user;
           [[BLUApService sharedService] uploadRegistrationID];
       }];
    }];
}

- (RACSignal *)_validate {
    return [[RACSignal combineLatest:@[[BLUUser validatePassword:RACObserve(self, password)], [BLUUser validateNickname:RACObserve(self, nickname)], [BLUUser validateMobile:RACObserve(self, mobile)]]] reduceEach:^id(NSNumber *isPassword, NSNumber *isNickname, NSNumber *isMobile){
        return @(isPassword.boolValue && isNickname.boolValue && isMobile.boolValue);
    }];
}

@end
