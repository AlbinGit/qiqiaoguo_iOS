//
//  BLUUsersViewModel.h
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUUsersViewModelType) {
    BLUUsersViewModelTypeFollowing = 0,
    BLUUsersViewModelTypeFollower,
};

@interface BLUUsersViewModel : BLUViewModel

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) BLUUsersViewModelType type;
@property (nonatomic, strong, readonly) NSArray *users;
@property (nonatomic, weak) RACDisposable *fetchDiaposable;

- (RACSignal *)fetchNext;
- (RACSignal *)fetch;

@end
