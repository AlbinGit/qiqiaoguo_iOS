//
//  BLUPostDetailViewModel.m
//  Blue
//
//  Created by Bowen on 25/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostDetailViewModel.h"
#import "BLUApiManager+Post.h"
#import "BLUPost.h"

@implementation BLUPostDetailViewModel

- (RACSignal *)fetch {
    @weakify(self);
    [self.fetchDisposable dispose];
    return [[[BLUApiManager sharedManager] fetchPostDetail:self.postID] doNext:^(BLUPost *post) {
        @strongify(self);
        self.post = post;
    }];
}

@end
