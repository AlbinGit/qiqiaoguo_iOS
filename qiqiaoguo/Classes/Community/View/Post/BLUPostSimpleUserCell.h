//
//  BLUPostSimpleUserCell.h
//  Blue
//
//  Created by Bowen on 6/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCell.h"
#import "BLUUserTransitionProtocal.h"

@class BLUUser;

@interface BLUPostSimpleUserCell : BLUCell

@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) BLUGenderButton *genderButton;
@property (nonatomic, strong) UIButton *timeButton;

@property (nonatomic, strong) BLUUser *user;
@property (nonatomic, strong) NSString *time;

@property (nonatomic, weak) id <BLUUserTransitionDelegate> userTransitionDelegate;

- (void)setUser:(BLUUser *)user anonymous:(BOOL)anonymous;

@end
