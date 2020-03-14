//
//  BLUMessageCategory.m
//  Blue
//
//  Created by Bowen on 13/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUMessageCategory.h"

NSString * const BLUMessageCategoryKeyType                  = @"type";
NSString * const BLUMessageCategoryKeyContent               = @"content";
NSString * const BLUMessageCategoryKeyLastTime              = @"lastTime";
NSString * const BLUMessageCategoryKeyUnreadCount           = @"unreadCount";
NSString * const BLUMessageCategoryKeyTargetUser            = @"targetUser";

@implementation BLUMessageCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BLUMessageCategoryKeyType:                 @"msg_type",
             BLUMessageCategoryKeyContent:              @"msg_last_content",
             BLUMessageCategoryKeyLastTime:             @"msg_last_date",
             BLUMessageCategoryKeyUnreadCount:          @"msg_unread_count",
             BLUMessageCategoryKeyTargetUser:           @"msg_target",
             };
}

+ (NSValueTransformer *)lastTimeJSONTransformer {
    return [BLUMessageCategory createDateJSONTransformer];
}

+ (NSValueTransformer *)targetUserJSONTransformer {
    return [BLUMessageCategory userJSONTransformer];
}

@end

@implementation BLUMessageCategory (Test)

+ (BLUMessageCategory *)testMessageCategoryWithType:(BLUMessageCategoryType)type {
    NSDictionary *dict = @{
                           BLUMessageCategoryKeyType: @(type),
                           BLUMessageCategoryKeyContent: [NSString randomLorumIpsumWithLength:arc4random() % 40],
                           BLUMessageCategoryKeyLastTime: [NSDate date],
                           BLUMessageCategoryKeyUnreadCount: @(arc4random() % 1000),
                           };

    return [[BLUMessageCategory alloc] initWithDictionary:dict error:nil];
}

+ (BLUMessageCategory *)testDynamicCategory {
    return [BLUMessageCategory testMessageCategoryWithType:BLUMessageCategoryTypeDynamic];
}

+ (BLUMessageCategory *)testChatCategory {
    return [BLUMessageCategory testMessageCategoryWithType:BLUMessageCategoryTypeChat];
}

@end
