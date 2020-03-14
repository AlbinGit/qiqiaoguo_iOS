//
//  BLUPostTagSearchResultViewController.m
//  Blue
//
//  Created by Bowen on 3/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagSearchResultViewController.h"
#import "BLUPostTagSearchViewModel.h"
#import "BLUPostTag.h"

static const CGFloat kHeaderHeight = 44.0;

@interface BLUPostTagSearchResultViewController ()

@property (nonatomic, weak) RACDisposable *disposable;

@end

@implementation BLUPostTagSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _searchResultTableView = [BLUTableView new];
    _searchResultTableView.delegate = self;
    _searchResultTableView.dataSource = self;
    _searchResultTableView.tableFooterView = [UIView new];
    _searchResultTableView.separatorStyle =
    UITableViewCellSeparatorStyleSingleLine;
    [_searchResultTableView setSeparatorColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.91 alpha:1]];
    [_searchResultTableView registerClass:[UITableViewCell class]
                   forCellReuseIdentifier:
     NSStringFromClass([UITableViewCell class])];

    _header = [UIToolbar new];
    _header.backgroundColor = [UIColor darkGrayColor];

    _promptor = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _promptor.textColor = BLUThemeMainColor;
    _promptor.text = [self promptWithKeyword:nil];

    [_header addSubview:_promptor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchResultTableView];

    [_promptor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.header);
        make.left.equalTo(self.header).offset(BLUThemeMargin * 4);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.disposable dispose];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _searchResultTableView.frame = self.view.bounds;
    [_searchResultTableView setSeparatorInset:UIEdgeInsetsZero];
    [_searchResultTableView setLayoutMargins:UIEdgeInsetsZero];
}

- (BLUPostTagSearchViewModel *)searchViewModel {
    if (_searchViewModel == nil) {
        _searchViewModel = [BLUPostTagSearchViewModel new];
    }
    return _searchViewModel;
}

- (NSString *)promptWithKeyword:(NSString *)keyword {
    return [NSString stringWithFormat:@"%@: %@",
            NSLocalizedString(@"post-tag-search-results-vc.promptor.title",
                              @"Add new topic"),
            (keyword.length > 0 ? keyword : @"")];
}

- (void)searchKeyword:(NSString *)keyword {
    self.promptor.text = [self promptWithKeyword:keyword];
    [self.disposable dispose];
    @weakify(self);
    self.disposable = [[self.searchViewModel searchKeyword:keyword]
                       subscribeError:^(NSError *error) {
        @strongify(self);
        if ([self.delegate respondsToSelector:
             @selector(searchResultsViewController:didSearchFailed:)]) {
            [self.delegate searchResultsViewController:self didSearchFailed:error];
        }
    } completed:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:
             @selector(searchResultsViewControllerDidSearchSuccess:)]) {
            [self.delegate searchResultsViewControllerDidSearchSuccess:self];
        }
        [self.searchResultTableView reloadData];
    }];
}

@end

@implementation BLUPostTagSearchResultViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.searchViewModel.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:
                             NSStringFromClass([UITableViewCell class])
                             forIndexPath:indexPath];
    BLUPostTag *tag = self.searchViewModel.tags[indexPath.row];
    cell.textLabel.text = tag.title;
    cell.textLabel.textColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    return self.header;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return kHeaderHeight;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLUPostTag *tag = self.searchViewModel.tags[indexPath.row];
    if ([self.delegate respondsToSelector:
         @selector(searchResultsViewControllerDidSelectTag:searchResultsViewControlelr:)]) {
        [self.delegate searchResultsViewControllerDidSelectTag:tag
                                   searchResultsViewControlelr:self];
    }
}

@end
