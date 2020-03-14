//
//  BLUCommentReply.h
//  Blue
//
//  Created by Bowen on 10/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

UIKIT_EXTERN NSString *BLUCommentReplyKeyCommentReply;
UIKIT_EXTERN NSString *BLUCommentReplyKeyReplyID;

@class BLUUser;

@interface BLUCommentReply : BLUObject

@property (nonatomic, assign, readonly) NSInteger replyID;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) BLUUser *author;
@property (nonatomic, copy, readonly) BLUUser *target;
@property (nonatomic, assign, readonly) BOOL isOwner;
@property (nonatomic, copy, readonly) NSDate *createDate;

@property (nonatomic, assign) NSInteger floor;

- (instancetype)initWithContent:(NSString *)content author:(BLUUser *)author createDate:(NSDate *)date;

@end

@interface BLUCommentReply (Info)

+ (NSDictionary *)replyInfoWithReply:(BLUCommentReply *)reply;
+ (NSDictionary *)replyInfoWithReplyID:(NSInteger)replyID;

@end

@interface BLUCommentReply (Desc)

- (NSString *)floorDesc;

@end

@interface NSString (BLUCommentReply)

- (BOOL)isCommentReply;

@end