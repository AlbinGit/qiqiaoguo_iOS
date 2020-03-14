//
//  BLUPageView.m
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPageView.h"

@interface BLUPageView () <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isDragging;

@property (nonatomic, weak) NSTimer *repeatingTimer;

@end

@implementation BLUPageView

#pragma mark - Life Circle

- (instancetype)init {
    if (self = [super init]) {
       
        // ScrollView
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
       
        // PageControl
        _pageControl = [UIPageControl new];
        _pageControl.numberOfPages = _scrollView.subviews.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        _pageControl.currentPage = 0;
        _pageControl.hidesForSinglePage = YES;
        [_pageControl addTarget:self action:@selector(pageChangeAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _pageControl.size = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
    _pageControl.height = _pageControl.height / 2 - BLUThemeMargin;
    _pageControl.width += BLUThemeMargin * 4;
    _pageControl.cornerRadius = _pageControl.height / 2;
    _pageControl.centerX = self.centerX;
    _pageControl.y = self.bottom - _pageControl.height * 1.5;

    // ScrollView
    _scrollView.frame = self.bounds;
   
    // Views
    CGFloat xOffset = 0.0;
    for (UIView *view in _scrollView.subviews) {
        view.frame = _scrollView.bounds;
        view.x = xOffset;
        xOffset += _scrollView.width;
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.size.width * _scrollView.subviews.count, _scrollView.frame.size.height);
}

#pragma mark - Manage Views

- (void)addView:(UIView *)view {
    [view removeFromSuperview];
    [_scrollView addSubview:view];
    _pageControl.numberOfPages = _scrollView.subviews.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
}

- (void)removeAllViews {
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    self.pageControl.numberOfPages = _scrollView.subviews.count;
}

#pragma mark - Page action

- (void)pageChangeAction:(UIPageControl *)pageControl{
    [self setPage:pageControl.currentPage];
}

#pragma mark - Public Accessor

- (void)setPage:(NSInteger)page {
    _page = page;
    _pageControl.currentPage = page;
    [_scrollView setContentOffset:CGPointMake(page * _scrollView.width, 0) animated:YES];
    [self startTimer];
}

- (void)setDurationForPageStaying:(CGFloat)durationForPageStaying {
    _durationForPageStaying = durationForPageStaying;
   
    if (durationForPageStaying == 0.0) {
        [self stopTimer];
        return ;
    }

    [self startTimer];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self startTimer];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.page = (scrollView.contentOffset.x + scrollView.width / 2) / scrollView.width;
    [self startTimer];
}

- (void)timerClicked:(NSTimer *)timer {
    NSInteger nextPage = _page + 1;
    if (nextPage == _scrollView.subviews.count) {
        nextPage = 0;
    }
    
    self.page = nextPage;
}

- (void)startTimer {
    [self.repeatingTimer invalidate];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.durationForPageStaying target:self selector:@selector(timerClicked:) userInfo:nil repeats:YES];
    
    self.repeatingTimer = timer;
}

- (void)stopTimer {
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

@end
