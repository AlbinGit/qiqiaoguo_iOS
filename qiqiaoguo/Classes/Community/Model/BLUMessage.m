//
//  BLUMessage.m
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUMessage.h"
#import "BLUContentParagraph.h"
#import "BLUMessageMO.h"
#import "BLUImageRes.h"
#import "BLUContentParagraph.h"

NSString * const BLUMessageKeyID             = @"messageID";
NSString * const BLUMessageKeyCreateDate     = @"createDate";
NSString * const BLUMessageKeyToUser         = @"toUser";
NSString * const BLUMessageKeyFromUser       = @"fromUser";
NSString * const BLUMessageKeyContent        = @"content";
NSString * const BLUMessageKeyRemoteState    = @"remoteState";
NSString * const BLUMessageKeyShowSendTime   = @"showSendTime";
NSString * const BLUMessageKeyType           = @"type";
NSString * const BLUMessageKeyRedirectType   = @"redirectType";
NSString * const BLUMessageKeyRedirectID     = @"redirectID";

@implementation BLUMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        BLUMessageKeyID:             @"message_id",
        BLUMessageKeyCreateDate:     @"send_date",
        BLUMessageKeyToUser:         @"to_user",
        BLUMessageKeyFromUser:       @"from_user",
        BLUMessageKeyContent:        @"content",
        BLUMessageKeyType:           @"content.type",
        BLUMessageKeyRedirectType:   @"jump_type",
        BLUMessageKeyRedirectID:     @"jump_id",
        @"fromUserID":               @"from_user_id",
        @"fromUserName":             @"from_nickname",
        @"fromUserImageStr":         @"from_head_image",
        @"toUserID":                 @"to_user_id",
        @"width":                    @"width",
        @"height":                   @"height",
    };
}

+ (NSValueTransformer *)contentJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary  *dict, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[BLUContentParagraph class] fromJSONDictionary:dict error:nil];
    } reverseBlock:^id(BLUContentParagraph *contentParagraph, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONDictionaryFromModel:contentParagraph error:nil];
    }];
}

+ (NSValueTransformer *)fromUserJSONTransformer {
    return [self userJSONTransformer];
}

+ (NSValueTransformer *)toUserJSONTransformer {
    return [self userJSONTransformer];
}

+ (NSValueTransformer *)createTimeJSONTransformer {
    return [BLUMessage createDateJSONTransformer];
}

@end

@implementation BLUMessage (Test)

+ (instancetype)testMessage {
    NSDictionary *dict = @{
        BLUMessageKeyID:             @(0),
        BLUMessageKeyCreateDate:     [NSDate date],
        BLUMessageKeyToUser:         [BLUUser testUser],
        BLUMessageKeyFromUser:       [BLUUser testUser],
        BLUMessageKeyContent:        [NSString randomLorumIpsumWithLength:arc4random() % 200],
    };
    return [[BLUMessage alloc] initWithDictionary:dict error:nil];
}

@end

@implementation BLUMessage (ManagedObject)

+ (BLUMessage *)messageWithMessageManagedObject:(BLUMessageMO *)messageMO {
    NSParameterAssert([messageMO isKindOfClass:[BLUMessageMO class]]);

    BLUImageRes *fromUserAvatar =
    [[BLUImageRes alloc]
     initWithDictionary:@{BLUImageResKeyThumbnailURL:[NSURL URLWithString:messageMO.fromUserThumbnailAvatarURL]}
                  error:nil];

    BLUUser *fromUser =
    [[BLUUser alloc]
     initWithDictionary:@{BLUUserKeyUserID: messageMO.fromUserID,
                          BLUUserKeyNickname: messageMO.fromUserNickname,
                          BLUUserKeyAvatar: fromUserAvatar,
                          BLUUserKeyGender: messageMO.fromUserGender}
                  error:nil];

    BLUUser *toUser =
    [[BLUUser alloc]
     initWithDictionary:@{BLUUserKeyUserID: messageMO.toUserID}
                  error:nil];

    BLUContentParagraph *contentParagraph;
    BLUMessage *message;

    NSInteger contentType = messageMO.contentType.integerValue;
    if (contentType == 0) {
        contentParagraph =
        [[BLUContentParagraph alloc]
         initWithDictionary:@{BLUContentParagraphType: @(0),
                              BLUContentParagraphText: messageMO.text}
         error:nil];

        message =
        [[BLUMessage alloc]
         initWithDictionary:@{BLUMessageKeyID: messageMO.messageID,
                              BLUMessageKeyCreateDate: messageMO.createDate,
                              BLUMessageKeyToUser: toUser,
                              BLUMessageKeyFromUser: fromUser,
                              BLUMessageKeyContent: contentParagraph,
                              BLUMessageKeyShowSendTime: messageMO.showSendTime,
                              }
         error:nil];
    }

    return message;
}

@end
