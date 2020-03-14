//
//  BLUAppManager.h
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"

UIKIT_EXTERN NSString *BLUAppManagerUserLoginRequiredNotification;

@class BLUUser;

@interface BLUAppManager : BLUObject

@property (nonatomic, copy) BLUUser *currentUser;

+ (instancetype)sharedManager;

- (BOOL)didUserLogin;

- (void)logOut;

- (RACSignal *)updateCurrentUser;

@end
