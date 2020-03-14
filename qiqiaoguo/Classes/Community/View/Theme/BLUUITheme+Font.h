//
//  BLUUITheme+Font.h
//  Blue
//
//  Created by Bowen on 15/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLUUIThemeFontSizeType) {
    BLUUIThemeFontSizeTypeVeryLarge = 0,
    BLUUIThemeFontSizeTypeLarge,
    BLUUIThemeFontSizeTypeNormal,
    BLUUIThemeFontSizeTypeSmall,
    BLUUIThemeFontSizeTypeVerySmall,
};

@protocol BLUUIThemeFont <NSObject>

- (UIFont *)mainFontWithFontSizeType:(BLUUIThemeFontSizeType)fontSizeType;
- (UIFont *)boldFontWithFontSizeType:(BLUUIThemeFontSizeType)fontSizeType;

- (UIFont *)mainFontWithSize:(CGFloat)size;
- (UIFont *)boldFontWithSize:(CGFloat)size;

- (UIFont *)titleFontWithFontSizeType:(BLUUIThemeFontSizeType)fontSizeType;

@end
