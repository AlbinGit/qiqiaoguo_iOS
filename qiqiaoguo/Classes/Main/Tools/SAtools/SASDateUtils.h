//
//  SASDateUtils.h
//  SalesAssistant
//
//  Created by Albin on 15/5/14.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SASDateUtils : NSObject

// 得到当前时间
+ (NSString *)getTime;
// 得到当前年月
+ (NSString *)getYearAndMonth;
// 得到当前月日
+ (NSString *)getMonthAndDay;
// 字符串转换年月
+ (NSString *)getMonthAndDay:(NSString *)stringDate;
// 日期类型转字符串
+ (NSString *)dateToString:(NSDate *)date;
// 字符串转日期类型
+ (NSDate *)stringToDate:(NSString *)string;

// 2015-02-04 15:00:30 --> 15:00
+ (NSString *)getHourAndMinute:(NSString *)string;
+ (NSString *)getHour:(NSString *)string;

// 2015-02-04 15:00:30 --> 02-04
+ (NSString *)getMonthAndDaySting:(NSString *)string;
// 判断今日昨日
+ (NSString *)compareDateToDate:(NSString *)dateString;

//xxxx-xx-xx --->xxxx年xx月xx日
+ (NSString *)getNormalData:(NSString *)str;
//xxxx-xx-xx --->xx月xx日
+ (NSString *)getNormalMonthAndDayData:(NSString *)str;

@end
