//
//  QGAdiceCell.m
//  qiqiaoguo
//
//  Created by cws on 16/6/13.
//
//

#import "QGAdiceCell.h"

static const CGFloat kPromptImageViewHeight = 32;
static const CGFloat kIndicatorImageViewHeight = 16;

@implementation QGAdiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        
        // Prompt image view
        _promptImageView = [UIImageView new];
        [superview addSubview:_promptImageView];
        
        // Content label
        _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _contentLabel.textColor = [UIColor grayColor];
        [superview addSubview:_contentLabel];
        
        // Indicator image view
        _indicatorImageView = [UIImageView new];
        _indicatorImageView.image = [UIImage imageNamed:@"common-navigation-right-gray-icon"];
        [superview addSubview:_indicatorImageView];
        
        // Solid line
        _solidLine = [UIView new];
        _solidLine.backgroundColor = [UIColor colorFromHexString:@"e1e1e1"];
        [superview addSubview:_solidLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leftToCell = 4 * 4, topToCell = 4 * 4, margin = 4 * 3;
    
    _promptImageView.frame = CGRectMake(leftToCell, topToCell, _promptImageView.image.size.width, _promptImageView.image.size.height);
    
    _indicatorImageView.frame = CGRectMake(self.contentView.width - kIndicatorImageViewHeight - leftToCell, 0, kIndicatorImageViewHeight, kIndicatorImageViewHeight);
    _indicatorImageView.centerY = _promptImageView.centerY;
    
    CGFloat maxContentLabelWidth = _indicatorImageView.left - _promptImageView.right - margin * 2;
    [_contentLabel sizeToFit];
    CGFloat contentLabelWidth = _contentLabel.width > maxContentLabelWidth ? maxContentLabelWidth : _contentLabel.width;
    _contentLabel.frame = CGRectMake(_promptImageView.right + margin, 0, contentLabelWidth, _contentLabel.height);
    _contentLabel.centerY = _promptImageView.centerY;
    
    _solidLine.frame = CGRectMake(leftToCell, _promptImageView.bottom + topToCell, self.contentView.width - leftToCell * 2, 1.0 / [UIScreen mainScreen].scale);
    
    self.cellSize = CGSizeMake(self.contentView.width, _solidLine.bottom);
}

- (void)setShowSeparatorLine:(BOOL)showSeparatorLine {
    _showSeparatorLine = showSeparatorLine;
    self.solidLine.hidden = !showSeparatorLine;
}

- (void)setAdviceType:(QGUserAdiceType)AdviceType
{
    _AdviceType = AdviceType;
    _showSeparatorLine = YES;
    switch (AdviceType) {
        case QGUserAdiceTypePost: {
            _promptImageView.image = [UIImage imageNamed:@"icon_personal_post"];
            _contentLabel.text = @"我的发布";
        } break;
        case QGUserAdiceTypeActivity: {
            _promptImageView.image = [UIImage imageNamed:@"icon＿my_activity"];
            _contentLabel.text = @"我参与的";
        } break;
        case QGUserAdiceTypeCollection: {
            _promptImageView.image = [UIImage imageNamed:@"icon_personal_collection"];
            _contentLabel.text = @"我的收藏";
            _solidLine.hidden = YES;
        } break;
        
        default: break;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];

}



@end
