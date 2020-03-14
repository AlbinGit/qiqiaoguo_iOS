//
//  BLUPostTagSearchResultViewController.h
//  Blue
//
//  Created by Bowen on 3/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"

@class BLUPostTagSearchViewModel, BLUPostTagSearchResultViewController, BLUPostTag;

@protocol BLUPostTagSearchResultViewControllerDelegate <NSObject>

@optional
- (void)searchResultsViewController:
(BLUPostTagSearchResultViewController *)searchResultController
                    didSearchFailed:(NSError *)error;

- (void)searchResultsViewControllerDidSearchSuccess:
(BLUPostTagSearchResultViewController *)searchResultController;

- (void)searchResultsViewControllerDidSelectTag:(BLUPostTag *)tag
                    searchResultsViewControlelr:
(BLUPostTagSearchResultViewController *)tagSearchResultViewController;

@end

@interface BLUPostTagSearchResultViewController : BLUViewController

@property (nonatomic, strong) UITableView *searchResultTableView;
@property (nonatomic, strong) BLUPostTagSearchViewModel *searchViewModel;
@property (nonatomic, weak) id <BLUPostTagSearchResultViewControllerDelegate> delegate;
@property (nonatomic, strong) UIToolbar *header;
@property (nonatomic, strong) UILabel *promptor;

- (void)searchKeyword:(NSString *)keyword;

@end

@interface BLUPostTagSearchResultViewController (TableView)
<UITableViewDelegate, UITableViewDataSource>

@end
