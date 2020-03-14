//
//  BLUMessage.m
//  Blue
//
//  Created by Bowen on 13/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUDynamic.h"

NSString * const BLUDynamicKeyDynamicID         = @"dynamicID";
NSString * const BLUDynamicKeyType              = @"type";
NSString * const BLUDynamicKeyCreateDate        = @"createDate";
NSString * const BLUDynamicKeyFromUser          = @"fromUser";
NSString * const BLUDynamicKeyToUser            = @"toUser";
NSString * const BLUDynamicKeyContent           = @"content";
NSString * const BLUDynamicKeyTarget            = @"target";
NSString * const BLUDynamicKeyFromUserAnonymous = @"fromUserAnonymous";

@implementation BLUDynamic

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BLUDynamicKeyDynamicID:            @"udynamic_id",
             BLUDynamicKeyType:                 @"type",
             BLUDynamicKeyCreateDate:           @"create_date",
             BLUDynamicKeyFromUser:             @"from_user",
             BLUDynamicKeyToUser:               @"to_user",
             BLUDynamicKeyContent:              @"content",
             BLUDynamicKeyTarget:               @"target",
             BLUDynamicKeyFromUserAnonymous:    @"user_anonymous_status",
             @"FromUserID" :                    @"from_user_id",
             @"FromUserName" :                  @"from_nickname",
             @"headimageURLStr" :               @"head_image",
             @"width" :                         @"width",
             @"height" :                        @"height",
             };
}

+ (NSValueTransformer *)fromUserJSONTransformer {
    return [self userJSONTransformer];
}

+ (NSValueTransformer *)toUserJSONTransformer {
    return [self userJSONTransformer];
}

+ (NSValueTransformer *)targetJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *dict, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[BLUDynamicTarget class] fromJSONDictionary:dict error:nil];
    } reverseBlock:^id(id model , BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    }];
}

@end

@implementation BLUDynamic (Test)

+ (instancetype)testMessage {
    NSDictionary *dynamicDict = @{
                                  BLUDynamicKeyDynamicID: @(0),
                                  BLUDynamicKeyType: @(arc4random() % BLUDynamicTypeCount),
                                  BLUDynamicKeyCreateDate: [NSDate date],
                                  BLUDynamicKeyFromUser: [BLUUser testUser],
                                  BLUDynamicKeyToUser: [BLUUser testUser],
                                  BLUDynamicKeyContent: [NSString randomLorumIpsumWithLength:arc4random() % 40],
                                  };
    return [[BLUDynamic alloc] initWithDictionary:dynamicDict error:nil];
}

@end

@implementation BLUDynamicTarget

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postID":         @"post_id",
             @"commentID":      @"post_comment_id",
             @"anonymous":      @"anonymous_status",
             @"userID":         @"user_id",
             };
}

@end
