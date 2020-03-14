//
//  BLUPostLikedUserCell.h
//  Blue
//
//  Created by Bowen on 4/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUCell.h"

@interface BLUPostLikedUserCell : BLUCell

@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *signatureLabel;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, assign) CGFloat cellInset;
@property (nonatomic, assign) CGFloat contentMargin;
@property (nonatomic, assign) CGFloat avatarSize;

@property (nonatomic, strong) BLUUser *user;

@end
