//
//  QGRegisterViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/6/28.
//
//

#import "QGRegisterViewController.h"
#import "BLULoginOrRegUIComponent.h"
#import "BLUWebViewController.h"
#import "QGHttpManager.h"
#import "QGHttpManager+User.h"
#import "QGRegisterUserinfoViewController.h"

typedef NS_ENUM(NSInteger, PromptType) {
    PromptTypeNormal = 0,
    PromptTypeSending,
    PromptTypeResend,
};

NSInteger QGSecurityCodeTotalSendingSeconds = 60;
NSInteger QGSecurityCodeSendingInterval = 1;

@interface QGRegisterViewController ()
@property (nonatomic, strong) BLUTextFieldContainer *mobileTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *securityCodeTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *passwordTextFieldContainer;
@property (nonatomic, strong) BLUMainTitleButton *nextStepButton;

@property (nonatomic, strong) UIView *agreementContainer;
@property (nonatomic, strong) UILabel *agreementLabel;
@property (nonatomic, strong) UIButton *agreementButton;

@property (nonatomic, strong) NSString *code; // 验证码
@property (nonatomic, strong) NSString *password; // 验证码
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *prompt; // 时间

@property (nonatomic, strong) NSTimer *repeatingTimer; //定时器
@property (nonatomic, assign) NSInteger leftSeconds;
@property (nonatomic, assign) BOOL isSending; // 发送中
@end

@implementation QGRegisterViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"注册";
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = APPBackgroundColor;
    UIView *superview = self.view;
    
    _mobileTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    _mobileTextFieldContainer.textField.secureTextEntry = NO;
    _mobileTextFieldContainer.textField.keyboardType = UIKeyboardTypeNumberPad;
    [BLULoginOrRegUIComponent textFieldContainer:_mobileTextFieldContainer placeholder:@"手机号码" superview:superview];
    
    // Password text field container
    _securityCodeTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeSecurityCode];
    _securityCodeTextFieldContainer.textField.secureTextEntry = NO;
    _securityCodeTextFieldContainer.textField.keyboardType = UIKeyboardTypeNumberPad;
    [_securityCodeTextFieldContainer.securityCodeButton addTarget:self action:@selector(getValidationCode) forControlEvents:UIControlEventTouchUpInside];
    [BLULoginOrRegUIComponent textFieldContainer:_securityCodeTextFieldContainer placeholder:@"请输入验证码" superview:superview];
    
    _passwordTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeSecurePassword];
    [BLULoginOrRegUIComponent textFieldContainer:_passwordTextFieldContainer placeholder:@"请输入六位数以上的密码" superview:superview];
    
    // Login button
    _nextStepButton = [BLUMainTitleButton new];
    _nextStepButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_nextStepButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];

    [superview addSubview:_nextStepButton];
    
    // Agreement container
    _agreementContainer = [UIView new];
    _agreementLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _agreementButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
    [_agreementButton addTarget:self action:@selector(EULAAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Agreement
    [BLULoginOrRegUIComponent container:_agreementContainer label:_agreementLabel button:_agreementButton prefix:@"点击下一步即同意七巧国的" suffix:@"用户许可协议" superview:superview];
    
    // Constrants
    [_mobileTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(superview);
    }];
    
    [_securityCodeTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.equalTo(_mobileTextFieldContainer.mas_bottom).offset(1);
    }];
    
    
//    if (self.type == QGDetectionTypeBinding) {
        [_passwordTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(superview);
            make.top.equalTo(_securityCodeTextFieldContainer.mas_bottom).offset(1);
        }];
        [_nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_passwordTextFieldContainer.mas_bottom).offset([BLUCurrentTheme topMargin] * 6);
            make.left.equalTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
            make.right.equalTo(superview).offset(-[BLUCurrentTheme rightMargin] * 4);
        }];
//    }else{
//        [_passwordTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(superview);
//        make.top.equalTo(_securityCodeTextFieldContainer.mas_bottom).offset(1);
//    }];
//        [_nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_passwordTextFieldContainer.mas_bottom).offset([BLUCurrentTheme topMargin] * 6);
//            make.left.equalTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
//            make.right.equalTo(superview).offset(-[BLUCurrentTheme rightMargin] * 4);
//        }];
//        
//    }


    
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

    RAC(self, mobile) = self.mobileTextFieldContainer.textField.rac_textSignal;
    RAC(self, code) = self.securityCodeTextFieldContainer.textField.rac_textSignal;
    RAC(self, password) = self.passwordTextFieldContainer.textField.rac_textSignal;
    
    RAC(self.nextStepButton,enabled) = [RACSignal
                                        combineLatest:@[self.mobileTextFieldContainer.textField.rac_textSignal,
                                                        self.securityCodeTextFieldContainer.textField.rac_textSignal,
                                                        self.passwordTextFieldContainer.textField.rac_textSignal
                                                        ]
                                        reduce:^(NSString *mobile,NSString *code,NSString *password){
                                            return @( [mobile isMobile] && (code.length == 6) && [password isPassword]);
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
    
    if (_type == QGDetectionTypeBinding) {
        self.title = @"绑定手机";
        self.nextStepButton.title = @"完成绑定";
        _agreementContainer.hidden = NO;
        _agreementLabel.text = @"*绑定成功后，可通过手机号和设置的密码登录";
        _agreementButton.title = @"";
        [_agreementLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_agreementContainer);
        }];
//        [BLULoginOrRegUIComponent container:_agreementContainer label:_agreementLabel button:_agreementButton prefix:@"点击下一步即同意七巧国的" suffix:@"用户许可协议" superview:superview];
    }else{
        self.title = @"注册";
        _nextStepButton.title = @"下一步";
        _agreementContainer.hidden = NO;
    }
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
    
    Codetype type = Codetyperegister;
    switch (self.type) {
        case QGDetectionTypeRegister: {
            type = Codetyperegister;
            break;
        }
        case QGDetectionTypeBinding: {
            type =  Codetypebinding;
            break;
        }
    }
    
    @weakify(self)
    [QGHttpManager getValidationCodeWithMobile:self.mobile AndType:type Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self)
        self.leftSeconds = QGSecurityCodeTotalSendingSeconds;
        [self configPromptWithType:PromptTypeResend];
        [self startTimer];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self)
        self.isSending = NO;
        [self configPromptWithType:PromptTypeNormal];
        [self showTopIndicatorWithError:error];
    }];
    
}

- (void)EULAAction:(UIButton *)button {
    BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:[BLUApiManager eulaURL]];
    vc.title = NSLocalizedString(@"about.eula", @"EULA");
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击事件
- (void)nextClick{
    
    switch (self.type) {
        case QGDetectionTypeRegister: {
            @weakify(self);
            [QGHttpManager checkValidationCodeWithMobile:self.mobile AndCode:self.code Success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(self);
                QGRegisterUserinfoViewController *userinfoVC = [[QGRegisterUserinfoViewController alloc]initWithMobile:_mobile code:_code];
                [self.navigationController pushViewController:userinfoVC animated:YES];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                @strongify(self);
                [self showTopIndicatorWithError:error];
            }];
            break;
        }
        case QGDetectionTypeBinding: {
            @weakify(self);
            [QGHttpManager UserBoundMobile:self.mobile Code:self.code password:self.password Success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(self);
                [self showTopIndicatorWithSuccessMessage:@"绑定手机成功"];
                [SAUserDefaults saveValue:@"1" forKey:USERINFONEEDUPDATE];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                @strongify(self);
                [self showTopIndicatorWithError:error];
            }];
            break;
        }
    }

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
    
    left -= QGSecurityCodeSendingInterval;
    
    if (left <= 0) {
        self.leftSeconds = 0;
        [self stopTimer];
    } else {
        self.leftSeconds = left;
    }
}

- (void)startTimer {
    [self stopTimer];
    self.leftSeconds = QGSecurityCodeTotalSendingSeconds;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:QGSecurityCodeSendingInterval target:self selector:@selector(timerClicked:) userInfo:nil repeats:YES];
    
    self.repeatingTimer = timer;
}

- (void)stopTimer {
    [self configPromptWithType:PromptTypeNormal];
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

@end
