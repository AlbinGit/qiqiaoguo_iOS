//
//  SAImageView.m
//  ToysOnline
//
//  Created by Albin on 14-8-20.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SAImageView.h"
#import "SDImageCache.h"

@interface SAImageView ()
@property (nonatomic,copy)SAImageViewClick click;
@end

@implementation SAImageView {
    id _mTarget;
    SEL _mSel;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createBaseImageView];
    }
    return self;
}

- (void)createBaseImageView
{
    self.userInteractionEnabled = YES;
}

- (void)setImageWithRequest:(NSString *)url
{
    
}

- (void)addClick:(SAImageViewClick)click
{
    _click = click;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}

- (void)tapClick:(UITapGestureRecognizer *)tapClick
{
    if(_click)
    {
        _click(self);
    }
}


- (void)setCircleImageView
{
    self.layer.cornerRadius = self.width / 2;
    self.layer.masksToBounds = YES;
}

- (void)setImageWithName:(NSString *)imageName;
{
    self.image = [UIImage imageNamed:imageName];
}

//点击事件
- (void)addTarget:(id)target andWithSelector:(SEL)sel {
    self.userInteractionEnabled = YES;
    _mTarget = target;
    _mSel = sel;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMe:)];
    [self addGestureRecognizer:tap];
}

- (void)clickMe:(UITapGestureRecognizer *)guesture {
    SuppressPerformSelectorLeakWarning(
                                       [_mTarget performSelector:_mSel withObject:self];
                                       );
}

//创建一个本地UIImageView
+ (SAImageView *)createImageViewWithRect:(CGRect)f
                              andWithImg:(UIImage *)i
                           andWithEnable:(BOOL)n {
    SAImageView *mImageView = [[SAImageView alloc] initWithFrame:f];
    mImageView.image = i;
    mImageView.userInteractionEnabled = n;
    
    return mImageView;
}
//创建一个网络UIImageView
+ (SAImageView *)createNetImageViewWithRect:(CGRect)f
                                 andWithImg:(NSString *)u
                               andWithPlace:(UIImage *)i
                              andWithEnable:(BOOL)n {
    SAImageView *mImageView = [[SAImageView alloc] initWithFrame:f];
    [mImageView setImageWithURL:[NSURL URLWithString:u] placeholderImage:i];
    mImageView.userInteractionEnabled = n;
    
    return mImageView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
