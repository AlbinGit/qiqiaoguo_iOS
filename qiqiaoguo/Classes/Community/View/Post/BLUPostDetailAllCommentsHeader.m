//
//  BLUPostDetailAllCommentsHeader.m
//  Blue
//
//  Created by Bowen on 29/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAllCommentsHeader.h"

@implementation BLUPostDetailAllCommentsHeader

- (instancetype)init {
    if (self = [super init]) {

        _commentsReverse = YES;

        _commentsLabel = [UILabel new];
        NSString *commentsTitle =
        NSLocalizedString(@"post-detail-async-vc.comments-title",
                          @"All Comments");
        _commentsLabel.attributedText =
        [self attributedHeaderTitle:commentsTitle];
        [_commentsLabel sizeToFit];

        [self addSubview:_commentsLabel];
        [self setTranslucent:YES];
        self.clipsToBounds = YES;

        _orderButton = [UIButton new];
        _orderButton.borderColor =
        [UIColor colorWithHue:0.54 saturation:0.02 brightness:0.79 alpha:1];
        _orderButton.borderWidth = 1.0;
        _orderButton.clipsToBounds = 1.0;
        UIEdgeInsets orderButtonContentInsets = _orderButton.contentEdgeInsets;
        orderButtonContentInsets.left += BLUThemeMargin * 3;
        orderButtonContentInsets.right += BLUThemeMargin * 3;
        orderButtonContentInsets.top += BLUThemeMargin / 2.0;
        orderButtonContentInsets.bottom += BLUThemeMargin / 2.0;
        _orderButton.contentEdgeInsets = orderButtonContentInsets;
        [_orderButton addTarget:self
                         action:@selector(tapAndChangeCommentsReverse:)
               forControlEvents:UIControlEventTouchUpInside];
        [self configureOrderButton];
        [self addSubview:_orderButton];

        self.translucent = YES;
        self.barTintColor = [UIColor colorFromHexString:@"ebebeb"];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {

    [_commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(BLUThemeMargin * 4);
    }];

    [_orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-BLUThemeMargin * 4);
        make.centerY.equalTo(self);
    }];

    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _orderButton.cornerRadius = _orderButton.height / 2.0;
}

- (void)setCommentsReverse:(BOOL)commentsReverse {
    if (_commentsReverse != commentsReverse) {
        [self configureOrderButton];
    }
}

- (void)configureOrderButton {
    NSString *ascTitle = NSLocalizedString(@"post-detail-all-comments-header.asc-title",
                                           @"Ascending");
    NSString *descTitle = NSLocalizedString(@"post-detail-all-comments-header.desc-title",
                                            @"Descending");
    NSString *title = nil;
    if (_commentsReverse) {
        title = ascTitle;
    } else {
        title = descTitle;
    }
    NSAttributedString *attrTitle = [self attributedOrderTitle:title];
    [_orderButton setAttributedTitle:attrTitle
                            forState:UIControlStateNormal];
}

- (void)tapAndChangeCommentsReverse:(UIButton *)button {
    _commentsReverse = !_commentsReverse;
    [self configureOrderButton];
    if ([self.headerDelegate
         respondsToSelector:@selector(shouldChangeCommentsReverse:from:sender:)]) {
        [self.headerDelegate shouldChangeCommentsReverse:_commentsReverse
                                              from:self
                                            sender:button];
    }
    button.enabled = NO;
    [self performSelector:@selector(enableButton:) withObject:button afterDelay:0.5];
}

- (void)enableButton:(UIButton *)button {
    button.enabled = YES;
}

- (NSAttributedString *)attributedHeaderTitle:(NSString *)title {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName: [UIColor colorWithHue:0.58
                                                 saturation:0.02
                                                 brightness:0.41
                                                      alpha:1],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};

    return
    [[NSAttributedString alloc] initWithString:title attributes:attributed];
}

- (NSAttributedString *)attributedOrderTitle:(NSString *)title {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName: [UIColor colorWithHue:0.58
                                                 saturation:0.02
                                                 brightness:0.41
                                                      alpha:1],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal)};

    return
    [[NSAttributedString alloc] initWithString:title attributes:attributed];
}

@end
