//
//  BLUThirdPartyLoginViewController.m
//  Blue
//
//  Created by Bowen on 6/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUThirdPartyLoginViewController.h"
#import "BLULoginOrRegUIComponent.h"

static const CGFloat kAavatarEditViewHeight = 72.0;

@interface BLUThirdPartyLoginViewController ()

@property (nonatomic, strong) UIView *avatarContainer;
@property (nonatomic, strong) BLUAvatarEditView *avatarEditView;
@property (nonatomic, strong) BLUTextFieldContainer *nicknameTextFieldContainer;
@property (nonatomic, strong) BLUMainTitleButton *loginButton;

@end

@implementation BLUThirdPartyLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO: Local
    
    UIView *superview = self.view;
    superview.backgroundColor = BLUThemeMainTintBackgroundColor;
    
    // Avatar
    _avatarContainer = [UIView new];
    _avatarEditView = [BLUAvatarEditView new];
    [BLULoginOrRegUIComponent avatarContainer:_avatarContainer avatarEditView:_avatarEditView superview:superview];
    
    // Nickname text field container
    _nicknameTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:@"Nickname" accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    [BLULoginOrRegUIComponent textFieldContainer:_nicknameTextFieldContainer placeholder:@"No more than 12 characters" superview:superview];
    
    // Login button
    _loginButton = [BLUMainTitleButton new];
    _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    _loginButton.title = @"Login";
    [superview addSubview:_loginButton];
   
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
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nicknameTextFieldContainer.mas_bottom).offset([BLUCurrentTheme topMargin] * 4);
        make.left.equalTo(superview).offset([BLUCurrentTheme leftMargin] * 4);
        make.right.equalTo(superview).offset(-[BLUCurrentTheme rightMargin] * 4);
    }];
    
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:[topLayoutGuide]-(0)-[_avatarContainer]"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
}

@end
