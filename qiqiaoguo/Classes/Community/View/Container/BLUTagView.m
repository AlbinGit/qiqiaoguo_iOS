//
//  BLUTagView.m
//  Blue
//
//  Created by cws on 16/4/5.
//  Copyright © 2016年 com.boki. All rights reserved.
//

#import "BLUTagView.h"
#import "BLUPostTag.h"


@interface BLUTagView () <UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic,strong) UIButton *btn;
@end

@implementation BLUTagView

- (instancetype)init {
    if (self = [super init]) {
        //headView
        _headView = [UIView new];
        _headView.backgroundColor=[UIColor clearColor];
        [self addSubview:_headView];
        // ScrollView
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.height.equalTo(@35);
    }];
    for (UIView *view in _headView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            _tagLabel = (UILabel *)view;
            [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_headView).offset(5);
                make.left.equalTo(_headView).offset([BLUCurrentTheme leftMargin] * 2);
            }];
        }else
        {
            _btn = (UIButton *)view;
            [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_headView).offset(-10);
                make.centerY.equalTo(_tagLabel);
            }];
        }
    }
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom);
        make.left.width.bottom.right.equalTo(self);
    }];
    
    
    // Views
    CGFloat xOffset = 10.0;
    CGFloat viewW = self.frame.size.width / 5.5;
    for (UIView *view in _scrollView.subviews) {
        view.width = viewW;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(_scrollView);
            make.width.equalTo([NSNumber numberWithFloat:viewW]);
            make.left.equalTo([NSNumber numberWithFloat:xOffset]);
        }];
        
        xOffset += view.width;
        xOffset += 10;
        
        
        UIImageView *image = nil;
        UILabel *label = nil;
        UIButton *btn = nil;
        
        for (UIView *sv in view.subviews)
        {
            if ([sv isKindOfClass:[UILabel class]]) {
                label = (UILabel *)sv;
            }
            if ([sv isKindOfClass:[UIButton class]]) {
                btn = (UIButton *)sv;
            }
            if ([sv isKindOfClass:[UIImageView class]]) {
                image = (UIImageView *)sv;
                
            }
        }
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.bottom.equalTo(view).offset(-5);
            make.height.equalTo(@20);
        }];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view).offset(5);
            make.width.equalTo(view.mas_width).offset(-10);
            make.height.equalTo(view.mas_width).offset(-10);
        }];
        image.clipsToBounds = YES;
        image.layer.masksToBounds = YES;
        image.cornerRadius = (view.width - 10)/2;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.height.equalTo(view);
        }];
    }
    
    _scrollView.contentSize = CGSizeMake((viewW + 10) * _scrollView.subviews.count  + 10, _scrollView.frame.size.height);
    
}

#pragma mark - Manage Views

- (void)addHeadView:(UIView *)view {
    [view removeFromSuperview];
    [_headView addSubview:view];
}

- (void)addView:(UIView *)view {
    [view removeFromSuperview];
    [_scrollView addSubview:view];
}

- (void)removeAllViews {
    for (UIView *view in _headView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
}

@end
