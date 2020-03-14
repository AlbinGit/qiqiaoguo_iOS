//
//  BLURemoteNotification.m
//  Blue
//
//  Created by Bowen on 25/9/15.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLURemoteNotification.h"
#import "BLUAps.h"

@implementation BLURemoteNotification

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"objectID": @"id",
        @"type": @"type",
        @"url": @"page_url",
        @"aps": @"aps",
    };
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

+ (NSValueTransformer *)apsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *apsDict, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[BLUAps class] fromJSONDictionary:apsDict error:nil];
    } reverseBlock:^id(BLUAps *aps, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONDictionaryFromModel:aps error:nil];
    }];
}

@end
