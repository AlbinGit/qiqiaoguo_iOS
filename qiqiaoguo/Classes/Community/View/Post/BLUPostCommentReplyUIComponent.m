//
//  BLUPostCommentReplyUIComponent.m
//  Blue
//
//  Created by Bowen on 10/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommentReplyUIComponent.h"

@implementation BLUPostCommentReplyUIComponent

- (instancetype)init {
    if (self = [super init]) {
        _avatarButton = [BLUAvatarButton new];
        _avatarButton.backgroundColor = BLUThemeMainTintBackgroundColor;

        _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];

        _timeButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
        _timeButton.contentEdgeInsets = UIEdgeInsetsMake([BLUCurrentTheme topMargin], 0, 0, [BLUCurrentTheme rightMargin]);
        _timeButton.tintColor = BLUThemeSubTintContentForegroundColor;
        _timeButton.titleColor = BLUThemeSubTintContentForegroundColor;
        _timeButton.image = [BLUCurrentTheme postTimeIcon];

        _floorLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _floorLabel.numberOfLines = 1;

        _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];

        return self;
    }
    return nil;
}

- (void)addSuperView:(nonnull UIView *)view {
    [view addSubview:_avatarButton];
    [view addSubview:_nicknameLabel];
    [view addSubview:_timeButton];
    [view addSubview:_floorLabel];
    [view addSubview:_contentLabel];
}

@end
