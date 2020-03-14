//
//  QGRemoteNotiModel.m
//  qiqiaoguo
//
//  Created by cws on 16/6/7.
//
//

#import "QGRemoteNotiModel.h"

@implementation QGRemoteNotiModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"objectID": @"id",
             @"type": @"module",
             @"url": @"page_url",
//             @"alert": @"aps.alert",
//             @"sound":@"aps.sound",
             };
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

@end
