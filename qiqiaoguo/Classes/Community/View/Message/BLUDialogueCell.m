//
//  BLUDialogueCell.m
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUDialogueCell.h"
#import "BLUDialogueMO.h"

@implementation BLUDialogueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UIView *superview = self.contentView;
        superview.backgroundColor = BLUThemeMainTintBackgroundColor;

        _avatarButton = [BLUAvatarButton new];
        _avatarButton.backgroundColor = BLUThemeSubTintBackgroundColor;
        _avatarButton.userInteractionEnabled = NO;

//        _genderButton = [BLUGenderButton new];

        _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _nicknameLabel.numberOfLines = 1;

        _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _contentLabel.numberOfLines = 1;

        _timeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];

        _unreadLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall);
        _unreadLabel.textColor = [UIColor whiteColor];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;

        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;

        [superview addSubview:_avatarButton];
//        [superview addSubview:_genderButton];
        [superview addSubview:_nicknameLabel];
        [superview addSubview:_contentLabel];
        [superview addSubview:_timeLabel];
        [superview addSubview:_unreadLabel];
        [superview addSubview:_solidLine];

        return self;
    }

    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat avatarButtonWidth = 48.0f;

    self.avatarButton.frame = CGRectMake(BLUThemeMargin * 3, BLUThemeMargin * 3, avatarButtonWidth, avatarButtonWidth);
    self.avatarButton.cornerRadius = self.avatarButton.width / 2;

    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(self.contentView.width - BLUThemeMargin * 3 - self.timeLabel.width, 0, self.timeLabel.width, self.timeLabel.height);

    [self.unreadLabel sizeToFit];
    self.unreadLabel.width += BLUThemeMargin;
    self.unreadLabel.height += BLUThemeMargin;
    self.unreadLabel.width = (self.unreadLabel.width < self.unreadLabel.height ? self.unreadLabel.height : self.unreadLabel.width);
    self.unreadLabel.cornerRadius = self.unreadLabel.height / 2.0;

    [self.nicknameLabel sizeToFit];
    CGSize genderButtonSize = CGSizeMake(self.nicknameLabel.height - BLUThemeMargin * 2, self.nicknameLabel.height - BLUThemeMargin * 2);
    CGFloat nicknameLabelWidth = self.contentView.width - self.avatarButton.width - self.timeLabel.width - BLUThemeMargin * 12 - genderButtonSize.width;
    self.nicknameLabel.frame = CGRectMake(self.avatarButton.right + BLUThemeMargin * 2, 0, self.nicknameLabel.width < nicknameLabelWidth ? self.nicknameLabel.width : nicknameLabelWidth, self.nicknameLabel.height);

//    self.genderButton.x = self.nicknameLabel.right + BLUThemeMargin * 2;
//    self.genderButton.size = genderButtonSize;

    CGFloat contentLabelWidth = self.contentView.width - self.avatarButton.width - BLUThemeMargin * 8 - (self.showUnread ? self.unreadLabel.width + BLUThemeMargin * 2 : 0);
    CGSize contentLabelSize = [self.contentLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
    self.contentLabel.frame = CGRectMake(self.avatarButton.right + BLUThemeMargin * 2, 0, contentLabelWidth, contentLabelSize.height);

    self.solidLine.frame = CGRectMake(0, self.avatarButton.bottom + BLUThemeMargin * 3, self.contentView.width, BLUThemeOnePixelHeight);

    self.nicknameLabel.centerY = self.solidLine.bottom / 3;
    self.contentLabel.centerY = self.solidLine.bottom / 3 * 2;
    self.timeLabel.centerY = self.nicknameLabel.centerY;
    self.unreadLabel.centerY = self.contentLabel.centerY;
//    self.genderButton.y = self.nicknameLabel.bottom - BLUThemeMargin - genderButtonSize.height;

    self.cellSize = CGSizeMake(self.contentView.width, self.solidLine.bottom);

    if (!self.showUnread) {
        self.unreadLabel.frame = CGRectZero;
        self.timeLabel.centerY = self.avatarButton.centerY;
    } else {
        self.unreadLabel.x = self.contentView.width - BLUThemeMargin * 3 - self.unreadLabel.width;
        self.contentLabel.width = self.unreadLabel.left - self.avatarButton.right - BLUThemeMargin * 4;
    }

    if (!self.showSolidLine) {
        self.solidLine.frame = CGRectZero;
    }
}

- (void)setModel:(id)model showSolidLine:(BOOL)showSolidLine {
    NSParameterAssert([model isKindOfClass:[BLUDialogueMO class]]);

    self.dialogue = (BLUDialogueMO *)model;
    self.showSolidLine = showSolidLine;
    self.showUnread = self.dialogue.unreadCount.integerValue > 0;

    self.avatarButton.image = nil;
    if (!self.cellForCalcingSize) {
        self.avatarButton.user = self.dialogue.fromUser;
    }
    self.solidLine.hidden = !self.showSolidLine;

    _nicknameLabel.text = self.dialogue.fromUserNickname;
    _contentLabel.text = self.dialogue.lastMessage;
    _timeLabel.text = self.dialogue.lastTime.postTime;
//    _genderButton.gender = self.dialogue.fromUserGender.integerValue;

    if (self.showUnread) {
        _unreadLabel.hidden = NO;
        _unreadLabel.text = [NSString stringWithFormat:@"%@", self.dialogue.unreadCount];
    } else {
        _unreadLabel.hidden = YES;
    }
}

@end
