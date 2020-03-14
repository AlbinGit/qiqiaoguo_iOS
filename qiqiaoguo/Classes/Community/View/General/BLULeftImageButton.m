//
//  BLULeftImageButton.m
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLULeftImageButton.h"

@implementation BLULeftImageButton

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
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, [BLUCurrentTheme leftMargin] * 2);
    self.imageView.contentMode = UIViewContentModeScaleToFill;
}

@end
