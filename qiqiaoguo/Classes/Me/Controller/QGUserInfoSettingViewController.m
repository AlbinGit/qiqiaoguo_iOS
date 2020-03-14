//
//  QGUserInfoSettingViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/13.
//
//

#import "QGUserInfoSettingViewController.h"
#import "BLUTextEditViewController.h"
#import "BLUSelectAndPickImageViewModel.h"
#import "BLUAlterUserViewModel.h"
#import "BLUUserIndicatorCell.h"
#import "BLUNicknameEditViewController.h"
#import "QGHttpManager+User.h"
#import "QGRegisterViewController.h"

@interface QGUserInfoSettingViewController () <UITableViewDelegate, UITableViewDataSource,BLUTextEditViewControllerDelegate>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) BLUSelectAndPickImageViewModel *selectAndPickImageViewModel;
@property (nonatomic, strong) BLUAlterUserViewModel *alterUserViewModel;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation QGUserInfoSettingViewController

- (instancetype)initWithUser:(BLUUser *)user {
    if (self = [super init]) {
        NSParameterAssert([user isKindOfClass:[BLUUser class]]);
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"修改资料";
        _user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Model
    self.alterUserViewModel.marriage = self.user.marriage;
    self.alterUserViewModel.birthday = self.user.birthday;
    self.alterUserViewModel.nickname = self.user.nickname;
    self.alterUserViewModel.signature = self.user.signature;
    
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    // Table view
    _tableView = [BLUTableView new];
    _tableView.backgroundColor = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[BLUUserIndicatorCell class] forCellReuseIdentifier:NSStringFromClass([BLUUserIndicatorCell class])];

    self.tableView.frame = self.view.bounds;
    // Constraints

    
    // Model
    @weakify(self);
    [RACObserve(self, selectAndPickImageViewModel.pickedImage) subscribeNext:^(UIImage *image) {
        @strongify(self);
        if (image) {
            self.alterUserViewModel.avatarImage = image;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [QGHttpManager UserUpdateHeadImageWithNewImage:image Success:^(NSURLSessionDataTask *task, id responseObject) {
                [SAUserDefaults saveValue:@"1" forKey:USERINFONEEDUPDATE];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self showTopIndicatorWithError:error];
                self.alterUserViewModel.avatarImage = nil;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }
    }];
}

- (BLUSelectAndPickImageViewModel *)selectAndPickImageViewModel {
    if (_selectAndPickImageViewModel == nil) {
        _selectAndPickImageViewModel = [BLUSelectAndPickImageViewModel new];
        _selectAndPickImageViewModel.viewController = self;
    }
    return _selectAndPickImageViewModel;
}

- (BLUAlterUserViewModel *)alterUserViewModel {
    if (_alterUserViewModel == nil) {
        _alterUserViewModel = [BLUAlterUserViewModel new];
    }
    return  _alterUserViewModel;
}

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    BLUUserIndicatorCell *userCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLUUserIndicatorCell class]) forIndexPath:indexPath];
    [self configUserIndicatorCell:userCell indexPath:indexPath];
    cell = userCell;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    CGFloat width = self.view.width;
    @weakify(self);
    size = [_tableView sizeForCellWithCellClass:[BLUUserIndicatorCell class] cacheByIndexPath:indexPath width:width configuration:^(BLUCell *cell) {
        @strongify(self);
        BLUUserIndicatorCell *userCell = (BLUUserIndicatorCell *)cell;
        [self configUserIndicatorCell:userCell indexPath:indexPath];
    }];
    return size.height;
}

- (void)configUserIndicatorCell:(BLUUserIndicatorCell *)userCell indexPath:(NSIndexPath *)indexPath {
    userCell.shouldShowIndicator = YES;
    switch (indexPath.row) {
        case 0: {
            if (self.alterUserViewModel.avatarImage) {
                userCell.avatarImage = self.alterUserViewModel.avatarImage;
            } else {
                userCell.avatarURL = self.user.avatar.thumbnailURL;
            }
            userCell.content = NSLocalizedString(@"user-setting.user-cell.avatar", @"Avatar");
        } break;
        case 2: {
            userCell.infoType = NSLocalizedString(@"user-setting.user-cell.mobile", @"Mobile");
            if ([self.user hasMobile]) {
                userCell.content = self.user.mobile;
                userCell.selectionStyle = UITableViewCellSelectionStyleNone;
                userCell.shouldShowIndicator = NO;
            } else {
                userCell.content = NSLocalizedString(@"user-setting-vc.user-cell.unbound", @"Unbound");
                userCell.selectionStyle = UITableViewCellSelectionStyleDefault;
                userCell.shouldShowIndicator = YES;
            }
        } break;
        case 1: {
            userCell.infoType = NSLocalizedString(@"user-setting.user-cell.nickname", @"Nickname");
            userCell.content = self.alterUserViewModel.nickname;
        } break;
        default: break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: { // 更新头像
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            self.selectAndPickImageViewModel.sourceRect = cell.bounds;
            self.selectAndPickImageViewModel.sourceView = cell;
            [self.selectAndPickImageViewModel selectAndPickImage];
        } break;
        case 1: {// 昵称
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            BLUNicknameEditViewController *vc = [[BLUNicknameEditViewController alloc] initWithTitle:NSLocalizedString(@"user-setting.nicname-edit.title.nickname", @"Nickname") text:self.alterUserViewModel.nickname];
            vc.delegate = self;
            BLUNavigationController *nav = [[BLUNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        } break;
        case 2: {// 手机号
            if ([self.user hasMobile]) {
                return;
            } else {
                QGRegisterViewController *vc = [[QGRegisterViewController alloc] init];
                vc.type = QGDetectionTypeBinding;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } break;
        default: break;
    }
}

#pragma mark - Text edit delegate

- (void)textEditViewController:(BLUTextEditViewController *)textEditViewController didEditText:(NSString *)text {

        static NSString *oldNickname = nil;
        oldNickname = self.alterUserViewModel.nickname;
        self.alterUserViewModel.nickname = text;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        @weakify(self);
        [[self.alterUserViewModel updateNickname] subscribeError:^(NSError *error) {
            @strongify(self);
            [self showTopIndicatorWithError:error];
            self.alterUserViewModel.nickname = oldNickname;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
}




@end
