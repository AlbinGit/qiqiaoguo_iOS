//
//  BLUPostPlayButton.m
//  Blue
//
//  Created by Bowen on 20/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostPlayButton.h"

@interface BLUPostPlayButton ()

@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIView *blendView;

@end

@implementation BLUPostPlayButton

- (instancetype)init {
    if (self = [super init]) {

        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"post-play-video"];
        imageView.userInteractionEnabled = NO;

        UIView *blendView = [UIView new];
        blendView.backgroundColor = [UIColor blackColor];
        blendView.alpha = 0.5;
        blendView.userInteractionEnabled = NO;

        _playImageView = imageView;
        _blendView = blendView;

        [self addSubview:_blendView];
        [self addSubview:_playImageView];

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat playImageViewWidth = MIN(self.height, self.width) / 3;
    _playImageView.frame = CGRectMake(self.width / 2 - playImageViewWidth / 2, self.height / 2 - playImageViewWidth / 2, playImageViewWidth, playImageViewWidth);

    _blendView.frame = self.bounds;

}

@end
