//
//  BLUViewController+Fetch.m
//  Blue
//
//  Created by Bowen on 22/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController+Fetch.h"
#import "BLUViewModel.h"

@implementation BLUViewController (Fetch)

- (void)tableViewEndRefreshing:(UITableView *)tableView {
  
        if (tableView.mj_header) {
            [tableView.mj_header endRefreshing];
        }
        
        if (tableView.mj_footer) {
            [tableView.mj_footer endRefreshing];
        }
 
}

- (void)tableViewEndRefreshing:(UITableView *)tableView noMoreData:(BOOL)noMoreData {
    if (tableView.mj_footer) {
        if (noMoreData) {
            [tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [tableView.mj_footer endRefreshing];
        }
    }

    if (tableView.mj_header) {
        [tableView.mj_header endRefreshing];
    }
}

@end

@implementation RACSignal (Fetch)

- (void)handleFetchForViewController:(BLUViewController *)viewController tableView:(UITableView *)tableView reloadBlock:(BLUTableViewReloadBlock)block{
    [self subscribeError:^(NSError *error) {
        [viewController.view hideIndicator];
        [viewController showAlertForError:error];
        [viewController tableViewEndRefreshing:tableView];
    } completed:^{
        [viewController.view hideIndicator];
        [viewController tableViewEndRefreshing:tableView];
        if (block) {
            block();
        }
    }];
}

@end
