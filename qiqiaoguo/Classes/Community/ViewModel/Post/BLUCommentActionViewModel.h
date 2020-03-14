//
//  BLUCommentActionViewModel.h
//  Blue
//
//  Created by Bowen on 26/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLUCommentActionViewModel : BLUViewModel

@property (nonatomic, assign) NSInteger commentID;

- (RACSignal *)like;
- (RACSignal *)dislike;
- (RACSignal *)reply:(NSString *)content toUser:(BLUUser *)user;
- (RACSignal *)deleteReply:(NSInteger)replyID;
- (RACSignal *)deleteComment;

@end
