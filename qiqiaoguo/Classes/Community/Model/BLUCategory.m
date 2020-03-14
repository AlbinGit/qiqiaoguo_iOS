//
//  BLUCategory.m
//  Blue
//
//  Created by Bowen on 19/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCategory.h"

@implementation BLUCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"categoryID": @"category_id",
        @"name": @"name",
        @"categoryDescription": @"description",
        @"logo": @"logo",
        @"circleCount": @"circle_count",
        @"createDate": @"create_date",
    };
}

+ (NSValueTransformer *)logoJSONTransformer {
    return [self imageResJSONTransformer];
}

@end
