//
//  BLUComment.m
//  Blue
//
//  Created by Bowen on 22/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUComment.h"
#import "BLUCommentReply.h"

NSString * const BLUCommentKeyCommentID = @"commentID";
NSString * const BLUCommentKeyComment = @"comment";
NSString * const BLUCommentKeyReadOwner = @"read_owner";

NSInteger BLUCommentMaxPhotoCount = 1;

@implementation BLUComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"commentID": @"post_comment_id",
        @"createDate": @"create_date",
        @"content": @"content",
        @"post": @"post",
        @"author": @"author",
        @"photo": @"photo",
        @"replyType": @"reply_type",
        @"likeCount": @"like_count",
        @"floor": @"floor",
        
        @"like": @"is_like_comment",

        @"replies": @"replies",

        @"replyCount": @"reply_count",
    };
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [self userJSONTransformer];
}

+ (NSValueTransformer *)photoJSONTransformer {
    return [self imageResJSONTransformer];
}

+ (NSValueTransformer *)photosJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *photos, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[BLUImageRes class] fromJSONArray:photos error:nil];
    } reverseBlock:^id(NSArray *photos, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:photos error:nil];
    }];
}

+ (NSValueTransformer *)repliesJSONTransformer  {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *replys, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[BLUCommentReply class] fromJSONArray:replys error:nil];
    } reverseBlock:^id(NSArray *replys, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:replys error:nil];
    }];
}

@end

@implementation BLUComment (Desc)

- (NSString *)floorDesc {
    NSString *ret = nil;
    if (self.floor == 1) {
        ret = NSLocalizedString(@"comment.first-floor", @"first floor");
    } else {
        ret = [NSString stringWithFormat:NSLocalizedString(@"comment.%@-floor", @"%@ floor"), @(self.floor)];
    }
    return ret;
}

@end

@implementation BLUComment (Validation)

+ (RACSignal *)validateCommentContent:(RACSignal *)contentSignal {
    return [contentSignal map:^id(NSString *content) {
        BOOL ret = NO;
        if ([content isKindOfClass:[NSString class]]) {
            ret = [content isCommentContent];
        }
        return @(ret);
    }];
}

@end

@implementation NSString (BLUComment)

- (BOOL)isCommentContent {
    return (self.length >= 1 && self.length <= 2000);
}

@end

