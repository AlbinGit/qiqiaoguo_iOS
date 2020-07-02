//
//  SZJBrowserImageView.h
//  ChinaNews
//
//  Created by 史志杰 on 2020/1/20.
//  Copyright © 2020 Liufangfang. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "CNWaitingView.h"

@interface SZJBrowserImageView : UIImageView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;

- (void)eliminateScale; // 清除缩放

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)doubleTapToZommWithScale:(CGFloat)scale;

- (void)clear;

@end

