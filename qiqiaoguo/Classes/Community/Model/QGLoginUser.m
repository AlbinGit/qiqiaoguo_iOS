//
//  BLULoginUser.m
//  LongForTianjie
//
//  Created by cws on 16/4/14.
//  Copyright © 2016年 platomix. All rights reserved.
//

#import "QGLoginUser.h"

@implementation QGLoginUser
+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return @{
             @"userID": @"id",
             @"unionID": @"en_uid",
             @"nickname": @"uname",
             @"email": @"email",
             @"gender": @"sex",
             @"level": @"rank",
             @"coin": @"scores",
             @"openID": @"openId",
             @"pushToken": @"push_token",
             @"mobile": @"username",
             };
}


+ (NSValueTransformer *)WechatHeadimgURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

+ (NSValueTransformer *)userIDJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return @([string integerValue]);
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [number stringValue];
    }];
}

+ (NSValueTransformer *)coinJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return @([string integerValue]);
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [number stringValue];
    }];
}

+ (NSValueTransformer *)levelJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return @([string integerValue]);
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [number stringValue];
    }];
}



+ (NSValueTransformer *)genderJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        if ([string isEqualToString:@"男"]) {
            return @1;
        }
        return @2;
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        if ([number integerValue] == 1) {
            return @"男";
        }
        return @"女";
    }];
}


@end
