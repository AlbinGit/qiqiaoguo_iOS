//
//  BLUPostSimpleUserCell.m
//  Blue
//
//  Created by Bowen on 6/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostSimpleUserCell.h"

static const CGFloat kAvatarButtonHeight = 40.0;
static const CGFloat kGenderButtonHeight = 16.0;

@interface BLUPostSimpleUserCell ()

@property (nonatomic, assign) BOOL anonymous;

@end

@implementation BLUPostSimpleUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        UIView *superview = self.contentView;
        
        // Avatar button
        _avatarButton = [BLUAvatarButton new];
        _avatarButton.backgroundColor = BLUThemeSubTintBackgroundColor;
        [_avatarButton addTarget:self action:@selector(transitToUserAction:) forControlEvents:UIControlEventTouchUpInside];
        [superview addSubview:_avatarButton];
        
        // Nickname label
        _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _nicknameLabel.numberOfLines = 1;
        _nicknameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [superview addSubview:_nicknameLabel];
        
        // Gender button
        _genderButton = [BLUGenderButton new];
        _genderButton.genderButtonType = BLUGenderButtonTypeSmall;
        _genderButton.cornerRadius = 12.0 / 2.0;
        _genderButton.borderWidth = BLUThemeOnePixelHeight / 2.0;
        _genderButton.borderColor = [UIColor whiteColor];
        [superview addSubview:_genderButton];
        
        // Time button
        _timeButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
        _timeButton.contentEdgeInsets = UIEdgeInsetsMake([BLUCurrentTheme topMargin], 0, 0, [BLUCurrentTheme rightMargin]);
        _timeButton.tintColor = BLUThemeSubTintContentForegroundColor;
        _timeButton.titleColor = BLUThemeSubTintContentForegroundColor;
        _timeButton.image = [BLUCurrentTheme postTimeIcon];
        _timeButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall);
        [superview addSubview:_timeButton];

        _anonymous = NO;

    }
    return self;
}

- (void)setUser:(BLUUser *)user {
    _user = user;
    _avatarButton.image = nil;
    if (!self.cellForCalcingSize) _avatarButton.user = user;
    _nicknameLabel.text = user.nickname;
    _genderButton.gender = user.gender;
}

- (void)setUser:(BLUUser *)user anonymous:(BOOL)anonymous {
    _user = user;
    _avatarButton.image = nil;
    _genderButton.gender = user.gender;
    _anonymous = anonymous;

    _genderButton.hidden = anonymous ? YES : NO;

    if (!self.cellForCalcingSize) {
        [_avatarButton setUser:user anonymous:anonymous];
    }

    _nicknameLabel.text = anonymous ? [BLUUser anonymousNickname] : user.nickname;
}

- (void)setTime:(NSString *)time {
    _time = time;
    _timeButton.title = [NSString stringWithFormat:@" %@", time];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _avatarButton.frame = CGRectMake(BLUThemeMargin * 3, BLUThemeMargin * 3, kAvatarButtonHeight, kAvatarButtonHeight);
    _avatarButton.cornerRadius = _avatarButton.width / 2;
    
    [_nicknameLabel sizeToFit];
    
    CGFloat maxNicknameLaberWidth = self.contentView.width - _avatarButton.right - kGenderButtonHeight - BLUThemeMargin * 4;
    CGFloat nicknameLabelWidth = 0.0;
    
    if (_nicknameLabel.width > maxNicknameLaberWidth) {
        nicknameLabelWidth = maxNicknameLaberWidth;
    } else {
        nicknameLabelWidth = _nicknameLabel.width;
    }
    _nicknameLabel.frame = CGRectMake(_avatarButton.right + BLUThemeMargin, _avatarButton.top, nicknameLabelWidth, _nicknameLabel.height);

    _genderButton.frame = CGRectMake(_nicknameLabel.right + BLUThemeMargin, 0, kGenderButtonHeight, kGenderButtonHeight);
    _genderButton.centerY = _nicknameLabel.centerY;

    [_timeButton sizeToFit];
    CGFloat maxTimeButtonWidth = self.contentView.width - _nicknameLabel.left - BLUThemeMargin * 3;
    CGFloat timeButtonWidth = 0.0f;
    
    if (_timeButton.width < maxTimeButtonWidth) {
        timeButtonWidth = _timeButton.width;
    } else {
        timeButtonWidth = maxTimeButtonWidth;
    }
    _timeButton.frame = CGRectMake(_nicknameLabel.left, _avatarButton.bottom - _timeButton.height, timeButtonWidth, _timeButton.height);
    
    self.cellSize = CGSizeMake(self.contentView.width, _timeButton.bottom);
}

- (void)transitToUserAction:(id)sender {
    if (_anonymous) {
        return ;
    }
    if ([self.userTransitionDelegate respondsToSelector:@selector(shouldTransitToUser:fromView:sender:)]) {
        if (self.user) {
            NSDictionary *userInfo = @{BLUUserKeyUser: self.user};
            [self.userTransitionDelegate shouldTransitToUser:userInfo fromView:self sender:sender];
        }
    }
}

@end
