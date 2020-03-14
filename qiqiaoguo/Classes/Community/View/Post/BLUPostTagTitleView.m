//
//  BLUPostTagTitleView.m
//  Blue
//
//  Created by Bowen on 9/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagTitleView.h"
#import "BLUPostTag.h"

@implementation BLUPostTagTitleView

- (instancetype)init {
    if (self = [super init]) {

        _postTagLabel = [UILabel new];
        _postTagLabel.font =
        BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVeryLarge);
        _postTagLabel.textColor = [UIColor whiteColor];

        _postCountLabel = [UILabel new];
        _postCountLabel.font =
        BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _postCountLabel.textColor = [UIColor whiteColor];

        [self addSubview:_postTagLabel];
        [self addSubview:_postCountLabel];

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _postCountLabel.frame = CGRectMake(BLUThemeMargin * 4,
                                       self.height - _postTagLabel.height - BLUThemeMargin * 4,
                                       _postCountLabel.width,
                                       _postCountLabel.height);

    _postTagLabel.frame = CGRectMake(_postCountLabel.x,
                                     _postCountLabel.y - BLUThemeMargin * 2 - _postTagLabel.height,
                                     _postTagLabel.width,
                                     _postTagLabel.height);
}

- (void)setPostTag:(BLUPostTag *)postTag {
    _postTag = postTag;

    _postTagLabel.text = [NSString stringWithFormat:@"#%@#", _postTag.title];
    _postCountLabel.text =
    [NSString stringWithFormat:@"%@ %@",
     NSLocalizedString(@"post-tag-title-view.post-count-label.title-prompt",
                       @"Post count"),
     @(postTag.postCount)];

    [_postTagLabel sizeToFit];
    [_postCountLabel sizeToFit];
    [self setNeedsLayout];
}

+ (CGFloat)postTagTitleViewHeight {
    return 600.0 / 1080.0 * MAIN_SCREEN_WIDTH;
}

@end
