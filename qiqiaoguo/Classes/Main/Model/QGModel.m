//
//  QGModel.m
//  qiqiaoguo
//
//  Created by cws on 16/6/3.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGModel.h"

@implementation QGModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)makeDicModelTransformer:(Class)aClass {
    NSParameterAssert([aClass isSubclassOfClass:[QGModel class]]);
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *dict, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:aClass fromJSONDictionary:dict error:nil];
    } reverseBlock:^id(id model , BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    }];
}

+ (NSValueTransformer *)makeArrayModelTransformer:(Class)aClass {
    NSParameterAssert([aClass isSubclassOfClass:[QGModel class]]);
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *contents, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:aClass
                               fromJSONArray:contents
                                       error:nil];
    } reverseBlock:^id(NSArray *paragraphs , BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:paragraphs error:nil];
    }];
}

/** 将number转为字符串*/
+ (NSValueTransformer *)makeNumberConvertToString
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [number stringValue];
    } reverseBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return @([string integerValue]);
}];
}

// 转换时间
+ (NSValueTransformer *)createDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedModelDateFormater] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedModelDateFormater] stringFromDate:date];
    }];
}

@end
