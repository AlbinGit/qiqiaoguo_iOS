//
//  BLUPostDetailCommentReplyAsyncViewController.h
//  Blue
//
//  Created by Bowen on 25/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUPostCommentDetailAsyncViewModelDelegate.h"
#import "BLUContentReplyViewDelegate.h"
#import "BLUPostDetailCommentNodeDelegate.h"
#import "BLUPostDetailCommentReplyNodeDelegate.h"
#import "BLUPostDetailCommentReplyTextNodeDelegate.h"

@class BLUPost;
@class BLUComment;
@class BLUCommentReply;
@class BLUPostCommentDetailAsyncViewModel;
@class BLUContentReplyView;

@interface BLUPostCommentDetailReplyAsyncViewController : BLUViewController

@property (nonatomic, strong) ASTableView *tableView;
@property (nonatomic, strong) BLUPostCommentDetailAsyncViewModel *viewModel;

//@property (nonatomic, strong) BLUComment *comment;
//@property (nonatomic, strong) BLUPost *post;
//@property (nonatomic, assign) NSInteger commentID;
//@property (nonatomic, assign) NSInteger postID;

@property (nonatomic, strong) BLUContentReplyView *replyView;

- (instancetype)initWithComment:(BLUComment *)comment
                           post:(BLUPost *)post;

- (instancetype)initWithCommentID:(NSInteger)commentID postID:(NSInteger)postID;

- (void)replyToReply:(BLUCommentReply *)reply;
- (void)replyToComment;

- (void)setShouldReplyToComment:(BOOL)shouldReplyToComment;
- (void)setTargetReply:(BLUCommentReply *)targetReply;

@end

@interface BLUPostCommentDetailReplyAsyncViewController (TableView)
<ASTableViewDelegate, ASTableViewDataSource>

- (void)configureCommentNode;

@end

@interface BLUPostCommentDetailReplyAsyncViewController (ViewModel)
<BLUPostCommentDetailAsyncViewModelDelegate>

@end

@interface BLUPostCommentDetailReplyAsyncViewController (Reply)
<BLUContentReplyViewDelegate>

- (void)keyboardChanged:(NSNotification *)notification;

@end

@interface BLUPostCommentDetailReplyAsyncViewController (PostDetailCommentNode)
<BLUPostDetailCommentNodeDelegate,
BLUPostDetailCommentReplyTextNodeDelegate>

@end
