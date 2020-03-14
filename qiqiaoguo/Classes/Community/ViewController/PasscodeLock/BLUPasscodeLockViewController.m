//
//  BLUPasscodeLockViewController.m
//  Blue
//
//  Created by Bowen on 6/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPasscodeLockViewController.h"
#import "BLUPasscodeLockViewModel.h"
#import "BLUPasscodeLockEnableViewModel.h"
#import "BLUPasscodeLockDisableViewModel.h"
#import "BLUPasscodeLockChangeViewModel.h"
#import "BLUPasscodeLockUnlockViewModel.h"

static const CGFloat kDigitTextFieldHeight = 52.0;

@interface BLUPasscodeLockViewController () <UITextFieldDelegate, BLUPasscodeLockEnableViewModelDelegate, BLUPasscodeLockUnlockViewModelDelegate, BLUPasscodeLockDisableViewModelDelegate>

@property (nonatomic, strong) UITextField *firstDigitTextField;
@property (nonatomic, strong) UITextField *secondDigitTextField;
@property (nonatomic, strong) UITextField *thirdDigitTextField;
@property (nonatomic, strong) UITextField *fourthDigitTextField;

@property (nonatomic, strong) UITextField *passcodeTextField;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *enterPasscodeLabel;
@property (nonatomic, strong) UILabel *failedAttemptLabel;

@property (nonatomic, strong) NSString *passcode;

@property (nonatomic, strong) BLUPasscodeLockEnableViewModel *enableViewModel;
@property (nonatomic, strong) BLUPasscodeLockDisableViewModel *disableViewModel;
@property (nonatomic, strong) BLUPasscodeLockChangeViewModel *changeViewModel;
@property (nonatomic, strong) BLUPasscodeLockUnlockViewModel *unlockViewModel;

@property (nonatomic, strong) BLUPasscodeLockViewModel *currentViewModel;

@end

@implementation BLUPasscodeLockViewController

#pragma mark - Life Circle

+ (BLUPasscodeLockViewController *)passcodeLockViewControllerWithType:(BLUPasscodeLockType)type {
    return [[BLUPasscodeLockViewController alloc] initWithPasscodeLockType:type];
}

- (instancetype)initWithPasscodeLockType:(BLUPasscodeLockType)type {
    if (self = [super init]) {
        switch (type) {
            case BLUPasscodeLockTypeEnable: {
                self.currentViewModel = self.enableViewModel;
            } break;
            case BLUPasscodeLockTypeDisablePasscode: {
                self.currentViewModel = self.disableViewModel;
            } break;
            case BLUPasscodeLockTypeUnlock: {
                self.currentViewModel = self.unlockViewModel;
            } break;
            case BLUPasscodeLockTypeDeletePasscode: {
                self.currentViewModel = self.disableViewModel;
            } break;
            default: {
                self.currentViewModel = self.enableViewModel;
            } break;
        }
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    // ContainerView
    _containerView = [UIView new];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_containerView];
    
    // FirstDigitTextField
    _firstDigitTextField = [self _makeDigitTextField];
    [_containerView addSubview:_firstDigitTextField];
    
    // SecondDigitTextField
    _secondDigitTextField = [self _makeDigitTextField];
    [_containerView addSubview:_secondDigitTextField];
    
    // ThirdDigitTextField
    _thirdDigitTextField = [self _makeDigitTextField];
    [_containerView addSubview:_thirdDigitTextField];
    
    // ForthDigiTextField
    _fourthDigitTextField = [self _makeDigitTextField];
    [_containerView addSubview:_fourthDigitTextField];

    // PasscodeTextField
    _passcodeTextField = [UITextField new];
    _passcodeTextField.delegate = self;
    _passcodeTextField.secureTextEntry = NO;
    _passcodeTextField.keyboardType = UIKeyboardTypePhonePad;
    _passcodeTextField.hidden = YES;
    [self.view addSubview:_passcodeTextField];

    // EnterPasscodeLabel
    _enterPasscodeLabel = [UILabel labelWithFont:[BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeLarge] color:[UIColor colorFromHexString:@"343434"]];
    _enterPasscodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _enterPasscodeLabel.text = @"Enter passcode";
    _enterPasscodeLabel.textAlignment = NSTextAlignmentCenter;
    _enterPasscodeLabel.numberOfLines = 0;
    [self.view addSubview:_enterPasscodeLabel];
    
    // FailedAttemptLabel
    _failedAttemptLabel = [UILabel labelWithFont:[BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeSmall] color:[UIColor colorFromHexString:@"ff0101"]];
    _failedAttemptLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _failedAttemptLabel.text = @"failed";
    _failedAttemptLabel.textAlignment = NSTextAlignmentCenter;
    _failedAttemptLabel.numberOfLines = 0;
    [self.view addSubview:_failedAttemptLabel];
    
    // Constraints
    id <UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(topLayoutGuide, self.bottomLayoutGuide, _enterPasscodeLabel);
    
    NSDictionary *metricsDictionary = @{@"topMargin": @(16)};
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:[topLayoutGuide]-(topMargin)-[_enterPasscodeLabel]"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"H:|-(0)-[_enterPasscodeLabel]-(0)-|"
      options:0 metrics:nil views:viewsDictionary]];

    // NOTE: 这里使用了原生和框架混编
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enterPasscodeLabel.mas_bottom).offset([BLUCurrentTheme topMargin] * 4);
        make.left.right.equalTo(self.view);
    }];
    
    
    NSArray *digitTextFields = @[_firstDigitTextField, _secondDigitTextField, _thirdDigitTextField, _fourthDigitTextField];
    [digitTextFields enumerateObjectsUsingBlock:^(UITextField *digitTextField, NSUInteger idx, BOOL *stop) {
        CGFloat multiplier = (CGFloat)(idx + 1) * 2.0 / 5.0;
        [digitTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.containerView);
            make.centerX.equalTo(self.containerView.mas_centerX).multipliedBy(multiplier);
            make.height.width.equalTo(@(kDigitTextFieldHeight));
        }];
    }];
    
    [_failedAttemptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset([BLUCurrentTheme topMargin] * 2);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    [_passcodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    if ([self.navigationController.viewControllers indexOfObject:self] != 0) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BLUCurrentTheme navBackIndicatorImage] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonClicked:)];
    }
    
    RAC(self, currentViewModel.passcode) = [self.passcodeTextField.rac_textSignal doNext:^(NSString *typedString) {
        if (typedString.length >= 1) _firstDigitTextField.secureTextEntry = YES;
        else _firstDigitTextField.secureTextEntry = NO;
        if (typedString.length >= 2) _secondDigitTextField.secureTextEntry = YES;
        else _secondDigitTextField.secureTextEntry = NO;
        if (typedString.length >= 3) _thirdDigitTextField.secureTextEntry = YES;
        else _thirdDigitTextField.secureTextEntry = NO;
        if (typedString.length >= 4) _fourthDigitTextField.secureTextEntry = YES;
        else _fourthDigitTextField.secureTextEntry = NO;
    }];

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapAndBecomeFirstResponder:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAndBecomeFirstResponder:(UITapGestureRecognizer *)tap {
    if (_passcodeTextField.isFirstResponder) {
        [_passcodeTextField resignFirstResponder];
    } else {
        [_passcodeTextField becomeFirstResponder];
    }
}

- (void)leftBarButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = self.currentViewModel.title;
    self.enterPasscodeLabel.text = self.currentViewModel.enterPasscodeString;
    self.failedAttemptLabel.text = self.currentViewModel.failedString;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_passcodeTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    BLULogVerbose(@"%@ will disappear", self.class);
    [_passcodeTextField resignFirstResponder];
}

#pragma mark - ViewModel

- (BLUPasscodeLockUnlockViewModel *)unlockViewModel {
    if (_unlockViewModel == nil) {
        _unlockViewModel = [BLUPasscodeLockUnlockViewModel new];
        _unlockViewModel.delegate = self;
    }
    return _unlockViewModel;
}

- (BLUPasscodeLockEnableViewModel *)enableViewModel {
    if (_enableViewModel == nil) {
        _enableViewModel = [BLUPasscodeLockEnableViewModel new];
        _enableViewModel.delegate = self;
    }
    return _enableViewModel;
}

- (BLUPasscodeLockChangeViewModel *)changeViewModel {
    if (_changeViewModel == nil) {
        _changeViewModel = [BLUPasscodeLockChangeViewModel new];
    }
    return _changeViewModel;
}

- (BLUPasscodeLockDisableViewModel *)disableViewModel {
    if (_disableViewModel == nil) {
        _disableViewModel = [BLUPasscodeLockDisableViewModel new];
        _disableViewModel.delegate = self;
    }
    return _disableViewModel;
}

#pragma mark - UI

- (UITextField *)_makeDigitTextField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeVeryLarge];
    textField.secureTextEntry = NO;
    textField.userInteractionEnabled = NO;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = BLUThemeMainTintBackgroundColor;
    textField.borderWidth = BLUThemeOnePixelHeight;
    textField.borderColor = [UIColor colorFromHexString:@"c9c9c9"];
    textField.cornerRadius = [BLUCurrentTheme highActivityCornerRadius];
    textField.text = @" ";
    return textField;
}

- (void)_resetData {
    self.enterPasscodeLabel.text = self.currentViewModel.enterPasscodeString;
    self.title = self.currentViewModel.title;
    self.failedAttemptLabel.text = self.currentViewModel.failedString;
}

#pragma mark - Passcode

- (void)clearPasscode {
    self.passcode = @"";
    self.passcodeTextField.text = @"";
    self.firstDigitTextField.secureTextEntry = NO;
    self.secondDigitTextField.secureTextEntry = NO;
    self.thirdDigitTextField.secureTextEntry = NO;
    self.fourthDigitTextField.secureTextEntry = NO;
}

#pragma mark - Animation

- (void)shakeAnime {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath: @"transform.translation.x"];
    animation.duration = 0.6;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAAnimationLinear];
    animation.values = @[@-12, @12, @-12, @12, @-6, @6, @-3, @3, @0];
    [self.containerView.layer addAnimation:animation forKey:@"Shake"];
}

- (void)translationAnimeWithCompletion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.1 animations:^{
        self.containerView.x -= self.containerView.width;
        self.enterPasscodeLabel.centerX -= self.view.width;
    } completion:^(BOOL finished) {
        self.containerView.x = self.containerView.width;
        self.enterPasscodeLabel.centerX = self.view.width * 2;
        [UIView animateWithDuration:0.2 animations:^{
            self.containerView.x = 0.0;
            self.enterPasscodeLabel.centerX = self.view.centerX;
        } completion:^(BOOL finished) {
            completion(finished);
        }];
    }];
}

#pragma mark - Close 

- (void)close {

    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Enable View Model Delegate

- (void)shouldConfirmPasscode {
    BLULogVerbose(@"Should confirm passcode");
    [self translationAnimeWithCompletion:^(BOOL finished) {
        [self clearPasscode];
        [self _resetData];
    }];
}

- (void)enablePasscodeLockSuccess {
    BLULogVerbose(@"Enable passcode lock success");
    [self _resetData];
    [self close];
}

- (void)shouldSetPasscodeAgain {
    BLULogVerbose(@"Should set passcode again");
    [self translationAnimeWithCompletion:^(BOOL finished) {
        [self clearPasscode];
        [self _resetData];
    }];
}

#pragma mark - Unlock & Disable View Model Delegate

- (void)validationSuccess {
    BLULogVerbose(@"Validation success");
    [self _resetData];
    [self close];
}

- (void)validationFailure {
    BLULogVerbose(@"Validation fail");
    [self shakeAnime];
    [self clearPasscode];
    [self _resetData];
}

#pragma mark - Disable View Model Delegate

- (void)disableSuccess {
    BLULogVerbose(@"Disable success");
    [self _resetData];
    [self close];
}

- (void)disableFailure {
    BLULogVerbose(@"Disable failure");
    [self shakeAnime];
    [self _resetData];
    [self clearPasscode];
}

@end
