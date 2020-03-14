//
//  BLURatioButtonView.m
//  Blue
//
//  Created by Bowen on 5/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLURadioButtonView.h"

@implementation BLURadioButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSAssert(YES, @"Do not use this method.");
    }
    return self;
}

- (instancetype)initWithButtons:(NSArray *)buttons margin:(CGFloat)margin {
    if (self = [super init]) {
        [self _configWithButtons:buttons margin:margin];
    }
    return self;
}

- (void)_configWithButtons:(NSArray *)buttons margin:(CGFloat)margin {
    
    __block UIView *toView = nil;
    __block UIView *forView =nil;
    [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        NSCParameterAssert([button isKindOfClass:[UIButton class]]);
        
        [self addSubview:button];
        button.tag = idx;
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (idx == 0) {
            [self addConstraint:
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeLeft
              relatedBy:NSLayoutRelationEqual
              toItem:self
              attribute:NSLayoutAttributeLeft
              multiplier:1.0 constant:0]];
            
            [self addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:
              @"V:|-(0)-[button]-(0)-|"
              options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
            
            forView = button;
            toView = button;
        } else {
            if (toView) {
                [self addConstraint:
                 [NSLayoutConstraint
                  constraintWithItem:button
                  attribute:NSLayoutAttributeLeft
                  relatedBy:NSLayoutRelationEqual
                  toItem:toView
                  attribute:NSLayoutAttributeRight
                  multiplier:1.0 constant:margin]];
                
                [self addConstraint:
                 [NSLayoutConstraint
                  constraintWithItem:button
                  attribute:NSLayoutAttributeTop
                  relatedBy:NSLayoutRelationEqual
                  toItem:toView
                  attribute:NSLayoutAttributeTop
                  multiplier:1.0 constant:0]];
                toView = button;
            }
        }
        
        if (idx == buttons.count - 1) {
            [self addConstraint:
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeRight
              relatedBy:NSLayoutRelationEqual
              toItem:self
              attribute:NSLayoutAttributeRight
              multiplier:1.0 constant:0]];
        }
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    UILabel *label = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    label.text = @"您是:";
    [self addSubview:label];
    [label setTextColor:[UIColor colorFromHexString:@"c1c1c1"]];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(forView.mas_left).offset(-16);
        make.centerY.equalTo(forView);
    }];

    
}

- (void)setSeletedIndex:(NSInteger)seletedIndex {
    _seletedIndex = seletedIndex;
    
    if (!(seletedIndex > self.subviews.count)) {
        for (UIButton *btn in self.subviews) {
            if (![btn isKindOfClass:[UIButton class]]) {
                continue;
            }
            if (btn.tag == seletedIndex) {
                btn.selected = YES;
            } else {
                btn.selected = NO;
            }
        }
    }
}

- (void)buttonAction:(UIButton *)button {
    
    button.selected = YES;
    self.seletedIndex = button.tag;
    
    for (UIButton *btn in self.subviews) {
        if (![btn isKindOfClass:[UIButton class]])
            continue;
        if (btn.tag != button.tag) {
            btn.selected = NO;
        }
    }
}

@end