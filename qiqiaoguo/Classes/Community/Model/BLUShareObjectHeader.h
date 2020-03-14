//
//  BLUShareObjectHeader.h
//  Blue
//
//  Created by Bowen on 4/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

typedef NS_ENUM(NSInteger, BLUShareObjectType) {
    BLUShareObjectTypeDefault = 0, // None
    BLUShareObjectTypePost,
    BLUShareObjectTypeTag,
};

typedef NS_ENUM(NSInteger, BLUShareType) {
    BLUShareTypeSina = 0,
    BLUShareTypeWechatSession,
    BLUShareTypeWechatFavorite,
    BLUShareTypeWechatTimeline,
    BLUShareTypeQQSession,
    BLUShareTypeQZone,
};

typedef NS_ENUM(NSInteger, BLUShareResourceType) {
    BLUShareResourceTypeDefault = 0, // 无
    BLUShareResourceTypeImage,
    BLUShareResourceTypeVideo,
    BLUShareResourceTypeMusic,
};

typedef NS_ENUM(NSInteger, BLUOpenPlatformTypes) {
    BLUOpenPlatformTypeWechat = 1,
    BLUOpenPlatformTypeQQ,
    BLUOpenPlatformTypeSina,
};
