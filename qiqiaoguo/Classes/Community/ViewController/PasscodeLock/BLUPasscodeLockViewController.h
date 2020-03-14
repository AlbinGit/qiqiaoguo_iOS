//
//  BLUPasscodeLockViewController.h
//  Blue
//
//  Created by Bowen on 6/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLUPasscodeLockType) {
    BLUPasscodeLockTypeUnlock = 0,
    BLUPasscodeLockTypeEnable,
    BLUPasscodeLockTypeChangePasscode,
    BLUPasscodeLockTypeDisablePasscode,
    BLUPasscodeLockTypeDeletePasscode,
};

@interface BLUPasscodeLockViewController : UIViewController

+ (BLUPasscodeLockViewController *)passcodeLockViewControllerWithType:(BLUPasscodeLockType)type;

- (instancetype)initWithPasscodeLockType:(BLUPasscodeLockType)type;

@end
