//
//  BLUCommentReplyTextView.h
//  Blue
//
//  Created by Bowen on 16/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUCommentReply.h"
#import "BLUUserTransitionProtocal.h"

@class BLUCommentReplyTextView, BLUPost, BLUComment;

@protocol BLUCommentReplyTextViewDelegate <NSObject>

@required
- (void)shouldReportReply:(NSDictionary *)replyInfo commentReplyTextView:(BLUCommentReplyTextView *)commentReplyTextView;
- (void)shouldDeleteReply:(NSDictionary *)replyInfo commentReplyTextView:(BLUCommentReplyTextView *)commentReplyTextView;
- (void)shouldReplyToReply:(NSDictionary *)replyInfo commentReplyTextView:(BLUCommentReplyTextView *)commentReplyTextView;

@end

@interface BLUCommentReplyTextView : UITextView

@property (nonatomic, copy) BLUCommentReply *commentReply;

@property (nonatomic, weak) id <BLUUserTransitionDelegate> userTransitionDelegate;
@property (nonatomic, weak) id <BLUCommentReplyTextViewDelegate> commentReplyDelegate;

- (void)setCommentReply:(BLUCommentReply *)commentReply post:(BLUPost *)post comment:(BLUComment *)comment;

@end
