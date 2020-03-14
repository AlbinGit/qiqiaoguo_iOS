//
//  BLUMessage.h
//  Blue
//
//  Created by Bowen on 13/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

typedef NS_ENUM(NSInteger, BLUDynamicType) {
    BLUDynamicTypeCommentPost = 4,
    BLUDynamicTypeLikePost,
    BLUDynamicTypeLikeComment,
    BLUDynamicTypeReplyComment,
    BLUDynamicTypeUserFollow,
    BLUDynamicTypeCount,
};

@class BLUDynamicTarget;

@interface BLUDynamic : BLUObject

@property (nonatomic, assign, readonly) NSInteger dynamicID;
@property (nonatomic, assign, readonly) BLUDynamicType type;
@property (nonatomic, copy, readonly) NSDate *createDate;
@property (nonatomic, copy, readonly) BLUUser *fromUser;
@property (nonatomic, copy, readonly) BLUUser *toUser;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) BLUDynamicTarget *target;
@property (nonatomic, assign, readonly) BOOL fromUserAnonymous;

@property (nonatomic,assign) NSInteger FromUserID;
@property (nonatomic, copy) NSString * FromUserName;
@property (nonatomic, copy) NSString *headimageURLStr;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@interface BLUDynamic (Test)

+ (instancetype)testMessage;

@end

@interface BLUDynamicTarget : BLUObject

@property (nonatomic, assign) NSInteger postID;
@property (nonatomic, assign) NSInteger commentID;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) BOOL anonymous;

@end
