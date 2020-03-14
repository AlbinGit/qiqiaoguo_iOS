//
//  BLUPurpleTheme.m
//  Blue
//
//  Created by Bowen on 14/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "_BLUPurpleTheme.h"
#import "BLUPersonalViewController.h"
#import "BLUOtherUserViewController.h"

@implementation _BLUPurpleTheme

#pragma mark - App apperance

- (void)customizeAppAppearance {
    
    // Theme
    id <BLUUITheme> theme = [BLUThemeManager sharedTheme];
    
    // Bar tint color
    UINavigationBar *navigationBarAppearnce = [UINavigationBar appearance];
    navigationBarAppearnce.opaque = YES;
    navigationBarAppearnce.translucent = NO;
    [navigationBarAppearnce setBarTintColor:theme.NavColor];
    
    // Tint color
    [navigationBarAppearnce setTintColor:theme.subColor];
    
    [navigationBarAppearnce setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearnce setShadowImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"e1e1e1"]]];
}

#pragma mark - Corner radius

- (CGFloat)lowActivityCornerRadius {
    return 2.0;
}

- (CGFloat)normalActivityCornerRadius {
    return 4.0;
}

- (CGFloat)highActivityCornerRadius {
    return 8.0;
}

#pragma mark - Anime duration

- (CGFloat)shortAnimeDuration {
    return 0.1;
}

- (CGFloat)normalAnimeDuration {
    return 0.2;
}

- (CGFloat)longAnimeDuration {
    return 0.4;
}

#pragma mark - Margin

- (CGFloat)topMargin {
    return 4.0;
}

- (CGFloat)leftMargin {
    return 4.0;
}

- (CGFloat)rightMargin {
    return 4.0;
}

- (CGFloat)bottomMargin {
    return 4.0;
}

- (CGFloat)margin {
    return 4.0;
}

#pragma mark - Color

- (UIColor *)mainColor {
//    return [UIColor colorWithRed:0.60 green:0.05 blue:0.71 alpha:1];
//    return [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1];
    return RGB(255, 54, 89);
//    return [UIColor whiteColor];
//    return [UIColor colorFromHexString:@"e62f17"];
}

- (UIColor *)NavColor
{
    return [UIColor whiteColor];
}

- (UIColor *)subColor {
//    return [UIColor whiteColor];
    return [UIColor colorFromHexString:@"333333"];
}

- (UIColor *)mainTintBackgroundColor {
    return [UIColor whiteColor];
}

- (UIColor *)subTintBackgroundColor {
    return [UIColor colorFromHexString:@"ececec"];
}

- (UIColor *)mainDeepBackgroundColor {
    return [UIColor blackColor];
}

- (UIColor *)baseTintColor {
    return [self mainColor];
}

- (UIColor *)mainDeepContentForegroundColor {
    // Black
    return [UIColor colorFromHexString:@"343434"];
}

- (UIColor *)subDeepContentForegroundColor {
    // Deep gray
    return [UIColor colorFromHexString:@"666666"];
}

- (UIColor *)mainTintContentForegroundColor {
    return [UIColor whiteColor];
}

- (UIColor *)subTintContentForegroundColor {
    // Tint gray
    return [UIColor colorFromHexString:@"8e8e8e"];
}

- (UIColor *)mainInteractionForegroundColor {
    return [self mainColor];
}

- (UIColor *)mainContentInteractionForegroundColor {
    // Very tint gray
    return [UIColor colorFromHexString:@"ececec"];
}

#pragma mark - Font

- (CGFloat)_fontSizeWithType:(BLUUIThemeFontSizeType)type {
    CGFloat size = 0;
    switch (type) {
        case BLUUIThemeFontSizeTypeVeryLarge: {
            size = 24.0;
        } break;
        case BLUUIThemeFontSizeTypeLarge: {
            size = 16.0;
        } break;
        case BLUUIThemeFontSizeTypeNormal: {
            size = 14.0;
        } break;
        case BLUUIThemeFontSizeTypeSmall: {
            size = 12.0;
        } break;
        case BLUUIThemeFontSizeTypeVerySmall: {
            size = 10.0;
        } break;
        default: {
            size = 15.0;
        } break;
    }
    return size;
}

- (UIFont *)boldFontWithSize:(CGFloat)size {
    return [UIFont boldSystemFontOfSize:size];
}

- (UIFont *)boldFontWithFontSizeType:(BLUUIThemeFontSizeType)fontSizeType {
    return [UIFont boldSystemFontOfSize:[self _fontSizeWithType:fontSizeType]];
}

- (UIFont *)mainFontWithSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}

- (UIFont *)mainFontWithFontSizeType:(BLUUIThemeFontSizeType)fontSizeType {
    return [UIFont systemFontOfSize:[self _fontSizeWithType:fontSizeType]];
}

- (UIFont *)titleFontWithFontSizeType:(BLUUIThemeFontSizeType)fontSizeType {
    return [UIFont fontWithName:@"Heiti SC" size:[self _fontSizeWithType:fontSizeType]];
}

#pragma mark - Image

// Nav
- (UIImage *)navBackIndicatorImage {
    return [UIImage imageNamed:@"icon_classification_back"];
}

- (UIImage *)navBackIndicatorTransitionMaskImage {
    return [UIImage imageNamed:@"backIndicatorMask"];
}

- (UIImage *)timeIcon {
    return [UIImage imageNamed:@"post-detail-comment-user-info-time"];
}

- (UIImage *)moreIcon {
    return [UIImage imageNamed:@"common-more-icon"];
}

- (UIImage *)qqIcon {
    return [UIImage imageNamed:@"common-qq-icon"];
}

- (UIImage *)wechatIcon {
    return [UIImage imageNamed:@"common-wechat-icon"];
}

- (UIImage *)sinaIcon {
    return [UIImage imageNamed:@"common-sina-icon"];
}

- (UIImage *)shareIcon {
    return [UIImage imageNamed:@"common-share-icon"];
}

- (UIImage *)appLogo {
    return [UIImage imageNamed:@"common-app-logo"];
}

// User

- (UIImage *)genderMaleImage {
    return [UIImage imageNamed:@"user-male-icon"];
}

- (UIImage *)genderFemaleImage {
    return [UIImage imageNamed:@"user-female-icon"];
}

- (UIImage *)anonymousAvatar {
    return [UIImage imageNamed:@"user-anonymous-avatar"];
}

- (UIImage *)userFemaleAvatarIcon {
    return [UIImage imageNamed:@"user-female-avatar-icon"];
}

- (UIImage *)userMaleAvatarIcon {
    return [UIImage imageNamed:@"user-male-avatar-icon"];
}

- (UIImage *)userAvatarWhiteShadow {
    return [UIImage imageNamed:@"user-avatar-whiteshadow"];
}

- (UIImage *)userMaleRoundRect {
    return [UIImage imageNamed:@"user-male-icon"];
}

- (UIImage *)userFemaleRoundRect {
    return [UIImage imageNamed:@"user-female-icon"];
}

- (UIImage *)closedEyeIcon {
    return [[UIImage imageNamed:@"user-closed-eye-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)openedEyeIcon {
    return [[UIImage imageNamed:@"user-opened-eye-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)userGenderSelectedIcon {
    return [UIImage imageNamed:@"user-gender-selected-icon"];
}

- (UIImage *)userGenderDeselectedIcon {
    return [UIImage imageNamed:@"user-gender-deselected-icon"];
}

- (UIImage *)userSettingIndicatorIcon {
    return [UIImage imageNamed:@"user-setting-indicator-icon"];
}

- (UIImage *)userPostIcon {
    return [UIImage imageNamed:@"user-my-post-icon"];
}

- (UIImage *)userJoinIcon {
    return [UIImage imageNamed:@"user-my-joined-icon"];
}

- (UIImage *)userCollectionIcon {
    return [UIImage imageNamed:@"user-my-collectoin-icon"];
}

- (UIImage *)userSettingIcon {
    return [UIImage imageNamed:@"user-setting-icon"];
}

// Post
- (UIImage *)postCommentIcon {
    return [UIImage imageNamed:@"post-comment-icon"];
}

- (UIImage *)postTimeIcon {
    return [UIImage imageNamed:@"post-time-icon"];
}

- (UIImage *)postLikeIcon {
    return [UIImage imageNamed:@"post-like-icon"];
}

- (UIImage *)postDislikeIcon {
    return [UIImage imageNamed:@"post-dislike-icon"];
}

- (UIImage *)postDeleteIcon {
    return [UIImage imageNamed:@"post-delete-icon"];
}

- (UIImage *)postLikeNormalIcon {
    return [UIImage imageNamed:@"post-like-normal"];
}

- (UIImage *)postDislikeNormalIcon {
    return [UIImage imageNamed:@"post-dislike-nromal-icon"];
}

- (UIImage *)postSelectedImageIcon {
    return [UIImage imageNamed:@"post-selected-image-icon"];
}

- (UIImage *)postDeselectedCircle {
    return [UIImage imageNamed:@"post-deselected-circle"];
}

- (UIImage *)postDeselectedImageIcon {
    return [UIImage imageNamed:@"post-deselected-image-icon"];
}

- (UIImage *)postEmbossingLineIcon {
    UIImage *image = [UIImage imageNamed:@"post-embossing-line-icon"];
    return image;
}

- (UIImage *)postLeftShadeIcon {
    return [UIImage imageNamed:@"post-left-shade-icon"];
}

- (UIImage *)postRightShadeIcon {
    return [UIImage imageNamed:@"post-right-shade-icon"];
}

- (UIImage *)postFeatureIcon {
    return [UIImage imageNamed:@"post-feature-icon"];
}

- (UIImage *)postJustLooikngFirstfloorIcon {
    return [UIImage imageNamed:@"post-show-firstfloor"];
}

- (UIImage *)postViewAllIcon {
    return [UIImage imageNamed:@"post-show-allpost"];
}

- (UIImage *)postTakePhotoIcon {
    return [UIImage imageNamed:@"post-take-photo-icon"];
}

- (UIImage *)postAddImageIcon {
    return [UIImage imageNamed:@"post-add-image"];
}

- (UIImage *)sendPostIcon {
    return [UIImage imageNamed:@"post-send-post-icon"];
}

- (UIImage *)postLZ {
    return [UIImage imageNamed:@"post-lz"];
}

- (UIImage *)postTop {
    return [UIImage imageNamed:@"post-top"];
}

- (UIImage *)postPlayVideo {
    return [UIImage imageNamed:@"post-play-video"];
}

- (UIImage *)postPlayVideoSubscript {
    return [UIImage imageNamed:@"post-play-video-subscript"];
}

- (UIImage *)postNoCollection {
    return [UIImage imageNamed:@"post-no-collection"];
}
- (UIImage *)postNoParticipated {
    return [UIImage imageNamed:@"post-no-participated-watermark"];
}
- (UIImage *)postNoPost {
    return [UIImage imageNamed:@"post-no-posts"];
}

// Circle
- (UIImage *)circleAddPurpleIcon {
    return [UIImage imageNamed:@"circle_add_purple_icon"];
}

- (UIImage *)circlePostCountIcon {
    return [UIImage imageNamed:@"circle_post_count_icon"];
}

// Tab
- (UIImage *)tabCircleNormalIcon {
    return [UIImage imageNamed:@"tab-circle-normal-icon"];
}

- (UIImage *)tabCircleSelectedIcon {
    return [UIImage imageNamed:@"tab-circle-selected-icon"];
}

- (UIImage *)tabHomeNormalIcon {
    return [UIImage imageNamed:@"tab-home-normal-icon"];
}

- (UIImage *)tabHomeSelectedIcon {
    return [UIImage imageNamed:@"tab-home-selected-icon"];
}

- (UIImage *)tabMeNormalIcon {
    return [UIImage imageNamed:@"tab-me-normal-icon"];
}

- (UIImage *)tabMeSelectedIcon {
    return [UIImage imageNamed:@"tab-me-selected-icon"];
}

- (UIImage *)tabMessageNormalIcon {
    return [UIImage imageNamed:@"tab-message-normal-icon"];
}

- (UIImage *)tabMessageSelectedIcon {
    return [UIImage imageNamed:@"tab-message-selected-icon"];
}

// Guide
- (UIImage *)guide1stImage {
    return [UIImage imageNamed:@"guide-1st-image"];
}

- (UIImage *)guide2ndImage {
    return [UIImage imageNamed:@"guide-2nd-image"];
}

- (UIImage *)guide3rdImage {
    return [UIImage imageNamed:@"guide-3rd-image"];
}

- (UIImage *)guide4thImage {
    return [UIImage imageNamed:@"guide-4th-image"];
}

@end
