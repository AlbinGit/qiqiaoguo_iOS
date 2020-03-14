//
//  BLUDialogueCell.h
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCell.h"

@class BLUDialogueMO;

@interface BLUDialogueCell : BLUCell

@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *unreadLabel;
@property (nonatomic, strong) BLUGenderButton *genderButton;
@property (nonatomic, strong) BLUSolidLine *solidLine;

@property (nonatomic, assign) BOOL showSolidLine;
@property (nonatomic, assign) BOOL showUnread;

@property (nonatomic, strong) BLUDialogueMO *dialogue;

- (void)setModel:(id)model showSolidLine:(BOOL)showSolidLine;

@end
