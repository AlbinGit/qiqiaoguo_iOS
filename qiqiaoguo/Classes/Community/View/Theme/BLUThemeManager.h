//
//  BLUThemeManager.h
//  Blue
//
//  Created by Bowen on 13/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUUITheme.h"



@interface BLUThemeManager : NSObject

+ (id <BLUUITheme>)sharedTheme;

+ (id <BLUUITheme>)currentTheme;

+ (void)customizeAppAppearance;

@end
