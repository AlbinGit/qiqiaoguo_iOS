//
//  BLUPostTagDetailBarView.m
//  Blue
//
//  Created by Bowen on 10/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagDetailBarView.h"
#import "BLUPostTag.h"

@implementation BLUPostTagDetailBarView

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    [self setDisplayProgress:0.0];
    [self configureUIWithDisplayProgress:_displayProgress];
    self.backgroundColor = BLUThemeMainColor;
    self.clipsToBounds = YES;
}

- (void)setPostTag:(BLUPostTag *)postTag {
    NSParameterAssert([postTag isKindOfClass:[BLUPostTag class]]);
    _postTag = postTag;
    _titleLabel.text = _postTag.title.length > 0 ? _postTag.title : @"Tag";
    [_titleLabel sizeToFit];
    [self configureUIWithDisplayProgress:_displayProgress];
}

- (void)setDisplayProgress:(CGFloat)displayProgress {
    NSParameterAssert(displayProgress >= 0 && displayProgress <= 1.0);
    _displayProgress = displayProgress;
    [self configureUIWithDisplayProgress:_displayProgress];
}

- (void)configureUIWithDisplayProgress:(CGFloat)displayProgress {
    NSParameterAssert(displayProgress >= 0 && displayProgress <= 1.0);

    CGFloat titleLabelX = (self.width - _titleLabel.width) / 2.0;
    CGFloat titleLabelStartY = self.height;
    CGFloat titleLabelEndY = _statusBarOffset + (self.height - _statusBarOffset) / 2.0 - _titleLabel.height / 2.0;
    CGFloat titleLabelYOffset = titleLabelEndY - titleLabelStartY;
    CGFloat titleLabelY = displayProgress * titleLabelYOffset + titleLabelStartY;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY,
                                   _titleLabel.width, _titleLabel.height);

    self.alpha = displayProgress;
}

@end
