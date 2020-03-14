//
//  BLUUserSimpleCell.h
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCell.h"

@interface BLUUserSimpleCell : BLUCell

@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *signatureLabel;
@property (nonatomic, strong) BLUSolidLine *separator;
@property (nonatomic, strong) BLUUser *user;
@property (nonatomic, strong) BLUGenderButton *genderButton;

@end
