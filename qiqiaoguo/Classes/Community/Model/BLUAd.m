//
//  BLUAd.m
//  Blue
//
//  Created by Bowen on 10/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUAd.h"

@interface BLUAd () {
    NSInteger _redirectID;
    NSInteger _redirectType;
    NSURL *_redirectURL;
    id _redirectObject;
}

@end

@implementation BLUAd

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"title": @"title",
        @"imageURL": @"image_url",

        @"redirectID": @"id",
        @"redirectType": @"type",
        @"redirectURL": @"page_url",
    };
}

//+ (NSValueTransformer *)redirectTypeJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}


+ (NSValueTransformer *)redirectURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

+ (NSValueTransformer *)redirectIDJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        if (number == nil) {
            return 0;
        } else {
            return number;
        }
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return number;
    }];
}

- (void)setRedirectID:(NSInteger)redirectID {
    _redirectID = redirectID;
}

- (void)setRedirectType:(BLUPageRedirectionType)redirectType {
    _redirectType = redirectType;
}

- (void)setRedirectURL:(NSURL *)redirectURL {
    _redirectURL = redirectURL;
}

- (void)setRedirectObject:(id)redirectObject {
    _redirectObject = redirectObject;
}

- (NSInteger)redirectID {
    return _redirectID;
}

- (BLUPageRedirectionType)redirectType {
    return _redirectType;
}

- (NSURL *)redirectURL {
    return _redirectURL;
}

- (id)redirectObject {
    return _redirectObject;
}

@end
