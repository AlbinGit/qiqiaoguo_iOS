//
//  BLUObject.m
//  Blue
//
//  Created by Bowen on 29/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"
#import "BLUCircle.h"
#import "BLUPost.h"
#import "BLUResponse.h"
#import "BLUImageRes.h"
#import "BLUCategory.h"
#import "BLUPagination.h"
#import "BLUComment.h"
#import "BLUContentParagraph.h"

@implementation BLUObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)createDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedModelDateFormater] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedModelDateFormater] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedModelDateFormater] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedModelDateFormater] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)userJSONTransformer {
    return [self makeModelTransformer:[BLUUser class]];
}

+ (NSValueTransformer *)circleJSONTransformer {
    return [self makeModelTransformer:[BLUCircle class]];
}

+ (NSValueTransformer *)postJSONTransformer {
    return [self makeModelTransformer:[BLUPost class]];
}

+ (NSValueTransformer *)responseJSONTransformer {
    return [self makeModelTransformer:[BLUResponse class]];
}

+ (NSValueTransformer *)imageResJSONTransformer {
    return [self makeModelTransformer:[BLUImageRes class]];
}

+ (NSValueTransformer *)categoryJSONTransformer {
    return [self makeModelTransformer:[BLUCategory class]];
}

+ (NSValueTransformer *)paginationJSONTransformer {
    return [self makeModelTransformer:[BLUPagination class]];
}

+ (NSValueTransformer *)commentJSONTransformer {
    return [self makeModelTransformer:[BLUComment class]];
}

+ (NSValueTransformer *)postParagraphJSONTransformer {
    return [self makeModelTransformer:[BLUContentParagraph class]];
}

+ (NSValueTransformer *)makeModelTransformer:(Class)aClass {
    NSParameterAssert([aClass isSubclassOfClass:[BLUObject class]]);
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *dict, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:aClass fromJSONDictionary:dict error:nil];
    } reverseBlock:^id(id model , BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    }];
}

@end

@implementation BLUObject (SymbleNumber)

- (NSString *)symbleInt:(NSInteger)num {
    if (num >= 0) {
        return [NSString stringWithFormat:@"+%@", @(num)];
    } else {
        return [NSString stringWithFormat:@"%@", @(num)];
    }
}

@end

static const NSTimeInterval __XY_SECOND     = 1;
static const NSTimeInterval __XY_MINUTE     = (60 * __XY_SECOND);
static const NSTimeInterval __XY_HOUR       = (60 * __XY_MINUTE);
static const NSTimeInterval __XY_DAY        = (24 * __XY_HOUR);
static const NSTimeInterval __XY_MONTH      = (30 * __XY_DAY);
static const NSTimeInterval __XY_YEAR       = (12 * __XY_MONTH);

@implementation NSDate (BLUObject)

- (NSString *)postTime {
    
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSTimeInterval delta = [localeDate timeIntervalSinceDate:self];
    
    if (delta < 1 * __XY_MINUTE) {
        return NSLocalizedString(@"date-addition.<1min", @"1m");
    } else if (delta < 1 * __XY_HOUR) {
        NSInteger minutes = floor((double)delta / __XY_MINUTE);
        return [NSString stringWithFormat:NSLocalizedString(@"date-addition.%d-m", @"%dm") , minutes];
    } else if (delta < 1 * __XY_DAY) {
        NSInteger hours = floor((double)delta /__XY_HOUR);
        return [NSString stringWithFormat:NSLocalizedString(@"date-addition.%d-h", @"%dh"), hours];
    } else if (delta < 1 * __XY_MONTH) {
        NSInteger days = floor((double)delta / __XY_DAY);
        return [NSString stringWithFormat:NSLocalizedString(@"date-addition.%d-day", @"%dd"), days];
    } else if (delta < 1 * __XY_YEAR) {
        NSInteger month = floor((CGFloat)delta / __XY_MONTH);
        return [NSString stringWithFormat:NSLocalizedString(@"date-addition.%d-month", @"%dmon"), month];
    } else {
        NSInteger year = floor((CGFloat)delta / __XY_YEAR);
        return [NSString stringWithFormat:NSLocalizedString(@"date-addition.%d-year", @"%dy"), year];
    }
}

@end
