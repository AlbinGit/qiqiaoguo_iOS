//
//  BLUPostDetailTakeSofaFooterView.m
//  Blue
//
//  Created by Bowen on 6/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUPostDetailTakeSofaFooterView.h"

@implementation BLUPostDetailTakeSofaFooterView

- (instancetype)init {
    if (self = [super init]) {
        _promptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _promptLabel.textColor = BLUThemeSubTintContentForegroundColor;
        _promptLabel.text =
        NSLocalizedString(@"post-detail-vc.tableview-footer-view.prompt-label.text",
                          @"There is no comment.");

        _commentButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
        _commentButton.title =
        NSLocalizedString(@"post-detail-vc.tableview-footer-view.comment-button.title",
                          @"Comment");
        _commentButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _commentButton.contentEdgeInsets =
        UIEdgeInsetsMake(BLUThemeMargin, BLUThemeMargin * 12,
                         BLUThemeMargin, BLUThemeMargin * 12);
        [_commentButton addTarget:self
                           action:@selector(tapAndComment:)
                 forControlEvents:UIControlEventTouchUpInside];
        _commentButton.borderColor = [UIColor grayColor];
        _commentButton.titleColor = [UIColor blackColor];

        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;

        [self addSubview:_promptLabel];
        [self addSubview:_commentButton];
        [self addSubview:_solidLine];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {

    UIView *container = self;

    [_solidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container);
        make.left.equalTo(container);
        make.right.equalTo(container);
        make.height.equalTo(@(BLUThemeOnePixelHeight));
    }];

    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container).offset(BLUThemeMargin * 4);
        make.centerX.equalTo(container);
    }];

    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).offset(BLUThemeMargin * 4);
        make.centerX.equalTo(container);
    }];

    [super updateConstraints];
}

- (void)tapAndComment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(footerViewNeedComment:)]) {
        [self.delegate footerViewNeedComment:self];
    }
}

@end
