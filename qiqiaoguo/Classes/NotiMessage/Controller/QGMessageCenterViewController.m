//
//  QGMessageCenterViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/6/30.
//
//

#import "QGMessageCenterViewController.h"
#import "QGTableView.h"
#import "BLUMessageCategoryViewModel.h"
#import "BLUServerNoticationViewModel.h"
#import "BLUMessageCategoryCell.h"
#import "BLUServerNotificationCell.h"
#import "BLUMessageCategory.h"
#import "BLUDialogueViewController.h"
#import "BLUChatViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUWebViewController.h"
#import "BLUPostTagDetailViewController.h"
#import "BLUServerNotificationHeader.h"
#import "QGDynamicViewController.h"
#import "QGCardMessageViewController.h"
#import "QGActivMessageViewController.h"
#import "QGOrderMessageViewController.h"
#import "QGActivityHomeViewController.h"
#import "QGActivityDetailViewController.h"
#import "QGOrgViewController.h"
#import "QGTeacherViewController.h"
#import "QGCourseDetailViewController.h"

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionMessageCategory = 0, // 消息通知
    TableViewSectionServerNotitcation, // 系统通知
};

@interface QGMessageCenterViewController ()<UITableViewDelegate, UITableViewDataSource, BLUServerNotificationViewModelDelegate>

@property (nonatomic, strong) QGTableView *tableView;
@property (nonatomic, strong) BLUMessageCategoryViewModel *messageCategoryViewModel;
@property (nonatomic, strong) BLUServerNoticationViewModel *serverNotificationViewModel;

@end

@implementation QGMessageCenterViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"消息中心";
        self.hidesBottomBarWhenPushed = YES;
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _messageCategoryViewModel = [[BLUMessageCategoryViewModel alloc] init];
    _messageCategoryViewModel.delegate = self;
    [self.serverNotificationViewModel fetch];
    _tableView = [QGTableView new];
    _tableView.backgroundColor = APPBackgroundColor;
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.messageCategoryViewModel fetch];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableView reloadData];
}

//- (void)handleRemoteNotification:(NSNotification *)userInfo {
//    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
//    [self.messageCategoryViewModel fetch];
//    [self.serverNotificationViewModel fetch];
//}


#pragma mark - Model


- (BLUServerNoticationViewModel *)serverNotificationViewModel {
    if (_serverNotificationViewModel == nil) {
        _serverNotificationViewModel = [[BLUServerNoticationViewModel alloc] init];
        _serverNotificationViewModel.delegate = self;
    }
    return _serverNotificationViewModel;
}


#pragma mark - UITableView.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section < 2);
    
    if (section == TableViewSectionMessageCategory) {
        return self.messageCategoryViewModel.MessageArray.count;
    } else if (section == TableViewSectionServerNotitcation) {
        return self.serverNotificationViewModel.ServerNoticationArray.count;
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
                                       model:self.messageCategoryViewModel.MessageArray[indexPath.row]];
        } break;
        case TableViewSectionServerNotitcation: {
            cell = (BLUServerNotificationCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUServerNotificationCell class]) forIndexPath:indexPath];
        } break;
    }
       [self configCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case TableViewSectionMessageCategory: {
//            if (![BLUAppManager sharedManager].currentUser) {
//                [self loginRequired:nil];
//                return ;
//            }
            QGMessageTypeModel *model = self.messageCategoryViewModel.MessageArray[indexPath.row];
            [self JumpToDealWithMessageTpye:model];
            
        } break;
        case TableViewSectionServerNotitcation: {
            BLUServerNotification *notification = self.serverNotificationViewModel.ServerNoticationArray[indexPath.row];
            [self JumpToDealWithNotification:notification];
            
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
             model:self.messageCategoryViewModel.MessageArray[indexPath.row]];
        } break;
        case TableViewSectionServerNotitcation: {
            size = [self.tableView sizeForCellWithCellClass:[BLUServerNotificationCell class] cacheByIndexPath:indexPath width:self.tableView.width configuration:^(QGCell *cell) {
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
        view.backgroundColor = [UIColor clearColor];
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
    if (section == TableViewSectionServerNotitcation && (self.serverNotificationViewModel.ServerNoticationArray.count > 0)) {
        return [BLUServerNotificationHeader headerHeight];
    } else {
        return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == TableViewSectionServerNotitcation && (self.serverNotificationViewModel.ServerNoticationArray.count > 0)) {
        return [BLUServerNotificationHeader new];
    } else {
        return nil;
    }
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[BLUServerNotificationCell class]]) {
        BLUServerNotificationCell *notificationCell = (BLUServerNotificationCell *)cell;
        if (indexPath.row == self.serverNotificationViewModel.ServerNoticationArray.count - 1) {
            notificationCell.showSeparator = NO;
        } else {
            notificationCell.showSeparator = YES;
        }
        [notificationCell setModel:self.serverNotificationViewModel.ServerNoticationArray[indexPath.row]];
    }
    
    if ([cell isKindOfClass:[BLUMessageCategoryCell class]]) {
        BLUMessageCategoryCell *messageCategoryCell = (BLUMessageCategoryCell *)cell;
        [messageCategoryCell setModel:self.messageCategoryViewModel.MessageArray[indexPath.row]];
        messageCategoryCell.solidLine.hidden = indexPath.row == self.messageCategoryViewModel.MessageArray.count - 1;
    }
}

#pragma mark - 跳转处理
- (void)JumpToDealWithNotification:(BLUServerNotification *)notification{
    
    switch (notification.type) {
        case BLUServerNotificationTypePost: {
            // 帖子详情
            NSInteger objectID = notification.objectID;
            BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:objectID];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case BLUServerNotificationTypeCircle: {
            // 圈子
            NSInteger objectID = notification.objectID;
            BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:objectID];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case BLUServerNotificationTypeWeb: {
            // 网页
            if (notification.webURL) {
                BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:notification.webURL];
                vc.title = notification.title;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } break;
        case BLUServerNotificationTypeTag: {
            // 帖子标签列表
            NSInteger objectID = notification.objectID;
            BLUPostTagDetailViewController *vc =
            [[BLUPostTagDetailViewController alloc] initWithTagID:objectID];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case BLUServerNotificationTypeItem: {
            // 单品
            break;
        }
        case QGServerNotificationTypePackage: {
            //套餐
            break;
        }
        case QGServerNotificationTypeBrandSale: {
            // 品牌特卖
            break;
        }
        case QGServerNotificationTypeBrand: {
           // 品牌
            break;
        }
        case QGServerNotificationTypeClassification: {
            // 商品分类
            break;
        }
        case QGServerNotificationTypeEducation: {
            // 教育首页
            if (self.tabBarController) {
                [self.tabBarController setSelectedIndex:1];
            }
            break;
        }
        case QGServerNotificationTypeAgency: {
            // 机构首页
            break;
        }
        case QGServerNotificationTypeTeacher: {
            // 教师首页
            break;
        }
        case QGServerNotificationTypeCourse: {
            // 课程首页
            break;
        }
        case QGServerNotificationTypeEduClassification: {
            // 教育分类
            break;
        }
        case QGServerNotificationTypeActivity: {
             // 活动首页
            QGActivityHomeViewController *vc = [QGActivityHomeViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case QGServerNotificationTypeActivityDetail: {
            // 活动详情
            NSInteger objectID = notification.objectID;
            QGActivityDetailViewController *vc = [QGActivityDetailViewController new];
            vc.activity_id = [@(objectID) stringValue];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case QGServerNotificationTypeAgencydDetail: {
            // 机构详情
            NSInteger objectID = notification.objectID;
            QGOrgViewController *vc = [QGOrgViewController new];
            vc.org_id = [@(objectID) stringValue];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case QGServerNotificationTypeTeacherDetail: {
            // 教师详情
            NSInteger objectID = notification.objectID;
            QGTeacherViewController *vc = [QGTeacherViewController new];
            vc.teacher_id = [@(objectID) stringValue];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case QGServerNotificationTypeCourseDetail: {
            // 课程详情
            NSInteger objectID = notification.objectID;
            QGCourseDetailViewController *vc = [QGCourseDetailViewController new];
            vc.course_id = [@(objectID) stringValue];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }

}

- (void)JumpToDealWithMessageTpye:(QGMessageTypeModel *)model{
    if (model.type == QGMessageTypeCard) {
        QGCardMessageViewController *vc = [QGCardMessageViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == QGMessageTypeOrder) {
        QGOrderMessageViewController *vc = [QGOrderMessageViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == QGMessageTypeActiv || model.type == QGMessageTypeEdu) {
        QGActivMessageViewController *vc = [QGActivMessageViewController new];
        vc.type = model.type;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == QGMessageTypeDynamic) {
        QGDynamicViewController *vc = [QGDynamicViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == QGMessageTypePrivate) {
        BLUDialogueViewController *vc = [BLUDialogueViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.type == QGMessageTypeSecretary) {
        NSDictionary *UserDict = @{
                                   BLUUserKeyUserID: @(model.kefuUserID),
                                   BLUUserKeyNickname: @"官方客服",
                                   BLUUserKeyGender: @(arc4random() & 2),
                                   BLUUserKeySignature: [NSString randomLorumIpsumWithLength:arc4random() % 40],
                                   };
        BLUUser *user = [[BLUUser alloc]initWithDictionary:UserDict error:nil];
        BLUChatViewController *vc = [[BLUChatViewController alloc]initWithUser:user];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
        model.unreadCount = 0;
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
    [self showTopIndicatorWithError:error];
}



@end
