//
//  BLUApiManager+Comment.m
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager+Comment.h"
#import "BLUApiManager+User.h"
#import "BLUApiManager+Post.h"
#import "BLUComment.h"

#define BLUCommentApiLikeComment       (BLUApiString(@"/comment/like"))
#define BLUCommentApiLikedComments     (BLUApiString(@"/user/liked/comments"))
#define BLUCommentApiComments          (BLUApiString(@"/comments/all"))
#define BLUCommentApiReplyComment      (BLUApiString(@"/reply/write"))
#define BLUCommentApiFeaturedComments  (BLUApiString(@"/comments/wonderful"))

@implementation BLUApiManager (Comment)

- (RACSignal *)likeCommentWithCommentID:(NSInteger)commentID {
    BLULogDebug(@"commentID = %@", @(commentID));
    NSDictionary *parameters = @{BLUCommentApiKeyCommentID: @(commentID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCommentApiLikeComment parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)dislikeCommentWithCommentID:(NSInteger)commentID {
    BLULogDebug(@"commentID = %@", @(commentID));
    NSDictionary *parameters = @{BLUCommentApiKeyCommentID: @(commentID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodDelete URLString:BLUCommentApiLikeComment parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)fetchCommentsForPost:(NSInteger)postID pagination:(BLUPagination *)pagination {
    BLULogInfo(@"postID = %@", @(postID));
    NSDictionary *parameters = @{BLUPostApiKeyPostID: @(postID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCommentApiComments parameters:parameters pagination:pagination resultClass:[BLUComment class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchFeaturedCommentsForPost:(NSInteger)postID pagination:(BLUPagination *)pagination {
    BLULogInfo(@"post id = %@", @(postID));
    NSDictionary *parameters = @{BLUPostApiKeyPostID: @(postID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCommentApiFeaturedComments parameters:parameters pagination:pagination resultClass:[BLUComment class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchLZCommentsForPost:(NSInteger)postID pagination:(BLUPagination *)pagination {
    BLULogInfo(@"postID = %@", @(postID));
    NSDictionary *parameters = @{BLUPostApiKeyPostID: @(postID),
                                 BLUCommentKeyReadOwner: @(1)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCommentApiComments parameters:parameters pagination:pagination resultClass:[BLUComment class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchCommentsForUser:(NSInteger)userID pagination:(BLUPagination *)pagination {
    BLULogInfo(@"userID = %@", @(userID));
    NSDictionary *parameters = @{BLUUserApiKeyUserID : @(userID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCommentApiComments parameters:parameters pagination:pagination resultClass:[BLUComment class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)comment:(NSString *)comment post:(NSInteger)postID {
    BLULogInfo(@"postID = %@", @(postID));
    NSDictionary *parameters = @{BLUPostApiKeyPostID: @(postID),
                                 BLUCommentApiKeyContent: comment};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUCommentApiComments parameters:parameters resultClass:[BLUComment class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)replyComment:(NSInteger)commentID content:(NSString *)content user:(BLUUser *)user {
    BLULogInfo(@"commentID = %@, content = %@, user.nickname = %@", @(commentID), content, user.nickname);
    NSDictionary *parameters = nil;
    if (user) {
        parameters = @{@"post_comment_id": @(commentID), @"content": content, @"target_id": @(user.userID)};
    } else {
        parameters = @{@"post_comment_id": @(commentID), @"content": content};
    }
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUCommentApiReplyComment parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)deleteReply:(NSInteger)replyID {
    BLULogInfo(@"reply ID = %@", @(replyID));
    NSDictionary *parameters = @{@"comment_reply_id": @(replyID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodDelete URLString:BLUCommentApiReplyComment parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)fetchCommentWithCommentID:(NSInteger)commentID {
    BLULogInfo(@"comment id = %@", @(commentID));
    NSDictionary *parameters = @{BLUCommentApiKeyCommentID: @(commentID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUCommentApiReplyComment parameters:parameters resultClass:[BLUComment class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)deleteCommentWithCommentID:(NSInteger)commentID {
    BLULogInfo(@"comment id = %@", @(commentID));
    NSDictionary *parameters = @{BLUCommentApiKeyCommentID: @(commentID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodDelete URLString:BLUCommentApiComments parameters:parameters resultClass:[BLUComment class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}
@end
