//
//  BLUApiManager+Comment.h
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager.h"
#import "BLUApiManager+Post.h"

static NSString * const BLUCommentApiKeyCommentID = @"post_comment_id";
static NSString * const BLUCommentApiKeyContent   = @"content";

@interface BLUApiManager (Comment)

- (RACSignal *)likeCommentWithCommentID:(NSInteger)commentID;

- (RACSignal *)dislikeCommentWithCommentID:(NSInteger)commentID;

- (RACSignal *)fetchCommentsForPost:(NSInteger)postID
                         pagination:(BLUPagination *)pagination;

- (RACSignal *)fetchFeaturedCommentsForPost:(NSInteger)postID
                                 pagination:(BLUPagination *)pagination;

- (RACSignal *)fetchLZCommentsForPost:(NSInteger)postID
                           pagination:(BLUPagination *)pagination;

- (RACSignal *)fetchCommentsForUser:(NSInteger)userID
                         pagination:(BLUPagination *)pagination;

- (RACSignal *)comment:(NSString *)comment post:(NSInteger)postID;

- (RACSignal *)replyComment:(NSInteger)commentID
                    content:(NSString *)content
                       user:(BLUUser *)user;

- (RACSignal *)deleteReply:(NSInteger)replyID;

- (RACSignal *)fetchCommentWithCommentID:(NSInteger)commentID;

- (RACSignal *)deleteCommentWithCommentID:(NSInteger)commentID;

@end
