//
//  BLUResetPasswordViewController.h
//  Blue
//
//  Created by Bowen on 6/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

typedef NS_ENUM(NSInteger, BLUUserMobileOperation) {
    BLUUserMobileOperationResetPassword = 0,
    BLUUserMobileOperationBindMobile,
};

@interface BLUResetPasswordViewController : BLUViewController

@property (nonatomic, assign) BLUUserMobileOperation userMobileOperation;

- (instancetype)initWithUserMobileOperation:(BLUUserMobileOperation)operation;

@end
