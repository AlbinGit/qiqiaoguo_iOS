//
//  BLUWechatUserInfo.m
//  Blue
//
//  Created by Bowen on 18/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUWechatUserInfo.h"

@implementation BLUWechatUserInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"openID": @"openid",
        @"unionID": @"unionid",
        @"nickname": @"nickname",
        @"sex": @"sex",
        @"avatarURLString": @"headimgurl",
    };
}

@end
