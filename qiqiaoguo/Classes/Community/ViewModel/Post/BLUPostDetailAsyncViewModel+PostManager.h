//
//  BLUPostDetailAsyncViewModel+PostManager.h
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel.h"

@interface BLUPostDetailAsyncViewModel (PostManager)

- (void)insertOrUpdatePost:(BLUPost *)post;
- (void)removePost;
- (BOOL)isPostExist;
- (BLUPost *)post;
- (NSIndexPath *)postIndexPath;
- (NSIndexPath *)postLikeIndexPath;


@end
