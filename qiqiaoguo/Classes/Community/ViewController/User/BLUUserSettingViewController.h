//
//  BLUUserSettingViewController.h
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

@interface BLUUserSettingViewController : BLUViewController

@property (nonatomic, strong) BLUUser *user;

- (instancetype)initWithUser:(BLUUser *)user;

@end
