//
//  BLUServerNotification.m
//  Blue
//
//  Created by Bowen on 30/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUServerNotification.h"

@implementation BLUServerNotification

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"notificationID": @"sn_id",
        @"objectID":       @"id",
        @"createDate":     @"create_date",
        @"title":          @"title",
        @"content":        @"alert",
        @"webURL":         @"page_url",
        @"photo":          @"as",
        @"imageURL":       @"cover_path",
        @"type":           @"type",
        @"height":         @"height",
        @"width":          @"width",
    };
}

//+ (NSValueTransformer *)photoJSONTransformer {
//    return [self makeModelTransformer:[BLUImageRes class]];
//}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

+ (NSValueTransformer *)webURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

- (void)setNilValueForKey:(NSString *)key
{
   NSLog(@"nil value detect for key=%@", key);
    
    if ([key isEqualToString:@"webURL"]) {
        
        [self setValue:[NSURL URLWithString:@"www.baidu.com"] forKey:@"webURL"];
        
    }else {
        
        [super setNilValueForKey:key];
        
    }
    
}

//+ (NSValueTransformer *)objectIDJSONTransformer {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return @(number ? number.integerValue : 0);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return number;
//    }];
//}

//+ (NSValueTransformer *)objectIDJSONTransformer {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return @(number ? number.integerValue : 0);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return number;
//    }];
//}

@end
