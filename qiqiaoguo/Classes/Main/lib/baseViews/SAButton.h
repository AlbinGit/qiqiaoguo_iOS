//
//  SAButton.h
//  ToysOnline
//
//  Created by Albin on 14-8-22.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SAButton;
typedef void(^SAButtonClick)(SAButton *button);

@interface SAButton : UIButton

@property (nonatomic,strong)NSIndexPath *indexPath;

- (void)setNormalBackgroundImage:(NSString *)imageName;
- (void)setNormalImage:(NSString *)imageName;
- (void)setNormalTitle:(NSString *)title;
- (void)setNormalTitleColor:(UIColor *)color;

- (void)setHighlightBackgroundImage:(NSString *)imageName;
- (void)setHighlightImage:(NSString *)imageName;
- (void)setborder:(int )width;
- (void)setSelectedImage:(NSString *)imageName;
- (void)setSelectedTitleColor:(UIColor *)color;

// 点击
- (void)addClick:(SAButtonClick)click;

/*
    cuisuai->method
 */

//创建一个本地UIButton
+ (SAButton *)createBtnWithRect:(CGRect)r
                     andWithImg:(UIImage *)i
                     andWithTag:(NSInteger)n
                      andWithBg:(UIImage *)b
                   andWithTitle:(NSString *)t
                   andWithColor:(UIColor *)c;

@end
