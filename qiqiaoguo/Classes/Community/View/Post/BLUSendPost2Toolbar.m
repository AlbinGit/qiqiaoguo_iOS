//
//  BLUSendPost2ToolBar.m
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUSendPost2Toolbar.h"

@implementation BLUSendPost2Toolbar

- (instancetype)init {
    if (self = [super init]) {
        _imageButton = [UIButton new];
        [_imageButton setImage:[UIImage imageNamed:@"send-post-image"]
                      forState:UIControlStateNormal];
        [_imageButton addTarget:self action:@selector(touchAndSelectImageAction:) forControlEvents:UIControlEventTouchUpInside];

        _tagButton = [UIButton new];
        [_tagButton setImage:[UIImage imageNamed:@"send-post-tag"]
                    forState:UIControlStateNormal];
        [_tagButton addTarget:self action:@selector(touchAndSelectTagAction:) forControlEvents:UIControlEventTouchUpInside];

        _anonymousButton = [UIButton new];
        _anonymousButton.selected = NO;
        [_anonymousButton setImage:[BLUCurrentTheme postSelectedImageIcon] forState:UIControlStateSelected];
        [_anonymousButton setImage:[BLUCurrentTheme postDeselectedCircle] forState:UIControlStateNormal];
        [_anonymousButton setTitleColor:BLUThemeSubDeepContentForegroundColor forState:UIControlStateNormal];
        _anonymousButton.imageView.tintColor = BLUThemeMainColor;
        [_anonymousButton addTarget:self action:@selector(touchAndSetAnonymousAction:) forControlEvents:UIControlEventTouchUpInside];
        _anonymousButton.tintColor = BLUThemeMainColor;
        _anonymousButton.imageView.tintColor = BLUThemeMainColor;
        _anonymousButton.title = NSLocalizedString(@"send-post.toolbar.button.title", @"Anonymous");

        _keyboardButton = [UIButton new];
        [_keyboardButton setImage:[UIImage imageNamed:@"send-post-hide-keyboard"]
                         forState:UIControlStateNormal];
        [_keyboardButton addTarget:self action:@selector(touchAndHideKeyboard:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_imageButton];
        [self addSubview:_tagButton];
        [self addSubview:_anonymousButton];
        [self addSubview:_keyboardButton];

        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_anonymousButton sizeToFit];
    CGFloat anonymousButtonHeight = _anonymousButton.height;
    CGFloat contentHeight= anonymousButtonHeight;

    CGFloat imageButtonY = self.height / 2.0 - anonymousButtonHeight / 2.0;
    _imageButton.frame = CGRectMake(BLUThemeMargin * 4, imageButtonY, contentHeight, contentHeight);

    _tagButton.frame = CGRectMake(_imageButton.right + BLUThemeMargin * 8, imageButtonY, contentHeight, contentHeight);

    CGFloat keyboardButtonX = self.width - BLUThemeMargin * 4 - contentHeight;
    _keyboardButton.frame = CGRectMake(keyboardButtonX, imageButtonY, contentHeight, contentHeight);

    CGFloat anonymousButtonX = keyboardButtonX - BLUThemeMargin * 4 - _anonymousButton.width;
    _anonymousButton.frame = CGRectMake(anonymousButtonX, imageButtonY, _anonymousButton.width, _anonymousButton.height);
}

- (void)touchAndSelectImageAction:(UIButton *)button {
    if ([self.sendPost2ToolbarDelegate respondsToSelector:@selector(toolbarShouldSelectImage:sender:)]) {
        [self.sendPost2ToolbarDelegate toolbarShouldSelectImage:self sender:button];
    }
}

- (void)touchAndSelectTagAction:(UIButton *)button {
    if ([self.sendPost2ToolbarDelegate respondsToSelector:@selector(toolbarShouldSelectTag:sender:)]) {
        [self.sendPost2ToolbarDelegate toolbarShouldSelectTag:self sender:button];
    }
}

- (void)touchAndSetAnonymousAction:(UIButton *)button {
    _anonymousButton.selected = !_anonymousButton.selected;
    if ([self.sendPost2ToolbarDelegate respondsToSelector:@selector(toolbarDidSetAnonymous:toolbar:sender:)]) {
        [self.sendPost2ToolbarDelegate toolbarDidSetAnonymous:_anonymousButton.selected toolbar:self sender:button];
    }
}

- (void)touchAndHideKeyboard:(UIButton *)button {
    if ([self.sendPost2ToolbarDelegate respondsToSelector:@selector(toolbarShouldHideKeyboard:sender:)]) {
        [self.sendPost2ToolbarDelegate toolbarShouldHideKeyboard:self sender:button];
    }
}

@end
