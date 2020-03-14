//
//  BLUPostDetailToolbar.m
//  Blue
//
//  Created by Bowen on 29/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailToolbar.h"

@implementation BLUPostDetailToolbar

- (instancetype)init {
    if (self = [super init]) {
        [self layoutIfNeeded];
        _replyBackground = [UIView new];
        _replyBackground.backgroundColor = [UIColor whiteColor];
        _replyBackground.clipsToBounds = YES;
        _replyBackground.cornerRadius = BLUThemeHighActivityCornerRadius;
        UITapGestureRecognizer *recognizer =
        [[UITapGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(tapAndReplyToAuthor:)];
        recognizer.numberOfTapsRequired = 1;
        recognizer.numberOfTouchesRequired = 1;
        _replyRecognizer = recognizer;
        [_replyBackground addGestureRecognizer:recognizer];

        _replyLabel = [UILabel new];
        _replyLabel.attributedText = [self attributedReply];
        [_replyLabel sizeToFit];

        _commentButton = [UIButton new];
        _commentButton.image = [UIImage imageNamed:@"post-comment-icon"];
        [_commentButton addTarget:self
                           action:@selector(tapAndShowComment:)
                 forControlEvents:UIControlEventTouchUpInside];

        _shareButton = [UIButton new];
        [_shareButton setImage:[UIImage imageNamed:@"post-detail-toolbar-share"]
                      forState:UIControlStateNormal];
        [_shareButton addTarget:self
                         action:@selector(tapAndShare:)
               forControlEvents:UIControlEventTouchUpInside];

        _othersButton = [UIButton new];
        [_othersButton setImage:[UIImage imageNamed:@"common-more"]
                       forState:UIControlStateNormal];
        [_othersButton addTarget:self
                          action:@selector(tapAndShowOtherOptions:)
                forControlEvents:UIControlEventTouchUpInside];

        _cornerMarker = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _cornerMarker.backgroundColor = BLUThemeMainColor;
        _cornerMarker.textColor = [UIColor whiteColor];
        _cornerMarker.textAlignment = NSTextAlignmentCenter;
        _cornerMarker.font =
        BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall);
        _cornerMarker.hidden = YES;

        [self addSubview:_replyBackground];
        [_replyBackground addSubview:_replyLabel];
        [self addSubview:_commentButton];
        [self addSubview:_shareButton];
        [self addSubview:_othersButton];
        [self addSubview:_cornerMarker];

        self.clipsToBounds = YES;
        self.translucent = YES;
        self.barTintColor = [UIColor colorFromHexString:@"ebebeb"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat contentWidth = self.width - [self iconHorizonMargin] * 1;
    CGFloat contentHeight =
    [self.class toolbarHeight] - [self iconVerticalMargin] * 2;

    CGFloat iconHeight = contentHeight;
    CGFloat iconWidth = (iconHeight * 3 + [self iconHorizonMargin] * 4) / 3.0;

    CGFloat iconRequiredWidth = iconWidth * 3;

    CGFloat replyBackgroundHeight = contentHeight;
    CGFloat replyBackgroundWidth = contentWidth - iconRequiredWidth;

    CGFloat replyLabelY = (replyBackgroundHeight - _replyLabel.height) / 2.0;
    CGFloat replyLabelMargin = replyLabelY;

    CGFloat replyBackgroundMinWidth =
    _replyLabel.width + replyLabelMargin * 2;

    replyBackgroundWidth = replyBackgroundWidth > replyBackgroundMinWidth ?
    replyBackgroundWidth : replyBackgroundMinWidth;

    _replyBackground.frame =
    CGRectMake([self iconHorizonMargin], [self iconVerticalMargin],
               replyBackgroundWidth,
               replyBackgroundHeight);

    _replyLabel.frame =
    CGRectMake(replyLabelMargin, replyLabelY,
               _replyLabel.width, _replyLabel.height);

    CGFloat commentButtonX =
    CGRectGetMaxX(_replyBackground.frame);

    _commentButton.frame =
    CGRectMake(commentButtonX, 0, iconWidth, self.height);

    CGFloat shareButtonX =
    CGRectGetMaxX(_commentButton.frame);
    _shareButton.frame = CGRectMake(shareButtonX, 0, iconWidth, self.height);

    CGFloat otherButtonX = CGRectGetMaxX(_shareButton.frame);
    _othersButton.frame =
    CGRectMake(otherButtonX, 0, iconWidth, self.height);

    if (_cornerMarker.hidden == NO) {
        [_cornerMarker sizeToFit];
        CGFloat cornerMarkerX = _commentButton.centerX;

        CGFloat cornerMakerWidth = _cornerMarker.width + BLUThemeMargin;
        CGFloat cornerMakerHeight = _cornerMarker.height + BLUThemeMargin;

        cornerMakerWidth = cornerMakerWidth < cornerMakerHeight ?
        cornerMakerHeight : cornerMakerWidth;

        CGFloat cornerMarkerY = _replyBackground.y - cornerMakerHeight / 2.0 +
        (iconHeight - _commentButton.image.size.height) / 2.0;

        _cornerMarker.frame =
        CGRectMake(cornerMarkerX, cornerMarkerY,
                   cornerMakerWidth, cornerMakerHeight);
        _cornerMarker.cornerRadius = cornerMakerHeight / 2.0;
    } else {
        _cornerMarker.frame = CGRectZero;
    }
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    _replyRecognizer.enabled = enabled;
    _commentButton.enabled = enabled;
    _shareButton.enabled = enabled;
    _othersButton.enabled = enabled;
}

- (CGFloat)iconVerticalMargin {
    return BLUThemeMargin * 2;
}

- (CGFloat)iconHorizonMargin{
    return BLUThemeMargin * 4;
}

+ (CGFloat)toolbarHeight {
    return 44.0;
}

- (NSAttributedString *)attributedReply {
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName:
          [UIColor colorWithHue:0.5 saturation:0.01 brightness:0.73 alpha:1],
      NSFontAttributeName:
          BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};
    NSString *title =
    NSLocalizedString(@"post-detail-toolbar.reply-title",
                      @"Reply to author...");
    return
    [[NSAttributedString alloc] initWithString:title
                                    attributes:attributes];
}

- (void)tapAndReplyToAuthor:(UITapGestureRecognizer *)recognizer {
    if ([self.toolbarDelegate
         respondsToSelector:@selector(shouldReplyFrom:sender:)]) {
        [self.toolbarDelegate shouldReplyFrom:self sender:recognizer.view];
    }
}

- (void)tapAndShowComment:(UIButton *)button {
    if ([self.toolbarDelegate
         respondsToSelector:@selector(shouldShowCommentsFrom:sender:)]) {
        [self.toolbarDelegate shouldShowCommentsFrom:self sender:button];
    }
}

- (void)tapAndShare:(UIButton *)button {
    if ([self.toolbarDelegate
         respondsToSelector:@selector(shouldShareFrom:sender:)]) {
        [self.toolbarDelegate shouldShareFrom:self sender:button];
    }
}

- (void)tapAndShowOtherOptions:(UIButton *)button {
    if ([self.toolbarDelegate
         respondsToSelector:@selector(shouldShowOtherOptionsFrom:sender:)]) {
        [self.toolbarDelegate shouldShowOtherOptionsFrom:self sender:button];
    }
}

- (void)showCornerMarkerWithNumberofComments:(NSInteger)numberOfComments {
    if (numberOfComments <= 0) {
        return;
    }
    [UIView animateWithDuration:BLUThemeShortAnimeDuration animations:^{
        _cornerMarker.hidden = NO;
        _cornerMarker.text = @(numberOfComments).description;
    }];
    [self setNeedsLayout];
}

- (void)hideCornerMarker {
    [UIView animateWithDuration:BLUThemeShortAnimeDuration animations:^{
        _cornerMarker.hidden = YES;
    }];
    [self setNeedsLayout];
}

@end
