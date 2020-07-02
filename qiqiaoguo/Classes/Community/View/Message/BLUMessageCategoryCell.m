//
//  BLUMessageCategoryCell.m
//  Blue
//
//  Created by Bowen on 13/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUMessageCategoryCell.h"
#import "BLUMessageCategoryMO.h"

@implementation BLUMessageCategoryCell

#pragma mark - UITableViewCell.

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UIView *superview = self.contentView;

        _messageImageView = [UIImageView new];

        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        [_titleLabel setTextColor:QGTitleColor];
        
        _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        [_contentLabel setTextColor:QGCellContentColor];
        _contentLabel.numberOfLines = 1;

        _timeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        [_timeLabel setTextColor:QGCellContentColor];
        
        _messageCountLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _messageCountLabel.backgroundColor = [UIColor redColor];
        _messageCountLabel.textColor = [UIColor whiteColor];
        _messageCountLabel.textAlignment = NSTextAlignmentCenter;
        _messageCountLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall);

        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = QGCellbottomLineColor;

        [superview addSubview:_messageImageView];
        [superview addSubview:_titleLabel];
        [superview addSubview:_contentLabel];
        [superview addSubview:_timeLabel];
        [superview addSubview:_messageCountLabel];
        [superview addSubview:_solidLine];

        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    const CGFloat contentWidth = self.contentView.width;

    [_messageImageView sizeToFit];
    _messageImageView.frame = CGRectMake(BLUThemeMargin * 3, BLUThemeMargin * 4, _messageImageView.width, _messageImageView.height);

    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake(contentWidth - _timeLabel.width - BLUThemeMargin * 3, 0, _timeLabel.width, _timeLabel.height);

    CGFloat messageCountWidth = contentWidth - _messageImageView.width - _timeLabel.width - BLUThemeMargin * 8;
    [_messageCountLabel sizeToFit];
    _messageCountLabel.width += BLUThemeMargin;
    _messageCountLabel.height += BLUThemeMargin;
    _messageCountLabel.frame = CGRectMake(0, 0, _messageCountLabel.height > _messageCountLabel.width ? _messageCountLabel.height : _messageCountLabel.width, _messageCountLabel.height);
    _messageCountLabel.x = contentWidth - _messageCountLabel.width - BLUThemeMargin * 3;
    _messageCountLabel.cornerRadius = _messageCountLabel.height / 2;

    CGSize titleLabelSize = [_titleLabel sizeThatFits:CGSizeMake(contentWidth - _messageImageView.right - BLUThemeMargin * 4 - _timeLabel.left, CGFLOAT_MAX)];
    CGFloat titleLabelWidth = contentWidth - _messageImageView.width - BLUThemeMargin * 10 - _timeLabel.width;
    _titleLabel.frame = CGRectMake(_messageImageView.right + BLUThemeMargin * 2, _messageImageView.minY, titleLabelWidth, titleLabelSize.height);
    
    
    CGSize contentLabelSize = [_contentLabel sizeThatFits:CGSizeMake(contentWidth - _messageImageView.right - BLUThemeMargin * 6 - _timeLabel.width, CGFLOAT_MAX)];
    _contentLabel.frame = CGRectMake(_messageImageView.right + BLUThemeMargin * 2, 0, contentLabelSize.width, contentLabelSize.height);
    _contentLabel.width = messageCountWidth;
    
    _solidLine.frame = CGRectMake(BLUThemeMargin * 2, _messageImageView.bottom + BLUThemeMargin * 4, self.contentView.width - BLUThemeMargin * 4, BLUThemeOnePixelHeight);

    _timeLabel.centerY = _solidLine.bottom / 3 ;
    _messageCountLabel.centerY = _solidLine.bottom / 3 * 2 ;
    _contentLabel.centerY = _messageCountLabel.centerY+5;
    _titleLabel.centerY = self.height/2.0;//_timeLabel.centerY;

    if (_messageModel.unreadCount == 0) {
        _messageCountLabel.frame = CGRectZero;
        _timeLabel.centerY = _messageImageView.centerY;
    }

    self.cellSize = CGSizeMake(contentWidth, _solidLine.bottom);
}

#pragma mark - Model

- (void)setModel:(id)model {
    _messageModel = model;
    if (_messageModel.type == 110) {
        _titleLabel.text = _messageModel.title;
        _messageImageView.image = [UIImage imageNamed:@"message-secretary"];
    } else if (_messageModel.type == 102) {
        _titleLabel.text = _messageModel.title;
        _messageImageView.image = [UIImage imageNamed:@"message-private-message"];
    } else if (_messageModel.type == 2){
        _titleLabel.text = _messageModel.title;
        _messageImageView.image = [UIImage imageNamed:@"message-card"];
    } else if (_messageModel.type == 101){
        _titleLabel.text = _messageModel.title;
        _messageImageView.image = [UIImage imageNamed:@"message-dynamic"];
    } else if (_messageModel.type == 6){
        _titleLabel.text = _messageModel.title;
        _messageImageView.image = [UIImage imageNamed:@"message-activity"];
    } else if (_messageModel.type == 3){
        _titleLabel.text = _messageModel.title;
        _messageImageView.image = [UIImage imageNamed:@"message-order"];
    }else if (_messageModel.type == 7){
        _titleLabel.text = _messageModel.title;
        _messageImageView.image = [UIImage imageNamed:@"edu-odderMessage"];
    }
    _titleLabel.text = _messageModel.title;
    _contentLabel.text = _messageModel.content;
    _timeLabel.text = _messageModel.createDate.postTime;
    _messageCountLabel.text = [NSString stringWithFormat:@"%ld", (long)_messageModel.unreadCount];
    _messageCountLabel.hidden = _messageModel.unreadCount == 0;

    [self setNeedsLayout];
    [self layoutSubviews];
}

@end
