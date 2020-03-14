//
//  BLUChatViewController.h
//  Blue
//
//  Created by Bowen on 27/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUChatViewModel.h"

@interface BLUChatViewController : BLUViewController

- (instancetype)initWithUser:(BLUUser *)user;

// 客服通话初始化方法
- (instancetype)initWithUserID:(NSInteger)userID;

@property (nonatomic, strong) BLUChatViewModel *chatViewModel;

@property (nonatomic, strong) id headModel;

@end
