//
//  BLUCommentActionViewModel.m
//  Blue
//
//  Created by Bowen on 26/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCommentActionViewModel.h"
#import "BLUApiManager+Comment.h"

@implementation BLUCommentActionViewModel

- (RACSignal *)like {
    return [[BLUApiManager sharedManager] likeCommentWithCommentID:self.commentID];
}

- (RACSignal *)dislike {
    return [[BLUApiManager sharedManager] dislikeCommentWithCommentID:self.commentID];
}

- (RACSignal *)reply:(NSString *)content toUser:(BLUUser *)user {
    return [[BLUApiManager sharedManager] replyComment:self.commentID content:content user:user];
}

- (RACSignal *)deleteReply:(NSInteger)replyID {
    return [[BLUApiManager sharedManager] deleteReply:replyID];
}

- (RACSignal *)deleteComment {
    return [[BLUApiManager sharedManager] deleteCommentWithCommentID:self.commentID];
}

@end
