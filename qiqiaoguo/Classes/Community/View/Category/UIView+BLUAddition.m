//
//  UIView+BLUAddition.m
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "UIView+BLUAddition.h"

//static void *const kCornerRadiusKey = "kCornerRadiusKey";
static void * const kIndicatorKey = "kIndicatorKey";
static void * const kDimViewKey = "kDimViewKey";

@implementation UIView (BLUAddition)

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (UIColor *)borderColor {
    UIColor *color = [UIColor colorWithCGColor:self.layer.borderColor];
    return color;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)showIndicator {

    UIImageView *imageView = objc_getAssociatedObject(self, kIndicatorKey);

    if (imageView == nil) {
        NSArray *images = @[[UIImage imageNamed:@"common-indicator-1"],
                            [UIImage imageNamed:@"common-indicator-2"],
                            [UIImage imageNamed:@"common-indicator-3"],
                            [UIImage imageNamed:@"common-indicator-4"],
                            [UIImage imageNamed:@"common-indicator-5"],
                            [UIImage imageNamed:@"common-indicator-6"],
                            [UIImage imageNamed:@"common-indicator-7"],
                            [UIImage imageNamed:@"common-indicator-8"]];

        UIImage *simpleImage = images[0];
        CGSize imageSize = simpleImage.size;

        imageView = [UIImageView new];
        imageView.animationImages = images;
        imageView.animationDuration = 0.8;
        imageView.animationRepeatCount = 0.0;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];

        imageView.size = imageSize;
        imageView.centerX = self.width / 2.0;
        imageView.centerY = self.height / 2.0;

        objc_setAssociatedObject(self, kIndicatorKey, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    imageView.alpha = 0.0;
    [imageView startAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 1.0;
    }];
}

- (void)hideIndicator {
    UIImageView *imageView = objc_getAssociatedObject(self, kIndicatorKey);
    if (imageView) {
        [imageView stopAnimating];
        imageView.alpha = 1.0;
        [UIView animateWithDuration:0.2 animations:^{
            imageView.alpha = 0.0;
        }];
    }
}

- (void)showDimView {
    UIView *dimView = objc_getAssociatedObject(self, kDimViewKey);
    if (!dimView) {
        dimView = [UIView new];
        dimView.alpha = 0;
        dimView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.5];
        objc_setAssociatedObject(self, kDimViewKey, dimView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:dimView];
    }
    
    dimView.frame = self.bounds;
    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        dimView.alpha = 1;
    }];
}

- (void)hideDimView {
    UIView *dimView = objc_getAssociatedObject(self, kDimViewKey);
    
    if (dimView) {
        [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
            dimView.alpha = 0;
        }];
    }
}

@end
