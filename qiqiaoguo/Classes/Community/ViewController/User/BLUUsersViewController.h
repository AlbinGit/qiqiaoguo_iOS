//
//  BLUUsersViewController.h
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class BLUUsersViewModel;

@interface BLUUsersViewController : BLUViewController

@property (nonatomic, strong) BLUUsersViewModel *usersViewModel;

- (instancetype)initWithUsersViewModel:(BLUUsersViewModel *)usersViewModel;

@end
