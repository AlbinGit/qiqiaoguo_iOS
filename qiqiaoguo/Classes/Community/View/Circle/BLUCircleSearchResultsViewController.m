//
//  BLUCircleSearchResultsViewController.m
//  Blue
//
//  Created by Bowen on 7/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleSearchResultsViewController.h"
#import "BLUApiManager+Circle.h"
#import "BLUCircle.h"
#import "BLUCircleBriefCell.h"

@interface BLUCircleSearchResultsViewController ()

@property (nonatomic, strong) NSArray *circles;
@property (nonatomic, weak) RACDisposable *disposable;

@end

@implementation BLUCircleSearchResultsViewController

- (void)loadView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[BLUCircleBriefCell class] forCellReuseIdentifier:NSStringFromClass([BLUCircleBriefCell class])];

    [tableView reloadData];

    self.view = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.disposable dispose];
}

- (BLUTableView *)tableView {
    return (BLUTableView *)self.view;
}

- (void)searchKeyword:(NSString *)keyword {
    [self.disposable dispose];
    @weakify(self);
    self.disposable = [[[[BLUApiManager sharedManager] searchCircleWithKeyword:keyword] retry:2] subscribeNext:^(id x) {
        @strongify(self);
        self.circles = x;
        [[self tableView] reloadData];
    } error:^(NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
    }];
}

@end

@implementation BLUCircleSearchResultsViewController (TableView)

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate
         respondsToSelector:
         @selector(circleSearchResultsViewControllerDidSelectCircle:circleSearchResultsViewController:)]) {
        [self.delegate
         circleSearchResultsViewControllerDidSelectCircle:self.circles[indexPath.row]
         circleSearchResultsViewController:self];
    }
}

@end
