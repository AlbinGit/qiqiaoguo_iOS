//
//  QGStarRateView.m
//  LongForTianjie
//
//  Created by Albin on 15/11/12.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGStarRateView.h"

@interface QGStarRateView()

@property (nonatomic, strong) UIView * foregroundStarView; // 黄星
@property (nonatomic, strong) UIView * backgroundStarView; // 灰星
@property (nonatomic, assign) NSInteger numberOfStars; // 星星总数


@end

@implementation QGStarRateView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStars:5];
}

- (id)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)number {
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = number;
        [self p_createUI];
    }
    return self;
}

- (void)p_createUI {
    _score = 1;
    _hasAnimation = NO;
    _isComplete = NO;
    
    _foregroundStarView = [self createStarViewWithImage:@"yellow_star"];
    _backgroundStarView = [self createStarViewWithImage:@"star_gray"];
    [self addSubview:_backgroundStarView];
    [self addSubview:_foregroundStarView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRateView:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (UIView *)createStarViewWithImage:(NSString *)imageName {
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < _numberOfStars; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * self.width / _numberOfStars, 0, self.width / _numberOfStars, self.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)tapRateView:(UITapGestureRecognizer *)tap {
    CGPoint tapPoint = [tap locationInView:self];
    CGFloat offsetX = tapPoint.x;
    CGFloat realStarScore = offsetX / (self.width / self.numberOfStars);
    CGFloat starScore = self.isComplete ? realStarScore : ceilf(realStarScore);
    self.score = starScore / self.numberOfStars;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak QGStarRateView * weakSelf = self;
    CGFloat animationTimeInterval = self.hasAnimation ? 0.2 : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, weakSelf.width * weakSelf.score, weakSelf.height);
    }];
}

- (void)setScore:(CGFloat)score {
    if (_score == score)
        return;
    if (score < 0)
        _score = 0;
    else if (score > 1)
        _score = 1;
    else
        _score = score;
    if ([self.delegate respondsToSelector:@selector(starRateView:andScore:)])
        [self.delegate starRateView:self andScore:score];
    [self setNeedsLayout];
}


@end
