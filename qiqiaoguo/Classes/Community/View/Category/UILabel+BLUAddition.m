//
//  UILabel+BLUAddition.m
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "UILabel+BLUAddition.h"

@implementation UILabel (BLUAddition)

- (CGSize)contentSizeWithSize:(CGSize)paramSize {
    CGSize size = CGSizeZero;
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin;
    NSDictionary * attributes = @{
        NSFontAttributeName: self.font,
        NSParagraphStyleAttributeName: paragraphStyle,
    };
    
    size = [self.text boundingRectWithSize:paramSize options:options attributes:attributes context:nil].size;
    return size;
}

- (CGSize)contentSizeWithWidth:(CGFloat)width {
    CGSize originSize = [self contentSizeWithSize:CGSizeMake(width, MAXFLOAT)];
    CGSize size = CGSizeMake(ceilf(originSize.width), ceilf(originSize.height));
    return size;
}

- (CGSize)contentSizeWithHeight:(CGFloat)height {
    CGSize originSize = [self contentSizeWithSize:CGSizeMake(MAXFLOAT, height)];
    CGSize size = CGSizeMake(ceilf(originSize.width), ceilf(originSize.height));
    return size;
}

+ (UILabel *)labelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = color;
    return label;
}

@end
