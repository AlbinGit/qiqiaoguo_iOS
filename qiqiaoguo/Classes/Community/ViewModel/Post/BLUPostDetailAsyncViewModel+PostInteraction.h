//
//  BLUPostDetailAsyncViewModel+PostInteraction.h
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel.h"

@interface BLUPostDetailAsyncViewModel (PostInteraction)

- (void)likePost;
- (void)dislikePost;

- (void)collectPost;
- (void)cancelCollectPost;

- (void)replyToPost:(NSString *)content;

@end
