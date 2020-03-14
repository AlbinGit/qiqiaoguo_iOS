//
//  BLUUITheme.h
//  Blue
//
//  Created by Bowen on 15/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUUITheme+Image.h"
#import "BLUUITheme+Font.h"
#import "BLUUITheme+Color.h"

@protocol BLUUIThemeCornerRadius <NSObject>

- (CGFloat)lowActivityCornerRadius;
- (CGFloat)normalActivityCornerRadius;
- (CGFloat)highActivityCornerRadius;

@end

@protocol BLUUIThemeAnimeDuration <NSObject>

- (CGFloat)shortAnimeDuration;
- (CGFloat)normalAnimeDuration;
- (CGFloat)longAnimeDuration;

@end

@protocol BLUUIThemeMargin <NSObject>

- (CGFloat)topMargin;
- (CGFloat)leftMargin;
- (CGFloat)bottomMargin;
- (CGFloat)rightMargin;
- (CGFloat)margin;

@end

@protocol BLUUITheme <BLUUIThemeColor, BLUUIThemeFont, BLUUIThemeCornerRadius, BLUUIThemeAnimeDuration, BLUUIThemeMargin, BLUUIThemeImage>

- (void)customizeAppAppearance;

@end
