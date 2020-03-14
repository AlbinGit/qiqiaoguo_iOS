//
//  BLUCommentReply.m
//  Blue
//
//  Created by Bowen on 10/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCommentReply.h"

NSString *BLUCommentReplyKeyCommentReply = @"BLUCommentReplyKeyCommentReply";
NSString *BLUCommentReplyKeyReplyID = @"BLUCommentReplyKeyReplyID";

@implementation BLUCommentReply

- (instancetype)initWithContent:(NSString *)content
                         author:(BLUUser *)author
                     createDate:(NSDate *)date {
    if (self = [super init]) {
        _content = content;
        _author = author;
        _createDate = date;
        return self;
    }
    return nil;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"replyID":    @"comment_reply_id",
             @"content":    @"content",
             @"author":     @"user",
             @"target":     @"target",
             @"isOwner":    @"is_owner",
             @"createDate": @"create_date",
        };
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [self userJSONTransformer];
}

+ (NSValueTransformer *)targetJSONTransformer {
    return [self userJSONTransformer];
}

@end

@implementation BLUCommentReply (Info)

+ (NSDictionary *)replyInfoWithReply:(BLUCommentReply *)reply {
    NSParameterAssert(reply);
    return @{BLUCommentReplyKeyCommentReply: reply};
}

+ (NSDictionary *)replyInfoWithReplyID:(NSInteger)replyID {
    return @{BLUCommentReplyKeyReplyID: @(replyID)};
}

@end

@implementation BLUCommentReply (Desc)

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

@implementation NSString (BLUCommentReply)

- (BOOL)isCommentReply {
    return (self.length >= 1 && self.length <= 2000);
}

@end