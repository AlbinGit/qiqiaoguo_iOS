//
//  SAImageView.h
//  ToysOnline
//
//  Created by Albin on 14-8-20.
//  Copyright (c) 2014年 platomix. All rights reserved.
//
@class SAImageView;
typedef void(^SAImageViewClick)(SAImageView *imageView);

#import <UIKit/UIKit.h>

@interface SAImageView : UIImageView

- (void)setImageWithName:(NSString *)imageName;
- (void)setImageWithRequest:(NSString *)url;
- (void)addClick:(SAImageViewClick)click;
- (void)setCircleImageView;

// 获取本地门店缩略图
- (void)setStoreImageWithName:(NSString *)imageName;
// 获取巡店本地缩略图
- (void)setVisitStoreImageWithName:(NSString *)imageName;

//点击事件
- (void)addTarget:(id)target andWithSelector:(SEL)sel;

//创建一个本地UIImageView
+ (SAImageView *)createImageViewWithRect:(CGRect)f
                              andWithImg:(UIImage *)i
                           andWithEnable:(BOOL)n;

//创建一个网络UIImageView
+ (SAImageView *)createNetImageViewWithRect:(CGRect)f
                                 andWithImg:(NSString *)u
                               andWithPlace:(UIImage *)i
                              andWithEnable:(BOOL)n;

@end
