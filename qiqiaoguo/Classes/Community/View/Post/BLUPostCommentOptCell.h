//
//  BLUPostCommentOptCell.h
//  Blue
//
//  Created by Bowen on 7/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostSimpleUserCell.h"
#import "BLUPostCommentActionProtocal.h"

@protocol BLUCommentReplyTextViewDelegate;
@protocol BLUUserTransitionDelegate;

@class BLUComment, BLUPost;

@interface BLUPostCommentOptCell : BLUPostSimpleUserCell

@property (nonatomic, strong) BLUUser *postUser;
@property (nonatomic, strong) BLUComment *comment;
@property (nonatomic, assign, readonly) NSInteger maxReplyCount;
@property (nonatomic, strong) BLUSolidLine *solidLine;

@property (nonatomic, weak) id <BLUPostCommentActionDelegate> delegate;
@property (nonatomic, weak) id <BLUCommentReplyTextViewDelegate> replyTextViewDelegate;

- (void)setModel:(id)model
        postUser:(BLUUser *)postUser
            post:(BLUPost *)post
shouldShowCompleteReplies:(BOOL)showCompleteReplies
        delegate:(id <BLUPostCommentActionDelegate>)delegate
replytTextViewDelegate:(id <BLUCommentReplyTextViewDelegate>)replyTextViewDelegate
  userTransition:(id <BLUUserTransitionDelegate>)userTransitionDelegate;

@end
