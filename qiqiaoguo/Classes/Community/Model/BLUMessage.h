//
//  BLUMessage.h
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"
#import "BLUPageRedirection.h"
#import "BLUMessageHeader.h"

UIKIT_EXTERN NSString * const BLUMessageKeyID;
UIKIT_EXTERN NSString * const BLUMessageKeyCreateDate;
UIKIT_EXTERN NSString * const BLUMessageKeyToUser;
UIKIT_EXTERN NSString * const BLUMessageKeyFromUser;
UIKIT_EXTERN NSString * const BLUMessageKeyContent;
UIKIT_EXTERN NSString * const BLUMessageKeyRemoteState;
UIKIT_EXTERN NSString * const BLUMessageKeyShowSendTime;
UIKIT_EXTERN NSString * const BLUMessageKeyType;
UIKIT_EXTERN NSString * const BLUMessageKeyRedirectType;
UIKIT_EXTERN NSString * const BLUMessageKeyRedirectID;

@class BLUContentParagraph, BLUMessageMO;

@interface BLUMessage : BLUObject <BLUPageRedirection>

@property (nonatomic, assign, readonly) NSInteger messageID;
@property (nonatomic, copy, readonly) NSDate *createDate;
@property (nonatomic, copy, readonly) BLUUser *toUser;
@property (nonatomic, copy, readonly) BLUUser *fromUser;
@property (nonatomic, copy, readonly) BLUContentParagraph *content;
@property (nonatomic, assign, readonly) BLUMessageRemoteState remoteState;
@property (nonatomic, assign, readonly) BOOL showSendTime;
@property (nonatomic, assign, readonly) BLUMessageType type;
@property (nonatomic, assign) BLUPageRedirectionType redirectType;
@property (nonatomic, assign) NSInteger redirectID;

@property (nonatomic, assign) NSInteger fromUserID;
@property (nonatomic, copy) NSString *fromUserName;
@property (nonatomic, copy) NSString *fromUserImageStr;
@property (nonatomic, assign) NSInteger toUserID;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@interface BLUMessage (Test)

+ (instancetype)testMessage;

@end

@interface BLUMessage (ManagedObject)

+ (BLUMessage *)messageWithMessageManagedObject:(BLUMessageMO *)messageMO;

@end
