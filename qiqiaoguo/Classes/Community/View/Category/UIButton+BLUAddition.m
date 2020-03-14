//
//  UIButton+BLUAddition.m
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "UIButton+BLUAddition.h"

static void * const kImageKey = "kImageKey";
static void * const kBackgroundImageKey = "kBackgroundImageKey";
static void * const kImageURLKey = "kImageURLKey";
static void * const kBackgroundImageURLKey = "kBackgroundImageURLKey";
static void * const kButtonColorKey = "kButtonColorKey";
static void * const kTitleKey = "kTitleKey";
static void * const kTitleColorKey = "kTitleColorKey";
static void * const kImageURLStringKey = @"kImageURLStringKey";
static void * const kBackgroundImageURLStringKey = "kBackgroundImageURLStringKey";

@implementation UIButton (BLUAddition)

- (UIImage *)image {
    UIImage *img = objc_getAssociatedObject(self, kImageKey);
    return img;
}

- (UIImage *)backgroundImage {
    UIImage *image = objc_getAssociatedObject(self, kBackgroundImageKey);
    return image;
}

- (NSURL *)imageURL {
    NSURL *url = objc_getAssociatedObject(self, kImageURLKey);
    return url;
}

- (NSURL *)backgroundImageURL {
    NSURL *url = objc_getAssociatedObject(self, kBackgroundImageURLKey);
    return url;
}

- (NSString *)imageURLString {
    NSString *str = objc_getAssociatedObject(self, kImageURLStringKey);
    return str;
}

- (NSString *)backgroundImageURLString {
    NSString *str = objc_getAssociatedObject(self, kBackgroundImageURLStringKey);
    return str ;
}

- (UIColor *)buttonColor {
    UIColor *color = objc_getAssociatedObject(self, kButtonColorKey);
    return color;
}

- (NSString *)title {
    NSString *string = objc_getAssociatedObject(self, kTitleKey);
    return string;
}

- (UIColor *)titleColor {
    UIColor *color = objc_getAssociatedObject(self, kTitleColorKey);
    return color;
}

- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setImage:(UIImage *)image {
    objc_setAssociatedObject(self, kImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    objc_setAssociatedObject(self, kBackgroundImageKey, backgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (void)setImageURL:(NSURL *)imageUrl {
    objc_setAssociatedObject(self, kImageURLKey, imageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            [self setImage:image forState:UIControlStateNormal];
        }
    }];
}

- (void)setBackgroundImageURL:(NSURL *)backgroundImageUrl {
    objc_setAssociatedObject(self, kBackgroundImageURLKey, backgroundImageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[SDWebImageManager sharedManager] downloadImageWithURL:backgroundImageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
//            [self.layer addAnimation:[CATransition animation] forKey:kCATransition];
            [self setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
}

- (void)setImageURLString:(NSString *)imageURLString {
    objc_setAssociatedObject(self, kImageURLStringKey, imageURLString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setImageURL:[NSURL URLWithString:imageURLString]];
}

- (void)setBackgroundImageURLString:(NSString *)backgroundImageURLString {
    objc_setAssociatedObject(self, kBackgroundImageURLStringKey, backgroundImageURLString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBackgroundImageURL:[NSURL URLWithString:backgroundImageURLString]];
}

- (void)setButtonColor:(UIColor *)buttonColor {
    objc_setAssociatedObject(self, kButtonColorKey, buttonColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.image == nil && self.imageView.image == nil) {
        [self setImage:[UIImage imageWithColor:buttonColor] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:[UIImage imageWithColor:buttonColor] forState:UIControlStateNormal];
    }
}

- (void)setTitle:(NSString *)title {
    objc_setAssociatedObject(self, kTitleKey, title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor {
    objc_setAssociatedObject(self, kTitleColorKey, titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.titleLabel.font = titleFont;
}

- (void)setImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // Get your image somehow
        // Begin a new image that will be the new image with the rounded corners
        // (here with the size of an UIImageView)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        
        // Add a clip before drawing anything, in the shape of an rounded rect
        [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                    cornerRadius:cornerRadius] addClip];
        // Draw your image
        [image drawInRect:self.bounds];
        
        // Get the image, here setting the UIImageView image
        UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // Lets forget about that we were drawing
        UIGraphicsEndImageContext();
        
        // Lets forget about that we we
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:renderedImage forState:state];
        });
    });
}

- (void)setBackgroundImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // Get your image somehow
        // Begin a new image that will be the new image with the rounded corners
        // (here with the size of an UIImageView)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        
        // Add a clip before drawing anything, in the shape of an rounded rect
        [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                    cornerRadius:cornerRadius] addClip];
        // Draw your image
        [image drawInRect:self.bounds];
        
        // Get the image, here setting the UIImageView image
        UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // Lets forget about that we were drawing
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:renderedImage forState:state];
        });
    });
}

- (void)setImageURL:(NSURL *)imageURL cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state {
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
//            [self.layer addAnimation:[CATransition animation] forKey:kCATransition];
            [self setImage:image cornerRadius:cornerRadius forState:state];
        }
    }];
}

- (void)setBacgroundImageURL:(NSURL *)imageURL cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state {
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
//            [self.layer addAnimation:[CATransition animation] forKey:kCATransition];
            [self setBackgroundImage:image cornerRadius:cornerRadius forState:state];
        }
    }];
}

@end

@implementation UIButton (VerticalLayout)

- (void)centerVerticallyWithPadding:(float)padding {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;

    CGFloat totalHeight = (imageSize.height + titleSize.height + padding);

    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height),
                                            0.0f,
                                            0.0f,
                                            - titleSize.width);

    self.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            - imageSize.width,
                                            - (totalHeight - titleSize.height),
                                            0.0f);

}


- (void)centerVertically {
    const CGFloat kDefaultPadding = 6.0f;

    [self centerVerticallyWithPadding:kDefaultPadding];
}  


@end
