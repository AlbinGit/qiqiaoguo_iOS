//
//  UIImage+Tag.h
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUPostTag;

@interface UIImage (Tag)

+ (UIImage *)imageFromTagTitle:(NSString *)tag selected:(BOOL)selected deleteAble:(BOOL)deleteAble font:(UIFont *)font;
+ (UIImage *)imageFromTag:(BLUPostTag *)tag seleted:(BOOL)seleted deleteAble:(BOOL)deleteAble font:(UIFont *)font;

@end
