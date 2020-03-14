//
//  UIButton+MSMethod.h
//  MSLib
//
//  Created by Albin on 15/7/22.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIButtonClickBlock)(UIButton *button);

@interface UIButton (MSMethod)

- (void)addClick:(UIButtonClickBlock)click;
- (void)setBtnNormalImageName:(NSString *)imageName;
- (void)setBtnSelectImageName:(NSString *)imageName;
@end
