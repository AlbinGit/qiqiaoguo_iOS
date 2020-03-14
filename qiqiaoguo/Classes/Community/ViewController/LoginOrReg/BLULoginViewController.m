//
//  BLULoginViewController.m
//  Blue
//
//  Created by Bowen on 5/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLULoginViewController.h"
#import "BLUOrSepratorLine.h"
#import "BLULoginOrRegUIComponent.h"
#import "BLULoginViewModel.h"
#import "BLURegStep1ViewController.h"
#import "BLUResetPasswordViewController.h"

#import "UMSocial.h"

static const CGFloat kShareButtonWidth = 56;
static NSString * const kShouldShowLoginGuideKey = @"kShouldShowLoginGuideKey";
static const NSInteger kDimViewTag = 1002;

@interface BLULoginViewController ()

@property (nonatomic, strong) BLUTextFieldContainer *mobileTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *passwordTextFieldContainer;
@property (nonatomic, strong) UIButton *resetPasswordButton;
@property (nonatomic, strong) BLUMainTitleButton *loginButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *sinaButton;
@property (nonatomic, strong) BLUOrSepratorLine *orLine;

@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) BLULoginViewModel *loginViewModel;

@end

@implementation BLULoginViewController

- (instancetype)init {
    if (self = [super init]) {
        // TODO: Localized
        self.title = NSLocalizedString(@"login.title", @"Login");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *superview = self.view;
    superview.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    // Mobile text field container
    // TODO: Local
    _mobileTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    _mobileTextFieldContainer.textField.secureTextEntry = NO;
    [BLULoginOrRegUIComponent textFieldContainer:_mobileTextFieldContainer placeholder:NSLocalizedString(@"login.mobile-text-field.mobile", @"Mobile") superview:superview];
    
    // Password text field container
    _passwordTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeSecurePassword];
    [BLULoginOrRegUIComponent textFieldContainer:_passwordTextFieldContainer placeholder:NSLocalizedString(@"login.password-text-field.password", @"Password") superview:superview];
    
    // Reset password button
    _resetPasswordButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
    _resetPasswordButton.translatesAutoresizingMaskIntoConstraints = NO;
    // TODO: set attribute titile
    _resetPasswordButton.title = NSLocalizedString(@"login.reset-password-button.reset-password", @"Reset password");
    _resetPasswordButton.titleColor = [BLUCurrentTheme mainColor];
    [superview addSubview:_resetPasswordButton];
    
    // Login button
    _loginButton = [BLUMainTitleButton new];
    _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    _loginButton.title = NSLocalizedString(@"login.login-button.login", @"Log in");
    [superview addSubview:_loginButton];
    
    // Register button
    _registerButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
    _registerButton.translatesAutoresizingMaskIntoConstraints = NO;
    _registerButton.title = NSLocalizedString(@"login.register-button.register", @"Register");
    _registerButton.cornerRadius = BLUThemeHighActivityCornerRadius;
    [superview addSubview:_registerButton];
    
    // Or line
    _orLine = [BLUOrSepratorLine new];
    _orLine.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:_orLine];
    
    // Wechat button
    _wechatButton = [UIButton new];
    _wechatButton.translatesAutoresizingMaskIntoConstraints = NO;
    _wechatButton.image = [BLUCurrentTheme wechatIcon];
    [superview addSubview:_wechatButton];
    
    // QQ button
    _qqButton = [UIButton new];
    _qqButton.translatesAutoresizingMaskIntoConstraints = NO;
    _qqButton.image = [BLUCurrentTheme qqIcon];
    [superview addSubview:_qqButton];
    
    // Sina button
    _sinaButton = [UIButton new];
    _sinaButton.translatesAutoresizingMaskIntoConstraints = NO;
    _sinaButton.image = [BLUCurrentTheme sinaIcon];
    [superview addSubview:_sinaButton];
    
    // Constrants
    id <UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(superview, _mobileTextFieldContainer, topLayoutGuide, _passwordTextFieldContainer, _resetPasswordButton, _loginButton, _orLine, _wechatButton);
    NSDictionary *metricsDictionary = @{@"margin": @([BLUCurrentTheme leftMargin] * 4)};
   
    // H: Mobile text field container
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"H:|-(0)-[_mobileTextFieldContainer]-(0)-|"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    // H: Pass text field container
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"H:|-(0)-[_passwordTextFieldContainer]-(0)-|"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    // H: Reset password button
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"[_resetPasswordButton]-(margin)-|"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    // H: Or line
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"H:|-(margin)-[_orLine]-(margin)-|"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    // V: Vertical
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:|-(0)-[topLayoutGuide]-(0)-"
      @"[_mobileTextFieldContainer]-(1)-"
      @"[_passwordTextFieldContainer]-(8)-"
      @"[_resetPasswordButton]-(8)-"
      @"[_loginButton]-(margin)-"
      @"[_orLine]"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
        make.width.equalTo(superview).multipliedBy(0.5).offset(-[BLUCurrentTheme margin] * 6);
    }];
    
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton);
        make.width.equalTo(_loginButton);
        make.bottom.equalTo(_loginButton);
        make.left.equalTo(_loginButton.mas_right).offset([BLUCurrentTheme leftMargin] * 4);
    }];
    
    _wechatButton.hidden = ![QGSocialService isSupportWX];
//    _qqButton.hidden = ![BLUSocialService isSupportQQ];
//    // FIX 新浪微博不能够进行第三方登录
//    _sinaButton.hidden = ![BLUSocialService isSupportSina];
    self.orLine.hidden = _wechatButton.hidden && _qqButton.hidden && _sinaButton.hidden;
    
    NSArray *centerXOffsets = @[@[@(1.0)], @[@(0.5), @(1.5)], @[@(0.45), @(1), @(1.55)]];
    NSInteger count = (!_wechatButton.hidden ? 1 : 0) + (!_qqButton.hidden ? 1 : 0) + (!_sinaButton.hidden ? 1 : 0);
    centerXOffsets = count > 0 ? centerXOffsets[count - 1] : nil;
    __block NSInteger idx = 0;
   
    // Wechat button
    if (!_wechatButton.hidden) {
        [_wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(kShareButtonWidth));
            make.centerX.equalTo(_orLine).multipliedBy(((NSNumber *)centerXOffsets[idx++]).floatValue);
            make.top.equalTo(_orLine.mas_bottom).offset([BLUCurrentTheme leftMargin] * 3);
        }];
    }
   
    // Qq button
    if (!_qqButton.hidden) {
        [_qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(kShareButtonWidth));
            make.centerX.equalTo(_orLine).multipliedBy(((NSNumber *)centerXOffsets[idx++]).floatValue);
            make.top.equalTo(_orLine.mas_bottom).offset([BLUCurrentTheme leftMargin] * 3);
        }];
    }
    
    // Sina button
    if (!_sinaButton.hidden) {
        [_sinaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(kShareButtonWidth));
            make.centerX.equalTo(_orLine).multipliedBy(((NSNumber *)centerXOffsets[idx++]).floatValue);
            make.top.equalTo(_orLine.mas_bottom).offset([BLUCurrentTheme leftMargin] * 3);
        }];
    }
    
    // Navigation
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction:)];
    
    // Model
    [self loginViewModel];
    RAC(self, loginViewModel.mobile) = self.mobileTextFieldContainer.textField.rac_textSignal;
    RAC(self, loginViewModel.password) = self.passwordTextFieldContainer.textField.rac_textSignal;
    
    self.loginButton.rac_command = self.loginViewModel.login;
    
    @weakify(self);
    [_loginButton.rac_command.executionSignals subscribeNext:^(RACSignal *login) {
        [login subscribeNext:^(id x) {
            @strongify(self);
            [self backAction:nil];
        }];
    }];
    [_loginButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];
    
    self.wechatButton.rac_command = self.loginViewModel.wechatLogin;
    [_wechatButton.rac_command.executionSignals subscribeNext:^(RACSignal *login) {
        [login subscribeNext:^(id x) {
            @strongify(self);
            [self backAction:nil];
        }];
    }];
    [_wechatButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        if (error) {
            [self showAlertForError:error];
        }
    }];
    
//    self.qqButton.rac_command = self.loginViewModel.qqLogin;
//    [self.qqButton.rac_command.executionSignals subscribeNext:^(RACSignal *login) {
//        [login subscribeNext:^(id x) {
//            @strongify(self);
//            [self backAction:nil];
//        }];
//    }];
//    [self.qqButton.rac_command.errors subscribeNext:^(NSError *error) {
//        @strongify(self);
//        if (error) {
//            [self showAlertForError:error];
//        }
//    }];
//    
//    self.sinaButton.rac_command = self.loginViewModel.sinaLogin;
//    [self.sinaButton.rac_command.executionSignals subscribeNext:^(RACSignal *login) {
//        [login subscribeNext:^(id x) {
//            @strongify(self);
//            [self backAction:nil];
//        }];
//    }];
    [self.sinaButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        if (error) {
            [self showAlertForError:error];
        }
    }];
    
    [_registerButton addTarget:self action:@selector(regAction:) forControlEvents:UIControlEventTouchUpInside];
    [_resetPasswordButton addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    [self configGuide];
}

- (BLULoginViewModel *)loginViewModel {
    if (_loginViewModel == nil) {
        _loginViewModel = [BLULoginViewModel new];
    }
    return _loginViewModel;
}

- (void)regAction:(UIButton *)button {
    BLURegStep1ViewController *regVC = [BLURegStep1ViewController new];
    [self.navigationController pushViewController:regVC animated:YES];
}

- (void)resetAction:(UIButton *)button {
    BLUResetPasswordViewController *resetVC = [BLUResetPasswordViewController new];
    [self.navigationController pushViewController:resetVC animated:YES];
}

- (void)backAction:(UIBarButtonItem *)barButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configGuide {
    NSNumber *show = [[NSUserDefaults standardUserDefaults] objectForKey:kShouldShowLoginGuideKey];
    if (show) {
        if (show.boolValue == YES) {
            [self showGuide];
        }
    } else {
        [self showGuide];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:kShouldShowLoginGuideKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showGuide {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIView *dimView = [UIView new];
    dimView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.8];
    dimView.alpha = 0.0;
    dimView.tag = kDimViewTag;
    UITapGestureRecognizer *tapDimView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGuide:)];
    [dimView addGestureRecognizer:tapDimView];

    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"guide-login-prompt"];

    UILabel *label = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    label.text = NSLocalizedString(@"login-vc.guide-view.content", @"Guide");
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];

    UIButton *button = [UIButton makeThemeButtonWithType:BLUButtonTypeSolidRoundRect];
    button.backgroundColor = BLUThemeMainColor;
    button.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin * 2, BLUThemeMargin * 10, BLUThemeMargin * 2, BLUThemeMargin * 10);
    button.title = NSLocalizedString(@"login-vc.guide-view.button.title", @"OK");
    button.titleColor = label.textColor;
    button.cornerRadius = BLUThemeHighActivityCornerRadius;
    [button addTarget:self action:@selector(hideGuide:) forControlEvents:UIControlEventTouchUpInside];

    [window addSubview:dimView];
    [dimView addSubview:imageView];
    [imageView addSubview:label];
    [imageView addSubview:button];

    dimView.frame = window.bounds;

    [imageView sizeToFit];
    imageView.centerX = dimView.centerX;
    imageView.centerY = dimView.centerY;

    CGSize labelSize = [label sizeThatFits:CGSizeMake(imageView.width - BLUThemeMargin * 4, CGFLOAT_MAX)];
    label.size = labelSize;
    label.x = BLUThemeMargin * 2;
    label.y = 120;

    [button sizeToFit];
    button.y = imageView.height - button.height - BLUThemeMargin * 3;
    button.centerX = imageView.width / 2.0;

    [UIView animateWithDuration:0.4 animations:^{
        dimView.alpha = 1.0;
    }];

}

- (void)hideGuide:(id)sender {
    UIView *dimView = nil;
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == kDimViewTag) {
            dimView = view;
            break;
        }
    }

    if (dimView) {
        [UIView animateWithDuration:0.2 animations:^{
            dimView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [dimView removeFromSuperview];
        }];
    }
}

@end
