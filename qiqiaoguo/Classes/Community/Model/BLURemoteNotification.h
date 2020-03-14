//
//  BLURemoteNotification.h
//  Blue
//
//  Created by Bowen on 25/9/15.
//  Copyright © 2015 com.boki. All rights reserved.
//

typedef NS_ENUM(NSInteger, BLURemoteNotificationTypes) {
    BLURemoteNotificationTypePost = 1,
    BLURemoteNotificationTypeCircle,
    BLURemoteNotificationTypeWeb,
    BLURemoteNotificationTypeComment,
    BLURemoteNotificationTypeLikePost,
    BLURemoteNotificationTypeLikeComment,
    BLURemoteNotificationTypeCommentReply,
    BLURemoteNotificationTypeFollow,
    BLURemoteNotificationTypePrivateMessage,
    BLURemoteNotificationTypeSecretary,
    BLURemoteNotificationTypeTopics, // 11
    BLURemoteNotificationTypeToy, // 12
};

#import "BLUObject.h"

@class BLUAps;

@interface BLURemoteNotification : BLUObject

@property (nonatomic, assign, readonly) NSInteger objectID;
@property (nonatomic, assign, readonly) BLURemoteNotificationTypes type;
@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) BLUAps *aps;
@property (nonatomic, assign) BOOL showInfoDirectly;

@end
