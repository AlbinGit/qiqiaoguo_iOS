//
//  BLUServerNotificationHeader.m
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUServerNotificationHeader.h"

@implementation BLUServerNotificationHeader

- (instancetype)init {
    if (self =[super init]) {

        self.barTintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self setShadowImage:[UIImage imageWithColor:[UIColor clearColor]] forToolbarPosition:UIBarPositionAny];
        self.clipsToBounds = YES;

        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"message-notification"];
        _imageView.contentMode = UIViewContentModeCenter;

        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _titleLabel.text = NSLocalizedString(@"server-notification-header.title-label.title", @"Private message");
        [_titleLabel setTextColor:QGMainContentColor];

        _separator = [BLUSolidLine new];
        _separator.backgroundColor = QGCellbottomLineColor;

        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_separator];

        self.backgroundColor = [UIColor whiteColor];

        return self;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_imageView sizeToFit];
    _imageView.x = BLUThemeMargin * 3;
    _imageView.width = 24.4;
    _imageView.centerY = [BLUServerNotificationHeader headerHeight] / 2;

    [_titleLabel sizeToFit];
    _titleLabel.x = _imageView.right + BLUThemeMargin * 2;
    _titleLabel.centerY = [BLUServerNotificationHeader headerHeight] / 2;

    _separator.x = 0;
    _separator.height = BLUThemeOnePixelHeight;
    _separator.y = [BLUServerNotificationHeader headerHeight] - _separator.height;
    _separator.width = self.width;
}

+ (CGFloat)headerHeight {
    return 48;
}

@end
