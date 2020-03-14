//
//  BLUVideoIndicatorImageView.m
//  Blue
//
//  Created by Bowen on 4/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUVideoIndicatorImageView.h"

@implementation BLUVideoIndicatorImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        [self config];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self config];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        [self config];
    }
    return self;
}

- (void)config {
    _showVideoIndicator = NO;

    _coverView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.6];
    _videoIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"post-play-video"]];
    [self addSubview:_coverView];
    [self addSubview:_videoIndicator];

    [self update];
}

- (void)update {
    _coverView.hidden = !_showVideoIndicator;
    _videoIndicator.hidden  = !_showVideoIndicator;
}

- (void)setShowVideoIndicator:(BOOL)showVideoIndicator {
    _showVideoIndicator = showVideoIndicator;
    [self update];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _coverView.frame = self.bounds;

    CGFloat indicatorAspectRatios = 3.0 / 5.0;
    CGFloat indicatorLength = self.width * indicatorAspectRatios;
    CGFloat indicatorX = (self.width - indicatorLength) / 2.0;
    CGFloat indicatorY = (self.height - indicatorLength) / 2.0;
    _videoIndicator.frame = CGRectMake(indicatorX, indicatorY,
                                       indicatorLength, indicatorLength);
}


@end
