//
//  BLUVersion.m
//  Blue
//
//  Created by Bowen on 17/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUVersion.h"

NSString *BLUVersionKeyType = @"type";

@implementation BLUVersion

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"url": @"url",
             @"version": @"version",
             @"type": @"type",
             };
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *str, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:str];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

@end
