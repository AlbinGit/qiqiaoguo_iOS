//
//  UIView+BLUAddition.h
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (BLUAddition)

// 并没有事用Layer中的属性进行设置
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) UIColor *borderColor;

- (void)showIndicator;
- (void)hideIndicator;

- (void)showDimView;
- (void)hideDimView;

@end
