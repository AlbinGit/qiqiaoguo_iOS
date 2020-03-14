//
//  BLUUserBarView.m
//  Blue
//
//  Created by Bowen on 13/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUUserBarView.h"

static const CGFloat kAvatarButtonHeight = 24.0;
static const CGFloat kStatusBarHeight = 20.0;

@interface BLUUserBarView ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UILabel *nicknameLabel;

@end

@implementation BLUUserBarView

- (instancetype)init {
    if (self = [super init]) {
        
        UIView *superview = self;
        
        superview.alpha = 0;
        
        // Container
        _container = [UIView new];
        [superview addSubview:_container];
        
        // Avatar button
        _avatarButton = [BLUAvatarButton new];
        _avatarButton.backgroundColor = [UIColor randomColor];
        [_container addSubview:_avatarButton];
        
        // Nickname label
        _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _nicknameLabel.textColor = [UIColor whiteColor];
        [_container addSubview:_nicknameLabel];
        
        self.clipsToBounds = YES;
        
        _currentOffset = 0;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self adjustView];
}

- (void)setBarColor:(UIColor *)barColor {
    _barColor = barColor;
    self.backgroundColor = barColor;
}

- (void)setUser:(BLUUser *)user {
    _user = user;
    _nicknameLabel.text = user.nickname;
    if (![BLUAppManager sharedManager].currentUser) {
        _avatarButton.image = [UIImage imageNamed:@"user-logout-icon"];
    } else {
        _avatarButton.user = user;
    }
}

- (void)adjustView {
    _avatarButton.frame = CGRectMake(0, 0, kAvatarButtonHeight, kAvatarButtonHeight);
    _avatarButton.cornerRadius = _avatarButton.width / 2;
    
    [_nicknameLabel sizeToFit];
    _nicknameLabel.left = _avatarButton.right + [BLUCurrentTheme leftMargin];
    _nicknameLabel.width = _nicknameLabel.width < self.width * 0.6 ? _nicknameLabel.width : self.width * 0.6;
    _nicknameLabel.centerY = _avatarButton.centerY;
    
    _container.frame = CGRectMake(0, 0, _nicknameLabel.right, _avatarButton.height);
    _container.centerX = self.centerX;
    
    CGFloat containerStartY = self.height;
    // BUG: iOS 7
    UIInterfaceOrientation orientation= [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        _container.centerY = kStatusBarHeight + (self.height - kStatusBarHeight) / 2;
    } else {
        if (IOS_VERSION_8_BELOW) {
            _container.centerY = kStatusBarHeight + (self.height - kStatusBarHeight) / 2;
        } else {
            _container.centerY = self.height / 2;
        }
    }
    
    CGFloat containerEndY = _container.y;
    CGFloat totalOffset = containerEndY - containerStartY;
    CGFloat offset = _progress * totalOffset;
    _container.y = containerStartY + offset;
}

- (void)setCurrentOffset:(CGFloat)currentOffset {
    _currentOffset = currentOffset;
    if (_totalOffset > 0 && _currentOffset > 0) {
        _progress = _currentOffset / _totalOffset;
        if (_progress >= 1) {
            _progress = 1;
        } else if (_progress <= 0) {
            _progress = 0;
        }
        self.alpha = _progress;
        [self adjustView];
    } else {
        _progress = 0;
        self.alpha = _progress;
        [self adjustView];
    }
}

@end
