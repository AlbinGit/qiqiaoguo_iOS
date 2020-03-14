//
//  BLUTextFieldContainer.m
//  Blue
//
//  Created by Bowen on 15/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUTextFieldContainer.h"

@interface BLUTextFieldContainer ()

@property (nonatomic, assign) BLUTextFieldContaienrAccessoryType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *closedEyeIcon;
@property (nonatomic, strong) UIImage *openEyeIcon;

@end

@implementation BLUTextFieldContainer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configWithTitle:nil accesssoryType:BLUTextFieldContainerAccessoryTypeNone];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title accessoryType:(BLUTextFieldContaienrAccessoryType)type {
//    if (self = [super initWithTitle:title accessoryType:type]) {
    if (self = [super init]) {
        [self configWithTitle:title accesssoryType:type];
    }
    return self;
}

- (void)configWithTitle:(NSString *)title accesssoryType:(BLUTextFieldContaienrAccessoryType)type {
    
    _type = type;
    _title = title;
    _closedEyeIcon = [BLUCurrentTheme closedEyeIcon];
    _openEyeIcon = [BLUCurrentTheme openedEyeIcon];
    
    // title label
    _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.hidden = title && title.length > 0 ? NO : YES;
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor grayColor];
    [self addSubview:_titleLabel];
    
    // Text field
    _textField = [UITextField new];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.font = _titleLabel.font;
    if (BLUTextFieldContainerAccessoryTypeSecurePassword) {
        _textField.secureTextEntry = YES;
    }
    [self addSubview:_textField];
    
    // Security password button
    _securityPasswordButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
    _securityPasswordButton.hidden = type == BLUTextFieldContainerAccessoryTypeSecurePassword ? NO : YES;
    _securityPasswordButton.translatesAutoresizingMaskIntoConstraints = NO;
    _securityPasswordButton.image = _closedEyeIcon;
    
    [_securityPasswordButton addTarget:self action:@selector(securityPasspassAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_securityPasswordButton];
    
    // Security code button
    _securityCodeButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
    _securityCodeButton.title = @"立即获取";
    [_securityCodeButton setTitleColor:BLUThemeMainColor forState:UIControlStateNormal];
    [_securityCodeButton setTitleColor:[UIColor colorFromHexString:@"c1c1c1"] forState:UIControlStateDisabled];
    _securityCodeButton.titleFont = [UIFont systemFontOfSize:15];
    _securityCodeButton.translatesAutoresizingMaskIntoConstraints = NO;
    _securityCodeButton.hidden = type == BLUTextFieldContainerAccessoryTypeSecurityCode ? NO : YES;
    _securityCodeButton.contentEdgeInsets = UIEdgeInsetsMake([BLUCurrentTheme topMargin] * 2, [BLUCurrentTheme leftMargin], [BLUCurrentTheme bottomMargin] * 2, [BLUCurrentTheme rightMargin]);
    // TODO: set code button
    [self addSubview:_securityCodeButton];
    
    // 验证码的横线
    _CodeButtonLine = [UIView new];
    _CodeButtonLine.backgroundColor = [UIColor colorFromHexString:@"e1e1e1"];
    _CodeButtonLine.hidden = _securityCodeButton.hidden;
    [self addSubview:_CodeButtonLine];
}

- (void)securityPasspassAction:(UIButton *)button {
    if (button.image == _closedEyeIcon) {
        _textField.secureTextEntry = NO;
        button.image = _openEyeIcon;
    } else {
        _textField.secureTextEntry = YES;
        button.image = _closedEyeIcon;
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    UIView *superview = self;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_titleLabel, _securityPasswordButton, _securityCodeButton, _textField, superview);
    
    NSDictionary *metricsDictionary = @{@"margin": @([BLUCurrentTheme leftMargin] * 4)};
    
    NSString *horizonVirtualFormat = @"[_textField(>=20)]-(margin)-";
    // Left
    if (self.title && self.title.length > 0) {
        horizonVirtualFormat = [NSString stringWithFormat:@"%@%@",
                                @"H:|-(margin)-[_titleLabel]-(4)-",
                                horizonVirtualFormat];
        
    } else {
        horizonVirtualFormat = [NSString stringWithFormat:@"%@%@",
                                @"H:|-(margin)-",
                                horizonVirtualFormat];
    }
    // Right
    switch (self.type) {
        case BLUTextFieldContainerAccessoryTypeSecurityCode: {
            horizonVirtualFormat = [horizonVirtualFormat stringByAppendingString:
                                    @"[_securityCodeButton(80)]-(margin)-|"];
        } break;
        case BLUTextFieldContainerAccessoryTypeSecurePassword: {
            horizonVirtualFormat = [horizonVirtualFormat stringByAppendingString:
                                    @"[_securityPasswordButton(40)]-(margin)-|"];
        } break;
        case BLUTextFieldContainerAccessoryTypeNone:
        default: {
            horizonVirtualFormat = [horizonVirtualFormat stringByAppendingString:@"|"];
        } break;
    }
    
    [self addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      horizonVirtualFormat
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [self addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:|-(margin)-[_textField]-(margin)-|"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    void (^addConstraints)(UIView *view) = ^(UIView *view) {
        [superview addConstraint:
         [NSLayoutConstraint
          constraintWithItem:view
          attribute:NSLayoutAttributeCenterY
          relatedBy:NSLayoutRelationEqual
          toItem:self
          attribute:NSLayoutAttributeCenterY
          multiplier:1.0 constant:0]];
        
        [superview addConstraint:
         [NSLayoutConstraint
          constraintWithItem:view
          attribute:NSLayoutAttributeHeight
          relatedBy:NSLayoutRelationEqual
          toItem:_textField
          attribute:NSLayoutAttributeHeight
          multiplier:1.0 constant:0]];
    };
    
    if (self.title && self.title.length > 0) {
        addConstraints(self.titleLabel);
    }
    
    switch (self.type) {
        case BLUTextFieldContainerAccessoryTypeSecurePassword: {
            addConstraints(_securityPasswordButton);
        } break;
        case BLUTextFieldContainerAccessoryTypeSecurityCode: {
            [_securityCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.equalTo(self);
            }];
            [_CodeButtonLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(8);
                make.bottom.equalTo(self).offset(-8);
                make.centerY.equalTo(_textField);
                make.width.equalTo(@1);
                make.left.equalTo(_textField.mas_right).offset(4);
            }];
            
        } break;
        case BLUTextFieldContainerAccessoryTypeNone:
        default: {
        } break;
    }
    
    [super updateConstraints];
}

@end
