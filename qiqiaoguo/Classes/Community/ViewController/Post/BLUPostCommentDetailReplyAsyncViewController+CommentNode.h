//
//  BLUPostCommentDetailReplyAsyncViewController+CommentNode.h
//  Blue
//
//  Created by Bowen on 26/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommentDetailReplyAsyncViewController.h"
#import "BLUPostDetailCommentNodeDelegate.h"
#import "BLUPostDetailCommentReplyNodeDelegate.h"
#import "BLUPostDetailCommentReplyTextNodeDelegate.h"

@interface BLUPostCommentDetailReplyAsyncViewController (CommentNode)
<BLUPostDetailCommentNodeDelegate,
BLUPostDetailCommentReplyNodeDelegate,
BLUPostDetailCommentReplyTextNodeDelegate>


@end
