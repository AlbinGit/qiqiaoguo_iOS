//
//  BLUSendPost2CircleSelector.m
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUSendPost2CircleSelector.h"

#define kSendToCircleStr NSLocalizedString(@"send-post-2-circle-selector.send-label.title.send-to-circle", @"Send to circle")
#define kSendToStr NSLocalizedString(@"send-post-2-circle-selector.send-label.title.send-to", @"Send to")

@implementation BLUSendPost2CircleSelector

- (instancetype)init {
    if (self = [super init]) {
        _sendLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _sendLabel.text = kSendToCircleStr;
        _sendLabel.textColor = [UIColor colorFromHexString:@"#979899"];

        _circleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _circleLabel.textColor = [UIColor colorFromHexString:@"#656667"];

        _indicator = [UIImageView new];
        _indicator.image = [UIImage imageNamed:@"send-post-select-circle"];


        [self addSubview:_sendLabel];
        [self addSubview:_circleLabel];
        [self addSubview:_indicator];

        _circleTitle = nil;

        self.backgroundColor = [UIColor colorFromHexString:@"#EDEEEE"];

        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapIndicator:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:recognizer];

        [self configureUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_sendLabel sizeToFit];
    CGFloat sendLabelX = BLUThemeMargin * 4;
    CGFloat sendLabelY = self.height / 2.0 - _sendLabel.height / 2.0;
    _sendLabel.frame = CGRectMake(sendLabelX, sendLabelY, _sendLabel.width, _sendLabel.height);

    CGSize indicatorSize = [UIImage imageNamed:@"send-post-select-circle"].size;
    CGFloat indicatorX = self.width - indicatorSize.width - BLUThemeMargin * 4;
    CGFloat indicatorY = (self.height - indicatorSize.height) / 2.0;
    _indicator.frame = CGRectMake(indicatorX, indicatorY,
                                  indicatorSize.width, indicatorSize.height);

    [_circleLabel sizeToFit];
    CGFloat circleLabelX = _indicator.x - BLUThemeMargin * 2 - _circleLabel.width;
    _circleLabel.frame = CGRectMake(circleLabelX, sendLabelY, _circleLabel.width, _circleLabel.height);
}

- (void)setCircleTitle:(NSString *)circleTitle {
    _circleTitle = circleTitle;
    [self configureUI];
}

- (void)configureUI {
    if (_circleTitle == nil) {
        _sendLabel.text = kSendToCircleStr;
        _circleLabel.hidden = YES;
    } else {
        _sendLabel.text = kSendToStr;
        _circleLabel.hidden = NO;
        _circleLabel.text = _circleTitle;
    }
    [self setNeedsLayout];
}

- (void)tapIndicator:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate
         respondsToSelector:@selector(selectorDidTapIndicator:selector:)]) {
        [self.delegate selectorDidTapIndicator:recognizer.view selector:self];
    }
}

@end
