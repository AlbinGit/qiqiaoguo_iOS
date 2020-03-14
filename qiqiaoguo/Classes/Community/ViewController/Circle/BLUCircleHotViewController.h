//
//  BLUCircleHotViewController.h
//  Blue
//
//  Created by Bowen on 27/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class BLUPostViewModel;

@interface BLUCircleHotViewController : BLUViewController

@property (nonatomic, strong) BLUPostViewModel *postViewModel;
@property (nonatomic, strong) ASTableView *tableView;

@end

@interface BLUCircleHotViewController (TableView)
<ASTableViewDelegate, ASTableViewDataSource>

@end
