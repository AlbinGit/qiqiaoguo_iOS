//
//  BLUPost.m
//  Blue
//
//  Created by Bowen on 22/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPost.h"
#import "BLUUser.h"
#import "BLUImageRes.h"
#import "BLUContentParagraph.h"
#import "BLUPostTag.h"
#import "BLUShareObject.h"
#import "BLUContentParagraph.h"
#import "BLUCircle.h"

@interface BLUPost ()

@property (nonatomic, copy, readwrite) NSArray *paragraphs;

@end

static NSString * const kShareBaseURLString = @"http://m.blue69.cn/post/share/";
static const NSInteger kShareContentLength = 32;

NSInteger BLUPostTitleMaxLength = 32;
NSInteger BLUPostContentMaxLength = 2000;
NSInteger BLUPostMaxPhotosCount = 9;

NSString * const BLUPostKeyPostID = @"postID";
NSString * const BLUPostKeyPost = @"post";

@implementation BLUPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"postID": @"post_id",
        @"createDate": @"create_date",
        @"title": @"title",
        @"content": @"content",
        @"author": @"author",
        @"circle": @"circle",

        @"postType": @"post_type",
        @"commentCount": @"comment_count",
        @"likeCount": @"like_count",
        @"photoCount": @"photo_count",
        @"collectedCount": @"collect_count",
        
        @"photos": @"photos",
        
        @"likedUsers": @"liked_users",
        
        @"like": @"is_like_post",
        @"collect": @"is_collect_post",
        
        @"paragraphs": @"html_content",
        @"contentType": @"post_content_type",

        @"anonymousEnable": @"anonymous_status",

        @"hasVideo": @"is_video",

        @"isTop": @"top_status",

        @"tags": @"post_tags",

        @"follow": @"is_follow_author",
        @"recommend": @"is_recommended",
        @"videoCoverURL": @"video_face",
        @"accessCount": @"access_count",
    };
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [self userJSONTransformer];
}

+ (NSValueTransformer *)videoCoverURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *URLString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:URLString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return url.absoluteString;
    }];
}

//+ (NSValueTransformer *)postIDJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}
//
//+ (NSValueTransformer *)postTypeJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}
//
//
//+ (NSValueTransformer *)isTopJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return [string integerValue]?@(YES):@(NO);;
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}
//
//+ (NSValueTransformer *)anonymousEnableJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}
//
//
//+ (NSValueTransformer *)commentCountJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}
//
//+ (NSValueTransformer *)likeCountJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}
//
//+ (NSValueTransformer *)hasVideoJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}
//
//+ (NSValueTransformer *)contentTypeJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}


+ (NSValueTransformer *)tagsJSONTransformer {
    return [MTLValueTransformer
            transformerUsingForwardBlock:^id(NSArray *tagDicts,
                                             BOOL *success,
                                             NSError *__autoreleasing *error) {

                NSError *e;
                NSArray *tags = [MTLJSONAdapter modelsOfClass:[BLUPostTag class] fromJSONArray:tagDicts error:&e];
                return tags;
            } reverseBlock:^id(NSArray *tags,
                       BOOL *success,
                       NSError *__autoreleasing *error) {

        return [MTLJSONAdapter JSONArrayFromModels:tags
                                             error:nil];

    }];
}

+ (NSValueTransformer *)paragraphsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *contents, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[BLUContentParagraph class] fromJSONArray:contents error:nil];
    } reverseBlock:^id(NSArray *paragraphs , BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:paragraphs error:nil];
    }];
}

+ (NSValueTransformer *)circleJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *contents, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[BLUCircle class] fromJSONDictionary:contents error:nil];
    } reverseBlock:^id(NSArray *circles, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:circles error:nil];
    }];
}

+ (NSValueTransformer *)photosJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *photos, BOOL *success, NSError *__autoreleasing *error) {
        NSError *e;
        return [MTLJSONAdapter modelsOfClass:[BLUImageRes class] fromJSONArray:photos error:&e];
        
    } reverseBlock:^id(NSArray *photos, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:photos error:nil];
    }];
}

+ (NSValueTransformer *)likedUsersJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *users, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[BLUUser class] fromJSONArray:users error:nil];
    } reverseBlock:^id(NSArray *users, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:users error:nil];
    }];
}

- (void)generateParagraphFromNormalContent {
    NSMutableArray *paragraphs = [NSMutableArray new];
    if (self.content.length > 0) {
        BLUContentParagraph *p = [self paragraphFromText:self.content];
        [paragraphs addObject:p];
    }

    for (BLUImageRes *imageRes in self.photos) {
        BLUContentParagraph *p = [self paragraphFromImageRes:imageRes];
        [paragraphs addObject:p];
    }

    self.paragraphs = paragraphs;
}

- (void)generateParagraphFromPhotos {
    NSMutableArray *paragraphs = nil;

    if (self.paragraphs.count > 0) {
        paragraphs = [NSMutableArray arrayWithArray:self.paragraphs];
    } else {
        paragraphs = [NSMutableArray new];
    }

    for (BLUImageRes *imageRes in self.photos) {
        BLUContentParagraph *p = [self paragraphFromImageRes:imageRes];
        [paragraphs addObject:p];
    }

    self.paragraphs = paragraphs;
}

- (BLUContentParagraph *)paragraphFromText:(NSString *)text {
    BLUAssertObjectIsKindOfClass(text, [NSString class]);
    NSDictionary *paragraphDict =
    @{@"type": @(BLUPostParagraphTypeText),
      @"text": text};
    return [[BLUContentParagraph alloc] initWithDictionary:paragraphDict
                                                     error:nil];
}

- (BLUContentParagraph *)paragraphFromImageRes:(BLUImageRes *)imageRes {
    BLUAssertObjectIsKindOfClass(imageRes, [BLUImageRes class]);
    NSDictionary *paragraphDict =
    @{@"type": @(BLUPostParagraphTypeImage),
      @"imageURL": imageRes.originURL,
      @"height": @(imageRes.height),
      @"width": @(imageRes.width)};
    return [[BLUContentParagraph alloc] initWithDictionary:paragraphDict
                                                     error:nil];
}

@end

@implementation BLUPost (Share)

- (BLUShareObjectType)objectType {
    return BLUShareObjectTypePost;
}

- (NSString *)shareTitle{
    return self.title;
}

- (NSString *)shareContent {
    if (self.content.length > kShareContentLength) {
        return [NSString stringWithFormat:@"%@...", [self.content substringWithRange:NSMakeRange(0, kShareContentLength)]];
    } else {
        return self.content;
    }
}

- (NSURL *)shareImageURL {
    for ( BLUContentParagraph * par in self.paragraphs) {
        if ([par.imageURL isKindOfClass:[NSURL class]] && par.imageURL != nil) {
            return par.imageURL;
        }
    }
    return ((BLUImageRes *)self.photos.firstObject).originURL;
}

- (NSURL *)shareRedirectURL {
    NSString *URLString = [NSString stringWithFormat:@"%@/post/share/post_id/%@", [[BLUServer sharedServer] baseURLString], @(self.postID)];
    return [NSURL URLWithString:URLString];
}

- (UIImage *)shareDefaultImage {
    return [UIImage imageNamed:@"logo-40"];
}

@end

@implementation BLUPost (Validation)

+ (RACSignal *)validatePostTitle:(RACSignal *)titleSignal {
    return [titleSignal map:^id(NSString *title) {
        BOOL ret = NO;
        if ([title isKindOfClass:[NSString class]]) {
            ret = [title isPostTitle];
        }
        return @(ret);
    }];
}

+ (RACSignal *)validatePostContent:(RACSignal *)contentSignal {
    return [contentSignal map:^id(NSString *content) {
        BOOL ret = NO;
        if ([content isKindOfClass:[NSString class]]) {
            ret = [content isPostContent];
        }
        return @(ret);
    }];
}

@end

@implementation NSString (BLUPost)

- (BOOL)isPostTitle {
    return (self.length > 0 && self.length <= 32);
}

- (BOOL)isPostContent {
    return (self.length >= 6 && self.length <= 2000);
}

@end
