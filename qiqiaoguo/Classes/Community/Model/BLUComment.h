//
//  BLUComment.h
//  Blue
//
//  Created by Bowen on 22/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"

UIKIT_EXTERN NSString * const BLUCommentKeyCommentID;
UIKIT_EXTERN NSString * const BLUCommentKeyComment;
UIKIT_EXTERN NSString * const BLUCommentKeyReadOwner;
UIKIT_EXTERN NSInteger BLUCommentMaxPhotoCount;

typedef NS_ENUM(NSInteger, BLUCommentReplyType) {
    BLUCommentReplyTypeDefault = 0,
};

@class BLUPost, BLUUser, BLUImageRes;

@interface BLUComment : BLUObject

@property (nonatomic, assign, readonly) NSInteger commentID;
@property (nonatomic, copy, readonly) NSDate *createDate;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) BLUPost *post;
@property (nonatomic, copy, readonly) BLUUser *author;
@property (nonatomic, copy, readonly) BLUImageRes *photo;
@property (nonatomic, assign, readonly) BLUCommentReplyType replyType;
@property (nonatomic, assign, readonly) NSInteger floor;

@property (nonatomic, assign) NSInteger likeCount;

@property (nonatomic, assign, getter=didLike) BOOL like;

@property (nonatomic, strong) NSArray *replies;

@property (nonatomic, assign, readonly) NSInteger replyCount;

@end

@interface BLUComment (Desc)

- (NSString *)floorDesc;

@end

@interface BLUComment (Validation)

+ (RACSignal *)validateCommentContent:(RACSignal *)contentSignal;

@end

@interface NSString (BLUComment)

- (BOOL)isCommentContent;

@end
