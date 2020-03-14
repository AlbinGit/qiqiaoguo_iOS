//
//  BLUOrSepratorLine.m
//  Blue
//
//  Created by Bowen on 5/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUOrSepratorLine.h"

@interface BLUOrSepratorLine ()

@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UILabel *orLabel;

@end

@implementation BLUOrSepratorLine

- (instancetype)init {
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (void)config {
    
    UIView *superview = self;
    
    // Left line
    _leftLine = [UIView new];
    _leftLine.translatesAutoresizingMaskIntoConstraints = NO;
    _leftLine.backgroundColor = [UIColor colorFromHexString:@"c1c1c1"];
    [superview addSubview:_leftLine];
    
    // Right line
    _rightLine = [UIView new];
    _rightLine.translatesAutoresizingMaskIntoConstraints = NO;
    _rightLine.backgroundColor = [UIColor colorFromHexString:@"c1c1c1"];
    [superview addSubview:_rightLine];
    
    // Or label
//    _orLabel = [BLUCurrentTheme makeThemeLabelWithType:BLULabelTypeDefault];
    _orLabel = [UILabel makeThemeLabelWithType:BLULabelTypeDefault];
    _orLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _orLabel.textColor = [UIColor colorFromHexString:@"999999"];
    _orLabel.text = NSLocalizedString(@"or-separatorline.or", @"Or");
    [superview addSubview:_orLabel];
    
    
    // Constrants
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_leftLine, _rightLine, _orLabel, superview);
    NSDictionary *metricsDictionary = @{@"margin": @([BLUCurrentTheme leftMargin] * 2),
                                        @"lineHeight": @(1)};
    
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"H:|-(0)-[_leftLine(>=20)]-(margin)-[_orLabel]-(margin)-[_rightLine(>=20)]-(0)-|"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:|-(0)-[_orLabel]-(0)-|"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [superview addConstraint:
     [NSLayoutConstraint
      constraintWithItem:_orLabel
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:superview
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0 constant:0]];
    
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:[_leftLine(lineHeight)]"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:[_rightLine(lineHeight)]"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [superview addConstraint:
     [NSLayoutConstraint
      constraintWithItem:_leftLine
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:_orLabel
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0 constant:0]];
    
    [superview addConstraint:
     [NSLayoutConstraint
      constraintWithItem:_rightLine
      attribute:NSLayoutAttributeCenterY
      relatedBy:NSLayoutRelationEqual
      toItem:_orLabel
      attribute:NSLayoutAttributeCenterY
      multiplier:1.0 constant:0]];
}

@end
