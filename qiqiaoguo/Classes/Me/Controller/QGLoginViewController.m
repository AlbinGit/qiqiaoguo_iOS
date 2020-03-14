//
//  QGLoginViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/6/22.
//
//

#import "QGLoginViewController.h"
#import "BLULoginOrRegUIComponent.h"
#import "BLUOrSepratorLine.h"
#import "QGHttpManager+User.h"
#import "QGLoginUser.h"
#import "QGSocialService.h"
#import "QGRegisterViewController.h"
#import "QGRegisterUserinfoViewController.h"
#import "QGResetPasswordViewController.h"

static const CGFloat kShareButtonWidth = 56;

@interface QGLoginViewController ()
@property (nonatomic, strong) BLUTextFieldContainer *mobileTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *passwordTextFieldContainer;
@property (nonatomic, strong) UIButton *resetPasswordButton;
@property (nonatomic, strong) BLUMainTitleButton *loginButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *sinaButton;
@property (nonatomic, strong) UILabel *wechatLabel;
@property (nonatomic, strong) UILabel *qqLabel;
@property (nonatomic, strong) UILabel *sinaLabel;
@property (nonatomic, strong) BLUOrSepratorLine *orLine;

@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;
//@property (nonatomic, strong) BLULoginViewModel *loginViewModel;
@end

@implementation QGLoginViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"登录";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavItem];
    
    UIView *superview = self.view;
    superview.backgroundColor = [UIColor colorFromHexString:@"f5f5f5"];
    
    _mobileTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    _mobileTextFieldContainer.textField.secureTextEntry = NO;
    _mobileTextFieldContainer.textField.keyboardType = UIKeyboardTypeNumberPad;
    [BLULoginOrRegUIComponent textFieldContainer:_mobileTextFieldContainer placeholder:@"手机号码" superview:superview];
    
    _passwordTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeSecurePassword];
    [BLULoginOrRegUIComponent textFieldContainer:_passwordTextFieldContainer placeholder:@"密码" superview:superview];
    
    _resetPasswordButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"666666"]} range:strRange];
    _resetPasswordButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_resetPasswordButton setAttributedTitle:str forState:UIControlStateNormal];
    [superview addSubview:_resetPasswordButton];
    
    // Login button
    _loginButton = [BLUMainTitleButton new];
    _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    _loginButton.title = NSLocalizedString(@"login.login-button.login", @"Log in");
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:_loginButton];

    
    // Or line
    _orLine = [BLUOrSepratorLine new];
    _orLine.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:_orLine];
    
    // Wechat button
    _wechatButton = [UIButton new];
    _wechatButton.translatesAutoresizingMaskIntoConstraints = NO;
    _wechatButton.image = [BLUCurrentTheme wechatIcon];
    [_wechatButton addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:_wechatButton];
    
    NSMutableAttributedString *wechatLabel = [[NSMutableAttributedString alloc] initWithString:@"微信"];
    NSRange wechatRange = {0,[wechatLabel length]};
    [wechatLabel addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:wechatRange];
    [wechatLabel addAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"63cf79"]} range:wechatRange];
    _wechatLabel = [UILabel new];
    _wechatLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_wechatLabel setAttributedText:wechatLabel];
    [superview addSubview:_wechatLabel];
    
    // QQ button
    _qqButton = [UIButton new];
    _qqButton.translatesAutoresizingMaskIntoConstraints = NO;
    _qqButton.image = [BLUCurrentTheme qqIcon];
    [_qqButton addTarget:self action:@selector(QQLogin) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:_qqButton];
    
    NSMutableAttributedString *qqLabel = [[NSMutableAttributedString alloc] initWithString:@"QQ"];
    NSRange qqRange = {0,[qqLabel length]};
    [qqLabel addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:qqRange];
    [qqLabel addAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"69bce5"]} range:qqRange];
    _qqLabel = [UILabel new];
    _qqLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_qqLabel setAttributedText:qqLabel];
    [superview addSubview:_qqLabel];
    
    // Sina button
    _sinaButton = [UIButton new];
    _sinaButton.translatesAutoresizingMaskIntoConstraints = NO;
    _sinaButton.image = [BLUCurrentTheme sinaIcon];
    [_sinaButton addTarget:self action:@selector(sinaLogin) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:_sinaButton];
    
    NSMutableAttributedString *sinaLabel = [[NSMutableAttributedString alloc] initWithString:@"微博"];
    NSRange sinaRange = {0,[sinaLabel length]};
    [sinaLabel addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:sinaRange];
    [sinaLabel addAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"e25265"]} range:sinaRange];
    _sinaLabel = [UILabel new];
    _sinaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_sinaLabel setAttributedText:sinaLabel];
    [superview addSubview:_sinaLabel];
    
    [self configConstraint]; // 设置约束
    
    [_registerButton addTarget:self action:@selector(regAction:) forControlEvents:UIControlEventTouchUpInside];
    [_resetPasswordButton addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];

    RAC(self, mobile) = self.mobileTextFieldContainer.textField.rac_textSignal;
    RAC(self, password) = self.passwordTextFieldContainer.textField.rac_textSignal;
    
    // 登录按钮的点击状态
    RAC(self.loginButton,enabled) = [RACSignal
                                     combineLatest:@[self.mobileTextFieldContainer.textField.rac_textSignal,
                                                     self.passwordTextFieldContainer.textField.rac_textSignal
                                                   ]
                                   reduce:^(NSString *mobile, NSString *password){
                                       return @([mobile isMobile]&& [password isPassword]);
                                   }];
}

- (void)configNavItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(regAction:)];
    rightItem.tintColor = [UIColor colorFromHexString:@"ff3859"];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithnorImage:[UIImage imageNamed:@"icon_classification_back"] heighImage:nil targer:self action:@selector(backAction:)];
}

- (void)configConstraint
{
    
    [_mobileTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    [_passwordTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_mobileTextFieldContainer);
        make.top.equalTo(_mobileTextFieldContainer.mas_bottom).offset(1);
    }];
    
    [_resetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextFieldContainer.mas_bottom).offset(16);
        make.right.equalTo(_passwordTextFieldContainer.mas_right).offset(-16);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_resetPasswordButton.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset([BLUCurrentTheme leftMargin] * 4);
        make.right.equalTo(self.view).offset(-16);
    }];

    
    [_orLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
    }];
    
    _wechatButton.hidden = ![QGSocialService isSupportWX];
    _qqButton.hidden = ![QGSocialService isSupportQQ];
    _sinaButton.hidden = ![QGSocialService isSupportSina];
    self.orLine.hidden = _wechatButton.hidden && _qqButton.hidden && _sinaButton.hidden;
    _wechatLabel.hidden = _wechatButton.hidden;
    _qqLabel.hidden = _qqButton.hidden;
    _sinaLabel.hidden = _sinaButton.hidden;
    
    NSArray *centerXOffsets = @[@[@(1.0)], @[@(0.5), @(1.5)], @[@(0.45), @(1), @(1.55)]];
    NSInteger count = (!_wechatButton.hidden ? 1 : 0) + (!_qqButton.hidden ? 1 : 0) + (!_sinaButton.hidden ? 1 : 0);
    centerXOffsets = count > 0 ? centerXOffsets[count - 1] : nil;
    __block NSInteger idx = 0;
    
    if (!_wechatButton.hidden) {
        [_wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(kShareButtonWidth));
            make.centerX.equalTo(_orLine).multipliedBy(((NSNumber *)centerXOffsets[idx++]).floatValue);
            make.top.equalTo(_orLine.mas_bottom).offset([BLUCurrentTheme leftMargin] * 4);
        }];
        
        [_wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_wechatButton.mas_bottom).offset(4);
            make.centerX.equalTo(_wechatButton);
        }];
    }
    
    
    if (!_qqButton.hidden) {
        [_qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(kShareButtonWidth));
            make.centerX.equalTo(_orLine).multipliedBy(((NSNumber *)centerXOffsets[idx++]).floatValue);
            make.top.equalTo(_orLine.mas_bottom).offset([BLUCurrentTheme leftMargin] * 4);
        }];
        
        [_qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_qqButton.mas_bottom).offset(4);
            make.centerX.equalTo(_qqButton);
        }];
    }
    
    if (!_sinaButton.hidden) {
        [_sinaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(kShareButtonWidth));
            make.centerX.equalTo(_orLine).multipliedBy(((NSNumber *)centerXOffsets[idx++]).floatValue);
            make.top.equalTo(_orLine.mas_bottom).offset([BLUCurrentTheme leftMargin] * 4);
        }];
        
        [_sinaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sinaButton.mas_bottom).offset(4);
            make.centerX.equalTo(_sinaButton);
        }];
    }
}





#pragma mark - 按钮点击事件
// 登录按钮点击
- (void)loginAction:(UIButton *)button{
    @weakify(self)
    [QGHttpManager loginWithMobile:_mobile Password:_password Success:^(NSURLSessionDataTask *task, id responseObject) {
        
        @strongify(self);
        QGLoginUser *user = responseObject;
        BLUAppManager *appManager = [BLUAppManager sharedManager];
        appManager.currentUser = user;
        [QGHttpManager updateDeviceToken:[SAUserDefaults getValueWithKey:USERDEFAULTS_registrationID] Success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        // 登录成功后拉取用户信息详情
        [QGHttpManager getUserDetaileWithUserID:user.userID Success:^(NSURLSessionDataTask *task, id responseObject) {
            BLUAppManager *appManager = [BLUAppManager sharedManager];
            appManager.currentUser = user;
            [SAUserDefaults saveValue:@"1" forKey:USERINFONEEDUPDATE];
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self showTopIndicatorWithError:error];
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
    }];
}

// 注册按钮点击
- (void)regAction:(UIBarButtonItem *)barButton {
    
    QGRegisterViewController *registerVC = [QGRegisterViewController new];
    [self.navigationController pushViewController:registerVC animated:YES];
}

// 重置密码按钮点击
- (void)resetAction:(UIButton *)button {
    
    QGResetPasswordViewcontroller *resetPassword = [QGResetPasswordViewcontroller new];
    [self.navigationController pushViewController:resetPassword animated:YES];
}

// 返回按钮点击
- (void)backAction:(UIBarButtonItem *)barButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 第三方登录方法

- (void)wechatLogin{
    [self thirdPartyLoginWithType:BLUOpenPlatformTypeWechat];
}

- (void)QQLogin{
    [self thirdPartyLoginWithType:BLUOpenPlatformTypeQQ];
}

- (void)sinaLogin{
    [self thirdPartyLoginWithType:BLUOpenPlatformTypeSina];
}

- (void)thirdPartyLoginWithType:(BLUOpenPlatformTypes)type{
    [QGSocialService thirdPartyLoginformType:type inViewController:self];
}

- (void)thirdPartyLogin{
    
    BLUUser *user = [BLUAppManager sharedManager].currentUser;
    [self.view showIndicator];
    @weakify(self)
    [QGHttpManager thirdLoginWithUser:user Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self.view hideIndicator];
        BLUUser *user = responseObject;
        [BLUAppManager sharedManager].currentUser = user;
        [self dismissViewControllerAnimated:YES completion:nil];
        [SAUserDefaults saveValue:@"1" forKey:USERINFONEEDUPDATE];
        [QGHttpManager updateDeviceToken:[SAUserDefaults getValueWithKey:USERDEFAULTS_registrationID] Success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self.view hideIndicator];
        [self showTopIndicatorWithError:error];
    }];
}


@end
