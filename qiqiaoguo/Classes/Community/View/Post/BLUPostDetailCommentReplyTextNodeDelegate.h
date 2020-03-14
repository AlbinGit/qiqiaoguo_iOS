//
//  BLUPostDetailCommentReplyTextNodeDelegate.h
//  Blue
//
//  Created by Bowen on 23/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUUser;
@class BLUCommentReply;
@class BLUPostDetailCommentReplyTextNode;

@protocol BLUPostDetailCommentReplyTextNodeDelegate <NSObject>

@optional
- (void)shouldReplyToCommentReply:(BLUCommentReply *)reply
                             from:(BLUPostDetailCommentReplyTextNode *)node;

@required
- (void)shouldDeleteCommentReply:(BLUCommentReply *)reply
                            from:(BLUPostDetailCommentReplyTextNode *)node;

- (void)shouldReportCommentReply:(BLUCommentReply *)reply
                            from:(BLUPostDetailCommentReplyTextNode *)node;

- (void)shouldShowUserDetails:(BLUUser *)user
                         from:(BLUPostDetailCommentReplyTextNode *)node;

@end
