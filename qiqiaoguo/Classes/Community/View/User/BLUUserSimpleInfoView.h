//
//  BLUUserSimpleInfoView.h
//  Blue
//
//  Created by Bowen on 12/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUUserSimpleInfoView : UIView

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UIView *avatarBackgroundView;
@property (nonatomic, strong) BLUUser *user;

+ (CGFloat)userSimpleInfoViewHeight;

@end
