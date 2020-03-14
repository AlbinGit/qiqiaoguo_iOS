//
//  BLUPostDetailAsyncViewModel+CommentInteraction.h
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel.h"

@class BLUPost;
@class BLUCommentReply;
@class BLUComment;

@interface BLUPostDetailAsyncViewModel (CommentInteraction)

- (void)likeComment:(BLUComment *)comment;
- (void)disLikeComment:(BLUComment *)comment;

- (void)replyToPostWithContent:(NSString *)content;

- (void)replyToCommentAtIndexPath:(NSIndexPath *)indexPath
                          content:(NSString *)content;

- (void)replyToCommentReplyAtIndexPath:(NSIndexPath *)indexPath
                                 reply:(BLUCommentReply *)reply
                               content:(NSString *)content;

- (void)deleteCommentReplyAtIndexPath:(NSIndexPath *)indexPath
                                reply:(BLUCommentReply *)reply;

- (void)deleteCommentAtIndexPath:(NSIndexPath *)indexPath;

@end
