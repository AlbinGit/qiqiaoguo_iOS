//
//  BLUHotTagViewController.h
//  Blue
//
//  Created by cws on 16/4/6.
//  Copyright © 2016年 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class BLUHotTagViewModel;

@interface BLUHotTagViewController : BLUViewController

@property (nonatomic, strong) BLUHotTagViewModel *hotTagViewModel;
@property (nonatomic, strong) ASTableView *tableView;

@end

@interface BLUHotTagViewController (TableView)
<ASTableViewDelegate, ASTableViewDataSource>

@end