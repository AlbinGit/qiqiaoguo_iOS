//
//  UIButton+BLUTheme.h
//  Blue
//
//  Created by Bowen on 17/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BLUButtonType) {
    BLUButtonTypeDefault = 0,
    BLUButtonTypeBorderedRoundRect,
    BLUButtonTypeSolidRoundRect,
    BLUButtonTypeLeftImage,
};

@interface UIButton (BLUTheme)

- (void)themeButton:(UIButton *)button withType:(BLUButtonType)buttonType;

+ (UIButton *)makeThemeButtonWithType:(BLUButtonType)buttonType;

@end
