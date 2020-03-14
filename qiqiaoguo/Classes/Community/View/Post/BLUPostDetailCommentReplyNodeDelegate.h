//
//  BLUPostDetailCommentReplyNodeDelegate.h
//  Blue
//
//  Created by Bowen on 24/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUUser;
@class BLUCommentReply;
@class BLUComment;
@class BLUPostDetailCommentReplyNode;

@protocol BLUPostDetailCommentReplyNodeDelegate <NSObject>

- (void)shouldShowRepliesForComment:(BLUComment *)comment
                               from:(BLUPostDetailCommentReplyNode *)replyNode
                             sender:(id)sender;

@end
