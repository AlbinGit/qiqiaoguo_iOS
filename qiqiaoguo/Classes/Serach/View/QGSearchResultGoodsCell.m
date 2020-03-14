

//
//  QGSearchResultGoodsCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/10.
//
//

#import "QGSearchResultGoodsCell.h"
#import "QGSearchResultGoodsModel.h"

@interface QGSearchResultGoodsCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UIView *bttomLine;

@end

@implementation QGSearchResultGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        
        _goodsImage = [UIImageView new];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
        
        _priceLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _priceLabel.textColor = QGCellContentColor;
        
        _volumeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeSub];
        _volumeLabel.textColor = QGCellContentColor;
        
        _bttomLine = [UIView new];
        _bttomLine.backgroundColor = QGCellbottomLineColor;
        
        [superview addSubview:_goodsImage];
        [superview addSubview:_titleLabel];
        [superview addSubview:_priceLabel];
        [superview addSubview:_volumeLabel];
        [superview addSubview:_bttomLine];
        
        return self;
    }
    return nil;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_goodsImage sizeToFit];
    [_titleLabel sizeToFit];
    [_priceLabel sizeToFit];
    [_volumeLabel sizeToFit];
    
    _goodsImage.X = BLUThemeMargin * 2;
    _goodsImage.Y = BLUThemeMargin * 2;
    
    _titleLabel.X = _goodsImage.maxX + BLUThemeMargin * 2;
    _titleLabel.Y = _goodsImage.Y;
    
    _priceLabel.X = _titleLabel.X;
    _priceLabel.bottom = _goodsImage.bottom - BLUThemeMargin;
    
    _volumeLabel.X = _priceLabel.maxX + BLUThemeMargin * 2;
    _volumeLabel.Y = _priceLabel.Y;
    
    _bttomLine.X = _titleLabel.X;
    _bttomLine.Y = _volumeLabel.bottom + BLUThemeMargin * 2;
    _bttomLine.height = QGOnePixelLineHeight;
    
    
    self.cellSize = CGSizeMake(self.contentView.width, _bttomLine.bottom);
}


#pragma mark - Model

- (void)setModel:(id)model {
    QGSearchResultGoodsModel *messageModel = model;
    _titleLabel.text = messageModel.goodsTitle;
    _priceLabel.text = [NSString stringWithFormat:@"%f",messageModel.salesPrice];
    _goodsImage.image = [UIImage imageNamed:messageModel.goodsImageStr];
    _volumeLabel.text = [NSString stringWithFormat:@"%ld",(long)messageModel.salesVolume];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}


@end
