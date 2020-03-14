//
//  BLUPostActionViewModel.m
//  Blue
//
//  Created by Bowen on 26/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostActionViewModel.h"
#import "BLUApiManager+Post.h"
#import "BLUApiManager+Comment.h"

@implementation BLUPostActionViewModel

- (RACSignal *)like {
    return [[BLUApiManager sharedManager] likePostWithPostID:self.postID];
}

- (RACSignal *)disLike {
    return [[BLUApiManager sharedManager] dislikePostWithPostID:self.postID];
}

- (RACSignal *)collect {
    return [[BLUApiManager sharedManager] collectPostWithPostID:self.postID];
}

- (RACSignal *)cancelCollect {
    return [[BLUApiManager sharedManager] cancelCollectPostWithPostID:self.postID];
}

- (RACSignal *)comment:(NSString *)comment {
    return [[BLUApiManager sharedManager] comment:comment post:self.postID];
}

@end
