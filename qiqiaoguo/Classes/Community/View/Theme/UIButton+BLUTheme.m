//
//  UIButton+BLUTheme.m
//  Blue
//
//  Created by Bowen on 17/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "UIButton+BLUTheme.h"

@implementation UIButton (BLUTheme)

- (void)themeButton:(UIButton *)button withType:(BLUButtonType)buttonType {
    switch (buttonType) {
        case BLUButtonTypeBorderedRoundRect: {
            button.cornerRadius = BLUThemeNormalActivityCornerRadius;
            [button setCornerRadius:BLUThemeNormalActivityCornerRadius];
            button.borderColor = BLUThemeMainColor;
            button.borderWidth = 1.0;
            button.tintColor = BLUThemeMainColor;
        } break;
        case BLUButtonTypeSolidRoundRect: {
            button.cornerRadius = BLUThemeNormalActivityCornerRadius;
            button.backgroundColor = BLUThemeMainColor;
        } break;
        case BLUButtonTypeLeftImage: {
            UIEdgeInsets titleEdgeInsets = button.titleEdgeInsets;
            titleEdgeInsets.left = BLUThemeMargin;
            button.titleEdgeInsets = titleEdgeInsets;
        } break;
        case BLUButtonTypeDefault: break;
        default: break;
    }
}

+ (UIButton *)makeThemeButtonWithType:(BLUButtonType)buttonType {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button themeButton:button withType:buttonType];
    return button;
}

@end
