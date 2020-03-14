//
//  BLUCircleFollowFooterView.m
//  Blue
//
//  Created by Bowen on 11/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUCircleFollowFooterView.h"

@implementation BLUCircleFollowFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        _refreshButton = [UIButton new];
        _refreshButton.cornerRadius = BLUThemeNormalActivityCornerRadius;
        _refreshButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);
        [_refreshButton setTitle:NSLocalizedString(@"circle-follow-footer-view.refresh-button.start-browsing", @"Start browing")
                        forState:UIControlStateNormal];
        [_refreshButton addTarget:self
                           action:@selector(tapAndRefresh:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self configureRefreshButton];

        [self addSubview:_refreshButton];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {

    [_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(BLUThemeMargin * 2);
        make.left.equalTo(self).offset(BLUThemeMargin * 4);
        make.right.equalTo(self).offset(-BLUThemeMargin * 4);
        make.bottom.equalTo(self).offset(-BLUThemeMargin * 2);
    }];

    [super updateConstraints];
}

- (void)setDidFollow:(BOOL)didFollow {
    _didFollow = didFollow;
    [self configureRefreshButton];
}

- (void)configureRefreshButton {
    _refreshButton.titleColor = [UIColor whiteColor];
    if (_didFollow) {
        _refreshButton.backgroundColor = BLUThemeMainColor;
        _refreshButton.titleColor = [UIColor whiteColor];
        _refreshButton.enabled = YES;
    } else {
        _refreshButton.backgroundColor = [UIColor colorFromHexString:@"c1c1c1"];
        _refreshButton.titleColor = [UIColor colorFromHexString:@"999999"];
        _refreshButton.enabled = NO;
    }
}

- (void)tapAndRefresh:(id)sender {
    if ([self.delegate respondsToSelector:@selector(footerViewDidRefresh:)]) {
        [self.delegate footerViewDidRefresh:self];
    }
}

@end
