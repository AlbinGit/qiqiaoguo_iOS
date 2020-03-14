//
//  BLUUITheme+Color.h
//  Blue
//
//  Created by Bowen on 15/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLUUIThemeColor <NSObject>

// Theme
- (UIColor *)mainColor;
- (UIColor *)NavColor;
- (UIColor *)subColor;

// Background
- (UIColor *)mainTintBackgroundColor;
- (UIColor *)subTintBackgroundColor;
- (UIColor *)mainDeepBackgroundColor;

// Tint
- (UIColor *)baseTintColor;

// Foreground
- (UIColor *)mainDeepContentForegroundColor;
- (UIColor *)subDeepContentForegroundColor;
- (UIColor *)mainTintContentForegroundColor;
- (UIColor *)subTintContentForegroundColor;
- (UIColor *)mainInteractionForegroundColor;
- (UIColor *)mainContentInteractionForegroundColor;

@end
