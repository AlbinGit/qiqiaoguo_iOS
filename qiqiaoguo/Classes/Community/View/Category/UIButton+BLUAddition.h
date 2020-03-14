//
//  UIButton+BLUAddition.h
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (BLUAddition)

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSURL *backgroundImageURL;

@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) NSString *backgroundImageURLString;

@property (nonatomic, strong) UIColor *buttonColor;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

- (void)setImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state;
- (void)setImageURL:(NSURL *)imageURL cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state;

- (void)setBackgroundImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state;
- (void)setBacgroundImageURL:(NSURL *)imageURL cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state;

@end

@interface UIButton (VerticalLayout)

- (void)centerVerticallyWithPadding:(float)padding;
- (void)centerVertically;

@end

