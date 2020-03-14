//
//  BLUPostLikedUserViewController.h
//  Blue
//
//  Created by Bowen on 24/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class BLUPost;
@class BLUPagination;

@interface BLUPostLikedUserViewController : BLUViewController

@property (nonatomic, strong) BLUPost *post;
@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) BLUPagination *pagination;

@property (nonatomic, strong) NSMutableArray *users;

- (instancetype)initWithPost:(BLUPost *)post;

@end

@interface BLUPostLikedUserViewController (TableView)
<UITableViewDelegate, UITableViewDataSource>

@end
