//
//  BLUServerNotificationCell.m
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUServerNotificationCell.h"
#import "BLUServerNotificationMO.h"

@implementation BLUServerNotificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UIView *superview = self.contentView;

        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _titleLabel.font = BLUThemeBoldFontWithType(BLUUIThemeFontSizeTypeVeryLarge);
        _titleLabel.textColor = QGTitleColor;

        _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _contentLabel.textColor = QGMainContentColor;

        _imageButton = [UIButton new];
        _imageButton.userInteractionEnabled = NO;

        _timeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _timeLabel.textColor = QGCellContentColor;

        _separator = [BLUSolidLine new];
        _separator.backgroundColor = BLUThemeSubTintBackgroundColor;

        [superview addSubview:_titleLabel];
        [superview addSubview:_contentLabel];
        [superview addSubview:_imageButton];
        [superview addSubview:_timeLabel];
        [superview addSubview:_separator];

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat contentWidth = self.contentView.width - BLUThemeMargin * 8;

    [_titleLabel sizeToFit];
    _titleLabel.x = BLUThemeMargin * 4;
    _titleLabel.y = BLUThemeMargin * 4;
    _titleLabel.width = contentWidth;

    CGSize contentLabelSize = [_contentLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    _contentLabel.x = _titleLabel.x;
    _contentLabel.y = _titleLabel.bottom + BLUThemeMargin * 3;
    _contentLabel.size = contentLabelSize;

    if (_notificaton.imageURL) {
        CGFloat ratio = contentWidth / _notificaton.width;
        _imageButton.width = _notificaton.width * ratio;
        _imageButton.height = _notificaton.height * ratio;
        _imageButton.x = BLUThemeMargin * 4;
        _imageButton.y = _contentLabel.bottom + BLUThemeMargin * 3;
    } else {
        _imageButton.frame = CGRectZero;
    }

    [_timeLabel sizeToFit];
    _timeLabel.x = self.contentView.width - _timeLabel.width - BLUThemeMargin * 4;
    _timeLabel.y = (_imageButton.bottom > _contentLabel.bottom ? _imageButton.bottom : _contentLabel.bottom) + BLUThemeMargin * 3;

    if (_showSeparator) {
        _separator.height = BLUThemeMargin * 1.25;
        _separator.width = self.contentView.width;
        _separator.y = _timeLabel.bottom + BLUThemeMargin * 4;
    } else {
        _separator.frame = CGRectZero;
    }

    self.cellSize = CGSizeMake(self.contentView.width, _showSeparator ? _separator.bottom : _timeLabel.bottom + BLUThemeMargin * 4);
}

- (void)setModel:(id)model {
//    NSParameterAssert([model isKindOfClass:[BLUServerNotificationMO class]]);
    _notificaton = (BLUServerNotification *)model;

    _titleLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);


    _titleLabel.text = _notificaton.title;
    _contentLabel.attributedText = [NSAttributedString contentAttributedStringWithContent:_notificaton.content];

    _imageButton.image = nil;
    if (!self.cellForCalcingSize && _notificaton.imageURL) {
        NSURL *photoOriginURL = _notificaton.imageURL;
        if (photoOriginURL) {
            _imageButton.imageURL = photoOriginURL;
        }
    }

    if (self.showSeparator) {
        _separator.hidden = NO;
    } else {
        _separator.hidden = YES;
    }

    _timeLabel.text = _notificaton.createDate.postTime;
}

@end
