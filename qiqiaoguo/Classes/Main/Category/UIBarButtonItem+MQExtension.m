//
//  UIBarButtonItem+MQExtension.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/23.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "UIBarButtonItem+MQExtension.h"

@implementation UIBarButtonItem (MQExtension)
+ (UIBarButtonItem *)itemWithnorImage:(UIImage *)norImage heighImage:(UIImage *)heightimage targer:(id)targer action:(SEL)actoion {
    
    
    UIButton *button1 = [[UIButton alloc] init];
     
     [button1 addTarget:targer action:actoion forControlEvents:(UIControlEventTouchUpInside)];
     //设置字体与当前图片一样大小
    button1.size = CGSizeMake(40, 30);
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:norImage forState:(UIControlStateNormal)];
    [button setBackgroundImage:heightimage forState:(UIControlStateHighlighted)];
    [button addTarget:targer action:actoion forControlEvents:(UIControlEventTouchUpInside)];
    button.y = 8;
    button.size = button.currentBackgroundImage.size;
    [button1 addSubview:button];
  return  [[UIBarButtonItem alloc] initWithCustomView:button1];

}
@end
