//
//  BLUOtherUserViewController.h
//  Blue
//
//  Created by Bowen on 13/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

@interface BLUOtherUserViewController : BLUViewController

@property (nonatomic, copy) BLUUser *user;
@property (nonatomic, assign) NSInteger userID;

- (instancetype)initWithUserID:(NSInteger)userID;

@end
