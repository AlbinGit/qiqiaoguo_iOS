//
//  SASDateUtils.m
//  SalesAssistant
//
//  Created by Albin on 15/5/14.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "SASDateUtils.h"

@implementation SASDateUtils

// 得到当前时间
+ (NSString *)getTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    return time;
}

// 得到当前年月
+ (NSString *)getYearAndMonth
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    return time;
}

// 得到当前月日
+ (NSString *)getMonthAndDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    return time;
}

// 字符串转换年月
+ (NSString *)getMonthAndDay:(NSString *)stringDate
{
    NSArray *array = [stringDate componentsSeparatedByString:@" "];
    NSString *time = @"";
    if([array count] > 0)
    {
        time = array[0];
    }
    NSArray *tempArray = [time componentsSeparatedByString:@"-"];
    if([tempArray count] > 2)
    {
        return [NSString stringWithFormat:@"%@-%@",tempArray[1],tempArray[2]];
    }
    return nil;
}

// 日期类型转字符串
+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [dateFormatter stringFromDate:date];
    return time;
}

+ (NSDate *)stringToDate:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date= [dateFormatter dateFromString:string];
    return date;
}

// 2015-02-04 15:00:30 --> 15:00
+ (NSString *)getHourAndMinute:(NSString *)string
{
    if(string.length > 0)
    {
        NSString *resultString = [string substringWithRange:NSMakeRange(11, 5)];
        return resultString;
    }
    return @"";
}

+ (NSString *)getHour:(NSString *)string
{
    if(string.length > 0)
    {
        NSString *resultString = [string substringWithRange:NSMakeRange(0, 5)];
        return resultString;
    }
    return @"";
}
+ (NSString *)getMonthAndDaySting:(NSString *)string
{
    if (string.length > 0) {
        NSString *resultSting = [string substringWithRange:NSMakeRange(5, 5)];
        return resultSting;
    }
    return @"";
}

//判断是否是今日昨日，都不是，返回日期
+ (NSString *)compareDateToDate:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //今日日期 (年月日)
    NSDate *todayDate = [NSDate date];
    NSString *todayDateString = [dateFormatter stringFromDate:todayDate];
    NSString *todayString = [todayDateString substringWithRange:NSMakeRange(0, 10)];
    //昨日日期 (年月日)
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSString *yesterdayDateString = [dateFormatter stringFromDate:yesterdayDate];
    NSString *yesterdayString = [yesterdayDateString substringWithRange:NSMakeRange(0, 10)];
    
    //判断是否是今日昨日
    if ([dateString isEqualToString:todayString]) {
        return @"今日";
    }
    if ([dateString isEqualToString:yesterdayString]) {
        return @"昨日";
    }
    return dateString;
}

//xxxx-xx-xx --->xxxx年xx月xx日
+ (NSString *)getNormalData:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"-"];
    NSArray *array1 = @[@"年",@"月",@"日"];
    NSMutableString *string = [[NSMutableString alloc]init];
    for (int i = 0; i < 3; i++)
    {
        [string appendString:[NSString stringWithFormat:@"%@%@",array[i],array1[i]]];
    }
    return string;
}

//xxxx-xx-xx --->xx月xx日
+ (NSString *)getNormalMonthAndDayData:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"-"];
    NSArray *array1 = @[@"年",@"月",@"日"];
    NSMutableString *string = [[NSMutableString alloc]init];
    for (int i = 1; i < 3; i++)
    {
        [string appendString:[NSString stringWithFormat:@"%@%@",array[i],array1[i]]];
    }
    return string;
}


@end
