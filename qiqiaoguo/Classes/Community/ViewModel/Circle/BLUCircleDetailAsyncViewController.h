//
//  BLUCircleDetailAsyncViewController.h
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUPostViewModel.h"
#import "BLUCircleBriefAsyncNodeDelegate.h"
#import "BLUSendPost2ViewControllerDelegate.h"

@class BLUCircleViewModel;

@interface BLUCircleDetailAsyncViewController : BLUViewController
<BLUSendPost2ViewControllerDelegate>

@property (nonatomic, assign) NSInteger circleID;
@property (nonatomic, assign) BLUPostType type;

@property (nonatomic, strong) BLUCircleViewModel *circleViewModel;
@property (nonatomic, strong) BLUPostViewModel *postViewModel;
@property (nonatomic, strong) ASTableView *tableView;

@property (nonatomic, strong) UIButton *sendButton;

- (instancetype)initWithCircleID:(NSInteger)circleID
                            type:(BLUPostType)type;

@end

@interface BLUCircleDetailAsyncViewController (TableView)
<ASTableViewDelegate, ASTableViewDataSource>

@end

@interface BLUCircleDetailAsyncViewController (Cell)
<BLUCircleBriefAsyncNodeDelegate>

@end

