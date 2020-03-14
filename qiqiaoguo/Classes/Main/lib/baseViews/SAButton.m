//
//  SAButton.m
//  ToysOnline
//
//  Created by Albin on 14-8-22.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SAButton.h"

@interface SAButton ()

@property (nonatomic,copy)SAButtonClick click;

@end

@implementation SAButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createBaseButton];
    }
    return self;
}

- (void)createBaseButton
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setNormalBackgroundImage:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setNormalImage:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setNormalTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setNormalTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setHighlightBackgroundImage:(NSString *)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

- (void)setHighlightImage:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

- (void)setSelectedImage:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}
- (void)setSelectedTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateSelected];
}

// 点击
- (void)addClick:(SAButtonClick)click
{
    _click = click;
    [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick
{
    if(_click)
    {
        _click(self);
    }
}

//创建一个本地UIButton
+ (SAButton *)createBtnWithRect:(CGRect)r
                     andWithImg:(UIImage *)i
                     andWithTag:(NSInteger)n
                      andWithBg:(UIImage *)b
                   andWithTitle:(NSString *)t
                   andWithColor:(UIColor *)c{
    
    SAButton *mBtn = [SAButton buttonWithType:UIButtonTypeCustom];
    mBtn.titleLabel.font = FONT_CUSTOM(16);
    [mBtn setFrame:r];
    [mBtn setTitle:t forState:UIControlStateNormal];
   
    if (c) {
        [mBtn setTitleColor:c forState:UIControlStateNormal];
    }else{
        //默认颜色
        [mBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }

    if (b) {
        [mBtn setBackgroundImage:b forState:UIControlStateNormal];
        [mBtn setBackgroundImage:b forState:UIControlStateHighlighted];
    }
    if (i) {
        [mBtn setImage:i forState:UIControlStateNormal];
        [mBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    }
    
    [mBtn setTag:n];
    
    return mBtn;
}
- (void)setborder:(int )width
{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:width]; //设置矩圆角半径
    
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
