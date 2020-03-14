//
//  BLUImageRes.m
//  Blue
//
//  Created by Bowen on 19/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

NSString * BLUImageResKeyID = @"imageID";
NSString * BLUImageResKeyThumbnailURL = @"thumbnailURL";
NSString * BLUImageResKeyOriginURL = @"originURL";
NSString * BLUImageResKeyHeight = @"height";
NSString * BLUImageResKeyWeight = @"width";
NSString * BLUImageResKeyCreateDate = @"createDate";

#import "BLUImageRes.h"

@implementation BLUImageRes

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"imageID": @"image_id",
        @"thumbnailURL": @"thumbnail_url",
        @"originURL": @"origin_url",
        @"height": @"height",
        @"width": @"width",
        @"createDate": @"create_date",
        @"name": @"image_name",
    };
}

//+ (NSValueTransformer *)widthJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}
//
//+ (NSValueTransformer *)heightJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}

+ (NSValueTransformer *)thumbnailURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

+ (NSValueTransformer *)originURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

- (instancetype)initWithThumbnailURL:(NSURL *)thumbailURL originURL:(NSURL *)originURL {
    if (self = [super init]) {
        _thumbnailURL = thumbailURL;
        _originURL = originURL;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name {
    if (self = [super init]) {
        _image = image;
        _name = name;
    }
    return self;
}

- (instancetype)initWithWidth:(CGFloat)width
                       height:(CGFloat)height
                    originURL:(NSURL *)originURL
                 thumbnailURL:(NSURL *)thumbnailURL {
    BLUAssertObjectIsKindOfClass(originURL, [NSURL class]);
    BLUAssertObjectIsKindOfClass(thumbnailURL, [NSURL class]);

    NSDictionary *dict =
    @{@"width": @(width),
      @"height": @(height),
      @"thumbnailURL": thumbnailURL,
      @"originURL": originURL};

    return [[BLUImageRes alloc] initWithDictionary:dict error:nil];
}

@end
