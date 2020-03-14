//
//  BLUGridView.m
//  Blue
//
//  Created by Bowen on 1/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUGridView.h"

static const NSInteger kDefaultColumn = 3;
static const CGFloat kDefaultMargin = 4;

@interface BLUGridView ()

@property (nonatomic, assign) NSInteger heightOfGridView;
@property (nonatomic, strong, readwrite) NSMutableArray *viewArray;
@property (nonatomic, assign, readwrite) NSInteger column;

@end

@implementation BLUGridView

#pragma mark - Life Circle

- (instancetype)initWithColumn:(NSInteger)column margin:(CGFloat)margin {
    if (self = [super init]) {
        _column = column <= 1 ? kDefaultColumn : column;
        _margin = margin < 0 ? kDefaultMargin: margin;
    }
    return self;
}

- (instancetype)init {
    return [self initWithColumn:kDefaultColumn margin:kDefaultMargin];
}

#pragma mark - Manage Views

- (void)addView:(UIView *)view {
    [self addSubview:view];
    [self.viewArray addObject:view];
}

- (void)addViews:(NSArray *)views {
    for (UIView *view in views) {
        [self addSubview:view];
    }
    [self.viewArray addObjectsFromArray:views];
}

- (void)removeAllViews {
    for (UIView *view in self.viewArray) {
        [view removeFromSuperview];
    }
    [self.viewArray removeAllObjects];
}

- (NSMutableArray *)viewArray {
    if (_viewArray == nil) {
        _viewArray = [NSMutableArray new];
    }
    return _viewArray;
}

#pragma mark - Adjust UI

- (void)setPreferedMaxLayoutWidth:(CGFloat)preferedMaxLayoutWidth {
    _preferedMaxLayoutWidth = preferedMaxLayoutWidth;
    [self _adjustViews];
    self.frame = CGRectMake(self.x, self.y, preferedMaxLayoutWidth, self.heightOfGridView);
}

- (void)_adjustViews {
    CGFloat widthOfView = (self.preferedMaxLayoutWidth - _margin * ((CGFloat)self.column - 1)) / (CGFloat)self.column;
    CGFloat x = 0.0f, y = 0.0f;
    self.heightOfGridView = 0.0f;
    for (NSInteger i = 0, j = 1; i < self.viewArray.count; ++i, ++j) {
        if (j == 1) {
            x = y = 0.0f;
        } else if (j % self.column == 1 && j != 1) {
            x = 0.0f;
            y += widthOfView + _margin;
        } else {
            x += widthOfView + _margin;
        }
        UIView *view = self.viewArray[i];
        view.frame = CGRectMake(x, y, widthOfView, widthOfView);
        self.heightOfGridView = view.bottom > self.heightOfGridView ? view.bottom : self.heightOfGridView;
    }
}

@end
