//
//  BLUUserSettingViewController.m
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUUserSettingViewController.h"
#import "BLUOtherUserViewController.h"
#import "BLUUserIndicatorCell.h"
#import "BLUSelectAndPickImageViewModel.h"
#import "BLUAlterUserViewModel.h"
#import "BLUNicknameEditViewController.h"
#import "BLUSignatureEditViewController.h"
#import "BLUResetPasswordViewController.h"

typedef NS_ENUM(NSInteger, RowType) {
    RowTypeAvatar = 0,
    RowTypeMobile,
    RowTypeNickname,
    RowTypeBirthday,
    RowTypeMarriage,
    RowTypeSignature,
    RowTypeCount,
};

@interface BLUUserSettingViewController () <UITableViewDelegate, UITableViewDataSource, BLUTextEditViewControllerDelegate>

@property (nonatomic, strong) BLUTableView *tableView;
@property (nonatomic, strong) BLUSelectAndPickImageViewModel *selectAndPickImageViewModel;
@property (nonatomic, strong) BLUAlterUserViewModel *alterUserViewModel;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation BLUUserSettingViewController

#pragma mark - Life circle

- (instancetype)initWithUser:(BLUUser *)user {
    if (self = [super init]) {
        NSParameterAssert([user isKindOfClass:[BLUUser class]]);
        self.hidesBottomBarWhenPushed = YES;
        self.title = NSLocalizedString(@"user-setting.title", @"User setting");
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
    
    // Date picker
    _datePicker = [UIDatePicker new];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = BLUThemeMainTintBackgroundColor;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-17];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-100];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    _datePicker.maximumDate = maxDate;
    _datePicker.minimumDate = minDate;
    [self.view addSubview:_datePicker];
    
    // Tool bar
    _toolbar = [UIToolbar new];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBirthdayAction:)];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(doneButtonAction:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [_toolbar setItems:@[cancelBarButton, flexibleSpace, doneBarButton] animated:YES];
    [self.view addSubview:_toolbar];
    
    // Constraints
    [self addTiledLayoutConstrantForView:_tableView];
   
    [self.toolbar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    [self.datePicker mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolbar.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    // Model
    @weakify(self);
    [RACObserve(self, selectAndPickImageViewModel.pickedImage) subscribeNext:^(UIImage *image) {
        @strongify(self);
        if (image) {
            self.alterUserViewModel.avatarImage = image;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowTypeAvatar inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [[self.alterUserViewModel alter] subscribeError:^(NSError *error) {
                [self showAlertForError:error];
                self.alterUserViewModel.avatarImage = nil;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowTypeAvatar inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }
    }];
}

#pragma mark - Model

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

- (void)cancelBirthdayAction:(UIBarButtonItem *)barButton {
    [self showDatePicker:NO];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)doneButtonAction:(UIBarButtonItem *)barButton {
    [self showDatePicker:NO];
   
    static NSDate *oldDate = nil;
    oldDate = self.alterUserViewModel.birthday;
    
    self.alterUserViewModel.birthday = self.datePicker.date;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [[self.alterUserViewModel alter] subscribeError:^(NSError *error) {
        [self showAlertForError:error];
        self.alterUserViewModel.birthday = oldDate;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowTypeAvatar inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma mark - view

- (void)showMarriageSelectSheetForCell:(UITableViewCell *)cell {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * (^makeAlertAction)(NSString *, BLUUserMarriage) = ^UIAlertAction *(NSString *title, BLUUserMarriage marriage) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            static BLUUserMarriage oldMarriage = 0;
            oldMarriage = self.alterUserViewModel.marriage;
            self.alterUserViewModel.marriage = marriage;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowTypeMarriage inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [[self.alterUserViewModel alter] subscribeError:^(NSError *error) {
                [self showAlertForError:error];
                self.alterUserViewModel.marriage = oldMarriage;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowTypeMarriage inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }];
        return action;
    };

    UIAlertAction *secretAction = makeAlertAction(NSLocalizedString(@"user.marriage.secret", @"Secret"), BLUUserMarriageSecrecy);
    UIAlertAction *singleAction = makeAlertAction(NSLocalizedString(@"user.marriage.single", @"Signal"), BLUUserMarriageSingle);
    UIAlertAction *inLoveAction = makeAlertAction(NSLocalizedString(@"user.marriage.in-love", @"In love"), BLUUserMarriageInLove);
    UIAlertAction *marriedAction = makeAlertAction(NSLocalizedString(@"user.marriage.married", @"Married"), BLUUserMarriageMarried);
    UIAlertAction *divorcedAction = makeAlertAction(NSLocalizedString(@"user.marriage.divorced", @"Divorced"), BLUUserMarriageDivorced);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"user-setting.cancel-action.cancel", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowTypeMarriage inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];

    [alertController addAction:secretAction];
    [alertController addAction:singleAction];
    [alertController addAction:inLoveAction];
    [alertController addAction:marriedAction];
    [alertController addAction:divorcedAction];
    [alertController addAction:cancelAction];
    alertController.popoverPresentationController.sourceView = cell;
    alertController.popoverPresentationController.sourceRect = cell.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showDatePicker:(BOOL)show {
    [UIView animateWithDuration:0.25 delay:0.0 options:7 animations:^{
        if (show) {
            [_datePicker mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
            }];
            
            [_toolbar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.bottom.equalTo(self.datePicker.mas_top);
            }];
        } else {
            [self.toolbar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_bottom);
                make.left.right.equalTo(self.view);
            }];
            
            [self.datePicker mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.toolbar.mas_bottom);
                make.left.right.equalTo(self.view);
            }];
        }
    
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return RowTypeCount;
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
        case RowTypeAvatar: {
            if (self.alterUserViewModel.avatarImage) {
                userCell.avatarImage = self.alterUserViewModel.avatarImage;
            } else {
                userCell.avatarURL = self.user.avatar.thumbnailURL;
            }
            userCell.content = NSLocalizedString(@"user-setting.user-cell.avatar", @"Avatar");
        } break;
        case RowTypeMobile: {
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
        case RowTypeBirthday: {
            userCell.infoType = NSLocalizedString(@"user-setting.user-cell.birthday", @"Birthday");
            userCell.content = [BLUUser descForBirtyday:self.alterUserViewModel.birthday];
        } break;
        case RowTypeMarriage: {
            userCell.infoType = NSLocalizedString(@"user-setting.user-cell.marriage", @"Marriage");
            userCell.content = [BLUUser descForMarriage:self.alterUserViewModel.marriage];
        } break;
        case RowTypeSignature: {
            userCell.infoType = NSLocalizedString(@"user-setting.user-cell.signature", @"Signature");
            userCell.content = [BLUUser descForSignature:self.alterUserViewModel.signature];
        } break;
        case RowTypeNickname: {
            userCell.infoType = NSLocalizedString(@"user-setting.user-cell.nickname", @"Nickname");
            userCell.content = self.alterUserViewModel.nickname;
        } break;
        default: break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case RowTypeSignature: {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            BLUSignatureEditViewController *vc = [[BLUSignatureEditViewController alloc] initWithTitle:NSLocalizedString(@"user-setting.signature-edit.title.signature",@"Signature") text:self.alterUserViewModel.signature];
            vc.delegate = self;
            BLUNavigationController *nav = [[BLUNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        } break;
        case RowTypeNickname: {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            BLUNicknameEditViewController *vc = [[BLUNicknameEditViewController alloc] initWithTitle:NSLocalizedString(@"user-setting.nicname-edit.title.nickname", @"Nickname") text:self.alterUserViewModel.nickname];
            vc.delegate = self;
            BLUNavigationController *nav = [[BLUNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        } break;
        case RowTypeAvatar: {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            self.selectAndPickImageViewModel.sourceRect = cell.bounds;
            self.selectAndPickImageViewModel.sourceView = cell;
            [self.selectAndPickImageViewModel selectAndPickImage];
        } break;
        case RowTypeMarriage: {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [self showMarriageSelectSheetForCell:cell];
        } break;
        case RowTypeBirthday: {
            [self showDatePicker:YES];
        } break;
        case RowTypeMobile: {
            if ([self.user hasMobile]) {
                return;
            } else {
                BLUResetPasswordViewController *vc = [[BLUResetPasswordViewController alloc] initWithUserMobileOperation:BLUUserMobileOperationBindMobile];
                [self pushViewController:vc];
            }
        } break;
        default: break;
    }
}

#pragma mark - Text edit delegate

- (void)textEditViewController:(BLUTextEditViewController *)textEditViewController didEditText:(NSString *)text {
    if ([textEditViewController isKindOfClass:[BLUNicknameEditViewController class]]) {
        
        static NSString *oldNickname = nil;
        oldNickname = self.alterUserViewModel.nickname;
        self.alterUserViewModel.nickname = text;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowTypeNickname inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        @weakify(self);
        [[self.alterUserViewModel alter] subscribeError:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
            self.alterUserViewModel.nickname = oldNickname;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowTypeNickname inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
    } else if ([textEditViewController isKindOfClass:[BLUSignatureEditViewController class]]) {
        static NSString *oldSignature = nil;
        oldSignature = self.alterUserViewModel.signature;
        self.alterUserViewModel.signature = text;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowTypeSignature inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
       
        @weakify(self);
        [[self.alterUserViewModel alter] subscribeError:^(NSError *error) {
            @strongify(self);
            [self showAlertForError:error];
            self.alterUserViewModel.signature = oldSignature;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:RowTypeSignature inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
}

@end
