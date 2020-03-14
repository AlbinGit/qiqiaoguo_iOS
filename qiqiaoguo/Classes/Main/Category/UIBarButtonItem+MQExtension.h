//
//  UIBarButtonItem+MQExtension.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/23.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MQExtension)
+ (UIBarButtonItem *)itemWithnorImage:(UIImage *)norImage heighImage:(UIImage *)heightimage targer:(id)targer action:(SEL)actoion;
@end
