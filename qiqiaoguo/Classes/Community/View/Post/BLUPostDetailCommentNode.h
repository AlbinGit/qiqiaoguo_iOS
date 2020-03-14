//
//  ASPostDetailCommentNode.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASCellNode.h"
#import "BLUPostDetailCommentNodeDelegate.h"

@class BLUComment;
@class BLUPostDetailCommentUserInfoNode;
@class BLUPostDetailCommentReplyNode;
@class BLUPost;

@interface BLUPostDetailCommentNode : ASCellNode

@property (nonatomic, strong) BLUPostDetailCommentUserInfoNode *userNode;
@property (nonatomic, strong) ASTextNode *contentNode;
@property (nonatomic, strong) BLUPostDetailCommentReplyNode *replyNode;

@property (nonatomic, strong) BLUComment *comment;
@property (nonatomic, assign) BOOL anonymous;
@property (nonatomic, strong) ASDisplayNode *separator;
@property (nonatomic, weak) id <BLUPostDetailCommentNodeDelegate> delegate;

- (instancetype)initWithComment:(BLUComment *)comment
                           post:(BLUPost *)post
                     replyCount:(NSInteger)replyCount
                      anonymous:(BOOL)anonymous
                      separator:(BOOL)separator;

@end
