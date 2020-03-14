//
//  BLUPostCommonVideoNode+TextStyle.m
//  Blue
//
//  Created by Bowen on 2/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUPostCommonVideoNode+TextStyle.h"

@implementation BLUPostCommonVideoNode (TextStyle)

- (NSAttributedString *)attributedTitlte:(NSString *)title {
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"333333"],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};

    return [[NSAttributedString alloc] initWithString:title
                                           attributes:attributes];
}

- (NSAttributedString *)attributedTime:(NSString *)time {
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"c1c1c1"],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal)};
    return [[NSAttributedString alloc] initWithString:time
                                           attributes:attributes];
}

- (NSAttributedString *)attributedNumberOfComments:(NSNumber *)count {
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"999999"],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal)};
    return [[NSAttributedString alloc] initWithString:count.stringValue
                                           attributes:attributes];
}
- (NSAttributedString *)attributedNumberOfViews:(NSNumber *)count {
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"999999"],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal)};
    return [[NSAttributedString alloc] initWithString:count.stringValue
                                           attributes:attributes];
}

@end
