//
//  BLUGridView.h
//  Blue
//
//  Created by Bowen on 1/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUGridView : UIView

@property (nonatomic, assign) CGFloat preferedMaxLayoutWidth;
@property (nonatomic, strong, readonly) NSMutableArray *viewArray;
@property (nonatomic, assign, readonly) NSInteger column;
@property (nonatomic, assign) CGFloat margin;

- (instancetype)initWithColumn:(NSInteger)column margin:(CGFloat)margin;
- (void)addView:(UIView *)view;
- (void)addViews:(NSArray *)views;
- (void)removeAllViews;

@end
