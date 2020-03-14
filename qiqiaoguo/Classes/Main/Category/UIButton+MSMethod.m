//
//  UIButton+MSMethod.m
//  MSLib
//
//  Created by Albin on 15/7/22.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "UIButton+MSMethod.h"
#import <objc/runtime.h>

static void *UIButtonClickBlockKey = "UIButtonClickBlockKey";

@implementation UIButton (MSMethod)

- (void)addClick:(UIButtonClickBlock)click
{
    objc_setAssociatedObject(self, UIButtonClickBlockKey, click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)button
{
    UIButtonClickBlock click = objc_getAssociatedObject(self, UIButtonClickBlockKey);
    if(click)
    {
        click(button);
    }
}
- (void)setBtnNormalImageName:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
- (void)setBtnSelectImageName:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}
@end
