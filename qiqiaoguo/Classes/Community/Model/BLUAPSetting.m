//
//  BLUAPSetting.m
//  Blue
//
//  Created by Bowen on 12/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUAPSetting.h"

@implementation BLUAPSetting

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"settingID":                       @"push_id",
        @"commentNotification":             @"comment_message",
        @"systemNotification":              @"system_message",
        @"likeNotification":                @"like_message",
        @"followNotification":              @"follow_message",
        @"privateMessageNotification":      @"letter_message",
    };
}

- (instancetype)initWithSystemNotification:(BOOL)systemNotification commentNotification:(BOOL)commentNotification likeNotification:(BOOL)likeNotification followNitification:(BOOL)followNotification privateMessageNotification:(BOOL)privateMessageNotification {
    if (self = [super init]) {
        _systemNotification = systemNotification;
        _commentNotification = commentNotification;
        _likeNotification = likeNotification;
        _followNotification = followNotification;
        _privateMessageNotification = privateMessageNotification;
    }
    return self;
}

@end
