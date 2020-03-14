//
//  BLUPostDetailCommentReplyNode.h
//  Blue
//
//  Created by Bowen on 23/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASDisplayNode.h"
#import "BLUPostDetailCommentReplyNodeDelegate.h"
#import "BLUPostDetailCommentReplyTextNodeDelegate.h"

@class BLUCommentReply;
@class BLUComment;
@class BLUPost;

@interface BLUPostDetailCommentReplyNode : ASDisplayNode

@property (nonatomic, strong) ASButtonNode *moreCommentsButtonNode;
@property (nonatomic, assign) BOOL showMoreCommentsPrompt;
@property (nonatomic, weak) id <BLUPostDetailCommentReplyNodeDelegate> delegate;
@property (nonatomic, weak) id <BLUPostDetailCommentReplyTextNodeDelegate> replyTextNodeDelegate;
@property (nonatomic, strong) BLUComment *comment;

- (instancetype)initWithComment:(BLUComment *)comment
                           post:(BLUPost *)post
                     replyCount:(NSInteger)replyCount;

+ (CGFloat)ovalDiameter;

@end
