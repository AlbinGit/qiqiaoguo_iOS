//
//  NSDate+Calendar.h
//  FreeDaily
//
//  Created by YongbinZhang on 3/7/13.
//  Copyright (c) 2013 YongbinZhang
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calendar)

- (NSDateComponents *)componentsOfDay;
- (NSInteger)weekdayOrdinal;

- (NSUInteger)year;
- (NSUInteger)month;
- (NSUInteger)day;
- (NSUInteger)hour;
- (NSUInteger)minute;

- (NSUInteger)second;
- (NSUInteger)weekday;
- (NSUInteger)week;
- (NSDate *)beginingOfDay;
- (NSDate *)endOfDay;

- (NSDate *)firstDayOfTheMonth;
- (NSDate *)lastDayOfTheMonth;
- (NSDate *)firstDayOfThePreviousMonth;
- (NSDate *)firstDayOfTheFollowingMonth;
- (NSDate *)associateDayOfThePreviousMonth;
- (NSDate *)associateDayOfTheFollowingMonth;

- (NSUInteger)numberOfDaysInMonth;
- (NSUInteger)numberOfWeeksInMonth;
- (NSDate *)firstDayOfTheWeek;
- (NSDate *)firstDayOfThePreviousWeekInTheMonth;
- (NSDate *)firstDayOfTheLastWeekInPreviousMonth;

- (NSDate *)firstDayOfTheFollowingWeekInTheMonth;
- (NSDate *)firstDayOfTheFirstWeekInFollowingMonth;
- (NSDate *)firstDayOfTheWeekInTheMonth;
- (NSUInteger)numberOfDaysInTheWeekInMonth;
- (NSUInteger)weekOfDayInMonth;

- (NSUInteger)weekOfDayInYear;
- (NSDate *)associateDayOfThePreviousWeek;
- (NSDate *)associateDayOfTheFollowingWeek;
- (NSDate *)previousDay;
- (NSDate *)followingDay;
- (BOOL)sameDayWithDate:(NSDate *)otherDate;

- (BOOL)sameWeekWithDate:(NSDate *)otherDate;
- (BOOL)sameMonthWithDate:(NSDate *)otherDate;

@end
