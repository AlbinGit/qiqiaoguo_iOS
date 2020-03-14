//
//  QGSearchScreeningModel.m
//  qiqiaoguo
//
//  Created by cws on 16/9/8.
//
//

#import "QGSearchScreeningModel.h"

@implementation QGSearchScreeningModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"courseCateList": @"courseCateList",
             @"areaList": @"areaList",
             @"sortList": @"sortList",
             @"orgCateList":@"orgCateList",
             };
}

+ (NSValueTransformer *)courseCateListJSONTransformer {
    
    return [self makeArrayModelTransformer:[QGScreeningModel class]];
}

+ (NSValueTransformer *)areaListJSONTransformer {
    
    return [self makeArrayModelTransformer:[QGScreeningModel class]];
}

+ (NSValueTransformer *)sortListJSONTransformer {
    
    return [self makeArrayModelTransformer:[QGScreeningModel class]];
}

+ (NSValueTransformer *)orgCateListJSONTransformer {
    
    return [self makeArrayModelTransformer:[QGScreeningModel class]];
}


@end

@implementation QGScreeningModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"courseID": @"id",
             @"subListArray": @"sublist",
             };
}

+ (NSValueTransformer *)subListArrayJSONTransformer {
    
    return [self makeArrayModelTransformer:[QGScreeningModel class]];
}

@end
