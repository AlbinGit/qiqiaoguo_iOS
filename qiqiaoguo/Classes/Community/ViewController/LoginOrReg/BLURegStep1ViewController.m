//
//  BLURegStep1ViewController.m
//  Blue
//
//  Created by Bowen on 6/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLURegStep1ViewController.h"
#import "BLULoginOrRegUIComponent.h"
#import "BLUSecurityCodeViewModel.h"
#import "BLURegStep2ViewController.h"
#import "BLUWebViewController.h"


@interface BLURegStep1ViewController ()

@property (nonatomic, strong) BLUTextFieldContainer *mobileTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *securityCodeTextFieldContainer;
@property (nonatomic, strong) BLUMainTitleButton *nextStepButton;

@property (nonatomic, strong) UIView *agreementContainer;
@property (nonatomic, strong) UILabel *agreementLabel;
@property (nonatomic, strong) UIButton *agreementButton;

@property (nonatomic, strong) BLUSecurityCodeViewModel *securityCodeViewModel;

@end

@implementation BLURegStep1ViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"reg-step1.title", @"Register");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: Local
    UIView *superview = self.view;
    superview.backgroundColor = BLUThemeSubTintBackgroundColor;
    _mobileTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    _mobileTextFieldContainer.textField.secureTextEntry = NO;
    [BLULoginOrRegUIComponent textFieldContainer:_mobileTextFieldContainer placeholder:NSLocalizedString(@"reg-step1.mobile-text-field.mobile", @"Mobile") superview:superview];
   
    // Password text field container
    _securityCodeTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeSecurityCode];
    _securityCodeTextFieldContainer.textField.secureTextEntry = NO;
    [BLULoginOrRegUIComponent textFieldContainer:_securityCodeTextFieldContainer placeholder:NSLocalizedString(@"reg-step1.security-code-text-field.security-code", @"Security code") superview:superview];
    
    // Login button
    _nextStepButton = [BLUMainTitleButton new];
    _nextStepButton.translatesAutoresizingMaskIntoConstraints = NO;
    _nextStepButton.title = NSLocalizedString(@"reg-step1.next-step-button.next", @"Next");
    [superview addSubview:_nextStepButton];
    
    // Agreement container
    _agreementContainer = [UIView new];
    _agreementLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _agreementButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
    [_agreementButton addTarget:self action:@selector(EULAAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Agreement
    [BLULoginOrRegUIComponent container:_agreementContainer label:_agreementLabel button:_agreementButton prefix:NSLocalizedString(@"reg-step1.agree-component.agree", @"Sign up and agree our") suffix:NSLocalizedString(@"reg-step1.agree-component.eula", @"User agreement") superview:superview];
    
    // Constrants
    id <UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
    
    NSDictionary *metricsDictionary = @{@"metrics": @([BLUCurrentTheme leftMargin])};
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(topLayoutGuide, _mobileTextFieldContainer, _securityCodeTextFieldContainer);
    
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:[topLayoutGuide]-(0)-[_mobileTextFieldContainer]"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [_mobileTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
    }];
    
    [_securityCodeTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.equalTo(_mobileTextFieldContainer.mas_bottom).offset(1);
    }];
    
    [_nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_securityCodeTextFieldContainer.mas_bottom).offset([BLUCurrentTheme topMargin] * 6);
        make.left.equalTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
        make.right.equalTo(superview).offset(-[BLUCurrentTheme rightMargin] * 4);
    }];
    
    [_agreementContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nextStepButton.mas_bottom).offset([BLUCurrentTheme topMargin] * 4);
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
    _securityCodeTextFieldContainer.securityCodeButton.rac_command = self.securityCodeViewModel.fetchForReg;
    [_securityCodeTextFieldContainer.securityCodeButton.rac_command.executionSignals subscribeNext:^(RACSignal *fetch) {
        [fetch subscribeNext:^(id x) {
            BLULogDebug(@"x = %@", x);
        }];
    }];
    
    
    @weakify(self);
    [_securityCodeTextFieldContainer.securityCodeButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];
    
    _nextStepButton.rac_command = self.securityCodeViewModel.send;
    [_nextStepButton.rac_command.executionSignals subscribeNext:^(RACSignal *send) {
        [send subscribeNext:^(id x) {
            BLULogDebug(@"x = %@", x);
            BLURegStep2ViewController *vc = [[BLURegStep2ViewController alloc] initWithMobile:self.securityCodeViewModel.mobile];
            [self pushViewController:vc];
        }];
    }];
    [_nextStepButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];
    
    RAC(self, securityCodeViewModel.mobile) = self.mobileTextFieldContainer.textField.rac_textSignal;
    RAC(self, securityCodeViewModel.code) = self.securityCodeTextFieldContainer.textField.rac_textSignal;
    [RACObserve(self, securityCodeViewModel.prompt) subscribeNext:^(NSString *prompt) {
        @strongify(self);
        self.securityCodeTextFieldContainer.securityCodeButton.title = prompt;
    }];
}

- (BLUSecurityCodeViewModel *)securityCodeViewModel {
    _securityCodeViewModel = [BLUSecurityCodeViewModel sharedViewModel];
    return _securityCodeViewModel;
}

- (void)EULAAction:(UIButton *)button {
#ifdef BLUDebug
    BLURegStep2ViewController *vc = [[BLURegStep2ViewController alloc] initWithMobile:self.securityCodeViewModel.mobile];
    [self pushViewController:vc];
#else
    BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:[BLUApiManager eulaURL]];
    vc.title = NSLocalizedString(@"about.eula", @"EULA");
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

@end
