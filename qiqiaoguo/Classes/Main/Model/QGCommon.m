//
//  QGCommon.m
//  LongForTianjie
//
//  Created by 杨常勇 on 15/6/10.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "QGCommon.h"

@implementation QGCommon
//根据字号计算字体高度
+ (CGRect)rectForString:(NSString *)bStr withFont:(int)font
{
    CGRect rect = [bStr boundingRectWithSize:CGSizeMake(1000, 200) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect;
}
+ (CGRect)rectForString:(NSString *)bStr withFont:(int)font WithWidth:(CGFloat)width
{
    CGRect rect = [bStr boundingRectWithSize:CGSizeMake(width,2000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect;
}

+ (CGRect)rectForString:(NSString *)bStr withBoldFont:(int)font
{
    CGRect rect = [bStr boundingRectWithSize:CGSizeMake(1000, 200) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil];
    
    return rect;
}
#pragma mark 获取单行字体高度
+ (CGFloat)rectWithFont:(int)font
{
    CGRect rect=[self rectForString:@"字体" withFont:font];
    return rect.size.height;
}

#pragma mark 获取字符串宽度
/**
 *  获取字符串宽度
 *
 *  @param str  内容
 *  @param font 字号
 *
 *  @return 宽度
 */
+ (CGFloat)rectWithString:(NSString *)str withFont:(int)font
{
    CGRect rect=[self rectForString:str withFont:font];
    return rect.size.width;
}
+ (CGFloat)rectWithString:(NSString *)str withBoldFont:(int)font
{
    CGRect rect=[self rectForString:str withBoldFont:font];
    return rect.size.width;
}

+ (NSInteger)compareTimeStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSDate *nowDate=[NSDate date];
    
    NSDateFormatter* formatter2 = [[NSDateFormatter alloc]init];
    if (startTime.length<11)
    {
        startTime=[NSString stringWithFormat:@"%@ 00:00:01",startTime];
        endTime=[NSString stringWithFormat:@"%@ 23:59:59",endTime];
    }
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *start=[formatter2 dateFromString:startTime];
    NSDate *end=[formatter2 dateFromString:endTime];
    

    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:28800];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr=[formatter stringFromDate:nowDate];
    NSDate *DateNow=[formatter2 dateFromString:dateStr];
    
    if ([DateNow laterDate:start]==DateNow&&[DateNow earlierDate:end]==DateNow)
    {
        NSLog(@"在活动期间");
        return 1;
    }
    if([DateNow earlierDate:start]==DateNow)
    {
        NSLog(@"未开始");
        return 0;
    }
    if ([DateNow laterDate:end]==DateNow)
    {
        NSLog(@"已结束");
        return 2;
    }
    return 0;
}
#pragma mark 计算当前时间距离目标时间的时间差
+ (NSString *)testTimeWithTheTime:(NSString *)time
{
    NSDateFormatter* formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *end=[formatter2 dateFromString:time];
    NSString *str=[formatter2 stringFromDate:end];
    NSLog(@"%@",str);
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:28800];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr=[formatter stringFromDate:[NSDate date]];
    NSDate *date=[formatter2 dateFromString:dateStr];
    ;
        NSLog(@"%.0f====%0.f=====%0.f",[date timeIntervalSince1970],[end timeIntervalSince1970],([end timeIntervalSince1970]-[date timeIntervalSince1970]));
    NSLog(@"xmq == %@",[NSString stringWithFormat:@"%ld",(long)([end timeIntervalSince1970]-[date timeIntervalSince1970])]);
        return [NSString stringWithFormat:@"%ld",(long)([end timeIntervalSince1970]-[date timeIntervalSince1970])];
}
#pragma  mark 计算时间距离当前时间差（开始、结束）
+ (NSString *)testTimeWithTargetTime:(NSString *)time
{
    NSDateFormatter* formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *end=[formatter2 dateFromString:time];
    NSString *str=[formatter2 stringFromDate:end];
    NSLog(@"%@",str);
    NSInteger internal=[[NSDate date] timeIntervalSince1970];
    internal+=28800;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:internal];
    
    if ([end timeIntervalSince1970]>=[date timeIntervalSince1970])
    {
        return [NSString stringWithFormat:@"%ld",(long)([end timeIntervalSince1970]-[date timeIntervalSince1970])];
    }else
    {
        return [NSString stringWithFormat:@"%ld",(long)([date timeIntervalSince1970]-[end timeIntervalSince1970])];
    }
    
}
+ (NSInteger)getCurrentTimeHour
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"'日期'yyyy-MM-dd '时间'HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800]];
    NSUInteger unitFlags =NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger hour = [dateComponent hour];
    NSLog(@"%ld",(long)hour);
    return hour;
}
+ (NSString *)dateFormdate:(NSString *)dateStr
{
    NSString *str=[dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    return str;
}

+ (UIImageView *)createLine
{
     UIImageView* lineImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_line_shopcar_shop"]];
    return lineImageView;
}
+ (UIImageView *)createdividingLine
{
    UIImageView* lineImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_icon_dividing_line"]];
    return lineImageView;
}
+ (NSString *)isNumber:(id)obj
{
    if ([obj isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@",obj];
    }
    return obj;
}
+ (void)setLableColorAndSize:(NSString *)redStr andLab:(UILabel *)lab
{
    NSString *money =redStr;
    NSString *text = lab.text;
    if ([lab respondsToSelector:@selector(setAttributedText:)]) {
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:lab.textColor,
                                  NSFontAttributeName:lab.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        // Red text attributes
        //#5773de
        UIColor *aColor = [UIColor colorFromHexString:@"ff2f4f"];
        NSRange redTextRange =[text rangeOfString:money];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        [attributedText setAttributes:@{NSForegroundColorAttributeName:aColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:redTextRange];
        lab.attributedText = attributedText;
    }
}
+ (void)setLableColor:(NSString *)redStr andLab:(UILabel *)lab foot:(UIFont *)foot color:(NSString *)str
{
    NSString *money =redStr;
    NSString *text = lab.text;
    if ([lab respondsToSelector:@selector(setAttributedText:)]) {
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:lab.textColor,
                                  NSFontAttributeName:lab.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        // Red text attributes
        //#5773de
        UIColor *aColor = [UIColor colorFromHexString:str];
        NSRange redTextRange =[text rangeOfString:money];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        [attributedText setAttributes:@{NSForegroundColorAttributeName:aColor,NSFontAttributeName:foot} range:redTextRange];
        lab.attributedText = attributedText;
    }
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
