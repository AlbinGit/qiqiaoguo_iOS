//
//  BLUPageView.h
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUPageView : UIView

@property (nonatomic, assign) NSInteger page;

// 当设置为0的时候，page将不会轮播，会永远停留
@property (nonatomic, assign) CGFloat durationForPageStaying;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)addView:(UIView *)view;
- (void)removeAllViews;

@end
