//
//  BLUPostCommentViewController.h
//  Blue
//
//  Created by Bowen on 15/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class BLUComment, BLUPost;

@interface BLUPostCommentViewController : BLUViewController

- (instancetype)initWithComment:(BLUComment *)comment user:(BLUUser *)postUser post:(BLUPost *)post;
- (instancetype)initWithCommentID:(NSInteger)commentID userID:(NSInteger)userID postID:(NSInteger)postID;

@end
