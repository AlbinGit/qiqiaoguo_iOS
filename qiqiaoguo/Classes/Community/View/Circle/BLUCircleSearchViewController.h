//
//  BLUCircleSearchViewController.h
//  Blue
//
//  Created by Bowen on 7/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUCircleSearchViewControllerDelegate.h"
#import "BLUCircleSearchResultsViewControllerDelegate.h"

@class BLUCircleSearchResultsViewController;

@interface BLUCircleSearchViewController : BLUViewController

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BLUCircleSearchResultsViewController *searchResultsViewController;
@property (nonatomic, weak) id <BLUCircleSearchViewControllerDelegate> delegate;

@end

@interface BLUCircleSearchViewController (TableView) <UITableViewDelegate, UITableViewDataSource>

@end

@interface BLUCircleSearchViewController (SearchController) <UISearchControllerDelegate, UISearchResultsUpdating>

@end

@interface BLUCircleSearchViewController (SearchResults) <BLUCircleSearchResultsViewControllerDelegate>

@end