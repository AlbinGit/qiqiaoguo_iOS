//
//  UILabel+BLUTheme.m
//  Blue
//
//  Created by Bowen on 17/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "UILabel+BLUTheme.h"

@implementation UILabel (BLUTheme)

- (void)themeLabel:(UILabel *)label withType:(BLULabelType)labelType {
    switch (labelType) {
        case BLULabelTypeBoldTitle: {
            label.font = [BLUCurrentTheme boldFontWithFontSizeType:BLUUIThemeFontSizeTypeLarge];
            label.numberOfLines = 1;
            label.textColor = BLUThemeMainDeepContentForegroundColor;
        } break;
        case BLULabelTypeTitle: {
            label.numberOfLines = 1;
            // TODO:
            label.font = [BLUCurrentTheme titleFontWithFontSizeType:BLUUIThemeFontSizeTypeLarge];
            label.textColor = BLUThemeMainDeepContentForegroundColor;
        } break;
        case BLULabelTypeContent: {
            label.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeNormal];
            label.textColor = BLUThemeSubDeepContentForegroundColor;
            label.numberOfLines = 0;
        } break;
        case BLULabelTypeMainContent: {
            label.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeLarge];
            label.textColor = BLUThemeSubDeepContentForegroundColor;
            label.numberOfLines = 0;
        } break;
        case BLULabelTypeHeat: {
            label.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeSmall];
            label.numberOfLines = 1;
            // TODO: Heat label should have a color
            label.textColor = [UIColor redColor];
        } break;
        case BLULabelTypeTime: {
            label.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeSmall];
            label.numberOfLines = 1;
            label.textColor = BLUThemeSubTintContentForegroundColor;
        } break;
        case BLULabelTypeSub: {
            label.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeSmall];
            label.numberOfLines = 1;
            label.textColor = BLUThemeSubTintContentForegroundColor;
        } break;
        case BLULabelTypeDefault: break;
        default: break;
    }
}

+ (UILabel *)makeThemeLabelWithType:(BLULabelType)labelType {
    UILabel *label = [UILabel new];
    [label themeLabel:label withType:labelType];
    return label;
}

@end
