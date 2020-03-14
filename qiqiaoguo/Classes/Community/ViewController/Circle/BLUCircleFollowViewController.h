//
//  BLUCircleFollowViewController.h
//  Blue
//
//  Created by Bowen on 27/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUCircleFollowedPostUserInfoNodeDelegate.h"
#import "BLUCircleFollowedPostNodeDelegate.h"
#import "BLUCircleFollowHeaderDelegate.h"
#import "BLUCircleFollowFooterViewDelegate.h"

@class BLUCircleFollowViewModel, BLUCircleFollowFooterView, BLUCircleFollowHeader;

@interface BLUCircleFollowViewController : BLUViewController

@property (nonatomic, strong) BLUCircleFollowViewModel *viewModel;
@property (nonatomic, strong) ASTableView *tableView;
@property (nonatomic, strong) BLUCircleFollowFooterView *footerView;
@property (nonatomic, strong) BLUCircleFollowHeader *header;

@end

@interface BLUCircleFollowViewController (TableView)
<ASTableViewDelegate, ASTableViewDataSource>

@end

@interface BLUCircleFollowViewController (Cell)
<BLUCircleFollowedPostUserInfoNodeDelegate,
BLUCircleFollowedPostUserInfoNodeDelegate,
BLUCircleFollowHeaderDelegate,BLUCircleFollowFooterViewDelegate,BLUCircleFollowedPostUserInfoNodeDelegate2>

@end
