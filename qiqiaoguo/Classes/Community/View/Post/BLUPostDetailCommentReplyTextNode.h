//
//  BLUPostDetailCommentReplyTextNode.h
//  Blue
//
//  Created by Bowen on 23/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASTextNode.h"
#import "BLUPostDetailCommentReplyTextNodeDelegate.h"

@class BLUCommentReply;
@class BLUComment;
@class BLUPost;

@interface BLUPostDetailCommentReplyTextNode : ASTextNode

@property (nonatomic, strong) BLUCommentReply *reply;
@property (nonatomic, strong) BLUComment *comment;
@property (nonatomic, strong) BLUPost *post;

@property (nonatomic, weak) id <BLUPostDetailCommentReplyTextNodeDelegate> commentReplyDelegate;

- (instancetype)initWithCommentReply:(BLUCommentReply *)reply
                             comment:(BLUComment *)comment
                                post:(BLUPost *)post;

@end

@interface BLUPostDetailCommentReplyTextNode (Text)

- (NSAttributedString *)attributedStringWithCommentReply:(BLUCommentReply *)reply comment:(BLUComment *)comment post:(BLUPost *)post;

- (NSArray *)replyLinkedAttributes;

- (NSAttributedString *)attributedAuthorNickname:(NSString *)nickname
                                          author:(BLUUser *)author
                                       anonymous:(BOOL)anonymous
                                            isUp:(BOOL)isUp;

- (NSAttributedString *)attributedColon;

- (NSAttributedString *)attributedReply;

- (NSAttributedString *)attributedTargetNickname:(NSString *)nickname;

- (NSAttributedString *)attributedContent:(NSString *)content
                             commentReply:(BLUCommentReply *)reply;

@end

@interface BLUPostDetailCommentReplyTextNode (Delegate) <ASTextNodeDelegate>

@end