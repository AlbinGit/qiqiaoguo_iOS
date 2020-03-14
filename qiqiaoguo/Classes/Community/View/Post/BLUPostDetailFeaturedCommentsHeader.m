//
//  BLUPostDetailFeaturedCommentsHeader.m
//  Blue
//
//  Created by Bowen on 29/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailFeaturedCommentsHeader.h"

@implementation BLUPostDetailFeaturedCommentsHeader

- (instancetype)init {
    if (self = [super init]) {
        _featuredCommentsLabel = [UILabel new];
        NSString *featuredCommentsTitle =
        NSLocalizedString(@"post-detail-async-vc.featured-comments-title",
                          @"Featured comments");
        _featuredCommentsLabel.attributedText =
        [self attributedHeaderTitle:featuredCommentsTitle];

        [self addSubview:_featuredCommentsLabel];
        self.clipsToBounds = YES;
        self.translucent = YES;
        self.barTintColor = [UIColor colorFromHexString:@"ebebeb"];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {

    [_featuredCommentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(BLUThemeMargin * 4);
    }];

    [super updateConstraints];
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

@end
