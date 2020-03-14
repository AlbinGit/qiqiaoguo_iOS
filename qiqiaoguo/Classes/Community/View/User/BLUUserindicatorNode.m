//
//  BLUUserindicatorNode.m
//  Blue
//
//  Created by Bowen on 8/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUUserindicatorNode.h"

@implementation BLUUserindicatorNode

- (instancetype)init {
    if (self = [super init]) {

        _bodyInsets = UIEdgeInsetsMake(BLUThemeMargin * 4,
                                       BLUThemeMargin * 4,
                                       BLUThemeMargin * 4,
                                       BLUThemeMargin * 4);
        _avatarSize = CGSizeMake(32.0, 32.0);
        _indicatorSize = CGSizeMake(16.0, 16.0);
        _contentOffset = BLUThemeMargin * 26.0;

        _avatarNode = [ASNetworkImageNode new];
        _avatarNode.backgroundColor = BLUThemeSubTintBackgroundColor;

        _titleNode = [ASTextNode new];
        _titleNode.maximumNumberOfLines = 1;

        _contentNode = [ASTextNode new];
        _contentNode.maximumNumberOfLines = 1;

        _indicatorNode = [ASImageNode new];

        _separator = [ASDisplayNode new];
        _separator.backgroundColor = BLUThemeSubTintBackgroundColor;

        _avatarNode.hidden = YES;
        _titleNode.hidden = YES;
        _contentNode.hidden = YES;
        _indicatorNode.hidden = YES;

        // 用于计算高度
        _titleNode.attributedString = [self attributedTitle:@"title"];

        [self addSubnode:_avatarNode];
        [self addSubnode:_titleNode];
        [self addSubnode:_contentNode];
        [self addSubnode:_indicatorNode];
        [self addSubnode:_separator];

        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setAvatarURL:(NSURL *)avatarURL {
    BLUAssertObjectIsKindOfClass(avatarURL, [NSURL class]);
    _avatarURL = avatarURL;
    _avatarNode.URL = avatarURL;
    _avatarNode.hidden = NO;
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title {
    BLUAssertObjectIsKindOfClass(title, [NSString class]);
    _title = title;
    _titleNode.attributedString = [self attributedTitle:title];
    _titleNode.hidden = NO;
    [self setNeedsLayout];
}

- (void)setContent:(NSString *)content {
    BLUAssertObjectIsKindOfClass(content, [NSString class]);
    _content = content;
    _contentNode.attributedString = [self attributedContent:content];
    _contentNode.hidden = NO;
    [self setNeedsLayout];
}

- (void)setIndicatorImage:(UIImage *)indicatorImage {
    BLUAssertObjectIsKindOfClass(indicatorImage, [UIImage class]);
    _indicatorImage = indicatorImage;
    _indicatorNode.image = indicatorImage;
    _indicatorNode.hidden = NO;
    [self setNeedsLayout];
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize calculateSize;
    CGSize contentSize;
    calculateSize.width = constrainedSize.width;
    contentSize = [_titleNode measure:CGSizeMake(constrainedSize.width,
                                                 constrainedSize.height)];

    [_contentNode measure:CGSizeMake(constrainedSize.width - _contentOffset -
                                     _bodyInsets.right,
                                     constrainedSize.height)];

    calculateSize.height =
    contentSize.height + _bodyInsets.top + _bodyInsets.bottom + BLUThemeOnePixelHeight;

    return calculateSize;
}

- (void)layout {
    [super layout];

    CGFloat bodyWidth = self.calculatedSize.width;
    CGFloat bodyHeight = self.calculatedSize.height;

    if (_avatarNode.hidden == NO) {
        CGFloat avatarY = (bodyHeight - _avatarSize.height) / 2.0;
        _avatarNode.frame = CGRectMake(_bodyInsets.left, avatarY,
                                       _avatarSize.width,
                                       _avatarSize.height);
    }

    if (_titleNode.hidden == NO) {
        CGFloat titleY = (bodyHeight - _titleNode.calculatedSize.height) / 2.0;
        _titleNode.frame = CGRectMake(_bodyInsets.left, titleY,
                                      _titleNode.calculatedSize.width,
                                      _titleNode.calculatedSize.height);
    }

    if (_contentNode.hidden == NO) {
        CGFloat contentY = (bodyHeight - _contentNode.calculatedSize.height) / 2.0;
        _contentNode.frame = CGRectMake(_contentOffset, contentY,
                                        _contentNode.calculatedSize.width,
                                        _contentNode.calculatedSize.height);
    }

    if (_indicatorNode.hidden == NO) {
        CGFloat indicatorY = (bodyHeight - _indicatorSize.height) / 2.0;
        CGFloat indicatorX = bodyWidth - _bodyInsets.right - _indicatorSize.width;
        _indicatorNode.frame = CGRectMake(indicatorX, indicatorY,
                                          _indicatorSize.width, _indicatorSize.height);
    }

    if (_separator.hidden == NO) {
        _separator.frame = CGRectMake(0, bodyHeight - BLUThemeOnePixelHeight,
                                      bodyWidth, BLUThemeOnePixelHeight);
    }
}

- (NSAttributedString *)attributedTitle:(NSString *)title {
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName: BLUThemeMainDeepContentForegroundColor,
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};

    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (NSAttributedString *)attributedContent:(NSString *)content {
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName: BLUThemeSubDeepContentForegroundColor,
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};

    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

@end
