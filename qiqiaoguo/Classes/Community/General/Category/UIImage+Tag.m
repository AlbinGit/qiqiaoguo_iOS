//
//  UIImage+Tag.m
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "UIImage+Tag.h"
#import "BLUPostTag.h"

#define kSeletedBackgroundColor         [UIColor colorFromHexString:@"#EDEEEE"]
#define kDeselectedBackgroundColor      [UIColor whiteColor]
#define kBorderColor                    [UIColor colorFromHexString:@"#EDEEEE"]

@implementation UIImage (Tag)

+ (UIImage *)imageFromTagTitle:(NSString *)tag selected:(BOOL)selected deleteAble:(BOOL)deleteAble font:(UIFont *)font {

    UIColor *backgroundColor = selected ? kSeletedBackgroundColor : kDeselectedBackgroundColor;
    UIColor *borderColor = kBorderColor;

    NSMutableParagraphStyle *textStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    NSDictionary *textAttributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#9FA0A2"],
                                     NSParagraphStyleAttributeName: textStyle};

    CGRect textRect = [tag boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:textAttributes
                                        context:nil];

    CGFloat leftPadding = 0;
    CGFloat rightPadding = BLUThemeMargin * 2;

    CGFloat imageWidth =
    textRect.size.width + textRect.size.height + leftPadding + rightPadding;
    CGFloat imageHeight =
    textRect.size.height + BLUThemeMargin * 2;

    CGSize imageSize = CGSizeMake(imageWidth, imageHeight);

    if (deleteAble) {
        imageSize.width += textRect.size.height;
        textRect.origin.x = textRect.size.height / 2.0;
        textRect.origin.x += leftPadding;
    } else {
        textRect.origin.x = imageSize.width / 2.0 - textRect.size.width / 2.0 - (rightPadding - leftPadding) / 2.0;
    }

    textRect.origin.y = BLUThemeMargin;

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);

    // Round rect Drawing
    CGFloat roundedRectLineWidth = 1.0;
    CGFloat roundedRectWidth =
    imageSize.width - roundedRectLineWidth - leftPadding - rightPadding;
    UIBezierPath *roundedRect =
    [UIBezierPath
     bezierPathWithRoundedRect:
     CGRectMake(roundedRectLineWidth + leftPadding, roundedRectLineWidth,
                roundedRectWidth,
                imageSize.height - roundedRectLineWidth * 2)
     cornerRadius:(imageSize.height - roundedRectLineWidth) / 2.0];
    [backgroundColor setFill];
    [roundedRect fill];
    [borderColor setStroke];
    roundedRect.lineWidth = roundedRectLineWidth;
    [roundedRect stroke];

    // Test Drawing
    [tag drawInRect:textRect withAttributes:textAttributes];

    // Line Drawing
    if (deleteAble) {

        CGFloat lineHeight = textRect.size.height - BLUThemeMargin * 2.4;
        CGFloat lineY = textRect.origin.y + BLUThemeMargin * 1.2;

        CGPoint topLeftPoint =
        CGPointMake(textRect.origin.x + textRect.size.width + BLUThemeMargin * 2.4,
                    lineY);

        CGPoint topRightPoint =
        CGPointMake(topLeftPoint.x + lineHeight,
                    topLeftPoint.y);

        CGPoint bottomLeftPoint =
        CGPointMake(topLeftPoint.x,
                    topLeftPoint.y + lineHeight);

        CGPoint bottomRightPoint =
        CGPointMake(topLeftPoint.x + lineHeight,
                    topLeftPoint.y + lineHeight);

        UIBezierPath *line1 = [UIBezierPath bezierPath];
        [line1 moveToPoint:topLeftPoint];
        [line1 addCurveToPoint:bottomRightPoint controlPoint1:bottomRightPoint controlPoint2:bottomRightPoint];
        line1.lineWidth = BLUThemeMargin / 2.0;
        line1.lineCapStyle = kCGLineCapRound;
        [[UIColor colorFromHexString:@"#999A9B"] setStroke];
        [line1 stroke];

        UIBezierPath *line2 = [UIBezierPath bezierPath];
        [line2 moveToPoint:topRightPoint];
        [line2 addCurveToPoint:bottomLeftPoint controlPoint1:bottomLeftPoint controlPoint2:bottomLeftPoint];
        line2.lineWidth = BLUThemeMargin / 2.0;
        line2.lineCapStyle = kCGLineCapRound;
        [[UIColor colorFromHexString:@"#999A9B"] setStroke];
        [line2 stroke];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)imageFromTag:(BLUPostTag *)tag seleted:(BOOL)seleted deleteAble:(BOOL)deleteAble font:(UIFont *)font {
    return [self imageFromTagTitle:tag.shortTitle selected:seleted deleteAble:deleteAble font:font];
}

@end
