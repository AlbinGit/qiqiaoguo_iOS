//
//  BLUPostDetailAsyncViewController+PostDetailCommentNode.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController.h"
#import "BLUPostDetailCommentNodeDelegate.h"
#import "BLUPostDetailCommentReplyNodeDelegate.h"
#import "BLUPostDetailCommentReplyTextNodeDelegate.h"

@interface BLUPostDetailAsyncViewController (PostDetailCommentNode)
<BLUPostDetailCommentNodeDelegate, BLUPostDetailCommentReplyTextNodeDelegate, BLUPostDetailCommentReplyNodeDelegate>

@end
