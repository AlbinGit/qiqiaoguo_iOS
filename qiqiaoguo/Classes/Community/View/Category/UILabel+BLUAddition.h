//
//  UILabel+BLUAddition.h
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (BLUAddition)

- (CGSize)contentSizeWithWidth:(CGFloat)width;
- (CGSize)contentSizeWithHeight:(CGFloat)height;

+ (UILabel *)labelWithFont:(UIFont *)font color:(UIColor *)color;

@end
