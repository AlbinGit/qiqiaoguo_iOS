//
//  BLUThemeManager.m
//  Blue
//
//  Created by Bowen on 13/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUThemeManager.h"
#import "_BLUPurpleTheme.h"

@implementation BLUThemeManager

+ (id <BLUUITheme>)sharedTheme {
    static id <BLUUITheme> sharedTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTheme = [[_BLUPurpleTheme alloc] init];
    });
    return sharedTheme;
}

+ (id <BLUUITheme>)currentTheme {
    return [self sharedTheme];
}

+ (void)customizeAppAppearance {
   
    // Theme
    id <BLUUITheme> theme = [BLUThemeManager sharedTheme];
    
    // Bar tint color
    UINavigationBar *navigationBarAppearnce = [UINavigationBar appearance];
    
    UIColor *barTintColor = theme.mainColor;
    UIColor *darkendBarTintColor = barTintColor;
    
    [navigationBarAppearnce setBarTintColor:darkendBarTintColor];
    if ([navigationBarAppearnce respondsToSelector:@selector(setTranslucent:)]) {
        [navigationBarAppearnce setTranslucent:YES];
    }
    
    // Bar title font
    NSMutableDictionary *titleTextAttributes = [[navigationBarAppearnce titleTextAttributes] mutableCopy];
    if (!titleTextAttributes) {
        titleTextAttributes = [NSMutableDictionary dictionary];
    }

    [titleTextAttributes setObject:[theme subColor] forKey:NSForegroundColorAttributeName];
    
    [navigationBarAppearnce setTitleTextAttributes:titleTextAttributes];
    
    // Tint color
    [navigationBarAppearnce setTintColor:theme.subColor];
    
    // Back button
    // NOTE:这里的indicator图片的大小是固定的，一定要注意大小
    UIImage *backIndicatorImage = theme.navBackIndicatorImage;
    UIImage *backIndicatorTransitionMaskImage = theme.navBackIndicatorTransitionMaskImage;
    [navigationBarAppearnce setBackIndicatorImage:backIndicatorImage];
    [navigationBarAppearnce setBackIndicatorTransitionMaskImage:backIndicatorTransitionMaskImage];
    [navigationBarAppearnce setShadowImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"e1e1e1"]]];
    
    // Tab bar
//    UITabBar *tabBarAppearance = [UITabBar appearance];
//    tabBarAppearance.tintColor = theme.mainColor;
  
}

@end


