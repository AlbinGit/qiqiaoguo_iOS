//
//  BLUCircleViewController.m
//  Blue
//
//  Created by Bowen on 2/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircleViewController.h"
#import "BLUCircleCarouselAndTagCell.h"
#import "BLUCircleCarouselCell.h"
#import "BLUBriefHeader.h"
#import "BLUCircleBriefCell.h"
#import "BLUCircleMoreCell.h"
#import "BLUCircleViewModel.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUCircleActionDelegate.h"
#import "BLUCircle.h"
#import "BLUCircleMoreViewController.h"
#import "BLUAdViewModel.h"
#import "BLUHotTagViewModel.h"
#import "BLUAdTransitionDelegate.h"
#import "BLUCircleAdViewModel.h"
#import "BLUCircleListViewModel.h"
#import "BLUCircleMO.h"
#import "BLUApiManager+Circle.h"

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionCarousel = 0,
    TableViewSectionFollow,
    TableViewSectionRecommand,
    TableViewSectionMore,
    TableViewSectionCount,
};

@interface BLUCircleViewController () <UITableViewDelegate, UITableViewDataSource, BLUCircleAdViewModelDelegate, NSFetchedResultsControllerDelegate,BLUHotTagViewModelDelegate>

@property (nonatomic, strong) BLUTableView *tableView;
//
@property (nonatomic, strong) BLUCircleCarouselCell *carouselCell;

@property (nonatomic, strong) BLUCircleCarouselAndTagCell *TagCell;
@property (nonatomic, strong) BLUCircleViewModel *circleViewModel;
@property (nonatomic, strong) BLUCircleActionDelegate *circleAction;

@property (nonatomic, strong) BLUAdTransitionDelegate *adTransition;
@property (nonatomic, strong) BLUCircleAdViewModel *circleAdViewModel;
@property (nonatomic, strong) BLUHotTagViewModel *hotTagViewModel;

@property (nonatomic, strong) NSFetchedResultsController *circleListFetchedResultsController;

@property (nonatomic, strong) BLUCircleListViewModel *circleListViewModel;

@end

@implementation BLUCircleViewController

#pragma mark - Life Circle

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"circle.title", @"Circle");
//        self.tabBarItem.image = [BLUCurrentTheme tabCircleNormalIcon];
//        self.tabBarItem.selectedImage = [BLUCurrentTheme tabCircleSelectedIcon];
//        self.tabBarItem.title = NSLocalizedString(@"circle.title", @"Circle");
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    // Carousel cell
    _carouselCell = [BLUCircleCarouselAndTagCell new];
    
    // TableView
    _tableView = [[BLUTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[BLUCircleCarouselCell class] forCellReuseIdentifier:NSStringFromClass([BLUCircleCarouselCell class])];
    [_tableView registerClass:[BLUCircleBriefCell class] forCellReuseIdentifier:NSStringFromClass([BLUCircleBriefCell class])];
    [_tableView registerClass:[BLUBriefHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([BLUBriefHeader class])];
    [_tableView registerClass:[BLUCircleMoreCell class] forCellReuseIdentifier:NSStringFromClass([BLUCircleMoreCell class])];
    [_tableView registerClass:[BLUCell class] forCellReuseIdentifier:NSStringFromClass([BLUCell class])];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.bottomLayoutGuide.length);
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_carouselCell startCarousel];
}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];
    [[self.circleListViewModel fetch] subscribeError:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showTopIndicatorWithError:error];
    } completed:^{
        
        [[self.hotTagViewModel fetch] subscribeError:^(NSError *error) {
            [self showTopIndicatorWithError:error];
        } completed:^{
        }];
        
        [[self.circleAdViewModel fetch] subscribeError:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self showTopIndicatorWithError:error];
        } completed:^{
            [self.tableView.mj_header endRefreshing];
        }];
    }];
}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    @weakify(self);
    self.tableView.mj_header = [BLURefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.circleListViewModel fetch] subscribeError:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self showTopIndicatorWithError:error];
        } completed:^{
            [[self.circleAdViewModel fetch] subscribeError:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
                [self showTopIndicatorWithError:error];
            } completed:^{
                [self.tableView.mj_header endRefreshing];
            }];
            [[self.hotTagViewModel fetch] subscribeError:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
                [self showTopIndicatorWithError:error];
            } completed:^{
                [self.tableView.mj_header endRefreshing];
            }];
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_carouselCell stopCarousel];
}

#pragma mark - View model

- (BLUCircleListViewModel *)circleListViewModel {
    if (_circleListViewModel == nil) {
        _circleListViewModel = [[BLUCircleListViewModel alloc] initWithFetchedResultsControllerDelegate:self];
    }
    return _circleListViewModel;
}

- (NSFetchedResultsController *)circleListFetchedResultsController {
    if (_circleListFetchedResultsController == nil) {
        _circleListFetchedResultsController = [self.circleListViewModel fetchedResultsController];
    }
    return _circleListFetchedResultsController;
}

- (BLUCircleAdViewModel *)circleAdViewModel {
    if (_circleAdViewModel == nil) {
        _circleAdViewModel = [BLUCircleAdViewModel new];
        _circleAdViewModel.delegate = self;
    }
    return _circleAdViewModel;
}

- (BLUHotTagViewModel *)hotTagViewModel {
    if (_hotTagViewModel == nil) {
        _hotTagViewModel = [BLUHotTagViewModel new];
        _hotTagViewModel.delegate = self;
    }
    return _hotTagViewModel;
}

- (BLUAdTransitionDelegate *)adTransition {
    if (_adTransition == nil) {
        _adTransition = [BLUAdTransitionDelegate new];
        _adTransition.viewController = self;
    }
    return _adTransition;
}

- (BLUCircleViewModel *)circleViewModel {
    if (_circleViewModel == nil) {
        _circleViewModel = [[BLUCircleViewModel alloc]
                            initWithFetchCircleType:BLUFetchCircleTypeOne];
    }
    return _circleViewModel;
}

- (BLUCircleActionDelegate *)circleAction {
    if (_circleAction == nil) {
        _circleAction = [BLUCircleActionDelegate new];
        _circleAction.viewController = self;
    }
    return _circleAction;
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2 + self.circleListFetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    NSInteger count = 0;
    NSInteger sectionCount = [self.tableView numberOfSections];
    NSInteger adCount = self.circleAdViewModel.ads.count > 0 ? 1 : 0;

    if (section == 0) {
        count = adCount;
    }

    if (section > 0 && section < (sectionCount - 1)) {
        id <NSFetchedResultsSectionInfo> sectionInfo = self.circleListFetchedResultsController.sections[section - 1];
        count = [sectionInfo numberOfObjects];
    }

    if (section == (sectionCount - 1)) {
        count = 1;
    }

    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSInteger sectionCount = [self.tableView numberOfSections];
    NSInteger section = indexPath.section;

    if (section == 0) {
        if (self.circleAdViewModel.ads.count > 0) {
            [self configCell:_carouselCell atIndexPath:indexPath];
            cell = _carouselCell;
        }
    }

    if (section > 0 && section < (sectionCount - 1)) {
        BLUCircleBriefCell *briefCell = (BLUCircleBriefCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUCircleBriefCell class]) forIndexPath:indexPath];
        [self configCell:briefCell atIndexPath:indexPath];
        cell = briefCell;
    }

    if (section == (sectionCount - 1)) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUCircleMoreCell class]) forIndexPath:indexPath];
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger sectionCount = [tableView numberOfSections];
    if (section > 0 && section < (sectionCount - 1)) {
        id <NSFetchedResultsSectionInfo> sectionInfo = self.circleListFetchedResultsController.sections[section - 1];

        BLUBriefHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([BLUBriefHeader class])];
        NSString *string = nil;
        NSString *text = nil;

        if ([sectionInfo.name isEqualToString:@(NO).description]) {
            string = NSLocalizedString(@"circle.brief-circle-header.recommend", @"Recommend");
//            text = [NSString stringWithFormat:@"%@ (%@)", string, @([sectionInfo numberOfObjects])];
            text = [NSString stringWithFormat:@"%@", string];
        } else {
            string = NSLocalizedString(@"circle.brief-circle-header.my-circles", @"My circles");
//            text = [NSString stringWithFormat:@"%@  (%@)", string, @([sectionInfo numberOfObjects])];
            text = [NSString stringWithFormat:@"%@", string];
        }
        header.titleLabel.text = text;
        return header;
    } else {
        return nil;
    }

}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[BLUCircleCarouselCell class]]) {
        BLUCircleCarouselAndTagCell *carouselCell = (BLUCircleCarouselAndTagCell *)cell;
        carouselCell.delegate = self.adTransition;
        carouselCell.model = self.circleAdViewModel.ads;
//        BLUPostTag *tags = [BLUPostTag new];
        // get data
        [carouselCell setTagModel:self.hotTagViewModel.tags];
        
    } else if ([cell isKindOfClass:[BLUCircleBriefCell class]]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = self.circleListFetchedResultsController.sections[indexPath.section - 1];
        BLUCircleBriefCell *briefCell = (BLUCircleBriefCell *)cell;
        briefCell.selectionStyle = UITableViewCellSelectionStyleDefault;
        BOOL shouldShowSeparatorLine = indexPath.row != [sectionInfo numberOfObjects] - 1 ? YES : NO;
        BOOL shouldShowQuit = indexPath.section == TableViewSectionFollow ? NO : YES;
        indexPath = [self circleListFectchedResultsControllerIndexPathFromTableViewIndexPath:indexPath];
        BLUCircle *circle = [BLUCircle circleFromCircleMO:[self.circleListFetchedResultsController objectAtIndexPath:indexPath]];
        
        [briefCell setModel:circle
    shouldShowSeparatorLine:shouldShowSeparatorLine
             shouldShowQuit:shouldShowQuit
  shouldShowUnreadPostCount:YES
       circleActionDelegate:self.circleAction];
        
    } else if ([cell isKindOfClass:[BLUCircleMoreCell class]]) {
        return;
    } else {
        return;
    }
}

#pragma mark - TableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.width;
    CGSize size = CGSizeMake(width, 0);

    CGSize adSize = self.circleAdViewModel.ads.count > 0 ? (CGSize){width, 5.0 / 9.0 * width} : CGSizeZero;
    CGSize tagSize = self.hotTagViewModel.tags.count > 0 ? (CGSize){width, 2.0 / 9.0 * width+40} : CGSizeZero;
    CGSize oneRowSize = CGSizeMake(width,adSize.height + tagSize.height);
    
    CGSize circleSize = [BLUCircleBriefCell sizeForLayoutedCellWith:width sharedCell:nil];
    CGSize moreSize = [_tableView sizeForCellWithCellClass:[BLUCircleMoreCell class] cacheByIndexPath:indexPath width:width model:nil];

    NSInteger section = indexPath.section;
    NSInteger sectionCount = [tableView numberOfSections];

    if (section == 0) {
        size = oneRowSize;
    }

    if (section > 0 && section < (sectionCount - 1)) {
        size = circleSize;
    }

    if (section == (sectionCount - 1)) {
        size = moreSize;
    }

    return size.height;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section {
    CGFloat height = 0;

    NSInteger sectionCount = [tableView numberOfSections];
    if (section > 0 && section < (sectionCount - 1)) {
        height = BLUBriefHeaderHeight;
    } else {
        height = 0;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    void (^pushCircleDetail)(BLUCircleMO *) = ^(BLUCircleMO *circleMO) {
        BLUCircle *circle = [BLUCircle circleFromCircleMO:circleMO];
        BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:circle.circleID];
        [self pushViewController:vc];
        [circleMO resetUnreadPostCount];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };

    NSInteger sectionCount = [self.tableView numberOfSections];
    NSInteger section = indexPath.section;

    if (section > 0 && section < (sectionCount - 1)) {
        indexPath = [self circleListFectchedResultsControllerIndexPathFromTableViewIndexPath:indexPath];
        @try {
            BLUCircleMO *circleMO =
            [self.circleListFetchedResultsController objectAtIndexPath:indexPath];
            pushCircleDetail(circleMO);
        }
        @catch (NSException *exception) {
            BLULogDebug(@"exception = %@", exception);
        }
        @finally {
        }
    }

    if (section == (sectionCount - 1)) {
        BLUCircleMoreViewController *vc = [BLUCircleMoreViewController new];
        [self pushViewController:vc];
    }

}

#pragma mark - Circle Ad.

- (void)shouldRefreshAds:(NSArray *)ads fromViewModel:(BLUCircleAdViewModel *)circleAdViewModel {
//    BLULogDebug(@"ads = %@", ads);
    [self.tableView reloadData];
}

- (void)shouldHandleFetchError:(NSError *)error fromViewModel:(BLUCircleAdViewModel *)circleAdViewModel {
    BLULogError(@"Error = %@", error);
    [self showTopIndicatorWithError:error];
}


- (void)shouldRefreshTags:(NSArray *)tags fromViewModel:(BLUHotTagViewModel *)hotTagViewModel
{
    [self.tableView reloadData];
}

#pragma mark - NSFetchedResultsController.

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
//    indexPath = [self tableViewIndexPathFromCircleListFetchedResultsControllerIndexPath:indexPath];
//    newIndexPath = [self tableViewIndexPathFromCircleListFetchedResultsControllerIndexPath:newIndexPath];
//    UITableView *tableView = self.tableView;
//    BOOL (^isRightIndexPath)(NSIndexPath *) = ^BOOL(NSIndexPath *indexPath) {
//        return YES;
//    };
//    switch (type) {
//        case NSFetchedResultsChangeInsert: {
//            if (isRightIndexPath(indexPath)) {
//                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        } break;
//        case NSFetchedResultsChangeDelete: {
//            if (isRightIndexPath(indexPath)) {
//                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        } break;
//        case NSFetchedResultsChangeUpdate: {
//            if (isRightIndexPath(indexPath)) {
//                [self configCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            }
//        } break;
//        case NSFetchedResultsChangeMove: {
//            if (isRightIndexPath(indexPath) && isRightIndexPath(newIndexPath)) {
//                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        } break;
//    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {

//    UITableView *tableView = self.tableView;
//
//    switch (type) {
//        case NSFetchedResultsChangeInsert: {
//            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex + 1] withRowAnimation:UITableViewRowAnimationFade];
//        } break;
//        case NSFetchedResultsChangeDelete: {
//            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex + 1] withRowAnimation:UITableViewRowAnimationFade];
//        } break;
//        default: break;
//    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (NSIndexPath *)circleListFectchedResultsControllerIndexPathFromTableViewIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == TableViewSectionRecommand || indexPath.section == TableViewSectionFollow);
    NSIndexPath *frcIndexPath = nil;
    if (indexPath.section == TableViewSectionFollow || indexPath.section == TableViewSectionRecommand) {
        frcIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
    } else {
        frcIndexPath = nil;
    }
    return frcIndexPath;
}

- (NSIndexPath *)tableViewIndexPathFromCircleListFetchedResultsControllerIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert((indexPath.section == TableViewSectionFollow - 1) ||
                      (indexPath.section == TableViewSectionRecommand - 1));
    NSIndexPath *tvIndexPath = nil;
    if ((indexPath.section == TableViewSectionFollow - 1) ||
        (indexPath.section == TableViewSectionRecommand - 1)) {
        tvIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
    } else {
        tvIndexPath = nil;
    }
    return tvIndexPath;
}

@end
