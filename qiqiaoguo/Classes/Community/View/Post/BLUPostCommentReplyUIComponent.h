//
//  BLUPostCommentReplyUIComponent.h
//  Blue
//
//  Created by Bowen on 10/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUPostCommentReplyUIComponent : NSObject

@property (nonnull, nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonnull, nonatomic, strong) UILabel *nicknameLabel;
@property (nonnull, nonatomic, strong) UILabel *floorLabel;
@property (nonnull, nonatomic, strong) UILabel *contentLabel;
@property (nonnull, nonatomic, strong) UIButton *timeButton;

- (void)addSuperView:(nonnull UIView *)view;

@end
