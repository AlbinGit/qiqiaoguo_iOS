//
//  BLUVideoIndicatorImageNode.m
//  Blue
//
//  Created by Bowen on 4/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUVideoIndicatorImageNode.h"

@implementation BLUVideoIndicatorImageNode

- (instancetype)initWithWebImage {
    if (self = [super initWithWebImage]) {
        self.defaultImage = ImageNamed(@"post-image-default");
        [self config];
    }
    return self;
}

- (void)config {
    _showVideoIndicator = NO;

    _coverNode = [ASDisplayNode new];
    _coverNode.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.6];

    _videoIndicator = [ASImageNode new];
    _videoIndicator.image = [UIImage imageNamed:@"post-play-video"];

    [self addSubnode:_coverNode];
    [self addSubnode:_videoIndicator];

    [self update];
}

- (void)update {
    _coverNode.hidden = !_showVideoIndicator;
    _videoIndicator.hidden = !_showVideoIndicator;
}

- (void)setShowVideoIndicator:(BOOL)showVideoIndicator {
    _showVideoIndicator = showVideoIndicator;
    [self update];
}

- (void)layout {
    [super layout];
    _coverNode.frame = self.bounds;
    
    CGFloat indicatorAspectRatios = 2.0 / 5.0;
    CGFloat indicatorLength = CGRectGetWidth(self.frame) * indicatorAspectRatios;
    CGFloat indicatorX = (CGRectGetWidth(self.frame) - indicatorLength) / 2.0;
    CGFloat indicatorY = (CGRectGetHeight(self.frame) - indicatorLength) / 2.0;
    _videoIndicator.frame = CGRectMake(indicatorX, indicatorY,
                                       indicatorLength, indicatorLength);
}

@end
