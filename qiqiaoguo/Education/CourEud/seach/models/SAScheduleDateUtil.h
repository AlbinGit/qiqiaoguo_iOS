//
//  SAScheduleDateUtil.h
//  SalesAssistant
//
//  Created by HeYM on 14/12/30.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAScheduleDateUtil : NSObject


+ (SAScheduleDateUtil *)sharedInstance;


- (NSDate *)dateFromString:(NSString *)dateString;
- (NSDate *)dateFromStringHour:(NSString *)dateString;


- (NSString *)stringFromDate:(NSDate *)date;
- (NSString *)stringFromDateHour:(NSDate *)date;

#pragma mark 根据date时间加上minute获取新时间
-(NSDate *)dateFromDatePlusMinute:(NSDate *)date Minute:(NSInteger)minute;

@end
