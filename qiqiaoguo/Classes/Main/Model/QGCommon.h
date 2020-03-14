//
//  QGCommon.h
//  LongForTianjie
//
//  Created by 杨常勇 on 15/6/10.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGCommon : NSObject

+ (CGFloat)rectWithFont:(int)font;
+ (CGFloat)rectWithString:(NSString *)str withFont:(int)font;
+ (NSInteger)compareTimeStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (NSString *)testTimeWithTheTime:(NSString *)time;
+ (NSInteger)getCurrentTimeHour;
+ (NSString *)testTimeWithTargetTime:(NSString *)time;
+ (UIImageView *)createLine;//创建分割线
/**穿件12的锯齿分割*/
+ (UIImageView *)createdividingLine;
+ (NSString *)isNumber:(id)obj;
+ (CGRect)rectForString:(NSString *)bStr withFont:(int)font WithWidth:(CGFloat)width;
+ (NSString *)dateFormdate:(NSString *)dateStr;
+ (void)setLableColorAndSize:(NSString *)redStr andLab:(UILabel *)lab;
+ (void)setLableColor:(NSString *)redStr andLab:(UILabel *)lab foot:(UIFont *)foot color:(NSString *)str;
/**json转字典*/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (CGFloat)rectWithString:(NSString *)str withBoldFont:(int)font;
+ (CGRect)rectForString:(NSString *)bStr withBoldFont:(int)font;
@end

