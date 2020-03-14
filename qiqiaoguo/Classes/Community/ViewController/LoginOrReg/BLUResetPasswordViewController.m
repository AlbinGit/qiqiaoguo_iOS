//
//  BLUResetPasswordViewController.m
//  Blue
//
//  Created by Bowen on 6/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUResetPasswordViewController.h"
#import "BLULoginOrRegUIComponent.h"
#import "BLUSecurityCodeViewModel.h"

@interface BLUResetPasswordViewController ()

@property (nonatomic, strong) BLUTextFieldContainer *mobileTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *securityCodeTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *securityPasswordTextFieldContainer;
@property (nonatomic, strong) BLUMainTitleButton *resetPasswordButton;
@property (nonatomic, strong) UIView *promptContainer;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *promptButton;

@property (nonatomic, strong) BLUSecurityCodeViewModel *securityCodeViewModel;

@end

@implementation BLUResetPasswordViewController

- (instancetype)init {
    return [self initWithUserMobileOperation:BLUUserMobileOperationResetPassword];
}

- (instancetype)initWithUserMobileOperation:(BLUUserMobileOperation)operation {
    if (self = [super init]) {
        _userMobileOperation = operation;
        self.title =
        operation == BLUUserMobileOperationBindMobile ?
        NSLocalizedString(@"reset-password.bind-mobile.title", @"Bind mobile") :
        NSLocalizedString(@"reset-password.title", @"Reset password");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *superview = self.view;
    superview.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    // Mobile text field container
    _mobileTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    _mobileTextFieldContainer.textField.secureTextEntry = NO;
    [BLULoginOrRegUIComponent textFieldContainer:_mobileTextFieldContainer placeholder:NSLocalizedString(@"reset-password.mobile-text-field.mobile", @"Mobile") superview:superview];
    
    // Security code text field container
    _securityCodeTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeSecurityCode];
    _securityCodeTextFieldContainer.textField.secureTextEntry = NO;
    [BLULoginOrRegUIComponent textFieldContainer:_securityCodeTextFieldContainer placeholder:NSLocalizedString(@"reset-password.security-code-text-field.security-code", @"Security code") superview:superview];
    
    // Security password text field container
    _securityPasswordTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeSecurePassword];
    _securityPasswordTextFieldContainer.textField.secureTextEntry = YES;
    [BLULoginOrRegUIComponent textFieldContainer:_securityPasswordTextFieldContainer placeholder:NSLocalizedString(@"reset-password.security-password-text-field.security-password", @"Security password") superview:superview];
    
    // Reset password button
    _resetPasswordButton = [BLUMainTitleButton new];
    _resetPasswordButton.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.userMobileOperation == BLUUserMobileOperationResetPassword) {
        _resetPasswordButton.title = NSLocalizedString(@"reset-password.reset-password-button.reset-password", @"Reset password");
    } else {
        _resetPasswordButton.title = NSLocalizedString(@"reset-password.reset-password-button.bind-mobile", @"Bind mobile");
    }
    [superview addSubview:_resetPasswordButton];
    
    // Agreement
    _promptContainer = [UIView new];
    _promptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _promptButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
    [BLULoginOrRegUIComponent container:_promptContainer label:_promptLabel button:_promptButton prefix:NSLocalizedString(@"reset-password.prompt-button.contact-us", @"Contact us") suffix:@"QQ: 524509159" superview:superview];
    _promptButton.hidden = YES;

    if (self.userMobileOperation == BLUUserMobileOperationBindMobile) {
        _promptLabel.hidden = NO;
        NSString *asterisk = @"*";
        NSString *promptStr = NSLocalizedString(@"reset-password-vc.prompt-label.binding-prompt", @"Binding prompt");
        NSString *prompt = [NSString stringWithFormat:@"%@%@", asterisk, promptStr];
        NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc] initWithString:prompt];
        [atrStr addAttribute:NSForegroundColorAttributeName value:BLUThemeMainColor range:[atrStr.string rangeOfString:asterisk]];
        [atrStr addAttribute:NSForegroundColorAttributeName value:BLUThemeSubDeepContentForegroundColor range:[atrStr.string rangeOfString:promptStr]];
        _promptLabel.attributedText = atrStr;
        _promptLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        _promptLabel.hidden = YES;
    }

    // Constrants
    id <UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(superview, _mobileTextFieldContainer, _securityCodeTextFieldContainer, _securityPasswordTextFieldContainer, topLayoutGuide);
    NSDictionary *metricsDictionary = @{@"margin": @([BLUCurrentTheme leftMargin] * 4)};
    
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:[topLayoutGuide]-(0)-[_mobileTextFieldContainer]"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [_mobileTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
    }];
    
    [_securityCodeTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobileTextFieldContainer.mas_bottom).offset(1);
        make.left.right.equalTo(superview);
    }];
    
    [_securityPasswordTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_securityCodeTextFieldContainer.mas_bottom).offset(1);
        make.left.right.equalTo(superview);
    }];
    
    [_resetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_securityPasswordTextFieldContainer.mas_bottom).offset([BLUCurrentTheme topMargin] * 6);
        make.left.equalTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
        make.right.equalTo(superview).offset(-[BLUCurrentTheme rightMargin] * 4);
    }];

    if (self.userMobileOperation == BLUUserMobileOperationBindMobile) {
        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_resetPasswordButton.mas_bottom).offset([BLUCurrentTheme topMargin] * 4);
            make.centerX.width.equalTo(_resetPasswordButton);
        }];
    } else {
        [_promptContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_resetPasswordButton.mas_bottom).offset([BLUCurrentTheme topMargin] * 4);
            make.centerX.equalTo(superview);
        }];

        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_promptContainer);
            make.top.bottom.equalTo(_promptContainer);
        }];

        [_promptButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_promptLabel.mas_right).offset([BLUCurrentTheme leftMargin]);
            make.right.equalTo(_promptContainer);
            make.centerY.equalTo(_promptLabel);
        }];
    }
    
    // Model
    if (self.userMobileOperation == BLUUserMobileOperationBindMobile) {
        _securityCodeTextFieldContainer.securityCodeButton.rac_command = self.securityCodeViewModel.fetchForBindMobile;
    } else {
        _securityCodeTextFieldContainer.securityCodeButton.rac_command = self.securityCodeViewModel.fetchForResetPassword;
    }

    [_securityCodeTextFieldContainer.securityCodeButton.rac_command.executionSignals subscribeNext:^(RACSignal *fetch) {
        [fetch subscribeNext:^(id x) {
            BLULogDebug(@"Fetch success");
        }];
    }];
    
    @weakify(self);
    [_securityCodeTextFieldContainer.securityCodeButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];

    if (self.userMobileOperation == BLUUserMobileOperationBindMobile) {
        _resetPasswordButton.rac_command = self.securityCodeViewModel.bindMobile;
    } else {
        _resetPasswordButton.rac_command = self.securityCodeViewModel.resetPassword;
    }

    [_resetPasswordButton.rac_command.executionSignals subscribeNext:^(RACSignal *reset) {
        [reset subscribeNext:^(id x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    [_resetPasswordButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];
    
    RAC(self, securityCodeViewModel.mobile) = self.mobileTextFieldContainer.textField.rac_textSignal;
    RAC(self, securityCodeViewModel.code) = self.securityCodeTextFieldContainer.textField.rac_textSignal;
    RAC(self, securityCodeViewModel.password) = self.securityPasswordTextFieldContainer.textField.rac_textSignal;
    [RACObserve(self, securityCodeViewModel.prompt) subscribeNext:^(NSString *prompt) {
        @strongify(self);
        self.securityCodeTextFieldContainer.securityCodeButton.title = prompt;
    }];
}

- (BLUSecurityCodeViewModel *)securityCodeViewModel {
    _securityCodeViewModel = [BLUSecurityCodeViewModel sharedViewModel];
    return _securityCodeViewModel;
}

@end
