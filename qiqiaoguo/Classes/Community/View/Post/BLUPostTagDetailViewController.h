//
//  BLUPostTagDetailViewController.h
//  Blue
//
//  Created by Bowen on 9/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUSendPost2ViewControllerDelegate.h"

@class BLUPostTagDetailSelector, BLUPostTagTitleView;
@class BLUPostTag, BLUPostTagDetailBarView;
@class BLUPostViewModel;

@interface BLUPostTagDetailViewController : BLUViewController
<BLUSendPost2ViewControllerDelegate>

@property (nonatomic, strong) ASTableView *tableView;
@property (nonatomic, strong) BLUPostTagTitleView *postTagTitleView;
@property (nonatomic, strong) BLUPostTagDetailBarView *postTagBar;
@property (nonatomic, strong) BLUPostTag *postTag;
@property (nonatomic, strong) BLUPostTagDetailSelector *postTagSelector;
@property (nonatomic, strong) ASNetworkImageNode *tagImageNode;

@property (nonatomic, strong) BLUPostViewModel *allViewModel;
@property (nonatomic, strong) BLUPostViewModel *recommendedViewModel;

@property (nonatomic, assign) NSInteger tagID;

@property (nonatomic, strong) UIButton *sendButton;

- (BLUPostViewModel *)currentViewModel;

- (void)updateUIWithOffset:(CGPoint)offset;

- (instancetype)initWithTagID:(NSInteger)tagID;

@end

@interface BLUPostTagDetailViewController (ASTableView)
<ASTableViewDelegate, ASTableViewDataSource>

- (void)handleSelection:(BLUPostTagDetailSelector *)selector;

@end
