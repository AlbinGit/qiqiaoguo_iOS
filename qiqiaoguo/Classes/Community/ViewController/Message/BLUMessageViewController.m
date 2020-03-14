//
//  BLUMessageViewController.m
//  Blue
//
//  Created by Bowen on 13/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUMessageViewController.h"
#import "BLUMessageCategoryCell.h"
#import "BLUDynamicViewController.h"
#import "BLUDialogueViewController.h"
#import "BLUMessageCategoryViewModel.h"
#import "BLUMessageCategory.h"
#import "BLUMessageCategoryMO.h"
#import "BLUServerNotificationCell.h"
#import "BLUServerNoticationViewModel.h"
#import "BLUServerNotificationHeader.h"
#import "BLUServerNotificationMO.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUWebViewController.h"
#import "BLUServerNotification.h"
#import <AudioToolbox/AudioServices.h>
#import "BLUChatViewController.h"
#import "BLUPostTagDetailViewController.h"

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionMessageCategory = 0,
    TableViewSectionServerNotitcation,
};

@interface BLUMessageViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, BLUServerNotificationViewModelDelegate>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) BLUMessageCategoryViewModel *messageCategoryViewModel;
@property (nonatomic, strong) BLUServerNoticationViewModel *serverNotificationViewModel;
@property (nonatomic, strong, readonly) NSFetchedResultsController *messageCategoryFetchedResultsController;
@property (nonatomic, strong, readonly) NSFetchedResultsController *serverNotificationFetchedResultsController;

@end

@implementation BLUMessageViewController

#pragma mark - UIViewController.

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"message.title", @"Message");
        self.tabBarItem.image = [BLUCurrentTheme tabMessageNormalIcon];
        self.tabBarItem.selectedImage = [BLUCurrentTheme tabMessageSelectedIcon];
        self.tabBarItem.title = NSLocalizedString(@"message.title", @"Message");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRedDot:) name:BLUMessageShowRedDotNotification object:nil];
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [BLUTableView new];
    _tableView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[BLUMessageCategoryCell class] forCellReuseIdentifier:NSStringFromClass([BLUMessageCategoryCell class])];
    [_tableView registerClass:[BLUServerNotificationCell class] forCellReuseIdentifier:NSStringFromClass([BLUServerNotificationCell class])];

    [self.view addSubview:_tableView];

    @weakify(self);
    self.tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.serverNotificationViewModel fetchNext];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.messageCategoryViewModel fetch];
    [self.serverNotificationViewModel fetch];
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.tabBarController) {
        [self.tabBarController.viewControllers enumerateObjectsUsingBlock:^(__kindof BLUNavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.viewControllers.firstObject isEqual:self]) {
                [self removeRedDotAtTabBarItemIndex:idx];
            }
        }];
    }
}

- (void)handleRemoteNotification:(NSNotification *)userInfo {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [self.messageCategoryViewModel fetch];
    [self.serverNotificationViewModel fetch];
}

- (void)showRedDot:(NSDictionary *)userInfo {
    if (self.tabBarController) {
        [self.tabBarController.viewControllers enumerateObjectsUsingBlock:^(__kindof BLUNavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.viewControllers.firstObject isEqual:self]) {
                [self addRedDotAtTabBarItemIndex:idx];
            }
        }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:BLUMessageShowRedDotNotification];
}

#pragma mark - Model

- (BLUMessageCategoryViewModel *)messageCategoryViewModel {
    if (_messageCategoryViewModel == nil) {
        _messageCategoryViewModel = [[BLUMessageCategoryViewModel alloc] init];
        _messageCategoryViewModel.delegate = self;
    }
    return _messageCategoryViewModel;
}

- (BLUServerNoticationViewModel *)serverNotificationViewModel {
    if (_serverNotificationViewModel == nil) {
        _serverNotificationViewModel = [[BLUServerNoticationViewModel alloc] init];
        _serverNotificationViewModel.delegate = self;
    }
    return _serverNotificationViewModel;
}

//- (NSFetchedResultsController *)messageCategoryFetchedResultsController {
//    return self.messageCategoryViewModel.fetchedResultsController;
//}
//
//- (NSFetchedResultsController *)serverNotificationFetchedResultsController {
//    return self.serverNotificationViewModel.fetchedResultsController;
//}

#pragma mark - UITableView.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section < 2);
    id <NSFetchedResultsSectionInfo> messageCategorySectionInfo = self.messageCategoryFetchedResultsController.sections[0];
    id <NSFetchedResultsSectionInfo> serverNotificationSectionInfo = self.serverNotificationFetchedResultsController.sections[0];
    if (section == TableViewSectionMessageCategory) {
        return [messageCategorySectionInfo numberOfObjects];
    } else if (section == TableViewSectionServerNotitcation) {
        return [serverNotificationSectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case TableViewSectionMessageCategory: {
            cell =
            (BLUMessageCategoryCell *)[tableView
                                       dequeueReusableCellWithIdentifier:NSStringFromClass([BLUMessageCategoryCell class])
                                       forIndexPath:indexPath
                                       model:[self.messageCategoryFetchedResultsController objectAtIndexPath:indexPath]];
        } break;
        case TableViewSectionServerNotitcation: {
            cell = (BLUServerNotificationCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUServerNotificationCell class]) forIndexPath:indexPath];
            [self configCell:cell atIndexPath:indexPath];
        } break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case TableViewSectionMessageCategory: {
            if (![BLUAppManager sharedManager].currentUser) {
                [self loginRequired:nil];
                return ;
            }

            BLUMessageCategoryMO *category = [self.messageCategoryFetchedResultsController objectAtIndexPath:indexPath];
            category.unreadCount = @(0);

            BLUMessageCategoryMO *messageCategoryMO = [self.messageCategoryFetchedResultsController objectAtIndexPath:indexPath];
            if (messageCategoryMO.type.integerValue == BLUMessageCategoryTypeDynamic) {
                BLUDynamicViewController *vc = [BLUDynamicViewController new];
                [self pushViewController:vc];
            } else if (messageCategoryMO.type.integerValue == BLUMessageCategoryTypeChat) {
                BLUDialogueViewController *vc = [BLUDialogueViewController new];
                [self pushViewController:vc];
            } else {
                BLUChatViewController *vc = [[BLUChatViewController alloc] initWithUser:[category targetUser]];
                [self pushViewController:vc];
            }

        } break;
        case TableViewSectionServerNotitcation: {
            BLUServerNotificationMO *notification = [self.serverNotificationFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            NSInteger type = notification.type.integerValue;
            switch (type) {
                case BLUServerNotificationTypePost: {
                    NSInteger objectID = notification.objID.integerValue;
                    BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:objectID];
                    [self pushViewController:vc];
                } break;
                case BLUServerNotificationTypeCircle: {
                    NSInteger objectID = notification.objID.integerValue;
                    BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:objectID];
                    [self pushViewController:vc];
                } break;
                case BLUServerNotificationTypeWeb: {
                    NSString *urlString = notification.webURL;
                    if (urlString) {
                        NSURL *webURL = [NSURL URLWithString:urlString];
                        BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:webURL];
                        vc.title = notification.title;
                        [self pushViewController:vc];
                    }
                } break;
                case BLUServerNotificationTypeTag: {
                    NSInteger objectID = notification.objID.integerValue;
                    BLUPostTagDetailViewController *vc =
                    [[BLUPostTagDetailViewController alloc] initWithTagID:objectID];
                    [self pushViewController:vc];
                } break;
            }
            notification.didRead = @(YES);
        } break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    switch (indexPath.section) {
        case TableViewSectionMessageCategory: {
            size =
            [self.tableView
             sizeForCellWithCellClass:[BLUMessageCategoryCell class]
             cacheByIndexPath:indexPath
             width:self.tableView.width
             model:[self.messageCategoryFetchedResultsController objectAtIndexPath:indexPath]];
        } break;
        case TableViewSectionServerNotitcation: {
            size = [self.tableView sizeForCellWithCellClass:[BLUServerNotificationCell class] cacheByIndexPath:indexPath width:self.tableView.width configuration:^(BLUCell *cell) {
                [self configCell:cell atIndexPath:indexPath];
            }];
        } break;
    }

    return size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;
    if (section == TableViewSectionMessageCategory) {
        view = [UIView new];
        view.backgroundColor = BLUThemeSubTintBackgroundColor;
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section == TableViewSectionMessageCategory) {
        height = BLUThemeMargin * 2;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == TableViewSectionServerNotitcation) {
        return [BLUServerNotificationHeader headerHeight];
    } else {
        return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == TableViewSectionServerNotitcation) {
        return [BLUServerNotificationHeader new];
    } else {
        return nil;
    }
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[BLUServerNotificationCell class]]) {
        BLUServerNotificationCell *notificationCell = (BLUServerNotificationCell *)cell;
        if (indexPath.row == self.serverNotificationFetchedResultsController.fetchedObjects.count - 1) {
            notificationCell.showSeparator = NO;
        } else {
            notificationCell.showSeparator = YES;
        }
        [notificationCell setModel:[self.serverNotificationFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
    }

    if ([cell isKindOfClass:[BLUMessageCategoryCell class]]) {
        BLUMessageCategoryCell *messageCategoryCell = (BLUMessageCategoryCell *)cell;
        [messageCategoryCell setModel:[self.messageCategoryFetchedResultsController objectAtIndexPath:indexPath]];
    }
}

#pragma mark - NSFetchResultController.

//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView beginUpdates];
//}
//
//- (void)controller:(NSFetchedResultsController *)controller
//   didChangeObject:(id)anObject
//       atIndexPath:(NSIndexPath *)indexPath
//     forChangeType:(NSFetchedResultsChangeType)type
//      newIndexPath:(NSIndexPath *)newIndexPath {
//    UITableView *tableView = self.tableView;
//    NSIndexPath *fixedIndexPath = indexPath;
//    NSIndexPath *fixedNewIndexPath = newIndexPath;
//    if (controller == self.serverNotificationFetchedResultsController) {
//        fixedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:TableViewSectionServerNotitcation];
//        fixedNewIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:TableViewSectionServerNotitcation];
//    }
//    switch (type) {
//        case NSFetchedResultsChangeInsert: {
//            [tableView insertRowsAtIndexPaths:@[fixedNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//        } break;
//        case NSFetchedResultsChangeDelete: {
//            [tableView deleteRowsAtIndexPaths:@[fixedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//        } break;
//        case NSFetchedResultsChangeUpdate: {
//            [self configCell:[tableView cellForRowAtIndexPath:fixedIndexPath] atIndexPath:fixedIndexPath];
//        } break;
//        case NSFetchedResultsChangeMove: {
//            [tableView deleteRowsAtIndexPaths:@[fixedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:@[fixedNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//        } break;
//    }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller
//  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex
//     forChangeType:(NSFetchedResultsChangeType)type {
//    UITableView *tableView = self.tableView;
//
//    if (controller == self.serverNotificationFetchedResultsController) {
//        sectionIndex = TableViewSectionServerNotitcation;
//    } else {
//        sectionIndex = 0;
//    }
//
//    switch (type) {
//        case NSFetchedResultsChangeInsert: {
//            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//        } break;
//        case NSFetchedResultsChangeDelete: {
//            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//        } break;
//        default: break;
//    }
//}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView endUpdates];
    [self.tableView reloadData];
}

#pragma mark - BLUServerNotificationViewModel.

- (void)shouldDiableFetchNextFromViewModel:(BLUServerNoticationViewModel *)viewModel {
    [self tableViewEndRefreshing:self.tableView noMoreData:YES];
}

- (void)viewModelDidFetchNextComplete:(BLUServerNoticationViewModel *)viewModel {
    [self tableViewEndRefreshing:self.tableView];
    [self.tableView reloadData];
}

- (void)viewModelDidFetchNextFailed:(BLUServerNoticationViewModel *)viewModel error:(NSError *)error {
    [self tableViewEndRefreshing:self.tableView];
    [self showAlertForError:error];
}

@end
