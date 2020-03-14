//
//  BLUPasscodeLockViewModel.h
//  Blue
//
//  Created by Bowen on 7/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"
#import "BLUKeyChainUtils.h"

@interface BLUPasscodeLockViewModel : BLUViewModel

@property (nonatomic, strong) NSString *passcode;

@property (nonatomic, strong) NSString *enterPasscodeString;
@property (nonatomic, strong) NSString *failedString;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) BLUKeyChainUtils *keyChainUtils;

@end

