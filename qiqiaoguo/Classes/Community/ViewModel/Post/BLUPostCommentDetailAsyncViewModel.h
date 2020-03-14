//
//  BLUPostDetailCommentReplyAsyncViewModel.h
//  Blue
//
//  Created by Bowen on 25/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"
#import "BLUPostCommentDetailAsyncViewModelDelegate.h"

typedef NS_ENUM(NSInteger, BLUPostCommentReplyTo) {
    BLUPostCommentReplyToComment = 0,
    BLUPostCommentReplyToReply,
};

@class BLUComment;
@class BLUCommentReply;
@class BLUPost;

@interface BLUPostCommentDetailAsyncViewModel : BLUViewModel

@property (nonatomic, assign) NSInteger commentID;
@property (nonatomic, assign) NSInteger postID;
@property (nonatomic, strong) BLUPost *post;
@property (nonatomic, strong) BLUComment *comment;
@property (nonatomic, weak) id <BLUPostCommentDetailAsyncViewModelDelegate> delegate;

@property (nonatomic, assign) BOOL shouldReplyToComment;
@property (nonatomic, strong) BLUCommentReply *targetReply;

@property (nonatomic, assign) BLUPostCommentReplyTo replyTo;

- (instancetype)initWithCommentID:(NSInteger)commentID;

- (void)replyComment:(NSString *)content;
- (void)replyToReply:(BLUCommentReply *)reply content:(NSString *)content;
- (void)deleteReply:(BLUCommentReply *)reply;
- (void)likeComment;
- (void)dislikeComment;
- (void)updateComment;

@end
