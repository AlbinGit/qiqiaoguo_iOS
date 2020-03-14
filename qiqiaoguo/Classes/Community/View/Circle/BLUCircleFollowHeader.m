//
//  BLUCircleFollowHeader.m
//  Blue
//
//  Created by Bowen on 7/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUCircleFollowHeader.h"

@implementation BLUCircleFollowHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        _promptLabel = [UILabel new];
        _promptLabel.attributedText = [self attributedRecommendedUser];

        _changeButton = [UIButton new];
        [_changeButton setImage:[UIImage imageNamed:@"circle-follow-header-change"]
                       forState:UIControlStateNormal];
        [_changeButton setAttributedTitle:[self attributedChange]
                                 forState:UIControlStateNormal];
        [_changeButton addTarget:self
                          action:@selector(tapAndChange:)
                forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_promptLabel];
        [self addSubview:_changeButton];

        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_promptLabel sizeToFit];
    CGFloat promptLabelY = (self.height - _promptLabel.height) / 2.0;
    _promptLabel.frame = CGRectMake(BLUThemeMargin * 4, promptLabelY, _promptLabel.width, _promptLabel.height);

    [_changeButton sizeToFit];
    CGFloat changeButtonY = (self.height - _changeButton.height) / 2.0;
    CGFloat changeButtonX = self.width - _changeButton.width - BLUThemeMargin * 4;
    _changeButton.frame = CGRectMake(changeButtonX, changeButtonY, _changeButton.width, _changeButton.height);
}

- (NSAttributedString *)attributedRecommendedUser {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName:
          [UIColor colorWithHue:0.5 saturation:0.01 brightness:0.68 alpha:1],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};

    NSString *text =
    NSLocalizedString(@"circle-follow-header.prompt-label.title",
                      @"Recommended user");
    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributed];
}

- (NSAttributedString *)attributedChange {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName: BLUThemeMainColor,
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};

    NSString *text =
    NSLocalizedString(@"circle-follow-header.change-button.title",
                      @"Change");

    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributed];
}

- (void)tapAndChange:(id)sender {
    if ([self.headerDelegate
         respondsToSelector:@selector(shouldChangeRecommendedUserFrom:sender:)]) {
        [self.headerDelegate shouldChangeRecommendedUserFrom:self sender:sender];
    }
}

@end
