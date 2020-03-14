//
//  BLUViewController+Fetch.h
//  Blue
//
//  Created by Bowen on 22/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

typedef void (^BLUTableViewReloadBlock)();

@class BLUViewModel;

@interface BLUViewController (Fetch)

- (void)tableViewEndRefreshing:(UITableView *)tableView;
- (void)tableViewEndRefreshing:(UITableView *)tableView noMoreData:(BOOL)noMoreData;

@end

@interface RACSignal (Fetch)

- (void)handleFetchForViewController:(BLUViewController *)viewController tableView:(UITableView *)tableView reloadBlock:(BLUTableViewReloadBlock)block;

@end
