//
//  UILabel+BLUTheme.h
//  Blue
//
//  Created by Bowen on 17/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BLULabelType) {
    BLULabelTypeDefault = 0,
    BLULabelTypeBoldTitle,
    BLULabelTypeTitle,
    BLULabelTypeMainContent,
    BLULabelTypeContent,
    BLULabelTypeSub,
    BLULabelTypeTime,
    BLULabelTypeHeat,
};

@interface UILabel (BLUTheme)

- (void)themeLabel:(UILabel *)label withType:(BLULabelType)labelType;
+ (UILabel *)makeThemeLabelWithType:(BLULabelType)labelType;

@end
