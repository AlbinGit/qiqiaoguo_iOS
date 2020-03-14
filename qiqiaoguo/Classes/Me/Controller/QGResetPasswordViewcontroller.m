//
//  QGResetPasswordViewcontroller.m
//  qiqiaoguo
//
//  Created by cws on 16/6/30.
//
//

#import "QGResetPasswordViewcontroller.h"
#import "BLULoginOrRegUIComponent.h"
#import "QGHttpManager+User.h"

typedef NS_ENUM(NSInteger, PromptType) {
    PromptTypeNormal = 0,
    PromptTypeSending,
    PromptTypeResend,
};

@interface QGResetPasswordViewcontroller ()

@property (nonatomic, strong) BLUTextFieldContainer *mobileTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *securityCodeTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *securityPasswordTextFieldContainer;
@property (nonatomic, strong) BLUMainTitleButton *resetPasswordButton;


@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *prompt;  // 获取验证码按钮文字
@property (nonatomic, strong) NSTimer *repeatingTimer; //定时器
@property (nonatomic, assign) NSInteger leftSeconds;
@property (nonatomic, assign) BOOL isSending;

@end

@implementation QGResetPasswordViewcontroller

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"重置密码";
        _leftSeconds = 0;
        _isSending = NO;
        @weakify(self);
        [RACObserve(self, leftSeconds) subscribeNext:^(id x) {
            @strongify(self);
            if (self.leftSeconds > 0) {
                self.isSending = NO;
                [self configPromptWithType:PromptTypeResend];
            } else {
                [self configPromptWithType:PromptTypeNormal];
            }
        }];
        
        [RACObserve(self, isSending) subscribeNext:^(NSNumber *isSending) {
            @strongify(self);
            if (isSending.boolValue) {
                [self configPromptWithType:PromptTypeSending];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *superview = self.view;
    superview.backgroundColor = APPBackgroundColor;
    
    // Mobile text field container
    _mobileTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    _mobileTextFieldContainer.textField.secureTextEntry = NO;
    _mobileTextFieldContainer.textField.keyboardType = UIKeyboardTypeNumberPad;
    [BLULoginOrRegUIComponent textFieldContainer:_mobileTextFieldContainer placeholder:@"手机号码" superview:superview];
    
    // Security code text field container
    _securityCodeTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeSecurityCode];
    _securityCodeTextFieldContainer.textField.secureTextEntry = NO;
    _securityCodeTextFieldContainer.textField.keyboardType = UIKeyboardTypeNumberPad;
    [_securityCodeTextFieldContainer.securityCodeButton addTarget:self action:@selector(getValidationCode) forControlEvents:UIControlEventTouchUpInside];
    [BLULoginOrRegUIComponent textFieldContainer:_securityCodeTextFieldContainer placeholder:@"请输入验证码" superview:superview];
    
    // Security password text field container
    _securityPasswordTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeSecurePassword];
    _securityPasswordTextFieldContainer.textField.secureTextEntry = YES;
    [BLULoginOrRegUIComponent textFieldContainer:_securityPasswordTextFieldContainer placeholder:@"请重新设置6位以上的登录密码" superview:superview];
    
    // Reset password button
    _resetPasswordButton = [BLUMainTitleButton new];
    _resetPasswordButton.translatesAutoresizingMaskIntoConstraints = NO;
        _resetPasswordButton.title = @"完成重置";
    [_resetPasswordButton addTarget:self action:@selector(FinishReset) forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:_resetPasswordButton];

    
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

    // RAC
    RAC(self, mobile) = self.mobileTextFieldContainer.textField.rac_textSignal;
    RAC(self, code) = self.securityCodeTextFieldContainer.textField.rac_textSignal;
    RAC(self, password) = self.securityPasswordTextFieldContainer.textField.rac_textSignal;
    RAC(self.resetPasswordButton,enabled) = [RACSignal
                                        combineLatest:@[self.mobileTextFieldContainer.textField.rac_textSignal,
                                                        self.securityCodeTextFieldContainer.textField.rac_textSignal,
                                                        self.securityPasswordTextFieldContainer.textField.rac_textSignal
                                                        ]
                                        reduce:^(NSString *mobile,NSString *code,NSString *password){
                                            return @( [mobile isMobile] && (code.length == 6) && [password isPassword] );
                                        }];
    @weakify(self)
    RAC(self.securityCodeTextFieldContainer.securityCodeButton,enabled) = [RACSignal
                                                                           combineLatest:@[
                                                                                           RACObserve(self, leftSeconds)
                                                                                           ]
                                                                           reduce:^(NSNumber *lefrSecond){
                                                                               return @(lefrSecond.integerValue <= 0);
                                                                           }];
    [RACObserve(self, prompt) subscribeNext:^(NSString *prompt) {
        @strongify(self);
        self.securityCodeTextFieldContainer.securityCodeButton.title = prompt;
    }];
}

#pragma mark - 完成重置点击
- (void)FinishReset{
    @weakify(self);
    [QGHttpManager resetPasswordWithMobile:self.mobile Code:self.code NewPassword:self.password Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self showTopIndicatorWithSuccessMessage:@"重置密码成功!"];
        [self performSelector:@selector(goToBack) withObject:nil afterDelay:1.5];
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
    }];
    
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -验证码获取
- (void)getValidationCode{
    
    if (![_mobile isMobile]) {
        [self showTopIndicatorWithWarningMessage:@"请输入正确的11位手机号码"];
        return;
    }
    if (self.isSending) {
        return;
    }
    self.isSending = YES;
    
    @weakify(self)
    [QGHttpManager getValidationCodeWithMobile:self.mobile AndType:Codetypepassword Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self)
        self.leftSeconds = 60;
        [self configPromptWithType:PromptTypeResend];
        [self startTimer];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self)
        self.isSending = NO;
        [self configPromptWithType:PromptTypeNormal];
        [self showTopIndicatorWithError:error];
    }];
    
}

#pragma mark - 定时器
- (void)configPromptWithType:(PromptType)type {
    switch (type) {
        case PromptTypeNormal: {
            self.prompt = @"立即获取";
        } break;
        case PromptTypeResend: {
            self.prompt = [NSString stringWithFormat:@"%@秒", @(self.leftSeconds)];
        } break;
        case PromptTypeSending: {
            self.prompt = @"正在获取";
        } break;
        default: {
            self.prompt =  @"立即获取";
        } break;
    }
}

- (void)timerClicked:(NSTimer *)timer {
    NSInteger left = self.leftSeconds;
    
    left -= 1;
    
    if (left <= 0) {
        self.leftSeconds = 0;
        [self stopTimer];
    } else {
        self.leftSeconds = left;
    }
}

- (void)startTimer {
    [self stopTimer];
    self.leftSeconds = 60;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClicked:) userInfo:nil repeats:YES];
    
    self.repeatingTimer = timer;
}

- (void)stopTimer {
    [self configPromptWithType:PromptTypeNormal];
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}


@end
