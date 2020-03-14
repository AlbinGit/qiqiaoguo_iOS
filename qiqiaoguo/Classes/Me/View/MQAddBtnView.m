//
//  MQAddBtnView.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/6/1.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "MQAddBtnView.h"

@interface MQAddBtnView()

@end

@implementation MQAddBtnView

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        
        
        [self setupBtnWithIcon:@"icon_personal_center_to_be_paid" title:@"待付款"];
        [self setupBtnWithIcon:@"icon_personal_center_to_be_shipped" title:@"待发货"];
        [self setupBtnWithIcon:@"icon_personal_center_goods_to_be_received" title:@"待收货" ];
        [self setupBtnWithIcon:@"icon_personal_center_to_be_commented" title:@"待评价" ];
        [self setupBtnWithIcon:@"icon_personal_center_refund" title:@"退款/售后" ];
        
    }
    return self;
}



/**
 *  添加按钮
 *
 *  @param icon  图标
 *  @param title 标题
 */
- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
   
    btn.tag = self.subviews.count;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    // 设置图片和文字
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];

    
    
    [btn setTitle:title forState:UIControlStateNormal];
    
//     设置高亮的时候不要让图标变色
    btn.adjustsImageWhenHighlighted = NO;

    
    // 设置按钮的内容左对齐
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    
    [btn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(50, -32, 0, 0);
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = self.frame.size.width / self.subviews.count;
    CGFloat btnH = self.frame.size.height;
    for (int i = 0; i< self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        
        // 3.3设置frame
        CGFloat btnY = 0;
        
        CGFloat btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

#pragma mark - 私有方法
/**
 *  监听按钮点击
 */
- (void)buttonClick:(UIButton *)button
{
    // 0.通知代理
    if ([self.delegate respondsToSelector:@selector(AddBtnMenu:didSelectedButtonToIndex:)]) {
        [self.delegate AddBtnMenu:self didSelectedButtonToIndex:button.tag];
    }
    
    button.selected = YES;
    
}
@end
