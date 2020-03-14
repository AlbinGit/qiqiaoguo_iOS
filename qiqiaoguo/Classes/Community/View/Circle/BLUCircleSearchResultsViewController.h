//
//  BLUCircleSearchResultsViewController.h
//  Blue
//
//  Created by Bowen on 7/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUCircleSearchResultsViewControllerDelegate.h"

@interface BLUCircleSearchResultsViewController : BLUViewController

@property (nonatomic, weak) id <BLUCircleSearchResultsViewControllerDelegate> delegate;

- (void)searchKeyword:(NSString *)keyword;

@end

@interface BLUCircleSearchResultsViewController (TableView) <UITableViewDelegate, UITableViewDataSource>

@end


