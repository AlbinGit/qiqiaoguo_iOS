//
//  BLUUserNavCell.m
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUUserNavCell.h"

static const CGFloat kPromptImageViewHeight = 32;
static const CGFloat kIndicatorImageViewHeight = 16;

@interface BLUUserNavCell ()



@end

@implementation BLUUserNavCell

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
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;
        [superview addSubview:_solidLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leftToCell = BLUThemeMargin * 4, topToCell = BLUThemeMargin * 4, margin = BLUThemeMargin * 3;
    
    _promptImageView.frame = CGRectMake(leftToCell, topToCell, _promptImageView.image.size.width, _promptImageView.image.size.height);
    
    _indicatorImageView.frame = CGRectMake(self.contentView.width - kIndicatorImageViewHeight - leftToCell, 0, kIndicatorImageViewHeight, kIndicatorImageViewHeight);
    _indicatorImageView.centerY = _promptImageView.centerY;
   
    CGFloat maxContentLabelWidth = _indicatorImageView.left - _promptImageView.right - margin * 2;
    [_contentLabel sizeToFit];
    CGFloat contentLabelWidth = _contentLabel.width > maxContentLabelWidth ? maxContentLabelWidth : _contentLabel.width;
    _contentLabel.frame = CGRectMake(_promptImageView.right + margin, 0, contentLabelWidth, _contentLabel.height);
    _contentLabel.centerY = _promptImageView.centerY;
    
    _solidLine.frame = CGRectMake(leftToCell, _promptImageView.bottom + topToCell, self.contentView.width - leftToCell * 2, BLUThemeOnePixelHeight);
    
    self.cellSize = CGSizeMake(self.contentView.width, _solidLine.bottom);
}

- (void)setShowSeparatorLine:(BOOL)showSeparatorLine {
    _showSeparatorLine = showSeparatorLine;
    self.solidLine.hidden = !showSeparatorLine;
}

- (void)setNavType:(BLUUserNavType)navType {
    _navType = navType;
    
    switch (navType) {
        case BLUUserNavTypePost: {
            _promptImageView.image = [UIImage imageNamed:@"personal-posts"];
            _contentLabel.text = NSLocalizedString(@"user-nav-cell.content-label.my-posts", @"My posts");
        } break;
        case BLUUserNavTypeCommented: {
            _promptImageView.image = [UIImage imageNamed:@"personal-comment"];
            _contentLabel.text = NSLocalizedString(@"user-nav-cell.content-label.participated", @"Participated");
        } break;
        case BLUUserNavTypeCollection: {
            _promptImageView.image = [UIImage imageNamed:@"personal-collectoin"];
            _contentLabel.text = NSLocalizedString(@"user-nav-cell.content-label.my-collections", @"My collections");
        } break;
        case BLUUserNavTypeMall: {
            _promptImageView.image = [UIImage imageNamed:@"personal-mall"];
            _contentLabel.text = NSLocalizedString(@"user-nav-cell.content-label.mall", @"Blue coin mall");
        } break;
        case BLUUserNavTypeSetting: {
            _promptImageView.image = [UIImage imageNamed:@"personal-setting"];
            _contentLabel.text = NSLocalizedString(@"user-nav-cell.content-label.setting", @"Setting");
        } break;
        case BLUuserNavTypeUserOrders: {
            _promptImageView.image = [UIImage imageNamed:@"personal-setting"];
            _contentLabel.text = NSLocalizedString(@"user-nav-cell.content-label.user-orders", @"My orders");
        } break;
        default: break;
    }
}

@end