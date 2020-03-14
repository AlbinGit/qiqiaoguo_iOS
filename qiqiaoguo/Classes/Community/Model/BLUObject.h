//
//  BLUObject.h
//  Blue
//
//  Created by Bowen on 29/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface BLUObject : MTLModel <MTLJSONSerializing>

+ (NSValueTransformer *)createDateJSONTransformer;
+ (NSValueTransformer *)dateJSONTransformer;
+ (NSValueTransformer *)userJSONTransformer;
+ (NSValueTransformer *)circleJSONTransformer;
+ (NSValueTransformer *)postJSONTransformer;
+ (NSValueTransformer *)responseJSONTransformer;
+ (NSValueTransformer *)imageResJSONTransformer;
+ (NSValueTransformer *)categoryJSONTransformer;
+ (NSValueTransformer *)paginationJSONTransformer;
+ (NSValueTransformer *)commentJSONTransformer;
+ (NSValueTransformer *)postParagraphJSONTransformer;

+ (NSValueTransformer *)makeModelTransformer:(Class)aClass;

@end

@interface BLUObject (SymbleNumber)

- (NSString *)symbleInt:(NSInteger)num;

@end

@interface NSDate (BLUObject)

- (NSString *)postTime;

@end

@interface NSDateFormatter (BLUObject)

+ (NSDateFormatter *)sharedModelDateFormater;
+ (NSDateFormatter *)sharedBirthdayDateFormater;

+ (NSDateFormatter *)postTimeMonthDateFormater;
+ (NSDateFormatter *)postTimeYearDateFormater;

@end

@implementation NSDateFormatter (BLUObject)

+ (NSDateFormatter *)sharedModelDateFormater {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [dateFormatter setTimeZone:utcTimeZone];
        
    });
    return dateFormatter;
}

+ (NSDateFormatter *)sharedBirthdayDateFormater {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [dateFormatter setTimeZone:utcTimeZone];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)postTimeMonthDateFormater{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)postTimeYearDateFormater {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    return dateFormatter;
    
}

@end