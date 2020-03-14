//
//  BLUPostDetailAsyncViewController.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class BLUPostDetailAsyncViewModel;
@class BLUPostDetailFeaturedCommentsHeader;
@class BLUPostDetailAllCommentsHeader;
@class BLUPostDetailToolbar;
@class BLUContentReplyView;
@class BLUBottomTransitioningAnimator;
@class BLUShowImageController;

@interface BLUPostDetailAsyncViewController : BLUViewController

@property (nonatomic, strong) ASTableView *tableView;
@property (nonatomic, strong) BLUPostDetailAsyncViewModel *viewModel;
@property (nonatomic, strong) BLUPostDetailFeaturedCommentsHeader *featuredCommentsHeader;
@property (nonatomic, strong) BLUPostDetailAllCommentsHeader *allCommentsHeader;
@property (nonatomic, strong) UIBarButtonItem *allCommentsButton;
@property (nonatomic, strong) UIBarButtonItem *ownerCommentButton;
@property (nonatomic, strong) BLUPostDetailToolbar *toolbar;
@property (nonatomic, strong) BLUContentReplyView *replyView;
@property (nonatomic, strong) NSLayoutConstraint *replyViewHideConstrant;
@property (nonatomic, strong) NSLayoutConstraint *replyViewShowConstrant;
@property (nonatomic, strong) ASBatchContext *batchContext;
@property (nonatomic, assign) BOOL upPullEnable;
@property (nonatomic, strong) BLUShowImageController *showImageController;

@property (nonatomic, assign) CGPoint tableViewLastContentOffset;

- (instancetype)initWithPostID:(NSInteger)postID;

- (void)configureAfterPostArrived;

@end
