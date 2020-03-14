//
//  BLUPostVideoViewController.h
//  Blue
//
//  Created by Bowen on 2/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class  BLUPostViewModel;

@interface BLUPostVideoViewController : BLUViewController

@property (nonatomic, strong) BLUPostViewModel *postViewModel;
@property (nonatomic, strong) ASTableView *tableView;

@property (nonatomic, strong) NSNumber *goodID;

- (instancetype)initWithGoodID:(NSNumber *)goodID;

@end

@interface BLUPostVideoViewController (TableView)
<ASTableViewDelegate, ASTableViewDataSource>

@end
