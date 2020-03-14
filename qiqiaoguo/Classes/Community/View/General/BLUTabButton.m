//
//  BLUTabButton.m
//  Blue
//
//  Created by Bowen on 13/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUTabButton.h"

@interface BLUTabButton ()

@property (nonatomic, strong) BLUSolidLine *solidLine;

@end

@implementation BLUTabButton

- (instancetype)init {
    if (self = [super init]) {
        [self _config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _config];
    }
    return self;
}

- (void)_config {
    [self setTitleColor:[BLUCurrentTheme mainColor] forState:UIControlStateSelected];
//    [self setTitleColor:[BLUCurrentTheme subFontColor] forState:UIControlStateNormal];
    [self setTitleColor:BLUThemeSubTintContentForegroundColor forState:UIControlStateNormal];
    [self solidLine];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _solidLine.hidden = selected ? NO : YES;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    [_solidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(2));
    }];
    
    [super updateConstraints];
}

- (BLUSolidLine *)solidLine {
    if (_solidLine == nil) {
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = [BLUCurrentTheme mainColor];
        _solidLine.hidden = self.selected ? NO : YES;
        [self addSubview:_solidLine];
    }
    return _solidLine;
}

@end
