//
//  BLURegStep2ViewController.m
//  Blue
//
//  Created by Bowen on 6/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLURegStep2ViewController.h"
#import "BLURadioButtonView.h"
#import "BLULoginOrRegUIComponent.h"
#import "BLUSelectAndPickImageViewModel.h"
#import "BLURegViewModel.h"
#import "BLUWebViewController.h"
#import "BLUApiManager.h"

static const CGFloat kAavatarEditViewHeight = 72.0;

@interface BLURegStep2ViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *avatarContainer;
@property (nonatomic, strong) BLUAvatarEditView *avatarEditView;
@property (nonatomic, strong) BLUTextFieldContainer *nicknameTextFieldContainer;
@property (nonatomic, strong) BLUTextFieldContainer *passwordTextFieldContainer;
@property (nonatomic, strong) BLURadioButtonView *genderRadioButtonView;
@property (nonatomic, strong) UILabel *genderPromptLabel;
@property (nonatomic, strong) BLUMainTitleButton *finishRegButton;
@property (nonatomic, strong) UIView *agreementContainer;
@property (nonatomic, strong) UILabel *agreementLabel;
@property (nonatomic, strong) UIButton *agreementButton;

@property (nonatomic, strong) BLUSelectAndPickImageViewModel *selectAndPickImageViewModel;

@property (nonatomic, assign) BOOL didSetAvatarImage;

@property (nonatomic, strong) BLURegViewModel *regViewModel;


@end

@implementation BLURegStep2ViewController

- (instancetype)initWithMobile:(NSString *)mobile {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"reg-step2.title", @"Register");
        _mobile = mobile;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: Local
    UIView *superview = self.view;
    superview.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    // Avatar
    _avatarContainer = [UIView new];
    _avatarEditView = [BLUAvatarEditView new];
    [_avatarEditView.avatarButton addTarget:self action:@selector(selectImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [BLULoginOrRegUIComponent avatarContainer:_avatarContainer avatarEditView:_avatarEditView superview:superview];
    
    // Nickname text field container
    _nicknameTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:NSLocalizedString(@"reg-step2.nickname-text-field.title", @"Nickname") accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    _nicknameTextFieldContainer.textField.secureTextEntry = NO;
    [BLULoginOrRegUIComponent textFieldContainer:_nicknameTextFieldContainer placeholder:NSLocalizedString(@"reg-step2.nickname-text-field.placeholder", @"1-12 characters") superview:superview];
    
    // Password text field container
    _passwordTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:NSLocalizedString(@"reg-step2.password-text-field.title", @"Password") accessoryType:BLUTextFieldContainerAccessoryTypeSecurePassword];
    [BLULoginOrRegUIComponent textFieldContainer:_passwordTextFieldContainer placeholder:NSLocalizedString(@"reg-step2.password-text-field.placeholder", @"6-12 characters") superview:superview];
    
    // Radio button view
    UIButton *maleButton = [UIButton new];
    maleButton.title = NSLocalizedString(@"reg-step2.male-button.title", @" Male");
    [maleButton setTitleColor:[BLUCurrentTheme mainColor] forState:UIControlStateSelected];
    [maleButton setTitleColor:BLUThemeSubTintContentForegroundColor forState:UIControlStateNormal];
    [maleButton setImage:[BLUCurrentTheme userGenderDeselectedIcon] forState:UIControlStateNormal];
    [maleButton setImage:[BLUCurrentTheme userGenderSelectedIcon] forState:UIControlStateSelected];
    
    UIButton *femaleButton = [UIButton new];
    femaleButton.title = NSLocalizedString(@"reg-step2.female-button.title", @" Female");
    [femaleButton setTitleColor:[BLUCurrentTheme mainColor] forState:UIControlStateSelected];
    [femaleButton setTitleColor:BLUThemeSubTintContentForegroundColor forState:UIControlStateNormal];
    [femaleButton setImage:[BLUCurrentTheme userGenderDeselectedIcon] forState:UIControlStateNormal];
    [femaleButton setImage:[BLUCurrentTheme userGenderSelectedIcon] forState:UIControlStateSelected];
    
    _genderRadioButtonView = [[BLURadioButtonView alloc] initWithButtons:@[maleButton, femaleButton] margin:[BLUCurrentTheme leftMargin] * 12];
    self.genderRadioButtonView.seletedIndex = BLUUserGenderMale;
    [superview addSubview:_genderRadioButtonView];
    
    // Gender prompt label
    _genderPromptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeDefault];
    _genderPromptLabel.numberOfLines = 0;
    _genderPromptLabel.font = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeNormal];
    NSString *starString = @"*";
    NSString *genderPromptString = NSLocalizedString(@"reg-step2.gender-prompt-label.title", @"Once you choose a gender, then you can't change any more");
    NSMutableAttributedString *promptString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", starString, genderPromptString]];
    [promptString addAttribute:NSForegroundColorAttributeName value:[BLUCurrentTheme mainColor] range:[promptString.string rangeOfString:starString]];
    [promptString addAttribute:NSFontAttributeName value:[BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeVeryLarge] range:[promptString.string rangeOfString:starString]];
    [promptString addAttribute:NSForegroundColorAttributeName value:BLUThemeSubTintContentForegroundColor range:[promptString.string rangeOfString:genderPromptString]];
    _genderPromptLabel.attributedText = promptString;
    [superview addSubview:_genderPromptLabel];
    
    // Finish reg button
    _finishRegButton = [BLUMainTitleButton new];
    _finishRegButton.backgroundColor = nil;
    _finishRegButton.translatesAutoresizingMaskIntoConstraints = NO;
    _finishRegButton.title = NSLocalizedString(@"reg-step2.finish-button.title", @"Complete registration");
    [superview addSubview:_finishRegButton];
    
    // Agreement container
    _agreementContainer = [UIView new];
    _agreementLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _agreementButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
    [_agreementButton addTarget:self action:@selector(EULAAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Agreement
    [BLULoginOrRegUIComponent container:_agreementContainer label:_agreementLabel button:_agreementButton prefix:NSLocalizedString(@"reg-step2.agree-component.agree", @"Sign up and agree our ") suffix:NSLocalizedString(@"reg-step2.agree-component.user-agreement", @"User agreement") superview:superview];
    
    // Constrants
    id <UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
   
    NSDictionary *metricsDictionary = @{@"margin": @([BLUCurrentTheme leftMargin] * 4)};
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_avatarEditView, _avatarContainer, topLayoutGuide);
    
    [_avatarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
    }];
    
    [_avatarEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarContainer).offset([BLUCurrentTheme leftMargin] * 6);
        make.bottom.equalTo(_avatarContainer).offset(-[BLUCurrentTheme leftMargin] * 6);
        make.width.height.equalTo(@(kAavatarEditViewHeight));
        make.centerX.equalTo(_avatarContainer);
    }];
    
    [_nicknameTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.equalTo(_avatarContainer.mas_bottom);
    }];
    
    [_passwordTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.equalTo(_nicknameTextFieldContainer.mas_bottom).offset(1);
    }];
    
    [_genderRadioButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextFieldContainer.mas_bottom).offset([BLUCurrentTheme topMargin] * 4);
        make.centerX.equalTo(superview);
    }];
    
    [_genderPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_genderRadioButtonView.mas_bottom);
        make.centerX.equalTo(superview);
        make.left.greaterThanOrEqualTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
        make.right.lessThanOrEqualTo(superview).offset(-[BLUCurrentTheme rightMargin] * 4);
    }];
    
    [_finishRegButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_genderPromptLabel.mas_bottom).offset([BLUCurrentTheme topMargin] * 4);
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
    
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:[topLayoutGuide]-(0)-[_avatarContainer]"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
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
    
    RAC(self, regViewModel.mobile) = [RACObserve(self, mobile) doNext:^(id x) {
        BLULogDebug(@"\nmobile = %@\n", x);
    }];
    RAC(self, regViewModel.nickname) = [self.nicknameTextFieldContainer.textField.rac_textSignal doNext:^(id x) {
        BLULogDebug(@"\nnickname = %@\n", x);
    }];
    RAC(self, regViewModel.password) = [self.passwordTextFieldContainer.textField.rac_textSignal doNext:^(id x) {
        BLULogDebug(@"\npassword = %@\n", x);
    }];
    RAC(self, regViewModel.gender) = [RACObserve(self, genderRadioButtonView.seletedIndex) map:^(NSNumber *indexNumber) {
        BLUUserGender gender = indexNumber.integerValue ? BLUUserGenderFemale : BLUUserGenderMale;
        return @(gender);
//        return indexNumber;
    }];
    RAC(self, regViewModel.avatarImage) = [RACObserve(self, avatarEditView.avatarButton.image) map:^id(UIImage *image) {
        @strongify(self);
        if (!self.didSetAvatarImage) {
            return nil;
        }
        return image;
    }];
    
    self.finishRegButton.rac_command = self.regViewModel.reg;
    [[self.finishRegButton.rac_command executionSignals] subscribeNext:^(RACSignal *rag) {
        [rag subscribeNext:^(id x) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
    [[self.finishRegButton.rac_command errors] subscribeNext:^(NSError *error) {
        [self showAlertForError:error];
    }];
}

- (BLURegViewModel *)regViewModel {
    if (_regViewModel == nil) {
        _regViewModel = [BLURegViewModel new];
    }
    return _regViewModel;
}

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
