//
//  BLUPostParagraph.m
//  Blue
//
//  Created by Bowen on 22/9/15.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUContentParagraph.h"

NSString * const BLUContentParagraphText = @"text";
NSString * const BLUContentParagraphImageURL = @"imageURL";
NSString * const BLUContentParagraphVideoURL = @"videoURL";
NSString * const BLUContentParagraphHeight = @"height";
NSString * const BLUContentParagraphWidth = @"width";
NSString * const BLUContentParagraphType = @"type";
NSString * const BLUContentParagraphImageRes = @"imageRes";

@implementation BLUContentParagraph

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"height": @"height",
        @"type": @"type",
        @"imageURL": @"url",
        @"width": @"width",
        @"text": @"text",
        @"videoURL": @"video_url",
        @"redirectType": @"redirect",
        @"pageURL": @"pageurl",
        @"objectID": @"id",
    };
}


+ (NSValueTransformer *)widthJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return @([string integerValue]);
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [number stringValue];
    }];
}

+ (NSValueTransformer *)heightJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return @([string integerValue]);
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [number stringValue];
    }];
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

+ (NSValueTransformer *)videoURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

+ (NSValueTransformer *)vpageURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

+ (BLUContentParagraph *)paragraphWithText:(NSString *)text {
    BLUAssertObjectIsKindOfClass(text, [NSString class]);
    NSDictionary *paragraphDict =
    @{BLUContentParagraphText: text,
      BLUContentParagraphType: @(BLUPostParagraphTypeText)};
    return [[BLUContentParagraph alloc] initWithDictionary:paragraphDict
                                                     error:nil];
}

+ (BLUContentParagraph *)paragraphWithImageRes:(BLUImageRes *)imageRes {
    BLUAssertObjectIsKindOfClass(imageRes, [BLUImageRes class]);
    NSDictionary *paragraphDict =
    @{BLUContentParagraphImageRes: imageRes,
      BLUContentParagraphType: @(BLUPostParagraphTypeImage)};
    return [[BLUContentParagraph alloc] initWithDictionary:paragraphDict
                                                     error:nil];
}

@end
