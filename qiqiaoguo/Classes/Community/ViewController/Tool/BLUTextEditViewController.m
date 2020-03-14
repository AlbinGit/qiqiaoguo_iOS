//
//  BLUTextEditVIewController.m
//  Blue
//
//  Created by Bowen on 27/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUTextEditViewController.h"
#import "BLUTextFieldContainer.h"

@interface BLUTextEditViewController ()


@end

@implementation BLUTextEditViewController

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text {
    if (self = [super init]) {
        _text = text;
    }
    
    self.title = title;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    // Text field container
    _textFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    _textFieldContainer.textField.text = self.text;
    _textFieldContainer.backgroundColor = BLUThemeMainTintBackgroundColor;
    _textFieldContainer.textField.secureTextEntry = NO;

    // Text count prompt label
    _textCountPromptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
    _textCountPromptLabel.numberOfLines = 1;
    _textCountPromptLabel.text = @" / ";
    _textCountPromptLabel.backgroundColor = BLUThemeMainTintBackgroundColor;

    // Container
    _promptContainer = [UIView new];
    _promptContainer.backgroundColor = BLUThemeMainTintBackgroundColor;

    [self.view addSubview:_textFieldContainer];
    [self.view addSubview:_promptContainer];
    [_promptContainer addSubview:_textCountPromptLabel];

    // Navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    
    id <UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_textFieldContainer, topLayoutGuide);
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:[topLayoutGuide]-(0)-[_textFieldContainer]"
      options:0 metrics:nil views:viewsDictionary]];
    
    [_textFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];

    [_textCountPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptContainer).offset(BLUThemeMargin * 2);
        make.bottom.equalTo(self.promptContainer).offset(-BLUThemeMargin * 2);
        make.right.equalTo(self.promptContainer).offset(-BLUThemeMargin * 4);
    }];

    [_promptContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textFieldContainer.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_textFieldContainer.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_textFieldContainer resignFirstResponder];
}

- (void)cancelAction:(UIBarButtonItem *)barButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction:(UIBarButtonItem *)barButton {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(textEditViewController:didEditText:)]) {
            [self.delegate textEditViewController:self didEditText:self.textFieldContainer.textField.text];
        }
    }];
}

@end
