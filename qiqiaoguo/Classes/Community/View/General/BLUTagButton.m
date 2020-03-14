//
//  BLUTagButton.m
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUTagButton.h"

@implementation BLUTagButton

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
    self.backgroundColor = [BLUCurrentTheme mainColor];
    self.cornerRadius = [BLUCurrentTheme normalActivityCornerRadius];
    self.titleColor = [UIColor whiteColor];
    self.titleFont = [BLUCurrentTheme mainFontWithFontSizeType:BLUUIThemeFontSizeTypeSmall];
}

- (void)setTagString:(NSString *)tagString {
    _tagString = tagString;
    self.title = tagString;
}

@end
