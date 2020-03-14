//
//  BLUTagView.h
//  Blue
//
//  Created by cws on 16/4/5.
//  Copyright © 2016年 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUTagView : UIView

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *tags;

- (void)addHeadView:(UIView *)view;
- (void)setTags:(NSArray *)tags;
- (void)addView:(UIView *)view;
- (void)removeAllViews;

@end

