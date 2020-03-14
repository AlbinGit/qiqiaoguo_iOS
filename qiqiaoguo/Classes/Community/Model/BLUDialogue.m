//
//  BLUDialogue.m
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

NSString * const BLUDialogueKeyID               = @"dialogueID";
NSString * const BLUDialogueKeyCreateDate       = @"createDate";
NSString * const BLUDialogueKeyLastTime         = @"lastTime";
NSString * const BLUDialogueKeyUnreadCount      = @"unreadCount";
NSString * const BLUDialogueKeyLastMessage      = @"lastMessage";
NSString * const BLUDialogueKeyFromUser         = @"fromUser";

#import "BLUDialogue.h"

@implementation BLUDialogue

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        BLUDialogueKeyID:              @"dialogue_id",
        BLUDialogueKeyCreateDate:      @"create_date",
        BLUDialogueKeyLastTime:        @"last_message_time",
        BLUDialogueKeyUnreadCount:     @"unread_count",
        BLUDialogueKeyLastMessage:     @"last_message",
        BLUDialogueKeyFromUser:        @"target",
        @"targetName":                 @"target_name",
        @"targetID":                   @"target_id",
        @"targetImage":                @"head_image",
        @"width":                      @"width",
        @"heigth":                     @"height",
    };
}

+ (NSValueTransformer *)fromUserJSONTransformer {
    return [self userJSONTransformer];
}

+ (NSValueTransformer *)lastTimeJSONTransformer {
    return [BLUDialogue createDateJSONTransformer];
}

@end

@implementation BLUDialogue (Test)

+ (instancetype)testDialogue {
    NSDictionary *dict = @{
        BLUDialogueKeyID: @(0),
        BLUDialogueKeyCreateDate:    [NSDate date],
        BLUDialogueKeyLastTime:      [NSDate date],
        BLUDialogueKeyUnreadCount:   @(arc4random() % 1000),
        BLUDialogueKeyLastMessage:   [NSString randomLorumIpsumWithLength:arc4random() % 40],
        BLUDialogueKeyFromUser:      [BLUUser testUser],
    };
    return [[BLUDialogue alloc] initWithDictionary:dict error:nil];
}

@end
