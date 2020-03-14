//
//  BLULevelButton.m
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLULevelButton.h"

@implementation BLULevelButton

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
    // TODO: Should have a level button background color
    self.backgroundColor = [UIColor orangeColor];
    self.cornerRadius = [BLUCurrentTheme lowActivityCornerRadius];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:12.5];
    self.titleColor = [UIColor whiteColor];
    self.contentEdgeInsets = UIEdgeInsetsMake(0, [BLUCurrentTheme leftMargin], 0, [BLUCurrentTheme rightMargin]);
}

- (void)setLevel:(NSInteger)level {
    _level = level;
    self.title = [NSString stringWithFormat:@"LV %@", @(level)];
}

@end
