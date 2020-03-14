//
//  QGRegisterUserinfoViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/6/29.
//
//

#import "QGRegisterUserinfoViewController.h"
#import "BLURadioButtonView.h"
#import "BLULoginOrRegUIComponent.h"
#import "BLUWebViewController.h"
#import "BLUSelectAndPickImageViewModel.h"
#import "QGHttpManager+User.h"
#import "QGLoginViewController.h"


static const CGFloat kAavatarEditViewHeight = 72.0;

@interface QGRegisterUserinfoViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *avatarContainer;
@property (nonatomic, strong) BLUAvatarEditView *avatarEditView;
@property (nonatomic, strong) BLUTextFieldContainer *nicknameTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *passwordTextFieldContainer;
@property (nonatomic, strong) BLURadioButtonView *genderRadioButtonView;
@property (nonatomic, strong) UILabel *genderPromptLabel;
@property (nonatomic, strong) UILabel *avatarLabel;
@property (nonatomic, strong) BLUMainTitleButton *finishRegButton;
@property (nonatomic, strong) UIView *agreementContainer;
@property (nonatomic, strong) UILabel *agreementLabel;
@property (nonatomic, strong) UIButton *agreementButton;
@property (nonatomic, strong) UIView *nicknameLine;
@property (nonatomic, strong) UIView *passwordLine;
@property (nonatomic, assign) BOOL didSetAvatarImage;
@property (nonatomic, strong) BLUSelectAndPickImageViewModel* selectAndPickImageViewModel;


@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BLUUserGender gender;
@property (nonatomic, strong) UIImage *avatarImage;

@end

@implementation QGRegisterUserinfoViewController

- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code {
    if (self = [super init]) {
        self.title = @"注册";
        _mobile = mobile;
        _code = code;
    }
    return self;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *superview = self.view;
    superview.backgroundColor = APPBackgroundColor;
    
    // Avatar
    _avatarContainer = [UIView new];
    _avatarEditView = [BLUAvatarEditView new];
    [_avatarEditView.avatarButton addTarget:self action:@selector(selectImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [BLULoginOrRegUIComponent avatarContainer:_avatarContainer avatarEditView:_avatarEditView superview:superview];
    
    _avatarLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _avatarLabel.textColor = [UIColor colorFromHexString:@"c1c1c1"];
    [_avatarLabel setText:@"请上传真实头像,让更多的人认识你"];
    [superview addSubview:_avatarLabel];
    
    
//     Nickname text field container
    _nicknameTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    _nicknameTextFieldContainer.textField.secureTextEntry = NO;
    _nicknameTextFieldContainer.textField.textAlignment = NSTextAlignmentCenter;
    [BLULoginOrRegUIComponent textFieldContainer:_nicknameTextFieldContainer placeholder:@"请输入昵称" superview:superview];
    _nicknameTextFieldContainer.backgroundColor = APPBackgroundColor;
    _nicknameTextFieldContainer.textField.backgroundColor = APPBackgroundColor;
    
    _nicknameLine = [UIView new];
    _nicknameLine.backgroundColor = [UIColor colorFromHexString:@"c1c1c1"];
    [superview addSubview:_nicknameLine];
    
    // Password text field container
    _passwordTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeSecurePassword];
    _passwordTextFieldContainer.textField.textAlignment = NSTextAlignmentCenter;
    [BLULoginOrRegUIComponent textFieldContainer:_passwordTextFieldContainer placeholder:@"请输入6位数以上的登录密码" superview:superview];
    _passwordTextFieldContainer.backgroundColor = APPBackgroundColor;
    _passwordTextFieldContainer.textField.backgroundColor = APPBackgroundColor;
    
    _passwordLine = [UIView new];
    _passwordLine.backgroundColor = [UIColor colorFromHexString:@"c1c1c1"];
    [superview addSubview:_passwordLine];
    
    // Radio button view
    UIButton *maleButton = [UIButton new];
    maleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    maleButton.title = @"爸爸";
    [maleButton sizeToFit];
    [maleButton setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    [maleButton setImage:[BLUCurrentTheme userGenderDeselectedIcon] forState:UIControlStateNormal];
    [maleButton setImage:[BLUCurrentTheme userGenderSelectedIcon] forState:UIControlStateSelected];
    
    UIButton *femaleButton = [UIButton new];
    femaleButton.title = @"妈妈";
    femaleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    [femaleButton setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    [femaleButton setImage:[BLUCurrentTheme userGenderDeselectedIcon] forState:UIControlStateNormal];
    [femaleButton setImage:[BLUCurrentTheme userGenderSelectedIcon] forState:UIControlStateSelected];
    
    _genderRadioButtonView = [[BLURadioButtonView alloc] initWithButtons:@[maleButton,femaleButton] margin:[BLUCurrentTheme leftMargin] * 12];
    self.genderRadioButtonView.seletedIndex = BLUUserGenderMale;
    [superview addSubview:_genderRadioButtonView];

    
    // Finish reg button
    _finishRegButton = [BLUMainTitleButton new];
    _finishRegButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_finishRegButton addTarget:self action:@selector(registerFinish) forControlEvents:UIControlEventTouchUpInside];
    _finishRegButton.title = NSLocalizedString(@"reg-step2.finish-button.title", @"Complete registration");
    [superview addSubview:_finishRegButton];
    
    // Agreement container
    _agreementContainer = [UIView new];
    _agreementLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _agreementButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
    [_agreementButton addTarget:self action:@selector(EULAAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Agreement
    [BLULoginOrRegUIComponent container:_agreementContainer label:_agreementLabel button:_agreementButton prefix:@"点击完成注册即同意七巧国的" suffix:@"用户许可协议" superview:superview];
    
    // Constrants
    
    [_avatarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(superview);
//        make.height.equalTo(@(kAavatarEditViewHeight + [BLUCurrentTheme leftMargin] * 19));
    }];
    
    [_avatarEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarContainer).offset([BLUCurrentTheme leftMargin] * 6);
        make.bottom.equalTo(_avatarContainer).offset(-[BLUCurrentTheme leftMargin] * 13);
        make.width.height.equalTo(@(kAavatarEditViewHeight +1));
        make.centerX.equalTo(_avatarContainer);
    }];
    
    [_avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_avatarContainer);
        make.bottom.equalTo(_avatarContainer.mas_bottom).offset(-[BLUCurrentTheme leftMargin] * 4);
    }];
    
    [_nicknameTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.equalTo(_avatarContainer.mas_bottom);
    }];
    
    [_nicknameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
        make.left.equalTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
        make.right.equalTo(superview).offset(-[BLUCurrentTheme leftMargin] * 4);
        make.top.equalTo(_nicknameTextFieldContainer.mas_bottom);
    }];
    
    [_passwordTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview);
        make.left.equalTo(superview).offset(40);
        make.top.equalTo(_nicknameTextFieldContainer.mas_bottom).offset(1);
    }];
    
    [_passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
        make.left.equalTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
        make.right.equalTo(superview).offset(-[BLUCurrentTheme leftMargin] * 4);
        make.top.equalTo(_passwordTextFieldContainer.mas_bottom);
    }];
    
    [_genderRadioButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextFieldContainer.mas_bottom).offset([BLUCurrentTheme topMargin] * 6);
        make.centerX.equalTo(superview);
    }];
    
    [_genderPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_genderRadioButtonView.mas_bottom);
        make.centerX.equalTo(superview);
        make.left.greaterThanOrEqualTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
        make.right.lessThanOrEqualTo(superview).offset(-[BLUCurrentTheme rightMargin] * 4);
    }];
    
    [_finishRegButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_genderRadioButtonView.mas_bottom).offset([BLUCurrentTheme topMargin] * 6);
        make.left.equalTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
        make.right.equalTo(superview).offset(-[BLUCurrentTheme rightMargin] * 4);
        make.centerX.equalTo(superview);
    }];
    
    [_agreementContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_finishRegButton.mas_bottom).offset([BLUCurrentTheme topMargin] * 4);
        make.centerX.equalTo(superview);
    }];
    
    [_agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_agreementContainer);
        make.top.bottom.equalTo(_agreementContainer);
    }];
    
    [_agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_agreementLabel.mas_right).offset([BLUCurrentTheme leftMargin]);
        make.right.equalTo(_agreementContainer);
        make.centerY.equalTo(_agreementLabel);
    }];
    
    // Model
    _didSetAvatarImage = NO;
    
    @weakify(self);
    RAC(self, avatarEditView.avatarButton.image) = [[[RACObserve(self, genderRadioButtonView.seletedIndex) distinctUntilChanged] map:^id(NSNumber *index) {
        UIImage *image = nil;
        BLUUserGender gender = index.integerValue ? BLUUserGenderFemale : BLUUserGenderMale;
        if (gender == BLUUserGenderMale) {
            image = [BLUCurrentTheme userMaleAvatarIcon];
        } else if (gender == BLUUserGenderFemale) {
            image = [BLUCurrentTheme userFemaleAvatarIcon];
        }
        return image;
    }] filter:^BOOL(id value) {
        @strongify(self);
        if (self.didSetAvatarImage) {
            return NO;
        } else {
            return YES;
        }
    }];
    
    _selectAndPickImageViewModel = [BLUSelectAndPickImageViewModel new];
    _selectAndPickImageViewModel.viewController = self;
    
    [RACObserve(self, selectAndPickImageViewModel.pickedImage) subscribeNext:^(UIImage *image) {
        @strongify(self);
        if (image) {
            self.didSetAvatarImage = YES;
            self.avatarEditView.avatarButton.image = image;
        }
    }];
    
    RAC(self.finishRegButton,enabled) = [RACSignal
                                        combineLatest:@[self.nicknameTextFieldContainer.textField.rac_textSignal,
                                                        self.passwordTextFieldContainer.textField.rac_textSignal
                                                        ]
                                        reduce:^(NSString *nickname,NSString *password){
                                            return @( [nickname isNickname] && [password isPassword]);
                                        }];
    
    RAC(self, password) = self.passwordTextFieldContainer.textField.rac_textSignal;
    RAC(self, nickname) = self.nicknameTextFieldContainer.textField.rac_textSignal;
    RAC(self, gender) = [RACObserve(self, genderRadioButtonView.seletedIndex) map:^id(NSNumber *indexNumber) {
        BLUUserGender gender = indexNumber.integerValue ? BLUUserGenderFemale : BLUUserGenderMale;
        return @(gender);
    }];
    
    RAC(self, avatarImage) = [RACObserve(self, avatarEditView.avatarButton.image) map:^id(UIImage *image) {
                @strongify(self);
                if (!self.didSetAvatarImage) {
                    return nil;
                }
                return image;
            }];
}

// 完成注册按钮点击
- (void)registerFinish{
    [QGHttpManager registerWithMobile:_mobile Code:_code Nickname:_nickname Password:_password Headimage:_avatarImage Success:^(NSURLSessionDataTask *task, id responseObject) {
        BLUUser *user = responseObject;
        [BLUAppManager sharedManager].currentUser = user;
        
        
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QGLoginViewController class]]) {
                [vc dismissViewControllerAnimated:YES completion:nil];
                return ;
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showTopIndicatorWithError:error];
    }];
    
}

// 选择图片
- (void)selectImageAction:(UIButton *)button {
    _selectAndPickImageViewModel.sourceView = button;
    _selectAndPickImageViewModel.sourceRect = button.bounds;
    [_selectAndPickImageViewModel selectAndPickImage];
}

- (void)EULAAction:(UIButton *)button {
    BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:[BLUApiManager eulaURL]];
    vc.title = NSLocalizedString(@"about.eula", @"EULA");
    [self.navigationController pushViewController:vc animated:YES];
}



@end
