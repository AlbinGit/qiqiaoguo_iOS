//
//  BLUMainTitleButton.m
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUMainTitleButton.h"

@implementation BLUMainTitleButton

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
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor colorFromHexString:@"000000"];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"ff3859"]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"e1e1e1"]] forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"ff3859" alpha:0.8]] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor colorFromHexString:@"ffffff"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorFromHexString:@"c1c1c1"] forState:UIControlStateDisabled];
    self.titleFont = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeLarge];
    self.contentEdgeInsets = UIEdgeInsetsMake([BLUCurrentTheme topMargin] * 3, 0, [BLUCurrentTheme bottomMargin] * 3, 0);
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    return [BLUMainTitleButton new];
}

@end
