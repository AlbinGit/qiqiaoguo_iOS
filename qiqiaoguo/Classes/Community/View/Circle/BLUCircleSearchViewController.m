//
//  BLUCircleSearchViewController.m
//  Blue
//
//  Created by Bowen on 7/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleSearchViewController.h"
#import "BLUCircleSearchResultsViewController.h"
#import "BLUApiManager+Circle.h"
#import "BLUCircleBriefCell.h"
#import "BLUCircle.h"
#import "BLUBriefHeader.h"

@interface BLUCircleSearchViewController ()

@property (nonatomic, weak) RACDisposable *disposable;
@property (nonatomic, strong) NSArray *circles;

@end

@implementation BLUCircleSearchViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"circle-search-vc.title", @"Select circle");
    }
    return self;
}

- (void)loadView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[BLUCircleBriefCell class] forCellReuseIdentifier:NSStringFromClass([BLUCircleBriefCell class])];
    [tableView registerClass:[BLUBriefHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([BLUBriefHeader class])];

    [tableView reloadData];

    self.view = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = (BLUTableView *)self.view;

    _searchResultsViewController = [BLUCircleSearchResultsViewController new];
    _searchResultsViewController.delegate = self;

    _searchController = [[UISearchController alloc]
                         initWithSearchResultsController:_searchResultsViewController];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = YES;
    _searchController.hidesNavigationBarDuringPresentation = NO;

    _searchController.searchBar.barTintColor = [UIColor whiteColor];
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    _searchController.searchBar.translucent = NO;
    _searchController.searchBar.opaque = YES;
    _tableView.tableHeaderView = _searchController.searchBar;

    // NOTE: private api method, apple will ignore this.
    UITextField *searchField = [_searchController.searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1];

    self.definesPresentationContext = YES;

    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.disposable dispose];
    @weakify(self);
    self.disposable = [[[[BLUApiManager sharedManager] fetchCircleHot] retry:2] subscribeNext:^(id x) {
        @strongify(self);
        self.circles = x;
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.disposable dispose];
}

@end

@implementation BLUCircleSearchViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.circles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLUCircleBriefCell *cell = (BLUCircleBriefCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUCircleBriefCell class]) forIndexPath:indexPath];
    BOOL shouldShowSeparator = YES;
    [cell setModel:self.circles[indexPath.row] shouldShowSeparatorLine:shouldShowSeparator shouldShowQuit:NO shouldShowUnreadPostCount:NO circleActionDelegate:nil];
    cell.addButton.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BLUCircleBriefCell sizeForLayoutedCellWith:tableView.width sharedCell:nil].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BLUBriefHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([BLUBriefHeader class])];
    header.titleLabel.text = NSLocalizedString(@"circle-search-vc.table-view.header.title", @"Hot circles");
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate
         respondsToSelector:
         @selector(circleSearchViewControllerDidSelectCircle:circleSearchViewController:)]) {
        [self.delegate
         circleSearchViewControllerDidSelectCircle:self.circles[indexPath.row]
         circleSearchViewController:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation BLUCircleSearchViewController (SearchController)

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.searchResultsViewController searchKeyword:searchController.searchBar.text];
}

@end

@implementation BLUCircleSearchViewController (SearchResults)

- (void)circleSearchResultsViewControllerDidSelectCircle:(BLUCircle *)circle
                       circleSearchResultsViewController:(BLUCircleSearchResultsViewController *)circleSearchResultsViewController {
    if ([self.delegate
         respondsToSelector:
         @selector(circleSearchViewControllerDidSelectCircle:circleSearchViewController:)]) {
        [self.delegate
         circleSearchViewControllerDidSelectCircle:circle
         circleSearchViewController:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end