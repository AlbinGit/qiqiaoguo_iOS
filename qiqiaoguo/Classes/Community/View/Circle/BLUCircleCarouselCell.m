//
//  BLUCircleCarouselCell.m
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircleCarouselCell.h"
#import "BLUPageView.h"
#import "BLUAd.h"

static const CGFloat kCarouselViewSizeRatio = 2.0 / 3.0;
static const CGFloat kDurationForPageStaying = 4.0f;

@interface BLUCircleCarouselCell ()

@property (nonatomic, strong) BLUPageView *pageView;


@end

@implementation BLUCircleCarouselCell

#pragma mark - Life Circle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _pageView = [BLUPageView new];
        _pageView.pageControl.currentPageIndicatorTintColor = [BLUCurrentTheme mainColor];
        [self.contentView addSubview:_pageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _pageView.frame = self.contentView.bounds;
//    _pageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width * 2 / 3);
//    NSLog(@"%f",self.bounds.size.width * 2 / 3);
}

- (void)setPageViewFrame:(CGRect)rect
{
    _pageView.frame = rect;
}

#pragma mark - Cell size

+ (CGSize)sizeForLayoutedCellWith:(CGFloat)width sharedCell:(BLUCell *)cell {
    return CGSizeMake(width, width * kCarouselViewSizeRatio);
}

#pragma mark - Model

- (void)setModel:(id)model {
    self.ads = (NSArray *)model;
    
    if (!self.cellForCalcingSize) {
        
        [_pageView removeAllViews];
        @weakify(self);
        [self.ads enumerateObjectsUsingBlock:^(BLUAd *ad, NSUInteger idx, BOOL *stop) {
            @strongify(self);
            UIButton *button = [UIButton new];
            button.backgroundColor = BLUThemeSubTintBackgroundColor;
            button.backgroundImageURL = ad.imageURL;
            button.tag = idx;
            [button addTarget:self action:@selector(transitionAction:) forControlEvents:UIControlEventTouchUpInside];
            [_pageView addView:button];
        }];
        [_pageView setNeedsLayout];
        [_pageView layoutIfNeeded];
    }
}

- (void)transitionAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(shouldTransitWithAd:fromView:sender:)]) {
        [self.delegate shouldTransitWithAd:self.ads[button.tag] fromView:self sender:button];
    }
}

#pragma mark - Manage carousel

- (void)startCarousel {
    self.pageView.durationForPageStaying = kDurationForPageStaying;
}

- (void)stopCarousel {
    self.pageView.durationForPageStaying = 0;
}

@end
