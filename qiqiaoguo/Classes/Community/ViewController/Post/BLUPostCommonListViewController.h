//
//  BLUPostCommonListViewController.h
//  Blue
//
//  Created by Bowen on 2/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class BLUPostViewModel;

@interface BLUPostCommonListViewController : BLUViewController

@property (nonatomic, strong) BLUPostViewModel *postViewModel;
@property (nonatomic, strong) ASTableView *tableView;

- (instancetype)initWithPostViewModel:(BLUPostViewModel *)viewModel;

@end

@interface BLUPostCommonListViewController (TableView)
<ASTableViewDelegate, ASTableViewDataSource>

@end
