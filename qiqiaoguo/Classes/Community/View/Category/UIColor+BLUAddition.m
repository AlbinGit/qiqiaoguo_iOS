//
//  UIColor+BLUAddition.m
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "UIColor+BLUAddition.h"

@implementation UIColor (BLUAddition)

+ (UIColor *)colorFromHexString:(NSString *)colorString alpha:(CGFloat)alpha {
    colorString = [colorString lowercaseString];
    if ([colorString length]<6) {
        
        return [UIColor blackColor];
    }
    NSRange range = NSMakeRange(0, 2);
    uint32_t redValue = 0;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]]scanHexInt:&redValue];
    range.location = 2;
    uint32_t greenValue = 0;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]]scanHexInt:&greenValue];
    range.location = 4;
    uint32_t blueValue = 0;
    [[NSScanner scannerWithString:[colorString substringWithRange:range]]scanHexInt:&blueValue];
    
    return [UIColor colorWithRed:redValue/255.0 green:greenValue/255.0 blue:blueValue/255.0 alpha:alpha];
}

+ (UIColor *)randomColor {
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        (time(NULL));
    }
    CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
