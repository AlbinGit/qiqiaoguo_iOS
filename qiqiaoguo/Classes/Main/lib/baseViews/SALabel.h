//
//  SALabel.h
//  SaleAssistant
//
//  Created by Albin on 14-8-25.
//  Copyright (c) 2014年 platomix. All rights reserved.
//
typedef enum{
    
    LineTypeNone,//没有画线
    LineTypeUp ,// 上边画线
    LineTypeMiddle,//中间画线
    LineTypeDown,//下边画线
    
} LineType ;
#import <UIKit/UIKit.h>

@class SALabel;
typedef void(^SALabelClickBlock)(SALabel *label);

@interface SALabel : UILabel
@property (assign, nonatomic) LineType lineType;
@property (strong, nonatomic) UIColor * lineColor;
//点击事件
- (void)addClick:(SALabelClickBlock)click;

//创建一个UILabel
+ (SALabel *)createLabelWithRect:(CGRect)r
                    andWithColor:(UIColor *)c
                     andWithFont:(CGFloat)f
                    andWithAlign:(NSTextAlignment)a
                    andWithTitle:(NSString *)t;

// 根据内容大小设置Label
- (void)setFrameWithPoint:(CGPoint)point text:(NSString *)text;

// 根据内容大小设置Label(固定宽度)
- (void)setFrameWithPoint:(CGPoint)point width:(CGFloat)width text:(NSString *)text;
// 根据内容大小设置Label(固定宽度,有最大高度)
- (void)setFrameWithPoint:(CGPoint)point width:(CGFloat)width maxHeight:(CGFloat)maxHeight text:(NSString *)text;
// 根据内容大小设置Label(固定高度,有最大宽度)
- (void)setFrameWithPoint:(CGPoint)point maxWidth:(CGFloat)maxWidth Height:(CGFloat)height text:(NSString *)text;
// 添加下划线
- (void)addUnderLineWithText:(NSString *)text;

@end
