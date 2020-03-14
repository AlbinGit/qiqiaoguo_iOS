//
//  BLUMessageHeader.h
//  Blue
//
//  Created by Bowen on 22/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#ifndef BLUMessageHeader_h
#define BLUMessageHeader_h

typedef NS_ENUM(NSInteger, BLUMessageType) {
    BLUMessageTypeText = 0,
    BLUMessageTypeImage,
    BLUMessageTypeVideo,
    BLUMessageTypeAdText = 11,
};

typedef NS_ENUM(NSInteger, BLUMessageMORemoteState) {
    BLUMessageMORemoteStateNormal = 0,
    BLUMessageMORemoteStateSending,
    BLUMessageMORemoteStateSendFailed,
};

typedef NS_ENUM(NSInteger, BLUMessageRemoteState) {
    BLUMessageRemoteStateSuccess = 0,
    BLUMessageRemoteStateSending,
    BLUMessageRemoteStateFailed,
};

typedef NS_ENUM(NSInteger, BLUMessageStyleType) {
    BLUMessageStyleTypeText = 1000,
    BLUMessageStyleTypeImage,
    BLUMessageStyleTypeAudio,
    BLUMessageStyleTypePhotoText,

    BLUMessageStyleTypeGoodHint = 2000,
    BLUMessageStyleTypeGoodPrompt,
};

#endif /* BLUMessageHeader_h */
