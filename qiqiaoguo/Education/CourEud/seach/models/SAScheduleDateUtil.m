//
//  SAScheduleDateUtil.m
//  SalesAssistant
//
//  Created by HeYM on 14/12/30.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SAScheduleDateUtil.h"

@implementation SAScheduleDateUtil



static SAScheduleDateUtil *_shareInstance = nil;

+ (SAScheduleDateUtil *)sharedInstance
{
    @synchronized(self)
    {
        if (!_shareInstance){
            _shareInstance = [[SAScheduleDateUtil alloc]init];
        }
    }
    return _shareInstance;
}



-(NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

- (NSDate *)dateFromStringHour:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}


- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


- (NSString *)stringFromDateHour:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *time = [formatter stringFromDate:date];
    return time;
}


-(NSDate *)dateFromDatePlusMinute:(NSDate *)date Minute:(NSInteger)minute{
//    NSDate *date=[NSDate date];
    double d= date.timeIntervalSince1970;
    d=d-60*minute;
    date=[NSDate dateWithTimeIntervalSince1970:d];
    return date;
}


@end
