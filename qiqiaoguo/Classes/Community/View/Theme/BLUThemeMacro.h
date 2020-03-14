//
//  BLUThemeMacro.h
//  Blue
//
//  Created by Bowen on 17/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUUITheme.h"
#import "BLUUITheme+Image.h"
#import "BLUUITheme+Font.h"
#import "BLUUITheme+Color.h"
#import "BLUThemeManager.h"

#ifndef Blue_BLUThemeMacro_h
#define Blue_BLUThemeMacro_h

#define BLUCurrentTheme ([BLUThemeManager currentTheme])

// Corner radius
#define BLUThemeLowActivityCornerRadius                 ([BLUCurrentTheme lowActivityCornerRadius])
#define BLUThemeNormalActivityCornerRadius              ([BLUCurrentTheme normalActivityCornerRadius])
#define BLUThemeHighActivityCornerRadius                ([BLUCurrentTheme highActivityCornerRadius])

// Line
#define BLUThemeOnePixelHeight                                  (1.0 / [UIScreen mainScreen].scale)
#define QGOnePixelLineHeight                                  (1.0 / [UIScreen mainScreen].scale)

// Anime duration
#define BLUThemeShortAnimeDuration                      ([BLUCurrentTheme shortAnimeDuration])
#define BLUThemeNormalAnimeDuration                     ([BLUCurrentTheme normalAnimeDuration])
#define BLUThemeLongAnimeDuration                       ([BLUCurrentTheme longAnimeDuration])

// Margin
#define BLUThemeTopMargin                               ([BLUCurrentTheme topMargin])
#define BLUThemeLeftMargin                              ([BLUCurrentTheme leftMargin])
#define BLUThemeRightMargin                             ([BLUCurrentTheme bottomMargin])
#define BLUThemeBottomMargin                            ([BLUCurrentTheme rightMargin])
#define BLUThemeMargin                                  ([BLUCurrentTheme margin])

// Color
#define BLUThemeMainColor                               ([BLUCurrentTheme mainColor])
#define BLUThemeSubColor                                ([BLUCurrentTheme subColor])
#define BLUThemeMainTintBackgroundColor                 ([BLUCurrentTheme mainTintBackgroundColor])
#define BLUThemeSubTintBackgroundColor                  ([BLUCurrentTheme subTintBackgroundColor])
#define BLUThemeMainDeepBackgroundColor                 ([BLUCurrentTheme mainDeepBackgroundColor])
#define BLUThemeBaseTintColor                           ([BLUCurrentTheme baseTintColor])
#define BLUThemeMainDeepContentForegroundColor          ([BLUCurrentTheme mainDeepContentForegroundColor])
#define BLUThemeSubDeepContentForegroundColor           ([BLUCurrentTheme subDeepContentForegroundColor])
#define BLUThemeMainTintContentForegroundColor          ([BLUCurrentTheme mainTintContentForegroundColor])
#define BLUThemeSubTintContentForegroundColor           ([BLUCurrentTheme subTintContentForegroundColor])
#define BLUThemeMainInteractionForegroundColor          ([BLUCurrentTheme mainInteractionForegroundColor])
#define BLUThemeContentInteractionForegroundColor       ([BLUCurrentTheme mainContentInteractionForegroundColor])

#define QGCellbottomLineColor                           [UIColor colorFromHexString:@"c1c1c1"]
#define QGTitleColor                                    [UIColor colorFromHexString:@"333333"]
#define QGCellContentColor                              [UIColor colorFromHexString:@"999999"]
#define QGMainContentColor                              [UIColor colorFromHexString:@"666666"]
#define QGMainRedColor                                  [UIColor colorFromHexString:@"ff3859"]
#define QGRandomColor                                   [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:arc4random()%100/100.0];

// Font
#define BLUThemeMainFontWithType(type)                  ([BLUCurrentTheme mainFontWithFontSizeType:type])
#define BLUThemeBoldFontWithType(type)                  ([BLUCurrentTheme boldFontWithFontSizeType:type])

#define BLUThemeMainFontWithSize(size)                  ([BLUCurrentTheme mainFontWithSize:size])
#define BLUThemeBoldFontWithSize(size)                  ([BLUCurrentTheme boldFontWithSize:size])


#endif
